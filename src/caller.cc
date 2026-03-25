#include <llvm/IRReader/IRReader.h>
#include <llvm/Passes/PassBuilder.h>
#include <llvm/IR/Module.h>
#include <llvm/Support/raw_ostream.h>
#include "printer.hpp"
#include "llvm/IR/Function.h"
#include "llvm/IR/Type.h"
#include <iostream>

using namespace llvm;

void get_matmul_caller(int m, int n, int k){
    LLVMContext context;
    Module module("caller", context);
    SMDiagnostic Error;

    Type *int32Ty = Type::getInt32Ty(context);
    Type *voidTy = Type::getVoidTy(context);
    PointerType *ptrTyWriteOnly = PointerType::get(Type::getInt8Ty(context), 0); // writeonly
    PointerType *ptrTyReadOnly = PointerType::get(Type::getInt8Ty(context), 0); // readonly


    auto kernelType =FunctionType::get(
        Type::getVoidTy(context), // Return type: void
        {
        int32Ty,                      // %M
        int32Ty,                      // %N
        ptrTyWriteOnly,                 // %T_matmul
        int32Ty,                      // %stride
        int32Ty,                      // %stride1
        int32Ty,                      // %K
        ptrTyReadOnly,                // %A
        int32Ty,                      // %stride2
        int32Ty,                      // %stride3
        ptrTyReadOnly,                // %B
        int32Ty,                      // %stride4
        int32Ty                       // %stride5
        },
        false // Not variadic
    );

    auto kernel = Function::Create(
        kernelType, 
        Function::ExternalLinkage, 
        Twine("matmul_compute_"), 
        module
    );

    // Create main function
    FunctionType *mainFuncType = FunctionType::get(Type::getInt32Ty(context), {}, false);
    Function *mainFunction = Function::Create(mainFuncType, Function::ExternalLinkage, "main", module);
    BasicBlock *entryBlock = BasicBlock::Create(context, "entry", mainFunction);
    IRBuilder<> builder(entryBlock);

    // prepare arguments
    GlobalVariable *A = new GlobalVariable(
        module, 
        ArrayType::get(Type::getInt32Ty(context), 16646400), 
        false,
        GlobalValue::PrivateLinkage, 
        ConstantAggregateZero::get(
            ArrayType::get(Type::getInt32Ty(context), 16646400)), "A");
    
    GlobalVariable *B = new GlobalVariable(
        module, 
        ArrayType::get(Type::getInt32Ty(context), 16646400), 
        false,
        GlobalValue::PrivateLinkage, 
        ConstantAggregateZero::get(
            ArrayType::get(Type::getInt32Ty(context), 16646400)), "B");

    GlobalVariable *T = new GlobalVariable(
        module, 
        ArrayType::get(Type::getInt32Ty(context), 16646400), 
        false,
        GlobalValue::PrivateLinkage, 
        ConstantAggregateZero::get(
            ArrayType::get(Type::getInt32Ty(context), 16646400)), "C");

    auto *M = builder.getInt32(m); // Example: M = 128
    auto *N = builder.getInt32(n); // Example: N = 256
    auto *stride = builder.getInt32(64);  // Example: stride = 64
    auto *stride1 = builder.getInt32(128); // Example: stride1 = 128
    auto *K = builder.getInt32(k);      // Example: K = 512
    auto *stride2 = builder.getInt32(32); // Example: stride2 = 32
    auto *stride3 = builder.getInt32(64); // Example: stride3 = 64
    auto *stride4 = builder.getInt32(16); // Example: stride4 = 16
    auto *stride5 = builder.getInt32(8);  // Example: stride5 = 8

    // Create the function call
    std::vector<Value *> args = {
        M, N, T, stride, stride1, K, A, stride2, stride3, B, stride4, stride5
    };

    builder.CreateCall(kernel, args);
    builder.CreateRet(ConstantInt::get(Type::getInt32Ty(context), 0));
    module.print(errs(), nullptr);
}

int main(int argc, char **argv) {
    if (argc < 4) {
        std::cerr << "Usage: " << argv[0] << " <LLVM IR file>\n";
        return 1;
    }
    auto m = atoi(argv[1]);
    auto n = atoi(argv[2]);
    auto k = atoi(argv[3]);
    get_matmul_caller(m,n,k);
    return 0;
}
