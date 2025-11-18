/*
Symbolic instance is to instanciate symbolic expressions into LLVM IR 
that can be run with concrete inputs to produce concrete outputs.
*/

#include "symb_expr.hpp"
#include <llvm/IR/Module.h>
#include <memory>

class SymbInstance {
public:
    // Return a unique_ptr to avoid copying llvm::Module (non-copyable)
    std::unique_ptr<llvm::Module> create(const std::vector<SymbolicExpr>& exprs,
                                          const std::vector<SymbolicExpr>& inputs,
                                          const std::vector<std::string> &basicBlocks);

    llvm::Value* createValueFromExpr(llvm::LLVMContext& ctx, const SymbolicExpr& expr);
};