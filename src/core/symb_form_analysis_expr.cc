#include "symb_form.hpp"

#include "llvm/Analysis/ScalarEvolutionExpressions.h"
#include "llvm/IR/Intrinsics.h"
#include "llvm/Support/Casting.h"
#include "llvm/Support/raw_ostream.h"

#include <cctype>
#include <functional>
#include <optional>
#include <set>
#include <string>
#include <vector>

using GA = GraphBuilder::Analysis;

namespace {
std::string sanitizeCallSymbolComponent(llvm::StringRef name) {
    std::string sanitized;
    sanitized.reserve(name.size());
    for (char ch : name) {
        if (std::isalnum(static_cast<unsigned char>(ch)) || ch == '_') {
            sanitized.push_back(ch);
        } else {
            sanitized.push_back('_');
        }
    }
    return sanitized;
}

std::string callReturnSymbolName(llvm::StringRef name) {
    return "call_ret_" + sanitizeCallSymbolComponent(name);
}

const llvm::Value* stripMemoryPointer(const llvm::Value* value) {
    return value ? value->stripPointerCasts() : nullptr;
}

bool sameMemoryPointer(const llvm::Value* lhs, const llvm::Value* rhs) {
    return stripMemoryPointer(lhs) == stripMemoryPointer(rhs);
}

bool isClearlyDifferentSimpleMemoryObject(const llvm::Value* lhs,
                                          const llvm::Value* rhs) {
    const llvm::Value* lhsBase = stripMemoryPointer(lhs);
    const llvm::Value* rhsBase = stripMemoryPointer(rhs);
    if (!lhsBase || !rhsBase || lhsBase == rhsBase) return false;

    auto isSimpleObject = [](const llvm::Value* value) {
        return llvm::isa<llvm::AllocaInst>(value) ||
               llvm::isa<llvm::GlobalValue>(value);
    };
    return isSimpleObject(lhsBase) && isSimpleObject(rhsBase);
}

enum class StoreSearchResult { Found, NotFound, Blocked };

StoreSearchResult findStoreInBlockBefore(const llvm::BasicBlock& block,
                                         const llvm::Instruction* before,
                                         const llvm::Value* loadPointer,
                                         const llvm::StoreInst*& store) {
    const llvm::Instruction* current = before ? before->getPrevNode()
                                              : block.getTerminator();
    while (current) {
        if (const auto* storeInst = llvm::dyn_cast<llvm::StoreInst>(current)) {
            if (storeInst->isVolatile() || storeInst->isAtomic()) {
                return StoreSearchResult::Blocked;
            }
            if (sameMemoryPointer(storeInst->getPointerOperand(), loadPointer)) {
                store = storeInst;
                return StoreSearchResult::Found;
            }
            if (!isClearlyDifferentSimpleMemoryObject(storeInst->getPointerOperand(),
                                                      loadPointer)) {
                return StoreSearchResult::Blocked;
            }
        } else if (current->mayWriteToMemory()) {
            return StoreSearchResult::Blocked;
        }
        current = current->getPrevNode();
    }
    return StoreSearchResult::NotFound;
}

const llvm::StoreInst* findPairedStoreForLoad(const llvm::LoadInst& load) {
    if (load.isVolatile() || load.isAtomic()) return nullptr;

    const llvm::Value* loadPointer = load.getPointerOperand();
    const llvm::BasicBlock* block = load.getParent();
    const llvm::Instruction* before = &load;
    std::set<const llvm::BasicBlock*> visited;

    while (block && visited.insert(block).second) {
        const llvm::StoreInst* store = nullptr;
        StoreSearchResult result =
            findStoreInBlockBefore(*block, before, loadPointer, store);
        if (result == StoreSearchResult::Found) return store;
        if (result == StoreSearchResult::Blocked) return nullptr;

        block = block->getSinglePredecessor();
        before = nullptr;
    }
    return nullptr;
}
} // namespace

SymbolicExpr GA::SCEV2Expr(const llvm::SCEV& scev) {
    // scev.print(llvm::errs());
    // llvm::errs() << "\n";
    auto & ctx = SEM.context();

    vector<SymbolicExpr> args;
    for (const auto& op : scev.operands()) {
        args.push_back(SCEV2Expr(*op));
    }

    switch (scev.getSCEVType()) {
        case llvm::scAddExpr:{
            SymbolicExpr sum = args.size() > 0 ? args[0] : SEM.intVal(0);
            for (unsigned i = 1; i < args.size(); ++i) {
                sum = sum + args[i];
            }
            return sum;
        }
        case llvm::scMulExpr:{
            SymbolicExpr product = args.size() > 0 ? args[0] : SEM.intVal(1);
            for (unsigned i = 1; i < args.size(); ++i) {
                product = product * args[i];
            }
            return product;
        }
        case llvm::scZeroExtend:{
            if (args.size() == 1) {
                // Get the target bitwidth from the SCEV type
                unsigned targetBitwidth = scev.getType()->getPrimitiveSizeInBits();
                unsigned srcBitwidth = args[0].getBitwidth();
                if (targetBitwidth > srcBitwidth) {
                    return args[0].zeroExtend(targetBitwidth - srcBitwidth);
                } else if (targetBitwidth == srcBitwidth) {
                    return args[0];
                } else {
                    llvm::errs() << "Error: ZeroExtend target bitwidth is less than source bitwidth.\n";
                }
            }
            llvm::errs() << "Error: ZeroExtend requires exactly one operand.\n";
            break;
        }
        case llvm::scTruncate:{
            if (args.size() == 1) {
                // Get the target bitwidth from the SCEV type
                unsigned targetBitwidth = scev.getType()->getPrimitiveSizeInBits();
                unsigned srcBitwidth = args[0].getBitwidth();
                if (targetBitwidth < srcBitwidth) {
                    return args[0].truncate(targetBitwidth);
                } else if (targetBitwidth == srcBitwidth) {
                    return args[0];
                } else {
                    llvm::errs() << "Error: Truncate target bitwidth is greater than source bitwidth.\n";
                }
            }
            llvm::errs() << "Error: Truncate requires exactly one operand.\n";
            break;
        }
        case llvm::scUDivExpr:{
            if (args.size() == 2) {
                return args[0] / args[1];
            }
            llvm::errs() << "Error: UDivExpr requires exactly two operands.\n";
            break;
        }
        case llvm::scSignExtend:{
            if (args.size() == 1) {
                // Get the target bitwidth from the SCEV type
                unsigned targetBitwidth = scev.getType()->getPrimitiveSizeInBits();
                unsigned srcBitwidth = args[0].getBitwidth();
                if (targetBitwidth > srcBitwidth) {
                    return args[0].signedExtend(targetBitwidth - srcBitwidth);
                } else if (targetBitwidth == srcBitwidth) {
                    return args[0];
                } else {
                    llvm::errs() << "Error: SignExtend target bitwidth is less than source bitwidth.\n";
                }
            }
            llvm::errs() << "Error: SignExtend requires exactly one operand.\n";
            break;
        }
        case llvm::scSMaxExpr:{
            if (args.size() == 2) {
                return SymbolicExpr::smax(args[0], args[1]);
            }
            llvm::errs() << "Error: SMaxExpr requires exactly two operands.\n";
            break;
        }
        case llvm::scConstant:{
            const llvm::SCEVConstant* scevConst = llvm::cast<llvm::SCEVConstant>(&scev);
            unsigned bitwidth = scevConst->getType()->getPrimitiveSizeInBits();
            return SEM.bvVal(scevConst->getValue()->getSExtValue(), bitwidth);
        }
        case llvm::scUnknown:{
            unsigned bitwidth = scev.getType()->getPrimitiveSizeInBits();
            if (const llvm::SCEVUnknown* scevUnknown = llvm::dyn_cast<llvm::SCEVUnknown>(&scev)) {
                if (const llvm::Value* val = scevUnknown->getValue()) {
                    return value2Expr(*val);
                }
            }
            llvm::errs() << "Error: SCEVUnknown without value.\n";
        }
        default:{
            llvm::errs() << "Error: Unsupported SCEV type: " << scev.getSCEVType() << "\n";
            scev.print(llvm::errs());
            llvm::errs() << "\n";
        }
    }
    return SEM.bvSCEV(scev);
}

SymbolicExpr GA::call2Expr(const llvm::CallInst& C) {
    auto bitwidth = SEM.getBitWidth(static_cast<const llvm::Instruction&>(C));
    auto getCalledName = [&]() -> std::optional<std::string> {
        if (const auto* callee = C.getCalledFunction()) {
            return callee->getName().str();
        }

        const auto* calledOperand = C.getCalledOperand()->stripPointerCasts();
        if (const auto* global = llvm::dyn_cast<llvm::GlobalValue>(calledOperand)) {
            return global->getName().str();
        }

        if (const auto* load = llvm::dyn_cast<llvm::LoadInst>(calledOperand)) {
            const auto* pointerOperand = load->getPointerOperand()->stripPointerCasts();
            if (const auto* global = llvm::dyn_cast<llvm::GlobalValue>(pointerOperand)) {
                return global->getName().str();
            }
        }

        return std::nullopt;
    };

    auto id = C.getIntrinsicID();
    if (id == llvm::Intrinsic::not_intrinsic) {
        if (auto calledName = getCalledName()) {
            llvm::StringRef name(*calledName);
            if (name.starts_with("llvm.smax.")) {
                if (C.arg_size() == 2) {
                    return SymbolicExpr::smax(value2Expr(*C.getArgOperand(0)),
                                              value2Expr(*C.getArgOperand(1)));
                }
            }

            if (name == "__TVMBackendFreeWorkspace") {
                return SEM.bvVal(0, bitwidth);
            }

            if (name == "__TVMBackendAllocWorkspace") {
                return SEM.bvVal(1, bitwidth);
            }

            auto callRet = SEM.bvNamed(callReturnSymbolName(name), bitwidth);
            if (P) {
                P->addInput(callRet);
            }
            return callRet;
        }
        llvm::errs() << "Warning: call2Expr unsupported indirect call, assumed to be 1: ";
        C.print(llvm::errs());
        llvm::errs() << "\n";

        return SEM.bvVal(1, bitwidth);
    }

    auto selectMinSigned = [&](const SymbolicExpr& a, const SymbolicExpr& b) {
        return SymbolicExpr::select(SymbolicExpr::sle(a, b), a, b);
    };
    auto selectMaxUnsigned = [&](const SymbolicExpr& a, const SymbolicExpr& b) {
        return SymbolicExpr::select(SymbolicExpr::uge(a, b), a, b);
    };
    auto selectMinUnsigned = [&](const SymbolicExpr& a, const SymbolicExpr& b) {
        return SymbolicExpr::select(SymbolicExpr::ule(a, b), a, b);
    };

    switch (id) {
        case llvm::Intrinsic::smax:
            if (C.arg_size() == 2)
                return SymbolicExpr::smax(value2Expr(*C.getArgOperand(0)),
                                          value2Expr(*C.getArgOperand(1)));
            break;
        case llvm::Intrinsic::smin:
            if (C.arg_size() == 2)
                return selectMinSigned(value2Expr(*C.getArgOperand(0)),
                                       value2Expr(*C.getArgOperand(1)));
            break;
        case llvm::Intrinsic::umax:
            if (C.arg_size() == 2)
                return selectMaxUnsigned(value2Expr(*C.getArgOperand(0)),
                                         value2Expr(*C.getArgOperand(1)));
            break;
        case llvm::Intrinsic::umin:
            if (C.arg_size() == 2)
                return selectMinUnsigned(value2Expr(*C.getArgOperand(0)),
                                         value2Expr(*C.getArgOperand(1)));
            break;
        case llvm::Intrinsic::abs:
            if (C.arg_size() >= 1) {
                auto x = value2Expr(*C.getArgOperand(0));
                auto zero = SEM.bvVal(0, x.getBitwidth());
                return SymbolicExpr::select(SymbolicExpr::sge(x, zero), x, -x);
            }
            break;
        default:
            break;
    }

    llvm::errs() << "Warning: call2Expr unsupported intrinsic call, assumed to be 1: ";
    C.print(llvm::errs());
    llvm::errs() << "\n";

    return SEM.bvVal(1, bitwidth);
}

// expands an instruction into a symbolic expression
SymbolicExpr GA::inst2Expr(const llvm::Instruction& I) {

    auto & ctx_ = SEM.context();

    // debug print the instruction being converted
    // llvm::errs() << "DEBUG: Converting instruction to expression: ";
    // I.print(llvm::errs());
    // llvm::errs() << "\n";

    switch (I.getOpcode()) {

        // PHI node: weighted average based on incoming edge factors
        // the linear property is due to the linearity of value's effect on LC or TR
        case llvm::Instruction::PHI:{
            auto phi = llvm::dyn_cast<llvm::PHINode>(&I);
            auto sum = SEM.intVal(0);
            auto total_factor = SEM.intVal(0);
            for (unsigned i = 0; i < phi->getNumIncomingValues(); ++i) {
                auto incomingBB = phi->getIncomingBlock(i);
                auto currentBB = const_cast<llvm::BasicBlock*>(phi->getParent());
                auto incomingVal = phi->getIncomingValue(i);

                if (auto baseFactor = getFactor(incomingBB, currentBB)) {
                    if(isSolvableExitValue(incomingVal, incomingBB, currentBB)){
                        auto exit_value = getExitValueSCEV(incomingVal, incomingBB, currentBB);
                        sum = sum + baseFactor.value() * SCEV2Expr(*exit_value);
                    }
                    else{
                        sum = sum + baseFactor.value() * value2Expr(*incomingVal);
                    }
                    total_factor = total_factor + baseFactor.value();
                } else {
                    return SEM.bvInst(I);
                }
            }
            // Debug tracking, record the number of composite PHI nodes processed
            compositePHIs.insert(phi);

            // Normalize by the total factor
            auto normalized_expr = sum / total_factor;
            auto non_zero_total = SymbolicExpr::ne(total_factor, SEM.intVal(0));
            return SymbolicExpr::select(non_zero_total, normalized_expr, SEM.intVal(0));

        }
        case llvm::Instruction::Or:{
            auto op0 = I.getOperand(0);
            auto op1 = I.getOperand(1);
            auto expr0 = value2Expr(*op0);
            auto expr1 = value2Expr(*op1);
            return expr0 | expr1;
        }
        case llvm::Instruction::And:{
            auto op0 = I.getOperand(0);
            auto op1 = I.getOperand(1);
            auto expr0 = value2Expr(*op0);
            auto expr1 = value2Expr(*op1);
            return expr0 & expr1;
        }
        case llvm::Instruction::Add:{
            auto op0 = I.getOperand(0);
            auto op1 = I.getOperand(1);
            auto expr0 = value2Expr(*op0);
            auto expr1 = value2Expr(*op1);
            return expr0 + expr1;
        }
        case llvm::Instruction::Sub:{
            auto op0 = I.getOperand(0);
            auto op1 = I.getOperand(1);
            auto expr0 = value2Expr(*op0);
            auto expr1 = value2Expr(*op1);
            return expr0 - expr1;
        }
        case llvm::Instruction::Mul:{
            auto op0 = I.getOperand(0);
            auto op1 = I.getOperand(1);
            auto expr0 = value2Expr(*op0);
            auto expr1 = value2Expr(*op1);
            return expr0 * expr1;
        }
        case llvm::Instruction::UDiv:{
            auto op0 = I.getOperand(0);
            auto op1 = I.getOperand(1);
            auto expr0 = value2Expr(*op0);
            auto expr1 = value2Expr(*op1);
            return expr0 / expr1;
        }
        case llvm::Instruction::ZExt:{
            auto op = I.getOperand(0);
            auto expr = value2Expr(*op);
            unsigned targetBitwidth = I.getType()->getPrimitiveSizeInBits();
            return expr.zeroExtend(targetBitwidth - expr.getBitwidth());
        }
        case llvm::Instruction::SExt:{
            auto op = I.getOperand(0);
            auto expr = value2Expr(*op);
            unsigned targetBitwidth = I.getType()->getPrimitiveSizeInBits();
            return expr.signedExtend(targetBitwidth - expr.getBitwidth());
        }
        case llvm::Instruction::Br:{
            auto cond = I.getOperand(0);
            return value2Expr(*cond);
        }
        case llvm::Instruction::ICmp:{
            auto op0 = I.getOperand(0);
            auto op1 = I.getOperand(1);
            auto expr0 = value2Expr(*op0);
            auto expr1 = value2Expr(*op1);

            auto cmpInst = llvm::cast<llvm::ICmpInst>(&I);
            switch (cmpInst->getPredicate()) {
                case llvm::CmpInst::ICMP_EQ:
                    return SymbolicExpr::eq(expr0, expr1);
                case llvm::CmpInst::ICMP_NE:
                    return SymbolicExpr::ne(expr0, expr1);
                case llvm::CmpInst::ICMP_ULT:
                    return SymbolicExpr::ult(expr0, expr1);
                case llvm::CmpInst::ICMP_ULE:
                    return SymbolicExpr::ule(expr0, expr1);
                case llvm::CmpInst::ICMP_UGT:
                    return SymbolicExpr::ugt(expr0, expr1);
                case llvm::CmpInst::ICMP_UGE:
                    return SymbolicExpr::uge(expr0, expr1);
                case llvm::CmpInst::ICMP_SLT:
                    return SymbolicExpr::slt(expr0, expr1);
                case llvm::CmpInst::ICMP_SLE:
                    return SymbolicExpr::sle(expr0, expr1);
                case llvm::CmpInst::ICMP_SGT:
                    return SymbolicExpr::sgt(expr0, expr1);
                case llvm::CmpInst::ICMP_SGE:
                    return SymbolicExpr::sge(expr0, expr1);
                default: {
                    llvm::errs() << "Warning: inst2Expr ICmp unsupported predicate: " << cmpInst->getPredicate() << "\n";
                    return SEM.bvInst(I);
                }
            }
        }
        case llvm::Instruction::Select:{
            auto cond = I.getOperand(0);
            auto trueVal = I.getOperand(1);
            auto falseVal = I.getOperand(2);
            auto condExpr = value2Expr(*cond);
            auto trueExpr = value2Expr(*trueVal);
            auto falseExpr = value2Expr(*falseVal);
            return SymbolicExpr::select(condExpr, trueExpr, falseExpr);
        }
        case llvm::Instruction::AShr:{
            auto op0 = I.getOperand(0);
            auto op1 = I.getOperand(1);
            auto expr0 = value2Expr(*op0);
            auto expr1 = value2Expr(*op1);
            return SymbolicExpr::ashr(expr0, expr1);
        }
        case llvm::Instruction::Shl:{
            auto op0 = I.getOperand(0);
            auto op1 = I.getOperand(1);
            auto expr0 = value2Expr(*op0);
            auto expr1 = value2Expr(*op1);
            return SymbolicExpr::shl(expr0, expr1);
        }
        case llvm::Instruction::Trunc:{
            auto op = I.getOperand(0);
            auto expr = value2Expr(*op);
            unsigned targetBitwidth = I.getType()->getPrimitiveSizeInBits();
            unsigned srcBitwidth = expr.getBitwidth();
            if (targetBitwidth < srcBitwidth) {
                return expr.truncate(targetBitwidth);
            } else if (targetBitwidth == srcBitwidth) {
                return expr;
            } else {
                llvm::errs() << "Warning: Trunc target bitwidth greater than source bitwidth: "
                             << targetBitwidth << " > " << srcBitwidth << "\n";
                return SEM.bvInst(I);
            }
        }
        case llvm::Instruction::Freeze:{
            auto op = I.getOperand(0);
            return value2Expr(*op);
        }
        case llvm::Instruction::Load:{
            const auto* load = llvm::cast<llvm::LoadInst>(&I);
            if ((load->getType()->isIntegerTy() || load->getType()->isPointerTy())) {
                if (const auto* store = findPairedStoreForLoad(*load)) {
                    auto storedExpr = value2Expr(*store->getValueOperand());
                    unsigned loadBitwidth = SEM.getBitWidth(I);
                    if (storedExpr.getBitwidth() == loadBitwidth) {
                        return storedExpr;
                    }
                    llvm::errs() << "Warning: inst2Expr Load/store bitwidth mismatch, "
                                 << "falling back for load: ";
                    I.print(llvm::errs());
                    llvm::errs() << "\n";
                }
            }
            llvm::errs() << "Warning: inst2Expr Load instruction has no paired prior store, assumed to return 1 ";
            I.print(llvm::errs());
            llvm::errs() << "\n";
            auto bitwidth = SEM.getBitWidth(I);
            return SEM.bvVal(1, bitwidth);
        }
        case llvm::Instruction::Call: {
            if (auto *call = llvm::dyn_cast<llvm::CallInst>(&I)) {
                return call2Expr(*call);
            }
            return SEM.bvInst(I);
        }
        default:
            llvm::errs() << "Warning: inst2Expr Unsupported instruction, assumed to return 1 " << I.getOpcodeName() ;
            I.print(llvm::errs());
            llvm::errs() << "\n";
            auto bitwidth = SEM.getBitWidth(I);
            return SEM.bvVal(1, bitwidth);

    }
    // return SEM.bvInst(I);
}

SymbolicExpr GA::value2Expr(const llvm::Value& V) {
    // V.print(llvm::errs(), false);
    // llvm::errs() << "\n";

    // constants
    unsigned bitwidth = SEM.getBitWidth(V);
    if (auto* constant = llvm::dyn_cast<llvm::ConstantInt>(&V)) {
        return SEM.bvVal(constant->getValue().getSExtValue(), bitwidth);
    }
    if (auto* constant = llvm::dyn_cast<llvm::ConstantFP>(&V)) {
        // For floating point, use realVal or convert to bv if needed
        return SEM.realVal(constant->getValueAPF().convertToDouble());
    }
    if (llvm::isa<llvm::Argument>(&V)) {
        return SEM.bvValue(V);
    }
    if (llvm::isa<llvm::ConstantPointerNull>(&V)) {
        return SEM.bvVal(0, bitwidth);
    }

    // expanded variable
    if (auto* instruction = llvm::dyn_cast<llvm::Instruction>(&V)) {
        if (isSolvable(const_cast<llvm::Value*>(&V))) {
            return inst2Expr(*instruction);
        }
        llvm::errs() << "Warning: value2Expr unsolvable: " << V.getName() << "\n";
    }
    llvm::errs() << "Warning: value2Expr Unsupported value type: " << V.getType()->getTypeID() << " for value: ";
    V.printAsOperand(llvm::errs(), false);
    llvm::errs() << "\n";
    return SEM.bvValue(V);
}

// expand the symbolic count to an expression that only uses program inputs
string GA::getExpandedSCEV(const llvm::SCEV* scev){
    if (!scev) {
        llvm::errs() << "Error: getExpandedSCEV: SCEV is null\n";
        return "unknown";
    }

    std::string scevStr;
    llvm::raw_string_ostream rso(scevStr);
    printRootExpr(*scev, rso);
    rso.flush();

    // Expand the SCEV to a string representation
    return scevStr;
}

void GA::printRootExpr(const llvm::SCEV& E, llvm::raw_ostream &os){
    // Print the SCEV expression, replacing internal variables with printExpanded,
    // keeping original operations and constants untouched.
    if (const llvm::SCEVUnknown* u = llvm::dyn_cast<llvm::SCEVUnknown>(&E)) {
        // Replace variable with expanded form
        printExpanded(const_cast<llvm::Value*>(u->getValue()), os);
    } else if (const llvm::SCEVConstant* c = llvm::dyn_cast<llvm::SCEVConstant>(&E)) {
        // Print constant as is
        c->getValue()->printAsOperand(os, false);
    } else {
        // Print operation name
        // Print the SCEV type as a string instead of integer
        switch (E.getSCEVType()) {
            case llvm::scConstant:              os << "scConst("; break;
            case llvm::scVScale:                os << "scVScale("; break;
            case llvm::scTruncate:              os << "scTrunc("; break;
            case llvm::scZeroExtend:            os << "scZeroExt("; break;
            case llvm::scSignExtend:            os << "scSignExt("; break;
            case llvm::scAddExpr:               os << "scAdd("; break;
            case llvm::scMulExpr:               os << "scMul("; break;
            case llvm::scUDivExpr:              os << "scUDiv("; break;
            case llvm::scAddRecExpr:            os << "scAddRecExpr("; break;
            case llvm::scUMaxExpr:              os << "scUMax("; break;
            case llvm::scSMaxExpr:              os << "scSMax("; break;
            case llvm::scUMinExpr:              os << "scUMin("; break;
            case llvm::scSMinExpr:              os << "scSMin("; break;
            case llvm::scSequentialUMinExpr:    os << "scSequentialUMin("; break;
            case llvm::scPtrToInt:              os << "scPtrToInt("; break;
            case llvm::scUnknown:               os << "scUnknown("; break;
            case llvm::scCouldNotCompute:       os << "scCouldNotCompute("; break;
            default:                            os << "scOtherSCEV("; break;
        }
        bool first = true;
        for (const llvm::SCEV* op : E.operands()) {
            if (!first) os << ", ";
            first = false;
            printRootExpr(*op, os);
        }
        os << ")";
    }
}

void GA::printExpanded(const llvm::Value* I, llvm::raw_ostream &os){
    if (!isSolvable(I)){
        I->printAsOperand(os, false);
        return;
    }
    //expand cases
    if(const llvm::Instruction* i = llvm::dyn_cast<llvm::Instruction>(I)){
        if (i->getOpcode() == llvm::Instruction::PHI){
            printExpandedPHI(i, os);
            return;
        }
        // Map LLVM opcodes to SCEV operator names (with parentheses for consistency)
        switch (i->getOpcode()) {
            case llvm::Instruction::Add:    os << "scAdd(";     break;
            case llvm::Instruction::Mul:    os << "scMul(";     break;
            case llvm::Instruction::Sub:    os << "scSub(";     break;
            case llvm::Instruction::UDiv:   os << "scUDiv(";    break;
            case llvm::Instruction::SDiv:   os << "scSDiv(";    break;
            case llvm::Instruction::URem:   os << "scURem(";    break;
            case llvm::Instruction::SRem:   os << "scSRem(";    break;
            case llvm::Instruction::Shl:    os << "scShl(";     break;
            case llvm::Instruction::LShr:   os << "scLShr(";    break;
            case llvm::Instruction::AShr:   os << "scAShr(";    break;
            case llvm::Instruction::And:    os << "scAnd(";     break;
            case llvm::Instruction::Or:     os << "scOr(";      break;
            case llvm::Instruction::Xor:    os << "scXor(";     break;
            case llvm::Instruction::Trunc:  os << "scTrunc(";   break;
            case llvm::Instruction::ZExt:   os << "scZeroExt("; break;
            case llvm::Instruction::SExt:   os << "scSignExt("; break;
            default:
            os << "scOtherSCEV(";
            break;
        }
        bool first = true;
        for (const llvm::Use& opr : i->operands()) {
            if (!first) os << ", ";
            first = false;
            printExpanded(llvm::dyn_cast<llvm::Value>(opr.get()), os);
        }
        os << ")";
    }
    //basic cases
    else{
        I->printAsOperand(os, false);
    }
}

void GA::printExpandedPHI(const llvm::Value* I, llvm::raw_ostream & os){
    if (!I) {
        llvm::errs() << "Error: printExpandedPHI: Value is null\n";
        os << "unknown";
        return;
    }
    const llvm::PHINode* phi = llvm::dyn_cast<llvm::PHINode>(I);
    if (!phi) {
        llvm::errs() << "Error: printExpandedPHI: Not a PHI node\n";
        os << "unknown";
        return;
    }
    os << "scAdd(";
    for (unsigned i = 0; i < phi->getNumIncomingValues(); ++i) {
        if (i > 0) os << ", ";
        llvm::BasicBlock* incomingBB = phi->getIncomingBlock(i);
        const llvm::BasicBlock* currentBB = phi->getParent();
        llvm::Value* incomingVal = phi->getIncomingValue(i);
        if (auto baseFactor = getFactor(incomingBB, currentBB)) {
            os << "scMul(";
            os << baseFactor->str() << ", ";
            printExpanded(incomingVal, os);
            os << ")";
        } else {
            llvm::errs() << "printExpandedPHI: no TR expression for phi: ";
            phi->printAsOperand(llvm::errs(), false);
            llvm::errs() << " from basic block: " << GraphBuilder::getName(incomingBB) << "\n";
            phi->printAsOperand(os, false);
            os << "unknown";
        }
    }
    os << ")";
}

bool GA::isSolvableExitValue(const llvm::Value* v, const llvm::BasicBlock* from, const llvm::BasicBlock* to){

    //check if from belongs to a loop and to is outside the loop
    if (!v || !from || !to) return false;
    llvm::Loop* loop = LI.getLoopFor(const_cast<llvm::BasicBlock*>(from));
    if (!loop) return false;
    if (loop->contains(const_cast<llvm::BasicBlock*>(to))) return false;

    // check if SCEV can compute the exit value of v at the loop exit
    llvm::ScalarEvolution *SE = &this->SE;
    if (!SE) return false;

    const llvm::SCEV* scev = SE->getSCEVAtScope(const_cast<llvm::Value*>(v), loop->getParentLoop());
    if (llvm::isa<llvm::SCEVCouldNotCompute>(scev)) {
        return false;
    }
    return true;
}

llvm::SCEV* GA::getExitValueSCEV(const llvm::Value* v, const llvm::BasicBlock* from, const llvm::BasicBlock* to){
    if (!v || !from || !to) return nullptr;

    llvm::Loop* loop = LI.getLoopFor(const_cast<llvm::BasicBlock*>(from));
    if (!loop) return nullptr;
    if (loop->contains(const_cast<llvm::BasicBlock*>(to))) return nullptr;

    llvm::ScalarEvolution *SE = &this->SE;
    if (!SE) return nullptr;

    const llvm::SCEV* scev = SE->getSCEVAtScope(const_cast<llvm::Value*>(v), loop->getParentLoop());
    if (llvm::isa<llvm::SCEVCouldNotCompute>(scev)) {
        return nullptr;
    }
    return const_cast<llvm::SCEV*>(scev);
}

bool GA::isSolvable(const llvm::Value* v){
    if (!v) return false;
    std::set<const llvm::Value*> visited;
    std::set<const llvm::Value*> recStack;

    std::function<bool(const llvm::Value*)> hasCircularDependency = [&](const llvm::Value* V) -> bool {

        if (recStack.count(V)) return true;
        if (visited.count(V)) return false;

        visited.insert(V);
        recStack.insert(V);

        if (auto *phi = llvm::dyn_cast<llvm::PHINode>(V)) {
            for (unsigned i = 0; i < phi->getNumIncomingValues(); ++i) {
                // handle outsider induction variables whose values can be computed through SCEV
                if(isSolvableExitValue(phi->getIncomingValue(i), phi->getIncomingBlock(i), phi->getParent())){
                    continue;
                }

                if (hasCircularDependency(phi->getIncomingValue(i)))
                    return true;
            }
        }
        else if (auto *I = llvm::dyn_cast<llvm::Instruction>(V)) {
            for (auto &Op : I->operands()) {
                if (hasCircularDependency(Op.get()))
                    return true;
            }
        }

        recStack.erase(V);
        return false;
    };

    return !hasCircularDependency(v);
}
