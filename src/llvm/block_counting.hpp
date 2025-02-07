// From bploeckelman/count-bb.cpp https://gist.github.com/bploeckelman/3614316
// at 12/17/2024  

#pragma once

#include "loop_summary.hpp"
#include <llvm/Analysis/ScalarEvolution.h>
#include <llvm/IR/BasicBlock.h>
#include <llvm/IR/Function.h>
#include <llvm/IR/Type.h>
#include <map>
#include "llvm/IR/GlobalVariable.h"
#include "llvm/Analysis/LoopInfo.h"

class CountBasicBlocks{
    // map from basic block to counter variable 
    std::map<llvm::BasicBlock*, llvm::GlobalVariable*> counters;
    
    public:    
    // for each basic block in the module, insert a counter
    // at the end of the module, print the count of each basic block

    // static std::vector<llvm::GlobalVariable*> insertCounter(llvm::Module &M);
    void buildProxy(llvm::Function &F, std::set<LoopSummary*> SL);

    private:

    bool isSummarizedBlock(llvm::BasicBlock* B, std::set<llvm::Loop*> SL);
    
    // check if a basic block is already instrumented with some counter
    bool isInstrumented(llvm::BasicBlock* B);

    // insert a counter for a basic block
    void instrumentBlock(llvm::BasicBlock* B, llvm::Value* increment = nullptr);
    void instrumentNormalBlock(llvm::BasicBlock* B);
    void instrumentSummarizedBlock(llvm::BasicBlock* B, const llvm::SCEV* , llvm::ScalarEvolution &SE);

    // insert counters that increase by the backedge count of the loop
    void instrumentSummarizedLoop(LoopSummary* LS);
};