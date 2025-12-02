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
    std::map<unsigned, llvm::Value*> exprCache;  // Cache Z3 expr ID -> LLVM Value

    // Refactor helpers
    void setupModule(std::unique_ptr<llvm::Module>& module, llvm::LLVMContext*& ctx);
    llvm::Function* buildKernel(llvm::Module* module, llvm::LLVMContext& ctx,
                                const std::vector<std::string>& inputs);
    void emitKernelBody(llvm::Module* module, llvm::LLVMContext& ctx,
                        llvm::IRBuilder<>& builder,
                        const std::vector<SymbolicExpr>& exprs,
                        const std::vector<std::string>& basicBlocks,
                        bool outputToStdout,
                        llvm::Value*& resultsArray,
                        llvm::FunctionCallee& printfFunc,
                        llvm::FunctionCallee& clockGettimeFunc,
                        llvm::Type*& timespecTy,
                        llvm::Value*& startTime,
                        llvm::Value*& endTime);
    void emitTiming(llvm::Module* module, llvm::LLVMContext& ctx,
                             llvm::IRBuilder<>& builder,
                             llvm::FunctionCallee& printfFunc,
                             llvm::FunctionCallee& clockGettimeFunc,
                             llvm::Type* timespecTy,
                             llvm::Value* startTime,
                             llvm::Value* endTime);
    void buildTestMain(llvm::Module* module, llvm::LLVMContext& ctx,
                       llvm::Function* kernelFunc,
                       const std::vector<std::string>& inputs,
                       llvm::FunctionCallee printfFunc);

public:
    // Return a unique_ptr to avoid copying llvm::Module (non-copyable)
    std::unique_ptr<llvm::Module> create(const std::vector<SymbolicExpr>& exprs,
                                          const std::vector<std::string> &basicBlocks,
                                          bool generateTestMain = true,
                                          bool outputToStdout = true);

    llvm::Value* createValueFromExpr(llvm::LLVMContext& ctx, llvm::IRBuilder<>& builder, const SymbolicExpr& expr);
    llvm::Value* createValueFromZ3Expr(llvm::LLVMContext& ctx, llvm::IRBuilder<>& builder, const z3::expr& expr);
};