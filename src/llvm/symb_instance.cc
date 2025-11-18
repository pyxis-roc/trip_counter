/*
Symbolic instance is to instanciate symbolic expressions into executables
that can be run with concrete inputs to produce concrete outputs.

For example, given a symbolic expression x + y, we can instantiate it into
a function that takes two integers as input and returns their sum f(x, y) = x + y.
*/

#include "symb_expr.hpp"
#include "symb_instance.hpp"

#include <llvm/IR/IRBuilder.h>
#include <llvm/IR/LLVMContext.h>
#include <llvm/IR/Function.h>
#include <llvm/IR/BasicBlock.h>
#include <llvm/IR/Constants.h>

#include <cstdlib>
#include <string>
#include <memory>
#include <vector>

std::unique_ptr<llvm::Module> SymbInstance::create(const std::vector<SymbolicExpr>& exprs,
                                                    const std::vector<SymbolicExpr>& inputs,
                                                    const std::vector<std::string>& basicBlocks) {
    // Create an LLVM context and module
    llvm::LLVMContext *ctx = new llvm::LLVMContext();
    auto module = std::make_unique<llvm::Module>("SymbolicInstanceModule", *ctx);

    // Define the main function
    auto mainFuncType = llvm::FunctionType::get(llvm::Type::getInt64Ty(*ctx), false);
    auto mainFunc = llvm::Function::Create(mainFuncType, llvm::Function::ExternalLinkage, "main", module.get());

    // Create a basic block for the main function
    auto entryBlock = llvm::BasicBlock::Create(*ctx, "entry", mainFunc);
    llvm::IRBuilder<> builder(entryBlock);

    // Declare printf function
    llvm::FunctionType* printfType = llvm::FunctionType::get(
        llvm::Type::getInt32Ty(*ctx),
        llvm::PointerType::get(llvm::Type::getInt8Ty(*ctx), 0),
        true);
    llvm::FunctionCallee printfFunc = module->getOrInsertFunction("printf", printfType);

    for (size_t i = 0; i < exprs.size(); ++i) {
        // Create a value from the symbolic expression
        llvm::Value* value = createValueFromExpr(*ctx, exprs[i]);

        // Print the value and the corresponding basic block name
        std::string blockName = (i < basicBlocks.size()) ? basicBlocks[i] : "unknown_block";
        builder.CreateCall(
            printfFunc,
            { builder.CreateGlobalString("Expression %zu in block %s: ", "fmt"),
              builder.getInt64(i),
              builder.CreateGlobalString(blockName, "block_name") });
        builder.CreateCall(
            printfFunc,
            { builder.CreateGlobalString("%ld\n", "fmt"),
              value });
    }
    builder.CreateRet(llvm::ConstantInt::get(llvm::Type::getInt64Ty(*ctx), 0));
    return module;
}

llvm::Value* SymbInstance::createValueFromExpr(llvm::LLVMContext& ctx, const SymbolicExpr& expr) {
    // Default type is int64
    llvm::Type* int64Ty = llvm::Type::getInt64Ty(ctx);
    const auto& op = expr.getOpType();
    const auto& ops = expr.operands();

    // For constants (no operands)
    if (ops.empty()) {
        // Try to parse as integer constant
        std::string s = expr.str();
        int64_t val = 0;
        try {
            val = std::stoll(s);
        } catch (...) {
            val = 0; // fallback
        }
        return llvm::ConstantInt::get(int64Ty, val);
    }

    // Recursively lower operands
    std::vector<llvm::Value*> llvmOps;
    for (const auto& opExpr : ops) {
        llvmOps.push_back(createValueFromExpr(ctx, opExpr));
    }

    // Use a dummy IRBuilder for instruction creation (must be replaced by caller's builder in real use)
    static llvm::IRBuilder<> dummyBuilder(ctx);
    llvm::IRBuilder<>* builder = &dummyBuilder;

    switch (op) {
        case SymbolicExpr::OpType::ADD:
            return builder->CreateAdd(llvmOps[0], llvmOps[1], "addtmp");
        case SymbolicExpr::OpType::SUB:
            return builder->CreateSub(llvmOps[0], llvmOps[1], "subtmp");
        case SymbolicExpr::OpType::MUL:
            return builder->CreateMul(llvmOps[0], llvmOps[1], "multmp");
        case SymbolicExpr::OpType::DIV:
            return builder->CreateSDiv(llvmOps[0], llvmOps[1], "divtmp");
        case SymbolicExpr::OpType::NEG:
            return builder->CreateNeg(llvmOps[0], "negtmp");
        case SymbolicExpr::OpType::AND:
            return builder->CreateAnd(llvmOps[0], llvmOps[1], "andtmp");
        case SymbolicExpr::OpType::SEXT:
            return builder->CreateSExt(llvmOps[0], int64Ty, "sexttmp");
        case SymbolicExpr::OpType::ZEXT:
            return builder->CreateZExt(llvmOps[0], int64Ty, "zexttmp");
        case SymbolicExpr::OpType::TRUNC:
            return builder->CreateTrunc(llvmOps[0], int64Ty, "trunctmp");
        case SymbolicExpr::OpType::SMAX:
            return builder->CreateSelect(
                builder->CreateICmpSGT(llvmOps[0], llvmOps[1]), llvmOps[0], llvmOps[1], "smaxtmp");
        case SymbolicExpr::OpType::EQ:
            return builder->CreateZExt(
                builder->CreateICmpEQ(llvmOps[0], llvmOps[1]), int64Ty, "eqtmp");
        case SymbolicExpr::OpType::NE:
            return builder->CreateZExt(
                builder->CreateICmpNE(llvmOps[0], llvmOps[1]), int64Ty, "netmp");
        case SymbolicExpr::OpType::ULT:
            return builder->CreateZExt(
                builder->CreateICmpULT(llvmOps[0], llvmOps[1]), int64Ty, "ulttmp");
        case SymbolicExpr::OpType::ULE:
            return builder->CreateZExt(
                builder->CreateICmpULE(llvmOps[0], llvmOps[1]), int64Ty, "uletmp");
        case SymbolicExpr::OpType::UGT:
            return builder->CreateZExt(
                builder->CreateICmpUGT(llvmOps[0], llvmOps[1]), int64Ty, "ugttmp");
        case SymbolicExpr::OpType::UGE:
            return builder->CreateZExt(
                builder->CreateICmpUGE(llvmOps[0], llvmOps[1]), int64Ty, "ugetmp");
        case SymbolicExpr::OpType::SLT:
            return builder->CreateZExt(
                builder->CreateICmpSLT(llvmOps[0], llvmOps[1]), int64Ty, "slttmp");
        case SymbolicExpr::OpType::SLE:
            return builder->CreateZExt(
                builder->CreateICmpSLE(llvmOps[0], llvmOps[1]), int64Ty, "sletmp");
        case SymbolicExpr::OpType::SGT:
            return builder->CreateZExt(
                builder->CreateICmpSGT(llvmOps[0], llvmOps[1]), int64Ty, "sgttmp");
        case SymbolicExpr::OpType::SGE:
            return builder->CreateZExt(
                builder->CreateICmpSGE(llvmOps[0], llvmOps[1]), int64Ty, "sgetmp");
        case SymbolicExpr::OpType::SELECT:
            return builder->CreateSelect(llvmOps[0], llvmOps[1], llvmOps[2], "selecttmp");
        case SymbolicExpr::OpType::ASHR:
            return builder->CreateAShr(llvmOps[0], llvmOps[1], "ashrtmp");
        case SymbolicExpr::OpType::LSHR:
            return builder->CreateLShr(llvmOps[0], llvmOps[1], "lshrtmp");
        case SymbolicExpr::OpType::SHL:
            return builder->CreateShl(llvmOps[0], llvmOps[1], "shltmp");
        default:
            // Fallback: treat as constant zero
            return llvm::ConstantInt::get(int64Ty, 0);
    }
}