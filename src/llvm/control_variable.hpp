/*
    This file contains the implementation of the ControlVariable class.
    This class is used to find all the variables whose values affect the control flow of the program.
    Input: A module
    Output: A set of control variables
*/

#pragma once

#include <llvm/Analysis/ScalarEvolution.h>
#include <llvm/Analysis/LoopInfo.h>
#include <llvm/IR/BasicBlock.h>
#include <llvm/IR/Function.h>
#include <llvm/IR/Instruction.h>
#include <llvm/IR/Module.h>
#include <llvm/IR/Type.h>
#include <set>

class ControlVar{
    public:
        ControlVar();
        ~ControlVar();

        // Get all direct control variables in a module
        static std::set<llvm::Instruction*> getDirect(llvm::Module *);
        static std::set<llvm::Instruction*> getDirect(llvm::Function* );
        static std::set<llvm::Instruction*> getDirect(llvm::BasicBlock* );
        static std::set<llvm::Instruction*> getDirect(llvm::Instruction* );
        static std::set<llvm::Instruction*> getDirect(llvm::Loop* );

        //extend direct control variables to include related control variables
        static std::set<llvm::Instruction*> extened(std::set<llvm::Instruction*>);  

        // Get all variables that are modified by given code base
        static std::set<llvm::Instruction*> getAffected(llvm::Instruction* I);
        static std::set<llvm::Instruction*> getAffected(llvm::BasicBlock* B);
        static std::set<llvm::Instruction*> getAffected(llvm::Function* F);
        static std::set<llvm::Instruction*> getAffected(llvm::Module* M);
        static std::set<llvm::Instruction*> getAffected(llvm::Loop* L);

        // Get all control variables in a module/basic block/loop/instruction
        template <typename T>
        static std::set<llvm::Instruction*> getAll(T* codeBase){
            std::set<llvm::Instruction*> result;
            for(llvm::Instruction* i: getDirect(codeBase)){
                result.insert(i);
                for(llvm::Instruction* j: instRelated(i)){
                    result.insert(j);
                }
            }
            return result;
        }

        // Show all control variables in a module/basic block/loop/instruction
        template <typename T>
        static void showAll(T* codeBase){
            for(llvm::Instruction* I: getAll(codeBase)){
                I->print(llvm::errs());
                llvm::errs() << "\n";
            }
        }
    private:
        static std::set<llvm::Instruction*> instDirect(llvm::Instruction* I);
        static std::set<llvm::Instruction*> instRelated(llvm::Instruction* I);
};
