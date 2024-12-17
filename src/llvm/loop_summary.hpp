/*
    This file contains the definition of the LoopSummary class,
    which is used to handle the loop summary analysis.
*/

#pragma once

#include <llvm/ADT/STLExtras.h>
#include <llvm/Analysis/LoopInfo.h>
#include <llvm/Analysis/ScalarEvolution.h>
#include <llvm/IR/BasicBlock.h>
#include <llvm/IR/Instruction.h>
#include <llvm/IR/Module.h>
#include <set>


class LoopSummary {
    public:
        llvm::Module &M;
        llvm::Loop &L;
        llvm::ScalarEvolution &SE;

        LoopSummary(llvm::Module& M, llvm::Loop &L, llvm::ScalarEvolution &SE): M(M), L(L), SE(SE) {};
        ~LoopSummary(){};

        // Check if the loop affects any outside control variable 
        bool isAffectOutside();
        
        // Check if the linear control inside this loop is determined before entering the loop
        /*
            This function is used to help check if the loop can be summarized to a single block.
            So in current level, sub loops are optimistically assumed to be summarizable to a single block,
            then we further check if the control is determined given all sub loops are summarized.
        */
        bool isOutsideDetermined();

        // Check if the loop can be summarized to a single block
        bool isSummarizable();

        // Get all outside control variables that are affected by the loop
        std::set<llvm::Instruction*> getAffectOutside();
        void showAll();

        // Try to summarize the loop, remove backedges to form acyclic control, return the loop if successful
        // only works for loops that have a single latch
        llvm::Loop* trySummarize();


    private:
        // check if a set of instructions are all determined by outside
        bool isOutsideDetermined(std::set<llvm::Instruction*>);
        bool isOutsideDetermined(llvm::Instruction*);

        // filter out instructions that are determined by outside
        std::set<llvm::Instruction*> filterOutsideDetermined(std::set<llvm::Instruction*>);
};