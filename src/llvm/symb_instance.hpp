/*
Symbolic instance is to instanciate symbolic expressions into LLVM IR 
that can be run with concrete inputs to produce concrete outputs.
*/

#include "symb_expr.hpp"
#include <llvm/IR/Module.h>
#include <llvm/IR/IRBuilder.h>
#include <memory>
#include <map>
#include <string>

class SymbInstance {
private:
    std::map<std::string, llvm::Value*> variableMap;

public:
    // Return a unique_ptr to avoid copying llvm::Module (non-copyable)
    std::unique_ptr<llvm::Module> create(const std::vector<SymbolicExpr>& exprs,
                                          const std::vector<std::string> &basicBlocks);

    llvm::Value* createValueFromExpr(llvm::LLVMContext& ctx, llvm::IRBuilder<>& builder, const SymbolicExpr& expr);
    llvm::Value* createValueFromZ3Expr(llvm::LLVMContext& ctx, llvm::IRBuilder<>& builder, const z3::expr& expr);
};