/*
    Symbolic Expression Header
    This file contains the definition of symbolic expressions,
    including their representation and manipulation.

    It uses the Z3 SMT solver for symbolic reasoning.
*/
#pragma once

#include "llvm/IR/Instruction.h"
#include "llvm/Analysis/ScalarEvolutionExpressions.h"
#include <optional>
#include <set>
#include <string>
#include <vector>
#include <z3++.h>


class SymbolicExpr {
public:
    // Constructors
    SymbolicExpr(z3::context& ctx, const z3::expr& expr);

    // Copy/move
    SymbolicExpr(const SymbolicExpr& other);
    SymbolicExpr(SymbolicExpr&& other) noexcept;
    SymbolicExpr& operator=(const SymbolicExpr& other);
    SymbolicExpr& operator=(SymbolicExpr&& other) noexcept;

    // Manipulation
    SymbolicExpr operator+(const SymbolicExpr& rhs) const;
    SymbolicExpr operator-(const SymbolicExpr& rhs) const;
    SymbolicExpr operator*(const SymbolicExpr& rhs) const;
    SymbolicExpr operator/(const SymbolicExpr& rhs) const;
    SymbolicExpr operator-() const;
    SymbolicExpr operator&(const SymbolicExpr& rhs) const;

    SymbolicExpr signedExtend(unsigned additionalBits) const;
    SymbolicExpr zeroExtend(unsigned additionalBits) const;
    SymbolicExpr truncate(unsigned additionalBits) const;

    static SymbolicExpr smax(const SymbolicExpr& a, const SymbolicExpr& b);
    static SymbolicExpr eq(const SymbolicExpr& a, const SymbolicExpr& b);
    static SymbolicExpr ne(const SymbolicExpr& a, const SymbolicExpr& b);
    static SymbolicExpr ult(const SymbolicExpr& a, const SymbolicExpr& b);
    static SymbolicExpr ule(const SymbolicExpr& a, const SymbolicExpr& b);
    static SymbolicExpr ugt(const SymbolicExpr& a, const SymbolicExpr& b);
    static SymbolicExpr uge(const SymbolicExpr& a, const SymbolicExpr& b);
    static SymbolicExpr slt(const SymbolicExpr& a, const SymbolicExpr& b);
    static SymbolicExpr sle(const SymbolicExpr& a, const SymbolicExpr& b);
    static SymbolicExpr sgt(const SymbolicExpr& a, const SymbolicExpr& b);
    static SymbolicExpr sge(const SymbolicExpr& a, const SymbolicExpr& b);
    static SymbolicExpr select(const SymbolicExpr& cond, const SymbolicExpr& trueExpr, const SymbolicExpr& falseExpr);
    static SymbolicExpr ashr(const SymbolicExpr& a, const SymbolicExpr& b);
    static SymbolicExpr lshr(const SymbolicExpr& a, const SymbolicExpr& b);
    static SymbolicExpr shl(const SymbolicExpr& a, const SymbolicExpr& b);

    unsigned getBitwidth() const;

    // Access underlying Z3 expr
    const z3::expr& z3expr() const;

    // String representation
    std::string str() const;

    // substitution to replace symbolic variables with symbolic expressions
    void substitute(const SymbolicExpr& original, const SymbolicExpr& with);
    void substitute(const std::vector<SymbolicExpr>& inputs, const std::vector<int>& inputValues);
    void substitute(const std::vector<SymbolicExpr>& original, const std::vector<SymbolicExpr>& with);

    void simplify();

private:
    z3::context& ctx_;
    z3::expr expr_;
};

class SymbolicExprManager {
public:
    explicit SymbolicExprManager();
    ~SymbolicExprManager();
    
    // Debug tracking, unique loop counts and true ratios
    std::set<std::string> loopCountNames;
    std::set<std::string> trueRatioNames;

    z3::context& context();

    // Static API for constants
    SymbolicExpr zero();
    SymbolicExpr zero32();
    SymbolicExpr zero64();

    SymbolicExpr one();
    SymbolicExpr one32();
    SymbolicExpr one64();

    SymbolicExpr intVal(int val);
    SymbolicExpr intVal32(int val);
    SymbolicExpr intVal64(int val);

    SymbolicExpr realVal(double val);
    SymbolicExpr realNamed(const std::string& name);

    SymbolicExpr bvVal(uint64_t val, unsigned bitwidth);
    SymbolicExpr bvNamed(const std::string& name, unsigned bitwidth);

    // Static API for named symbol
    SymbolicExpr named(const std::string& name);
    SymbolicExpr named32(const std::string& name);
    SymbolicExpr named64(const std::string& name);

    
    // Helper function for analysis related construction
    SymbolicExpr symbTrueRatio(const std::string& name);
    SymbolicExpr symbLoopCount(const std::string& name);
    SymbolicExpr symbUnknown(const std::string& name);
    SymbolicExpr bvInst(const llvm::Instruction& I);
    SymbolicExpr bvValue(const llvm::Value& V);
    SymbolicExpr bvSCEV(const llvm::SCEV& scev);
    
    // find corresponding symbolic expression created for instruction, value or SCEV
    std::optional<SymbolicExpr> findInst(const llvm::Instruction& I);
    std::optional<SymbolicExpr> findValue(const llvm::Value& V);
    std::optional<SymbolicExpr> findSCEV(const llvm::SCEV& scev);

    std::vector<SymbolicExpr> getAllProgramExpr() const;

    void substitude(const std::vector<SymbolicExpr>& inputs, const std::vector<int>& inputValues);
    
    unsigned getBitWidth(const llvm::Instruction& I);
    unsigned getBitWidth(const llvm::Value& V);
    unsigned getBitWidth(const llvm::SCEV& scev);

    private:
    z3::context ctx_;

};