// From bploeckelman/count-bb.cpp https://gist.github.com/bploeckelman/3614316
// at 12/17/2024  

#include "llvm/ADT/Twine.h"
#include "llvm/IR/Function.h"
#include "llvm/IR/Instructions.h"
#include "llvm/IR/GlobalVariable.h"
#include "llvm/IR/IRBuilder.h"
#include <llvm/Analysis/ScalarEvolution.h>
#include <llvm/IR/BasicBlock.h>
#include <llvm/IR/Value.h>
#include <map>
#include "llvm/Transforms/Utils/ScalarEvolutionExpander.h"
#include "block_counting.hpp"
#include "loop_summary.hpp"


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
llvm::Function* createReport(llvm::Module &M, std::map<llvm::BasicBlock*, llvm::GlobalVariable*> counters){
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

    for(auto [bb,var]: counters){
        llvm::Value *val = new llvm::LoadInst(llvm::Type::getInt64Ty(M.getContext()), var, "bb.count", entry);
        builder.CreateCall(printUtil, val);
    }
    builder.CreateRetVoid();
    return printAll;
}

void CountBasicBlocks::buildProxy(llvm::Function &F, std::set<LoopSummary*> SL) {
    for (auto summary: SL){
        instrumentSummarizedLoop(summary);
    }

    for(auto &B: F){
        if(isInstrumented(&B)) continue;
        instrumentNormalBlock(&B);
    }

    // create a call to the report function before the return instruction
    llvm::Function* report = createReport(*F.getParent(), counters);
    for(auto &B: F){
        if(llvm::ReturnInst* R = llvm::dyn_cast<llvm::ReturnInst>(B.getTerminator())){
            llvm::IRBuilder<> builder(R);
            builder.CreateCall(report);
        }
    }
}

void CountBasicBlocks::instrumentBlock(llvm::BasicBlock* B, llvm::Value* increment){
    auto F = B->getParent();
    //create a global variable for each basic block to store the count
    llvm::GlobalVariable *bbCounter = new llvm::GlobalVariable(
        *F->getParent(),
        llvm::Type::getInt64Ty(F->getContext()),
        false,
        llvm::GlobalValue::CommonLinkage,
        llvm::ConstantInt::get(llvm::Type::getInt64Ty(F->getContext()), 0),
        B->getName() + "_bbCounter"
    );

    //insert the increment instruction at the end of the basic block
    auto *InsertPos = B->getTerminator(); 
    llvm::Value *OldVal = new llvm::LoadInst(llvm::Type::getInt64Ty(B->getContext()), bbCounter, "old.bb.count", InsertPos);
    llvm::Value *NewVal = llvm::BinaryOperator::Create(
                llvm::Instruction::Add
            , OldVal
            , increment
            , "new.bb.count"
            , InsertPos);
    new llvm::StoreInst(NewVal, bbCounter, InsertPos);

    counters[B] = bbCounter;
}

void CountBasicBlocks::instrumentNormalBlock(llvm::BasicBlock* B){
    instrumentBlock(B, llvm::ConstantInt::get(llvm::Type::getInt64Ty(B->getContext()), 1));
}

llvm::Value* materializeSCEV(llvm::BasicBlock* B, llvm::ScalarEvolution &SE, const llvm::SCEV* scev){
    llvm::IRBuilder<> builder(B->getContext());
    llvm::SCEVExpander expander(SE,  B->getDataLayout(), "scev");

    auto val = expander.expandCodeFor(scev, scev->getType(), B->begin());
    return val;
}

void CountBasicBlocks::instrumentSummarizedBlock(llvm::BasicBlock* B, const llvm::SCEV* backedgeCount, llvm::ScalarEvolution &SE){
    instrumentBlock(B, materializeSCEV(B, SE, backedgeCount));
}

void rec(LoopSummary* LS, std::map<llvm::BasicBlock*, const llvm::SCEV*> &symCounts){
    for(auto B: LS->L.getBlocks()){
        if(symCounts.find(B) == symCounts.end()){
            symCounts[B] = LS->backedgeCount;
        }
        else{
            symCounts[B] = LS->SE.getMulExpr(symCounts[B], LS->backedgeCount);
        }
    }
    for(auto c: LS->child){
        rec(c, symCounts);
    }
}

void CountBasicBlocks::instrumentSummarizedLoop(LoopSummary* LS){
    std::map<llvm::BasicBlock*, const llvm::SCEV*> symCounts;
    rec(LS, symCounts);
    
    for(auto [B, count]: symCounts){
        instrumentSummarizedBlock(B, count, LS->SE);
    }
}

bool CountBasicBlocks::isInstrumented(llvm::BasicBlock* B){
    return counters.find(B) != counters.end();
}