// From bploeckelman/count-bb.cpp https://gist.github.com/bploeckelman/3614316
// at 12/17/2024  

#include "llvm/ADT/Twine.h"
#include "llvm/IR/Function.h"
#include "llvm/IR/Instructions.h"
#include "llvm/IR/GlobalVariable.h"
#include "llvm/IR/IRBuilder.h"
#include <vector>
#include "block_counting.hpp"


llvm::Function* getPrint(llvm::Module &M){
    llvm::FunctionType *printType = llvm::FunctionType::get(
        llvm::Type::getVoidTy(M.getContext()),
        {llvm::Type::getInt64Ty(M.getContext())},
        false
    );
    return llvm::Function::Create(
        printType,
        llvm::Function::ExternalLinkage,
        llvm::Twine("_Z5printl"),
        M
    );
}

// At the end of the module, print the count of each basic block
llvm::Function* createReport(llvm::Module &M, std::vector<llvm::GlobalVariable*> counters){
    llvm::FunctionType *printType = llvm::FunctionType::get(
        llvm::Type::getVoidTy(M.getContext()),
        {},
        false
    );
    llvm::Function *printAll = llvm::Function::Create(
        printType,
        llvm::Function::ExternalLinkage,
        llvm::Twine("print_bb_count"),
        M
    );

    llvm::BasicBlock *entry = llvm::BasicBlock::Create(M.getContext(), "entry", printAll);
    llvm::IRBuilder<> builder(entry);
    llvm::Function* printUtil = getPrint(M);

    for(auto var: counters){
        llvm::Value *val = new llvm::LoadInst(llvm::Type::getInt64Ty(M.getContext()), var, "bb.count", entry);
        builder.CreateCall(printUtil, val);
    }
    builder.CreateRetVoid();
    return printAll;
}


std::vector<llvm::GlobalVariable*> CountBasicBlocks::insertCounter(llvm::Module &M) {
    std::vector<llvm::GlobalVariable*> counters;

    // insert individual counters for each basic block
    for(auto & F: M){
        for(auto & B: F){
            //create a global variable for each basic block to store the count
            llvm::GlobalVariable *bbCounter = new llvm::GlobalVariable(
                M,
                llvm::Type::getInt64Ty(M.getContext()),
                false,
                llvm::GlobalValue::CommonLinkage,
                llvm::ConstantInt::get(llvm::Type::getInt64Ty(M.getContext()), 0),
                B.getName() + "_bbCounter"
            );
            counters.push_back(bbCounter);

            //insert the increment instruction at the end of the basic block
            auto *InsertPos = B.getTerminator(); 
            llvm::Value *OldVal = new llvm::LoadInst(llvm::Type::getInt64Ty(B.getContext()), bbCounter, "old.bb.count", InsertPos);
            llvm::Value *NewVal = llvm::BinaryOperator::Create(
                        llvm::Instruction::Add
                    , OldVal
                    , llvm::ConstantInt::get(llvm::Type::getInt64Ty(B.getContext()), 1)
                    , "new.bb.count"
                    , InsertPos);
            new llvm::StoreInst(NewVal, bbCounter, InsertPos);
        }
    }

    // create a call to the report function before the return instruction
    llvm::Function* report = createReport(M, counters);
    for (auto &F :M){
        if(F.getName() == report->getName()) continue;
        for(auto &B: F){
            if(llvm::ReturnInst* R = llvm::dyn_cast<llvm::ReturnInst>(B.getTerminator())){
                llvm::IRBuilder<> builder(R);
                builder.CreateCall(report);
            }
        }
    }

    return counters;
}