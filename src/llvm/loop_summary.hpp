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
        llvm::Loop &L;
        llvm::ScalarEvolution &SE;

        LoopSummary(llvm::Loop &L, llvm::ScalarEvolution &SE): L(L), SE(SE) {};
        ~LoopSummary(){};
        
        std::set<llvm::Instruction*> getAffectInstructions(llvm::Module* M);
        void showAll(llvm::Module* M);
        bool isAffect(llvm::Module* M);
        bool tryReduceLoopBody();
};