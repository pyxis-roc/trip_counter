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

        // Get all direct control variables in a code base
        static std::set<llvm::Instruction*> getDirect(llvm::Module *);
        static std::set<llvm::Instruction*> getDirect(llvm::Function* );
        static std::set<llvm::Instruction*> getDirect(llvm::BasicBlock* );
        static std::set<llvm::Instruction*> getDirect(llvm::Loop* );
        
        template<typename Iterable>
        static std::set<llvm::Instruction*> getDirect(Iterable itr){
            std::set<llvm::Instruction*> result;
            for(auto* base: itr){
                for(auto* i: getDirect(base)){
                    result.insert(i);
                }
            }
            return result;
        }

        //extend variables to include variables that are touched by the given variables
        static std::set<llvm::Instruction*> extendTouch(std::set<llvm::Instruction*>);  
        
        //extend variables to include variables that decide the given variables
        static std::set<llvm::Instruction*> extendDepend(std::set<llvm::Instruction*>);

        // Get all variables that are modified by given code base
        static std::set<llvm::Instruction*> getAffected(llvm::Instruction* I);
        static std::set<llvm::Instruction*> getAffected(llvm::BasicBlock* B);
        static std::set<llvm::Instruction*> getAffected(llvm::Function* F);
        static std::set<llvm::Instruction*> getAffected(llvm::Module* M);
        static std::set<llvm::Instruction*> getAffected(llvm::Loop* L);

        // Get all variables that decide code base
        static std::set<llvm::Instruction*> getDepend(llvm::Instruction* I);
        static std::set<llvm::Instruction*> getDepend(llvm::BasicBlock* B);
        static std::set<llvm::Instruction*> getDepend(llvm::Function* F);
        static std::set<llvm::Instruction*> getDepend(llvm::Module* M);
        static std::set<llvm::Instruction*> getDepend(llvm::Loop* L);

        // Check if an instruction is fully determined by outside of the given code base 
        static bool isExternal(llvm::Instruction* I, llvm::Loop* L);
        static bool isExternal(llvm::Instruction* I, llvm::BasicBlock* B);

        // Get all control variables in a module/basicblock/loop/instruction
        template <typename T>
        static std::set<llvm::Instruction*> getAll(T* codeBase){
            std::set<llvm::Instruction*> result;
            for(llvm::Instruction* i: getDirect(codeBase)){
                result.insert(i);
                for(llvm::Instruction* j: instTouch(i)){
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
        // check if an instruction is a direct control variable
        static bool isDirect(llvm::Instruction* I);

        // Get all instructions that are touched by the given instruction, excluding the given instruction
        static std::set<llvm::Instruction*> instTouch(llvm::Instruction* I);

        // Get all instructions that decide the given instruction
        static std::set<llvm::Instruction*> instDepend(llvm::Instruction* I);
};
