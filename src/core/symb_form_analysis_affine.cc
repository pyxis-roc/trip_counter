#include "symb_form.hpp"

#include "llvm/Analysis/ScalarEvolutionExpressions.h"
#include "llvm/IR/CFG.h"
#include "llvm/Support/Casting.h"
#include "llvm/Support/raw_ostream.h"

#include <cstdlib>
#include <functional>
#include <optional>
#include <set>
#include <utility>
#include <vector>

using GA = GraphBuilder::Analysis;

// ============================================================
// Affine Condition Analysis for getTrueRatio
// See affine-conditions-solving.txt for the mathematical detail.
// All symbolic range arithmetic uses 64-bit signed bitvectors.
// ============================================================
namespace {

// A range: range(s, e, anchor, step, D) =
// { n ∈ Z | s <= n <= e, n ≡ anchor (mod step), n ∉ D }
struct AffineRange {
    SymbolicExpr s;                  // start (inclusive)
    SymbolicExpr e;                  // end   (inclusive)
    SymbolicExpr anchor;             // congruence anchor of the arithmetic progression
    uint64_t step;                   // constant positive stride
    std::vector<SymbolicExpr> D;     // deleted points
    AffineRange(SymbolicExpr s, SymbolicExpr e,
        SymbolicExpr anchor, uint64_t step,
        std::vector<SymbolicExpr> D = {})
    : s(std::move(s)), e(std::move(e)),
      anchor(std::move(anchor)), step(step), D(std::move(D)) {}
};

// Relational operator (from the grammar in affine-conditions-solving.txt)
// Keep signed/unsigned variants explicit so range transfer uses correct semantics.
enum class RangeOp { SLT, SLE, SGT, SGE, ULT, ULE, UGT, UGE, EQ, NE};

// A single range condition: iv <rop> v  (iv always on the left after normalisation)
struct RangeCondition {
    RangeOp      op;
    SymbolicExpr v;   // the loop-invariant right-hand side, 64-bit
};

using Term = std::vector<RangeCondition>;   // conjunction of RCs
using AffineCondition = std::vector<Term>;  // disjunction (DNF)

// Signed minimum via select: min(a,b) = a ≤ b ? a : b
static SymbolicExpr smin(const SymbolicExpr& a, const SymbolicExpr& b) {
    return SymbolicExpr::select(SymbolicExpr::sle(a, b), a, b);
}

static SymbolicExpr umin(const SymbolicExpr& a, const SymbolicExpr& b) {
    return SymbolicExpr::select(SymbolicExpr::ule(a, b), a, b);
}

static SymbolicExpr umax(const SymbolicExpr& a, const SymbolicExpr& b) {
    return SymbolicExpr::select(SymbolicExpr::uge(a, b), a, b);
}

static bool isUnsignedRangeOp(RangeOp op) {
    switch (op) {
        case RangeOp::ULT:
        case RangeOp::ULE:
        case RangeOp::UGT:
        case RangeOp::UGE:
            return true;
        default:
            return false;
    }
}

static bool hasUnsignedOps(const AffineCondition& ac) {
    for (const auto& term : ac)
        for (const auto& rc : term)
            if (isUnsignedRangeOp(rc.op))
                return true;
    return false;
}

static bool containsDeletedPoint(const std::vector<SymbolicExpr>& points,
                                 const SymbolicExpr& point) {
    auto key = point.str();
    for (const auto& p : points) {
        if (p.str() == key)
            return true;
    }
    return false;
}

static void appendDeletedPointUnique(std::vector<SymbolicExpr>& points,
                                     const SymbolicExpr& point) {
    if (!containsDeletedPoint(points, point))
        points.emplace_back(point);
}

static std::vector<SymbolicExpr> unionDeletedPoints(const std::vector<SymbolicExpr>& a,
                                                    const std::vector<SymbolicExpr>& b) {
    std::vector<SymbolicExpr> merged;
    merged.reserve(a.size() + b.size());
    for (const auto& p : a)
        appendDeletedPointUnique(merged, p);
    for (const auto& p : b)
        appendDeletedPointUnique(merged, p);
    return merged;
}

// Check if a Value is loop-invariant (lives outside the loop body)
static bool isLI(const llvm::Value* v, llvm::Loop* loop) {
    if (!v || !loop) return false;
    if (llvm::isa<llvm::Constant>(v)) return true;
    if (llvm::isa<llvm::Argument>(v)) return true;
    if (auto* I = llvm::dyn_cast<llvm::Instruction>(v))
        return !loop->contains(I->getParent());
    return false;
}

// Find the principal induction variable of a loop:
// prefer LLVM's canonical IV; fall back to the first affine AddRec PHI.
static const llvm::PHINode* findLoopIV(llvm::Loop* loop,
                                       llvm::ScalarEvolution& SE) {
    if (auto* iv = loop->getInductionVariable(SE))
        return iv;
    auto* hdr = loop->getHeader();
    if (!hdr) return nullptr;
    for (auto& inst : *hdr) {
        if (auto* phi = llvm::dyn_cast<llvm::PHINode>(&inst)) {
            if (auto* ar = llvm::dyn_cast<llvm::SCEVAddRecExpr>(SE.getSCEV(phi)))
                if (ar->getLoop() == loop && ar->isAffine())
                    return phi;
        }
    }
    return nullptr;
}

static SymbolicExpr stepExpr(uint64_t step, SymbolicExprManager& SEM) {
    return SEM.bvVal(step, 64);
}

// Smallest point of the progression anchor + k*step that is >= lower.
static SymbolicExpr alignLower(const SymbolicExpr& lower,
                               const SymbolicExpr& anchor,
                               uint64_t step,
                               SymbolicExprManager& SEM,
                               bool useUnsignedCmp = false) {
    auto stepBV = stepExpr(step, SEM);
    auto one = SEM.bvVal(1, 64);
    auto delta = lower - anchor;
    auto ceilQ = (delta + stepBV - one) / stepBV;
    auto aligned = anchor + ceilQ * stepBV;
    auto le = useUnsignedCmp ? SymbolicExpr::ule(lower, anchor)
                             : SymbolicExpr::sle(lower, anchor);
    return SymbolicExpr::select(le, anchor, aligned);
}

// Largest point of the progression anchor + k*step that is <= upper.
// If upper is below the first progression point, return anchor-step so that
// callers can detect emptiness by checking start > end.
static SymbolicExpr alignUpper(const SymbolicExpr& upper,
                               const SymbolicExpr& anchor,
                               uint64_t step,
                               SymbolicExprManager& SEM,
                               bool useUnsignedCmp = false) {
    auto stepBV = stepExpr(step, SEM);
    auto delta = upper - anchor;
    auto floorQ = delta / stepBV;
    auto aligned = anchor + floorQ * stepBV;
    auto le = useUnsignedCmp ? SymbolicExpr::ule(anchor, upper)
                             : SymbolicExpr::sle(anchor, upper);
    return SymbolicExpr::select(le, aligned, anchor - stepBV);
}

static SymbolicExpr isAlignedToRange(const SymbolicExpr& value,
                                     const AffineRange& R,
                                     SymbolicExprManager& SEM) {
    auto zero = SEM.bvVal(0, 64);
    auto stepBV = stepExpr(R.step, SEM);
    return SymbolicExpr::eq((value - R.anchor) % stepBV, zero);
}

// Apply one transfer function F_{iv op v}(R) -> refined range
static AffineRange applyRC(const AffineRange& R,
                           const RangeCondition& rc,
                           SymbolicExprManager& SEM) {
    auto one = SEM.bvVal(1, 64);
    auto maxFn = isUnsignedRangeOp(rc.op) ? umax : SymbolicExpr::smax;
    auto minFn = isUnsignedRangeOp(rc.op) ? umin : smin;

    switch (rc.op) {
        case RangeOp::SLE:
        case RangeOp::ULE:
            return AffineRange(R.s, minFn(R.e, rc.v), R.anchor, R.step, R.D);
        case RangeOp::SLT:
        case RangeOp::ULT:
            return AffineRange(R.s, minFn(R.e, rc.v - one), R.anchor, R.step, R.D);
        case RangeOp::SGE:
        case RangeOp::UGE:
            return AffineRange(maxFn(R.s, rc.v), R.e, R.anchor, R.step, R.D);
        case RangeOp::SGT:
        case RangeOp::UGT:
            return AffineRange(maxFn(R.s, rc.v + one), R.e, R.anchor, R.step, R.D);
        case RangeOp::NE: {
            auto D2 = R.D;
            appendDeletedPointUnique(D2, rc.v);
            return AffineRange(R.s, R.e, R.anchor, R.step, std::move(D2));
        }
        case RangeOp::EQ:
            return AffineRange(maxFn(R.s, rc.v),
                               minFn(R.e, rc.v), R.anchor, R.step, R.D);
    }
    return R;
}

// Apply a full conjunctive term T by composing transfer functions
static AffineRange applyTerm(const AffineRange& R0,
                             const Term& term,
                             SymbolicExprManager& SEM) {
    AffineRange R = R0;
    for (const auto& rc : term) {
        R = applyRC(R, rc, SEM);
    }
    return R;
}

// len(range(s,e,anchor,step,D)) =
// max(0, floor((alignedEnd-alignedStart)/step)+1) minus deleted aligned points.
static SymbolicExpr computeLen(const AffineRange& R,
                               SymbolicExprManager& SEM,
                               bool useUnsignedCmp = false) {
    auto zero = SEM.bvVal(0, 64);
    auto one = SEM.bvVal(1, 64);
    auto stepBV = stepExpr(R.step, SEM);
    auto alignedStart = alignLower(R.s, R.anchor, R.step, SEM, useUnsignedCmp);
    auto alignedEnd = alignUpper(R.e, R.anchor, R.step, SEM, useUnsignedCmp);
    auto le = useUnsignedCmp ? SymbolicExpr::ule(alignedStart, alignedEnd)
                             : SymbolicExpr::sle(alignedStart, alignedEnd);
    auto base = SymbolicExpr::select(
        le,
        ((alignedEnd - alignedStart) / stepBV) + one,
        zero);
    auto del = zero;
    for (const auto& d : R.D) {
        auto inRange = useUnsignedCmp
            ? (SymbolicExpr::ule(alignedStart, d) & SymbolicExpr::ule(d, alignedEnd))
            : (SymbolicExpr::sle(alignedStart, d) & SymbolicExpr::sle(d, alignedEnd));
        auto aligned = isAlignedToRange(d, R, SEM);
        del = del + SymbolicExpr::select(inRange & aligned, one, zero);
    }
    return base - del;
}

// Ω(I_i, I_j) = range(max(s_i,s_j), min(e_i,e_j), D_i ∪ D_j)
// For set intersection (I_i ∩ I_j), deleted points are unioned.
static AffineRange computeOverlap(const AffineRange& a,
                                  const AffineRange& b,
                                  SymbolicExprManager& SEM,
                                  bool useUnsignedCmp = false) {
    auto maxFn = useUnsignedCmp ? umax : SymbolicExpr::smax;
    auto minFn = useUnsignedCmp ? umin : smin;
    auto overlapD = unionDeletedPoints(a.D, b.D);
    return AffineRange(maxFn(a.s, b.s),
                       minFn(a.e, b.e),
                       a.anchor,
                       a.step,
                       std::move(overlapD));
}

} // anonymous namespace
// ============================================================

optional<pair<SymbolicExpr, SymbolicExpr>> GA::tryAffineTrueRatio(const llvm::BasicBlock* bb) {
    if (!bb) return std::nullopt;

    // Only makes sense for a block inside a loop
    auto* currentLoop = LI.getLoopFor(const_cast<llvm::BasicBlock*>(bb));
    if (!currentLoop) return std::nullopt;

    // Terminator must be a conditional branch
    auto* termBr = llvm::dyn_cast<llvm::BranchInst>(bb->getTerminator());
    if (!termBr || !termBr->isConditional()) return std::nullopt;

    auto* condVal = termBr->getCondition();
    if (!condVal) return std::nullopt;

    // Try candidate induction variables from the current loop outward.
    std::vector<llvm::Loop*> candidateLoops;
    for (auto* loop = currentLoop; loop; loop = loop->getParentLoop())
        candidateLoops.push_back(loop);

    auto tryWithIV = [&](llvm::Loop* ivLoop, const llvm::PHINode* iv)
            -> std::optional<std::pair<SymbolicExpr, SymbolicExpr>> {
        if (!ivLoop || !iv)
            return std::nullopt;

        // -------------------------------------------------------
        // Parse the branch condition into DNF (AffineCondition)
        // -------------------------------------------------------

        // Parse a single ICmpInst as a RangeCondition on iv (nullopt if not eligible)
        auto parseSingleRC = [&](const llvm::ICmpInst* cmp)
                -> std::optional<RangeCondition> {
            auto* op0 = cmp->getOperand(0);
            auto* op1 = cmp->getOperand(1);
            bool ivLeft = (op0 == iv);
            bool ivRight = (op1 == iv);
            if (!ivLeft && !ivRight) return std::nullopt;
            auto* nonIv = ivLeft ? op1 : op0;
            if (!isLI(nonIv, ivLoop)) return std::nullopt;

            auto pred = cmp->getPredicate();
            if (ivRight) pred = llvm::ICmpInst::getSwappedPredicate(pred);

            RangeOp op;
            switch (pred) {
                case llvm::CmpInst::ICMP_SLT: op = RangeOp::SLT; break;
                case llvm::CmpInst::ICMP_ULT: op = RangeOp::ULT; break;
                case llvm::CmpInst::ICMP_SLE: op = RangeOp::SLE; break;
                case llvm::CmpInst::ICMP_ULE: op = RangeOp::ULE; break;
                case llvm::CmpInst::ICMP_SGT: op = RangeOp::SGT; break;
                case llvm::CmpInst::ICMP_UGT: op = RangeOp::UGT; break;
                case llvm::CmpInst::ICMP_SGE: op = RangeOp::SGE; break;
                case llvm::CmpInst::ICMP_UGE: op = RangeOp::UGE; break;
                case llvm::CmpInst::ICMP_EQ:  op = RangeOp::EQ; break;
                case llvm::CmpInst::ICMP_NE:  op = RangeOp::NE; break;
                default: return std::nullopt;
            }
            auto v = value2Expr(*nonIv);
            if (v.getBitwidth() < 64) {
                if (isUnsignedRangeOp(op)) v = v.zeroExtend(64 - v.getBitwidth());
                else                       v = v.signedExtend(64 - v.getBitwidth());
            }
            else if (v.getBitwidth() > 64) return std::nullopt;

            return RangeCondition{op, v};
        };

        std::function<std::optional<AffineCondition>(const llvm::Value*)> parseAC;
        parseAC = [&](const llvm::Value* val) -> std::optional<AffineCondition> {
            if (!val) return std::nullopt;

            if (auto* freeze = llvm::dyn_cast<llvm::FreezeInst>(val))
                return parseAC(freeze->getOperand(0));

            if (auto* cmp = llvm::dyn_cast<llvm::ICmpInst>(val)) {
                auto rc = parseSingleRC(cmp);
                if (!rc) return std::nullopt;
                return AffineCondition{{*rc}};
            }
            if (auto* inst = llvm::dyn_cast<llvm::Instruction>(val)) {
                if (inst->getOpcode() == llvm::Instruction::And) {
                    auto ac0 = parseAC(inst->getOperand(0));
                    auto ac1 = parseAC(inst->getOperand(1));
                    if (!ac0 || !ac1) return std::nullopt;
                    AffineCondition result;
                    for (auto& t0 : *ac0)
                        for (auto& t1 : *ac1) {
                            Term merged;
                            merged.insert(merged.end(), t0.begin(), t0.end());
                            merged.insert(merged.end(), t1.begin(), t1.end());
                            result.push_back(std::move(merged));
                        }
                    return result;
                }
                if (inst->getOpcode() == llvm::Instruction::Or) {
                    auto ac0 = parseAC(inst->getOperand(0));
                    auto ac1 = parseAC(inst->getOperand(1));
                    if (!ac0 || !ac1) return std::nullopt;
                    AffineCondition result;
                    result.insert(result.end(), ac0->begin(), ac0->end());
                    result.insert(result.end(), ac1->begin(), ac1->end());
                    return result;
                }
            }
            return std::nullopt;
        };

        auto negateRangeOp = [&](RangeOp op) -> RangeOp {
            switch (op) {
                case RangeOp::SLT: return RangeOp::SGE;
                case RangeOp::SLE: return RangeOp::SGT;
                case RangeOp::SGT: return RangeOp::SLE;
                case RangeOp::SGE: return RangeOp::SLT;
                case RangeOp::ULT: return RangeOp::UGE;
                case RangeOp::ULE: return RangeOp::UGT;
                case RangeOp::UGT: return RangeOp::ULE;
                case RangeOp::UGE: return RangeOp::ULT;
                case RangeOp::EQ:  return RangeOp::NE;
                case RangeOp::NE:  return RangeOp::EQ;
            }
            return op;
        };

        auto andAC = [&](const AffineCondition& lhs, const AffineCondition& rhs) -> AffineCondition {
            if (lhs.empty() || rhs.empty()) return {};
            AffineCondition out;
            out.reserve(lhs.size() * rhs.size());
            for (const auto& lt : lhs)
                for (const auto& rt : rhs) {
                    Term merged;
                    merged.reserve(lt.size() + rt.size());
                    merged.insert(merged.end(), lt.begin(), lt.end());
                    merged.insert(merged.end(), rt.begin(), rt.end());
                    out.push_back(std::move(merged));
                }
            return out;
        };

        auto orAC = [&](const AffineCondition& lhs, const AffineCondition& rhs) -> AffineCondition {
            AffineCondition out;
            out.reserve(lhs.size() + rhs.size());
            out.insert(out.end(), lhs.begin(), lhs.end());
            out.insert(out.end(), rhs.begin(), rhs.end());
            return out;
        };

        auto negateAC = [&](const AffineCondition& input) -> AffineCondition {
            if (input.empty()) return AffineCondition{Term{}};
            AffineCondition out{Term{}};
            for (const auto& term : input) {
                if (term.empty()) return AffineCondition{};
                AffineCondition notTerm;
                notTerm.reserve(term.size());
                for (const auto& rc : term)
                    notTerm.push_back(Term{RangeCondition{negateRangeOp(rc.op), rc.v}});
                out = andAC(out, notTerm);
                if (out.empty()) break;
            }
            return out;
        };

        auto trueAC = AffineCondition{Term{}};
        auto currentAC = parseAC(condVal);
        if (!currentAC || currentAC->empty()) return std::nullopt;

        auto edgeAC = [&](const llvm::BasicBlock* from, const llvm::BasicBlock* to) -> AffineCondition {
            auto* br = llvm::dyn_cast<llvm::BranchInst>(from->getTerminator());
            if (!br || !br->isConditional() || br->getNumSuccessors() != 2)
                return trueAC;
            auto parsed = parseAC(br->getCondition());
            if (!parsed || parsed->empty())
                return trueAC;
            if (br->getSuccessor(0) == to)
                return *parsed;
            if (br->getSuccessor(1) == to)
                return negateAC(*parsed);
            return trueAC;
        };

        auto* header = ivLoop->getHeader();
        if (!header) return std::nullopt;

        AffineCondition pathAC;
        bool hasPath = false;
        size_t exploredPaths = 0;
        constexpr size_t kMaxPaths = 2048;
        constexpr size_t kMaxTerms = 8192;

        std::function<void(const llvm::BasicBlock*, const AffineCondition&, std::set<const llvm::BasicBlock*>&)> dfs;
        dfs = [&](const llvm::BasicBlock* node,
                  const AffineCondition& acc,
                  std::set<const llvm::BasicBlock*>& visited) {
            if (!node || exploredPaths >= kMaxPaths) return;
            if (node == bb) {
                hasPath = true;
                ++exploredPaths;
                pathAC = pathAC.empty() ? acc : orAC(pathAC, acc);
                if (pathAC.size() > kMaxTerms) {
                    pathAC.resize(kMaxTerms);
                }
                return;
            }

            for (const auto* succ : llvm::successors(node)) {
                if (!succ || !ivLoop->contains(const_cast<llvm::BasicBlock*>(succ)))
                    continue;
                if (visited.count(succ))
                    continue;
                auto nextAcc = andAC(acc, edgeAC(node, succ));
                if (nextAcc.empty())
                    continue;
                if (nextAcc.size() > kMaxTerms)
                    nextAcc.resize(kMaxTerms);
                visited.insert(succ);
                dfs(succ, nextAcc, visited);
                visited.erase(succ);
                if (exploredPaths >= kMaxPaths)
                    return;
            }
        };

        std::set<const llvm::BasicBlock*> visited;
        visited.insert(header);
        dfs(header, trueAC, visited);

        auto baseAC = hasPath ? pathAC : trueAC;
        auto effectiveAC = andAC(baseAC, *currentAC);
        if (effectiveAC.empty()) {
            effectiveAC = AffineCondition{};
        }

        auto useUnsignedCmp = hasUnsignedOps(baseAC) || hasUnsignedOps(effectiveAC);

        const auto* addRec = llvm::dyn_cast<llvm::SCEVAddRecExpr>(
            SE.getSCEV(const_cast<llvm::PHINode*>(iv)));
        if (!addRec || !addRec->isAffine()) return std::nullopt;

        const auto* constStep = llvm::dyn_cast<llvm::SCEVConstant>(
            addRec->getStepRecurrence(SE));
        if (!constStep) return std::nullopt;
        auto stepValue = constStep->getValue()->getSExtValue();
        if (stepValue == 0) return std::nullopt;

        const llvm::SCEV* btc = SE.getBackedgeTakenCount(ivLoop);
        if (llvm::isa<llvm::SCEVCouldNotCompute>(btc)) return std::nullopt;

        auto S = SCEV2Expr(*addRec->getStart());
        if (S.getBitwidth() < 64)
            S = useUnsignedCmp ? S.zeroExtend(64 - S.getBitwidth())
                               : S.signedExtend(64 - S.getBitwidth());

        auto BTC = SCEV2Expr(*btc);
        if (BTC.getBitwidth() < 64) BTC = BTC.zeroExtend(64 - BTC.getBitwidth());

        auto stepExpr64 = SEM.bvVal(static_cast<uint64_t>(stepValue), 64);
        auto last = S + BTC * stepExpr64;
        auto absStep = static_cast<uint64_t>(std::llabs(static_cast<long long>(stepValue)));

        AffineRange R0 = (stepValue > 0)
            ? AffineRange(S, last, S, absStep)
            : AffineRange(last, S, last, absStep);

        auto countUnionRanges = [&](const std::vector<AffineRange>& ranges) {
            auto cnt = SEM.bvVal(0, 64);
            for (const auto& Ri : ranges)
                cnt = cnt + computeLen(Ri, SEM, useUnsignedCmp);
            for (size_t i = 0; i < ranges.size(); ++i)
                for (size_t j = i + 1; j < ranges.size(); ++j)
                    cnt = cnt - computeLen(computeOverlap(ranges[i], ranges[j], SEM, useUnsignedCmp),
                                           SEM, useUnsignedCmp);
            return cnt;
        };

        std::vector<AffineRange> BaseRanges;
        BaseRanges.reserve(baseAC.size());
        for (const auto& term : baseAC) {
            BaseRanges.emplace_back(applyTerm(R0, term, SEM));
        }

        std::vector<AffineRange> Iranges;
        Iranges.reserve(effectiveAC.size());
        for (const auto& term : effectiveAC){
            Iranges.emplace_back(applyTerm(R0, term, SEM));
        }

        auto lenR0 = countUnionRanges(BaseRanges);
        auto trueCount = countUnionRanges(Iranges);

        return make_pair(trueCount, lenR0);
    };

    for (auto* loop : candidateLoops) {
        const llvm::PHINode* iv = findLoopIV(loop, SE);
        if (!iv)
            continue;
        if (auto tr = tryWithIV(loop, iv)){
            return tr;
        }
    }

    return std::nullopt;
}

optional<pair<SymbolicExpr, SymbolicExpr>> GA::getTrueRatio(const llvm::BasicBlock* bb){
    if (!bb) {
        llvm::errs() << "Error: getTrueRatio: BasicBlock is null\n";
        return std::nullopt;
    }
    const llvm::Instruction* term = bb->getTerminator();
    if (!term) {
        llvm::errs() << "Error: getTrueRatio: Terminator is null for block " << GraphBuilder::getName(bb) << "\n";
        return std::nullopt;
    }

    if (isSolvable(term)){
        // denominator = 1 for loop-invariant conditions (exact ratio, no fractional part)
        auto cond = inst2Expr(*term); //1-bit vector return
        return make_pair(cond.zeroExtend(63), SEM.bvVal(1, 64));
    }

    // attempt the affine-condition analysis for loop-varying branches
    if (auto affineResult = tryAffineTrueRatio(bb)) {
        return affineResult;  // already a (numerator, denominator) pair
    }

    llvm::errs() << "Warning: getTrueRatio: Terminator not solvable for block " << GraphBuilder::getName(bb) << ", assuming all are true" << "\n";
    return make_pair(SEM.bvVal(1, 64), SEM.bvVal(1, 64)); // fallback to 0% true
}

optional<SymbolicExpr> GA::getLoopCount(llvm::Loop* loop){
    if (!loop) {
        llvm::errs() << "Error: getLoopCount: Loop is null\n";
        return std::nullopt;
    }

    // Use ScalarEvolution to get the backedge taken count
    llvm::ScalarEvolution *SE = &this->SE;
    if (!SE) {
        llvm::errs() << "Error: getLoopCount: ScalarEvolution is null\n";
        return std::nullopt;
    }

    const llvm::SCEV *backedgeCount = SE->getBackedgeTakenCount(loop);
    if (llvm::isa<llvm::SCEVCouldNotCompute>(backedgeCount)) {
        llvm::errs() << "Warning: getLoopCount: Could not compute backedge count for loop " << getName(loop) << "\n";
        // Fallback to symbolic name
        auto loopCount_literal = "LC_" + getName(loop);
        return SEM.symbLoopCount(loopCount_literal);
    }

    // SCEV gives backedge count, trip count is either backedge count + 1 (if header is exiting)
    // or backedge count (if header is not exiting)
    auto backedgeCountExpr = SCEV2Expr(*backedgeCount);
    bool headerExiting =
        loop->isLoopExiting(loop->getHeader()) && (loop->getBlocks().size() > 1);

    if(backedgeCountExpr.getBitwidth() == 64){
        // good, default loop count is 64 bits, we can directly use it
        return headerExiting ? backedgeCountExpr : backedgeCountExpr + SEM.one64();
    }
    else if (backedgeCountExpr.getBitwidth() < 64){
        // if it is smaller than 64 bits, we can zero extend it to 64 bits
        auto extended = backedgeCountExpr.zeroExtend(64 - backedgeCountExpr.getBitwidth());
        return headerExiting ? extended : extended + SEM.one64();
    }
    else{
        llvm::errs() << "Error: Loop " << getName(loop) << " backedge count SCEV: ";
        backedgeCount->print(llvm::errs());
        llvm::errs() << " is not 64 bits, type incompatible\n";
        exit(1);
    }
}
