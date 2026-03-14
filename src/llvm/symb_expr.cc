#include <optional>
#include <string>
#include "symb_expr.hpp"
#include "llvm/Analysis/ScalarEvolutionExpressions.h"
#include "llvm/IR/Instruction.h"
#include "llvm/IR/DataLayout.h"
#include "llvm/IR/Module.h"
#include "llvm/IR/Constants.h"
#include "llvm/Support/raw_ostream.h"


// Use maps to cache symbolic expressions for instructions and values
#include <unordered_map>

namespace {
    // Anonymous namespace for internal linkage
    std::unordered_map<const llvm::Instruction*, SymbolicExpr> instExprCache;
    std::unordered_map<const llvm::Value*, SymbolicExpr> valueExprCache;
    std::unordered_map<const llvm::SCEV*, SymbolicExpr> scevExprCache;
    std::unordered_map<std::string, SymbolicExpr> rawExprCache;
}

// Constructors
SymbolicExpr::SymbolicExpr(z3::context& ctx, const z3::expr& expr)
    : ctx_(ctx), expr_(expr) {}

// Copy/move
SymbolicExpr::SymbolicExpr(const SymbolicExpr& other)
    : ctx_(other.ctx_), expr_(other.expr_) {}
SymbolicExpr::SymbolicExpr(SymbolicExpr&& other) noexcept
    : ctx_(other.ctx_), expr_(std::move(other.expr_)) {}

SymbolicExpr& SymbolicExpr::operator=(const SymbolicExpr& other) {
    if (this != &other) {
        // ctx_ is a reference, assumed to be the same context
        expr_ = other.expr_;
    }
    return *this;
}

SymbolicExpr& SymbolicExpr::operator=(SymbolicExpr&& other) noexcept {
    if (this != &other) {
        expr_ = std::move(other.expr_);
        // ctx_ is a reference, assumed to be the same context
    }
    return *this;
}

// Manipulation
void SymbolicExpr::simplify() {
    expr_ = expr_.simplify();
}

SymbolicExpr SymbolicExpr::operator+(const SymbolicExpr& rhs) const {
    return SymbolicExpr(ctx_, expr_ + rhs.expr_);
}

SymbolicExpr SymbolicExpr::operator-(const SymbolicExpr& rhs) const {
    return SymbolicExpr(ctx_, expr_ - rhs.expr_);
}

SymbolicExpr SymbolicExpr::operator*(const SymbolicExpr& rhs) const {
    return SymbolicExpr(ctx_, expr_ * rhs.expr_);
}

SymbolicExpr SymbolicExpr::operator/(const SymbolicExpr& rhs) const {
    return SymbolicExpr(ctx_, expr_ / rhs.expr_);
}

SymbolicExpr SymbolicExpr::operator%(const SymbolicExpr& rhs) const {
    return SymbolicExpr(ctx_, z3::srem(expr_, rhs.expr_));
}

SymbolicExpr SymbolicExpr::operator-() const {
    return SymbolicExpr(ctx_, -expr_);
}

SymbolicExpr SymbolicExpr::operator&(const SymbolicExpr& rhs) const {
    return SymbolicExpr(ctx_, expr_ & rhs.expr_);
}

SymbolicExpr SymbolicExpr::operator|(const SymbolicExpr& rhs) const {
    return SymbolicExpr(ctx_, expr_ | rhs.expr_);
}

SymbolicExpr SymbolicExpr::signedExtend(unsigned additionalBits) const {
    return SymbolicExpr(ctx_, z3::sext(expr_, additionalBits));
}

SymbolicExpr SymbolicExpr::zeroExtend(unsigned additionalBits) const {
    return SymbolicExpr(ctx_, z3::zext(expr_, additionalBits));
}

SymbolicExpr SymbolicExpr::truncate(unsigned additionalBits) const {
    return SymbolicExpr(ctx_, expr_.extract(additionalBits - 1, 0));
}

SymbolicExpr SymbolicExpr::smax(const SymbolicExpr& a, const SymbolicExpr& b) {
    return SymbolicExpr(a.ctx_, z3::max(a.expr_, b.expr_));
}

SymbolicExpr SymbolicExpr::eq(const SymbolicExpr& a, const SymbolicExpr& b) {
    z3::expr cmp = a.expr_ == b.expr_;
    z3::expr bv = z3::ite(cmp, a.ctx_.bv_val(1, 1), a.ctx_.bv_val(0, 1));
    return SymbolicExpr(a.ctx_, bv);
}

SymbolicExpr SymbolicExpr::ne(const SymbolicExpr& a, const SymbolicExpr& b) {
    z3::expr cmp = a.expr_ != b.expr_;
    z3::expr bv = z3::ite(cmp, a.ctx_.bv_val(1, 1), a.ctx_.bv_val(0, 1));
    return SymbolicExpr(a.ctx_, bv);
}

SymbolicExpr SymbolicExpr::ult(const SymbolicExpr& a, const SymbolicExpr& b) {
    z3::expr cmp = z3::ult(a.expr_, b.expr_);
    z3::expr bv = z3::ite(cmp, a.ctx_.bv_val(1, 1), a.ctx_.bv_val(0, 1));
    return SymbolicExpr(a.ctx_, bv);
}

SymbolicExpr SymbolicExpr::ule(const SymbolicExpr& a, const SymbolicExpr& b) {
    z3::expr cmp = z3::ule(a.expr_, b.expr_);
    z3::expr bv = z3::ite(cmp, a.ctx_.bv_val(1, 1), a.ctx_.bv_val(0, 1));
    return SymbolicExpr(a.ctx_, bv);
}

SymbolicExpr SymbolicExpr::ugt(const SymbolicExpr& a, const SymbolicExpr& b) {
    z3::expr cmp = z3::ugt(a.expr_, b.expr_);
    z3::expr bv = z3::ite(cmp, a.ctx_.bv_val(1, 1), a.ctx_.bv_val(0, 1));
    return SymbolicExpr(a.ctx_, bv);
}

SymbolicExpr SymbolicExpr::uge(const SymbolicExpr& a, const SymbolicExpr& b) {
    z3::expr cmp = z3::uge(a.expr_, b.expr_);
    z3::expr bv = z3::ite(cmp, a.ctx_.bv_val(1, 1), a.ctx_.bv_val(0, 1));
    return SymbolicExpr(a.ctx_, bv);
}

SymbolicExpr SymbolicExpr::slt(const SymbolicExpr& a, const SymbolicExpr& b) {
    z3::expr cmp = z3::slt(a.expr_, b.expr_);
    z3::expr bv = z3::ite(cmp, a.ctx_.bv_val(1, 1), a.ctx_.bv_val(0, 1));
    return SymbolicExpr(a.ctx_, bv);
}

SymbolicExpr SymbolicExpr::sle(const SymbolicExpr& a, const SymbolicExpr& b) {
    z3::expr cmp = z3::sle(a.expr_, b.expr_);
    z3::expr bv = z3::ite(cmp, a.ctx_.bv_val(1, 1), a.ctx_.bv_val(0, 1));
    return SymbolicExpr(a.ctx_, bv);
}

SymbolicExpr SymbolicExpr::sgt(const SymbolicExpr& a, const SymbolicExpr& b) {
    z3::expr cmp = z3::sgt(a.expr_, b.expr_);
    z3::expr bv = z3::ite(cmp, a.ctx_.bv_val(1, 1), a.ctx_.bv_val(0, 1));
    return SymbolicExpr(a.ctx_, bv);
}

SymbolicExpr SymbolicExpr::sge(const SymbolicExpr& a, const SymbolicExpr& b) {
    z3::expr cmp = z3::sge(a.expr_, b.expr_);
    z3::expr bv = z3::ite(cmp, a.ctx_.bv_val(1, 1), a.ctx_.bv_val(0, 1));
    return SymbolicExpr(a.ctx_, bv);
}

SymbolicExpr SymbolicExpr::select(const SymbolicExpr &cond, const SymbolicExpr &trueExpr, const SymbolicExpr &falseExpr) {
    z3::expr cond_bool = cond.expr_ == cond.ctx_.bv_val(1, cond.expr_.get_sort().bv_size());
    z3::expr ite_expr = z3::ite(cond_bool, trueExpr.expr_, falseExpr.expr_);
    return SymbolicExpr(cond.ctx_, ite_expr);
}

SymbolicExpr SymbolicExpr::ashr(const SymbolicExpr& a, const SymbolicExpr& b) {
    return SymbolicExpr(a.ctx_, z3::ashr(a.expr_, b.expr_));
}

SymbolicExpr SymbolicExpr::lshr(const SymbolicExpr& a, const SymbolicExpr& b) {
    return SymbolicExpr(a.ctx_, z3::lshr(a.expr_, b.expr_));
}

SymbolicExpr SymbolicExpr::shl(const SymbolicExpr& a, const SymbolicExpr& b) {
    return SymbolicExpr(a.ctx_, z3::shl(a.expr_, b.expr_));
}

unsigned SymbolicExpr::getBitwidth() const {
    return expr_.get_sort().bv_size();
}

void SymbolicExpr::substitute(const SymbolicExpr& original, const SymbolicExpr& with) {
    // Use Z3's substitute API to replace all occurrences of the variable named 'original' with 'with.expr_'
    
    z3::expr_vector from(ctx_);
    z3::expr_vector to(ctx_);
    from.push_back(original.expr_);
    to.push_back(with.expr_);
    z3::expr new_expr = expr_.substitute(from, to);
    expr_ = new_expr;
    
}

void SymbolicExpr::substitute(const std::vector<SymbolicExpr>& original, const std::vector<SymbolicExpr>& with) {
    // Use Z3's substitute API to replace all occurrences of the variable named 'original' with 'with.expr_'
    if (original.size() != with.size()) {
        throw std::invalid_argument("Original and with vectors must have the same size");
    }

    for (int i = 0; i < original.size(); ++i) {
        substitute(original[i], with[i]);
    }
}

void SymbolicExpr::substitute(const std::vector<SymbolicExpr>& inputs, const std::vector<int>& inputValues) {
    if (inputs.size() != inputValues.size()) {
        throw std::invalid_argument("Inputs and inputValues must have the same size");
    }
    
    z3::expr_vector from(ctx_);
    z3::expr_vector to(ctx_);
    
    for (size_t i = 0; i < inputs.size(); ++i) {
        from.push_back(inputs[i].z3expr());
        to.push_back(ctx_.bv_val(inputValues[i], inputs[i].getBitwidth()));
    }
    
    expr_ = expr_.substitute(from, to);
}

std::string SymbolicExpr::str() const {
    std::string s = expr_.to_string();
    s.erase(std::remove(s.begin(), s.end(), '\n'), s.end());
    return s;
}

// Access underlying Z3 expr
const z3::expr& SymbolicExpr::z3expr() const {
    return expr_;
}

// SymbolicExprManager implementation
SymbolicExprManager::SymbolicExprManager() : ctx_() {}
SymbolicExprManager::~SymbolicExprManager() {}

z3::context& SymbolicExprManager::context() {
    return ctx_;
}

// Static API for constants
SymbolicExpr SymbolicExprManager::zero() {
    totalExprCount++;
    return zero64();
}

SymbolicExpr SymbolicExprManager::zero32() {
    totalExprCount++;
    return SymbolicExpr(ctx_, ctx_.bv_val(0, 32));
}

SymbolicExpr SymbolicExprManager::zero64() {
    totalExprCount++;
    return SymbolicExpr(ctx_, ctx_.bv_val(0, 64));
}

SymbolicExpr SymbolicExprManager::one() {
    totalExprCount++;
    return one64();
}

SymbolicExpr SymbolicExprManager::one32() {
    totalExprCount++;
    return SymbolicExpr(ctx_, ctx_.bv_val(1, 32));
}

SymbolicExpr SymbolicExprManager::one64() {
    totalExprCount++;
    return SymbolicExpr(ctx_, ctx_.bv_val(1, 64));
}

// Static API for named symbol
SymbolicExpr SymbolicExprManager::named(const std::string& name) {
    totalExprCount++;
    return named64(name);
}

SymbolicExpr SymbolicExprManager::named32(const std::string& name) {
    auto it = rawExprCache.find(name);
    if (it != rawExprCache.end()) {
        return it->second;
    }
    auto expr = SymbolicExpr(ctx_, ctx_.bv_const(name.c_str(), 32));
    rawExprCache.emplace(name, expr);
    totalExprCount++;
    return expr;
}

SymbolicExpr SymbolicExprManager::named64(const std::string& name) {
    auto it = rawExprCache.find(name);
    if (it != rawExprCache.end()) {
        return it->second;
    }
    auto expr = SymbolicExpr(ctx_, ctx_.bv_const(name.c_str(), 64));
    rawExprCache.emplace(name, expr);
    totalExprCount++;
    return expr;
}

SymbolicExpr SymbolicExprManager::intVal(int val) {
    return intVal64(val);
}

SymbolicExpr SymbolicExprManager::intVal32(int val) {
    return SymbolicExpr(ctx_, ctx_.bv_val(val, 32));
}

SymbolicExpr SymbolicExprManager::intVal64(int val) {
    return SymbolicExpr(ctx_, ctx_.bv_val(val, 64));
}

SymbolicExpr SymbolicExprManager::realVal(double val) {
    // Use string conversion to avoid ambiguity in real_val overloads
    return SymbolicExpr(ctx_, ctx_.real_val(std::to_string(val).c_str()));
}

SymbolicExpr SymbolicExprManager::realNamed(const std::string& name) {
    return SymbolicExpr(ctx_, ctx_.real_const(name.c_str()));
}

SymbolicExpr SymbolicExprManager::bvVal(uint64_t val, unsigned bitwidth) {
    return SymbolicExpr(ctx_, ctx_.bv_val(val, bitwidth));
}

SymbolicExpr SymbolicExprManager::bvNamed(const std::string& name, unsigned bitwidth) {
    auto it = rawExprCache.find(name);
    if (it != rawExprCache.end()) {
        return it->second;
    }
    auto expr = SymbolicExpr(ctx_, ctx_.bv_const(name.c_str(), bitwidth));
    rawExprCache.emplace(name, expr);
    return expr;
}

SymbolicExpr SymbolicExprManager::symbTrueRatio(const std::string& name) {
    trueRatioNames.insert(name);
    return named(name);
}

SymbolicExpr SymbolicExprManager::symbLoopCount(const std::string& name) {
    loopCountNames.insert(name);
    return named(name);
}

SymbolicExpr SymbolicExprManager::symbUnknown(const std::string& name) {
    return named(name);
}

SymbolicExpr SymbolicExprManager::bvInst(const llvm::Instruction& I) {
    auto it = instExprCache.find(&I);
    if (it != instExprCache.end()) {
        return it->second;
    }
    static int counter = 0;
    std::string name = "inst_" + I.getName().str() + "_" + std::to_string(++counter);
    if (I.getName().str().empty()) {
        const llvm::BasicBlock* BB = I.getParent();
        std::string bbStr;
        if (!BB) {
            bbStr = "null";
        } else {
            llvm::raw_string_ostream rso(bbStr);
            const_cast<llvm::BasicBlock*>(BB)->printAsOperand(rso, false);
            (void)rso.str();
        }
        llvm::errs() << "Warning: Instruction has empty name; kept default naming '" << name
                     << "'. Context basic block operand: " << bbStr << "\n";
    }

    auto bitwidth = getBitWidth(I);

    if (bitwidth == 0) {
        llvm::errs() << "Warning: Instruction " << name << "with type" << I.getType() << " has zero bitwidth, defaulting to 64 bits\n";
        bitwidth = 64;
    }
    SymbolicExpr expr = bvNamed(name, bitwidth);
    instExprCache.emplace(&I, expr);
    return expr;
}

SymbolicExpr SymbolicExprManager::bvValue(const llvm::Value& V) {
    auto it = valueExprCache.find(&V);
    if (it != valueExprCache.end()) {
        return it->second;
    }
    static int counter = 0;
    if (V.getName().str().empty()) {
        llvm::errs() << "Warning: Value has empty name; using default naming 'val_" << counter + 1 << "'. Context: ";
        V.print(llvm::errs(), false);
        llvm::errs() << "\n";
    }
    std::string name = V.getName().str().empty() ? "val_" + std::to_string(++counter) : V.getName().str();
    
    auto bitwidth = getBitWidth(V);
    if (bitwidth == 0) {
        llvm::errs() << "Warning: Value " << name << " has zero bitwidth, defaulting to 64 bits\n";
        bitwidth = 64;
    }
    SymbolicExpr expr = bvNamed(name, bitwidth);
    valueExprCache.emplace(&V, expr);
    return expr;
}

SymbolicExpr SymbolicExprManager::bvSCEV(const llvm::SCEV& scev) {
    auto it = scevExprCache.find(&scev);
    if (it != scevExprCache.end()) {
        return it->second;
    }
    static int counter = 0;
    std::string name = "scev_" + std::to_string(++counter);

    auto bitwidth = getBitWidth(scev);
    if (bitwidth == 0) {
        llvm::errs() << "Warning: SCEV " << name << " has zero bitwidth, defaulting to 64 bits\n";
        bitwidth = 64;
    }
    SymbolicExpr expr = bvNamed(name, bitwidth);
    scevExprCache.emplace(&scev, expr);
    return expr;
}

std::optional<SymbolicExpr> SymbolicExprManager::findInst(const llvm::Instruction& I) {
    auto it = instExprCache.find(&I);
    if (it != instExprCache.end()) {
        return it->second;
    }
    return std::nullopt; // If not found, return nullopt
}

std::optional<SymbolicExpr> SymbolicExprManager::findValue(const llvm::Value& V) {
    auto it = valueExprCache.find(&V);
    if (it != valueExprCache.end()) {
        return it->second;
    }
    return std::nullopt; // If not found, return nullopt
}

std::optional<SymbolicExpr> SymbolicExprManager::findSCEV(const llvm::SCEV& scev) {
    auto it = scevExprCache.find(&scev);
    if (it != scevExprCache.end()) {
        return it->second;
    }
    return std::nullopt; // If not found, return nullopt
}

std::vector<SymbolicExpr> SymbolicExprManager::getAllProgramExpr() const {
    std::vector<SymbolicExpr> allExprs;
    for (const auto& pair : instExprCache) {
        allExprs.push_back(pair.second);
    }
    for (const auto& pair : valueExprCache) {
        allExprs.push_back(pair.second);
    }
    for (const auto& pair : scevExprCache) {
        allExprs.push_back(pair.second);
    }
    for (const auto& pair : rawExprCache) {
        allExprs.push_back(pair.second);
    }
    return allExprs;
}

unsigned SymbolicExprManager::getBitWidth(const llvm::Instruction& I) {
    const llvm::Type* type = I.getType();
    const llvm::Module* M = I.getModule();
    const llvm::DataLayout* DL = M ? &M->getDataLayout() : nullptr;

    if (DL){
        return DL->getTypeSizeInBits(const_cast<llvm::Type*>(type));
    }
    else{
        llvm::errs() << "Warning: getBitWidth(Instruction): Instruction without Module/DataLayout, defaulting to 64 bits\n";
        return 64;
    }

    return 0;
}

unsigned SymbolicExprManager::getBitWidth(const llvm::Value& V) {
    const llvm::Type* type = V.getType();

    // Handle null pointer values
    if (llvm::isa<llvm::ConstantPointerNull>(&V)) {
        // Null pointer has the bitwidth of a pointer
        const llvm::Module* M = nullptr;
        
        // Try to find module context from other sources
        if (auto* I = llvm::dyn_cast<llvm::Instruction>(&V)) {
            M = I->getModule();
        }
        
        if (M) {
            return M->getDataLayout().getPointerSizeInBits();
        }
        llvm::errs() << "Warning: getBitWidth(Value): null pointer without Module context, defaulting to 64 bits\n";
        return 64;
    }

    const llvm::Module* M = nullptr;
    if (auto* I = llvm::dyn_cast<llvm::Instruction>(&V)) {
        M = I->getModule();
    } else if (auto* arg = llvm::dyn_cast<llvm::Argument>(&V)) {
        if (auto* func = arg->getParent()) {
            M = func->getParent();
        }
    } else if (auto* gv = llvm::dyn_cast<llvm::GlobalValue>(&V)) {
        M = gv->getParent();
    }
    
    const llvm::DataLayout* DL = M ? &M->getDataLayout() : nullptr;

    if (type->isPointerTy()) {
        if (DL) {
            return DL->getPointerSizeInBits();
        }
        llvm::errs() << "Warning: getBitWidth(Value): pointer type without Module/DataLayout, defaulting to 64 bits\n";
        return 64;
    }

    if (type->isArrayTy()) {
        if (type->isSized()) {
            if (DL) {
                return DL->getTypeSizeInBits(const_cast<llvm::Type*>(type));
            }

            // Fallback without DataLayout: derive by element width when possible.
            const llvm::Type* elemType = type->getArrayElementType();
            unsigned elemBits = elemType->getPrimitiveSizeInBits();
            if (elemBits > 0) {
                return elemBits * type->getArrayNumElements();
            }
        }

        llvm::errs() << "Warning: getBitWidth(Value): array type without computable size or Module/DataLayout, defaulting to 64 bits\n";
        return 64;
    }

    unsigned primitiveBits = type->getPrimitiveSizeInBits();
    if (primitiveBits > 0) {
        return primitiveBits;
    }

    if (type->isSized() && DL) {
        return DL->getTypeSizeInBits(const_cast<llvm::Type*>(type));
    }

    return 0;
}

unsigned SymbolicExprManager::getBitWidth(const llvm::SCEV& scev) {
    return scev.getType()->getPrimitiveSizeInBits();
}
