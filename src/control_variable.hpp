/*
    This file contains the implementation of the ControlVariable class.
    This class is used to find all the variables whose values affect the control flow of the program.
    Input: A module
    Output: A set of control variables
*/

#pragma once

#include <set>
#include "llvm/Analysis/ScalarEvolution.h"
#include "llvm/Analysis/LoopInfo.h"
#include "llvm/IR/BasicBlock.h"
#include "llvm/IR/Function.h"
#include "llvm/IR/Instruction.h"
#include "llvm/IR/Module.h"

class ControlVar{
    public:
        ControlVar();
        ~ControlVar();

        // Get all Instructions in a code base
        static std::set<llvm::Instruction*> getInstructions(llvm::Instruction* I);
        static std::set<llvm::Instruction*> getInstructions(llvm::BasicBlock* B);
        static std::set<llvm::Instruction*> getInstructions(llvm::Function* F);
        static std::set<llvm::Instruction*> getInstructions(llvm::Module* M);
        static std::set<llvm::Instruction*> getInstructions(llvm::Loop* L);

        template<typename Iterable>
        static std::set<llvm::Instruction*> getInstructions(Iterable* itr){
            std::set<llvm::Instruction*> result;
            for(auto* base: *itr){
                for(auto* i: getInstructions(base)){
                    result.insert(i);
                }
            }
            return result;
        }

        // Get all direct control variables in a code base
        template<typename CodebaseT>
        static std::set<llvm::Instruction*> getDirect(CodebaseT* codeBase){
            std::set<llvm::Instruction*> result;
            for(auto* I: getInstructions(codeBase)){
                if(isDirect(I)) result.insert(I);
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
       
        template<typename Iterable>
        static std::set<llvm::Instruction*> getAffected(Iterable* itr){
            std::set<llvm::Instruction*> result;
            for(auto* base: *itr){
                for(auto* i: getAffected(base)){
                    result.insert(i);
                }
            }
            return result;
        }

        //check if an instruction is affected by the given code base
        template<typename CodebaseT>
        static bool isAffected(llvm::Instruction* I, CodebaseT* codeBase){
            return getAffected(codeBase).find(I) != getAffected(codeBase).end();
        }

        // Get all variables that decide the control of the given code base
        static std::set<llvm::Instruction*> getDepend(llvm::Instruction* I);    // base case
        static std::set<llvm::Instruction*> getDepend(llvm::BasicBlock* B);
        static std::set<llvm::Instruction*> getDepend(llvm::Function* F);
        static std::set<llvm::Instruction*> getDepend(llvm::Module* M);
        static std::set<llvm::Instruction*> getDepend(llvm::Loop* L);

        template<typename Iterable>
        static std::set<llvm::Instruction*> getDepend(Iterable* itr){
            std::set<llvm::Instruction*> result;
            for(auto* base: *itr){
                for(auto* i: getDepend(base)){
                    result.insert(i);
                }
            }
            return result;
        }

        //check if an instruction is a control depend variable in a code base
        template<typename CodebaseT>
        static bool isDepend(llvm::Instruction* I, CodebaseT* codeBase){
            return getDepend(codeBase).find(I) != getDepend(codeBase).end();
        }

        // Check if an instruction is fully determined by outside of the given code base 
        static bool isExternal(llvm::Instruction* I, llvm::BasicBlock* B);
        static bool isExternal(llvm::Instruction* I, llvm::Loop* L);


        // erase an instruction
        static void erase(llvm::Instruction* I);
        // erase a set of instructions, but keep the control dependent instructions
        static void erase(std::set<llvm::Instruction*> all, std::set<llvm::Instruction*> controlDependent);

        // erase all computation, only keep variables that control the given code base 
        template<typename CodebaseT>
        static void eraseComputation(CodebaseT* codeBase){
            auto controlDependent = getDepend(codeBase);
            auto instructions = getInstructions(codeBase);
            erase(instructions, controlDependent);
        }
    
    private:
        // check if an instruction is a direct control variable
        static bool isDirect(llvm::Instruction* I);

        // Get all instructions that are touched by the given instruction, including the given instruction
        static std::set<llvm::Instruction*> instTouch(llvm::Instruction* I);

        // Get all instructions that decide the given instruction, including the given instruction
        static std::set<llvm::Instruction*> instDepend(llvm::Instruction* I);
};
