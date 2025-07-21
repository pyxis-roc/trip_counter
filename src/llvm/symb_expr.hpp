/*
    Symbolic Expression Header
    This file contains the definition of symbolic expressions,
    including their representation and manipulation.

    It uses the Z3 SMT solver for symbolic reasoning.
*/

#include "z3++.h"
#include "llvm/Analysis/ScalarEvolution.h"
#include "llvm/IR/Instruction.h"
#include "llvm/IR/Value.h"


class SymbolicExpr {
public:
    // Constructors
    SymbolicExpr(z3::context& ctx, const z3::expr& expr);
    SymbolicExpr(z3::context& ctx, int val); // constant integer
    SymbolicExpr(z3::context& ctx, const std::string& name); // named symbol

    // Copy/move
    SymbolicExpr(const SymbolicExpr& other);
    SymbolicExpr(SymbolicExpr&& other) noexcept;
    SymbolicExpr& operator=(const SymbolicExpr& other);
    SymbolicExpr& operator=(SymbolicExpr&& other) noexcept;

    // Manipulation
    SymbolicExpr simplify() const;
    SymbolicExpr operator+(const SymbolicExpr& rhs) const;
    SymbolicExpr operator-(const SymbolicExpr& rhs) const;
    SymbolicExpr operator*(const SymbolicExpr& rhs) const;
    SymbolicExpr operator/(const SymbolicExpr& rhs) const;
    SymbolicExpr operator-() const;

    // Access underlying Z3 expr
    const z3::expr& expr() const;

    // String representation
    std::string str() const;

    // substitution to replace symbolic variables with symbolic expressions
    bool substitude(const SymbolicExpr& original, const SymbolicExpr& with);

private:
    z3::context& ctx_;
    z3::expr expr_;
};

class SymbolicExprManager {
public:
    explicit SymbolicExprManager();
    ~SymbolicExprManager();

    z3::context& context();

    // Static API for constants
    SymbolicExpr zero();
    SymbolicExpr zero32();
    SymbolicExpr zero64();

    SymbolicExpr one();
    SymbolicExpr one32();
    SymbolicExpr one64();

    // Static API for named symbol
    SymbolicExpr named(const std::string& name);
    SymbolicExpr named32(const std::string& name);
    SymbolicExpr named64(const std::string& name);

    // helper function to convert SCEV to SymbolicExpr
    SymbolicExpr fromSCEV(const llvm::SCEV& E);
    SymbolicExpr fromInst(const llvm::Instruction& I);
    SymbolicExpr fromVal(const llvm::Value& V);

private:
    z3::context ctx_;
};