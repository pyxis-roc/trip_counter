#include <z3++.h>
#include "symb_expr.hpp"
#include "llvm/Analysis/ScalarEvolutionExpressions.h"
#include "llvm/IR/Instruction.h"
#include "llvm/Support/raw_ostream.h"


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
SymbolicExpr SymbolicExpr::simplify() const {
    return SymbolicExpr(ctx_, expr_.simplify());
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

SymbolicExpr SymbolicExpr::operator-() const {
    return SymbolicExpr(ctx_, -expr_);
}

SymbolicExpr SymbolicExpr::operator&(const SymbolicExpr& rhs) const {
    return SymbolicExpr(ctx_, expr_ & rhs.expr_);
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

SymbolicExpr SymbolicExpr::signedMax(const SymbolicExpr& a, const SymbolicExpr& b) {
    return SymbolicExpr(a.ctx_, z3::max(a.expr_, b.expr_));
}

unsigned SymbolicExpr::getBitwidth() const {
    return expr_.get_sort().bv_size();
}

bool SymbolicExpr::substitude(const SymbolicExpr& original, const SymbolicExpr& with) {
    // Use Z3's substitute API to replace all occurrences of the variable named 'original' with 'with.expr_'
    z3::expr_vector from(ctx_);
    z3::expr_vector to(ctx_);
    from.push_back(original.expr_);
    to.push_back(with.expr_);
    z3::expr new_expr = expr_.substitute(from, to);
    bool changed = !z3::eq(expr_, new_expr);
    expr_ = new_expr;
    return changed;
}

std::string SymbolicExpr::str() const {
    std::string s = expr_.to_string();
    s.erase(std::remove(s.begin(), s.end(), '\n'), s.end());
    return s;
}

// Access underlying Z3 expr
const z3::expr& SymbolicExpr::expr() const {
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
    return zero64();
}

SymbolicExpr SymbolicExprManager::zero32() {
    return SymbolicExpr(ctx_, ctx_.bv_val(0, 32));
}

SymbolicExpr SymbolicExprManager::zero64() {
    return SymbolicExpr(ctx_, ctx_.bv_val(0, 64));
}

SymbolicExpr SymbolicExprManager::one() {
    return one64();
}

SymbolicExpr SymbolicExprManager::one32() {
    return SymbolicExpr(ctx_, ctx_.bv_val(1, 32));
}

SymbolicExpr SymbolicExprManager::one64() {
    return SymbolicExpr(ctx_, ctx_.bv_val(1, 64));
}

// Static API for named symbol
SymbolicExpr SymbolicExprManager::named(const std::string& name) {
    return named64(name);
}

SymbolicExpr SymbolicExprManager::named32(const std::string& name) {
    return SymbolicExpr(ctx_, ctx_.bv_const(name.c_str(), 32));
}

SymbolicExpr SymbolicExprManager::named64(const std::string& name) {
    return SymbolicExpr(ctx_, ctx_.bv_const(name.c_str(), 64));
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

SymbolicExpr SymbolicExprManager::bvVal(uint64_t val, unsigned bitwidth) {
    return SymbolicExpr(ctx_, ctx_.bv_val(val, bitwidth));
}

SymbolicExpr SymbolicExprManager::bvNamed(const std::string& name, unsigned bitwidth) {
    return SymbolicExpr(ctx_, ctx_.bv_const(name.c_str(), bitwidth));
}
