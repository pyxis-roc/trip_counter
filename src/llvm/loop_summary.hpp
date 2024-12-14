/*
    This file contains the definition of the LoopSummary class,
    which is used to handle the loop summary analysis.
*/

#pragma once

#include <llvm/Analysis/ScalarEvolution.h>
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
        
        // Get all outside control variables that are affected by the loop
        std::set<llvm::Instruction*> getAffectOutside();
        void showAll();

        // Check if the loop affects any outside control variable 
        bool isAffectOutside();
        
        // Check if the linear control inside this loop is determined before entering the loop
        /*
            This function is used to help check if the loop can be reduced to a single block.
            So in current level, sub loops are optimistically assumed to be reducible to a single block,
            then we further check if the control is determined given all sub loops are reduced.
        */
        bool isOutsideDetermined();

        // Check if the loop can be reduced to a single block
        bool isSummarizable();

};