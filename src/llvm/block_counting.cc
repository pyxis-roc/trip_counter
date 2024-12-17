// From bploeckelman/count-bb.cpp https://gist.github.com/bploeckelman/3614316
// at 12/17/2024  

#include "block_counting.hpp"
#include <llvm/IR/Instructions.h>
#include <llvm/IR/GlobalVariable.h>
#include <llvm/IR/Constants.h>

std::set<std::string> CountBasicBlocks::insertCounter(llvm::Module &M) {
    std::set<std::string> names;

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
            names.insert(B.getName().str() + "_bbCounter");

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
    return names;
}