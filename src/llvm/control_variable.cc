#include <cstdlib>
#include <iostream>
#include <set>
#include <unordered_set>
#include "llvm/IR/BasicBlock.h"
#include "llvm/IR/Function.h"
#include "llvm/IR/Instruction.h"
#include "llvm/IR/Instructions.h"
#include "llvm/Support/Casting.h"
#include "llvm/Support/raw_ostream.h"
#include "llvm/Transforms/Utils/LoopUtils.h"
#include "control_variable.hpp"

std::set<llvm::Instruction*> ControlVar::getInstructions(llvm::Instruction* I){
    return {I};
}

std::set<llvm::Instruction*> ControlVar::getInstructions(llvm::BasicBlock* B){
    std::set<llvm::Instruction*> result;
    for(llvm::Instruction& I: *B){
        result.insert(&I);
    }
    return result;
}

std::set<llvm::Instruction*> ControlVar::getInstructions(llvm::Function* F){
    std::set<llvm::Instruction*> result;
    for(llvm::BasicBlock& B: *F){
        auto instructions = getInstructions(&B);
        result.insert(instructions.begin(), instructions.end());
    }
    return result;
}

std::set<llvm::Instruction*> ControlVar::getInstructions(llvm::Module* M){
    std::set<llvm::Instruction*> result;
    for(llvm::Function& F: *M){
        auto instructions = getInstructions(&F);
        result.insert(instructions.begin(), instructions.end());
    }
    return result;
}

std::set<llvm::Instruction*> ControlVar::getInstructions(llvm::Loop* L){
    std::set<llvm::Instruction*> result;
    for(llvm::BasicBlock* B: L->getBlocks()){
        auto instructions = getInstructions(B);
        result.insert(instructions.begin(), instructions.end());
    }
    return result;
}

std::set<llvm::Instruction*> ControlVar::getAffected(llvm::Instruction* I){
    std::set<llvm::Instruction*> result;
    for(llvm::Instruction* i: instTouch(I)){
        if(llvm::StoreInst* s = llvm::dyn_cast<llvm::StoreInst>(i)){
            result.insert(llvm::dyn_cast<llvm::Instruction>(s->getPointerOperand()));
        }
        else{
            result.insert(i);
        }

    }
    return result;
}

std::set<llvm::Instruction*> ControlVar::getAffected(llvm::BasicBlock* B){
    std::set<llvm::Instruction*> result;
    for(llvm::Instruction& I: *B){
        for(llvm::Instruction* i: getAffected(&I)){
            result.insert(i);
        }
    }
    return result;
}

std::set<llvm::Instruction*> ControlVar::getAffected(llvm::Function* F){
    std::set<llvm::Instruction*> result;
    for(llvm::BasicBlock& B: *F){
        for(llvm::Instruction* I: getAffected(&B)){
            result.insert(I);
        }
    }
    return result;
}

std::set<llvm::Instruction*> ControlVar::getAffected(llvm::Module* M){
    std::set<llvm::Instruction*> result;
    for(llvm::Function& F: *M){
        for(llvm::Instruction* I: getAffected(&F)){
            result.insert(I);
        }
    }
    return result;
}

bool ControlVar::isExternal(llvm::Instruction* I, llvm::Loop* L){
    return L->contains(I);
}

std::set<llvm::Instruction*> ControlVar::getAffected(llvm::Loop* L){
    std::set<llvm::Instruction*> result;
    for(llvm::BasicBlock* B: L->getBlocks()){
        for(llvm::Instruction* I: getAffected(B)){
            result.insert(I);
        }
    }
    return result;
}

bool ControlVar::isDirect(llvm::Instruction* I){
    return I->isTerminator() && !llvm::dyn_cast<llvm::ReturnInst>(I);
}

std::set<llvm::Instruction*> ControlVar::getDepend(llvm::Instruction* I){
    if (!isDirect(I)) return {};
    return instDepend(I);
}

std::set<llvm::Instruction*> ControlVar::getDepend(llvm::BasicBlock* B){
    std::set<llvm::Instruction*> result;
    for(llvm::Instruction& I: *B){
        auto depend = getDepend(&I);
        result.insert(depend.begin(), depend.end());
    }
    return result;
}

std::set<llvm::Instruction*> ControlVar::getDepend(llvm::Function* F){
    std::set<llvm::Instruction*> result;
    for(llvm::BasicBlock& B: *F){
        auto depend = getDepend(&B);
        result.insert(depend.begin(), depend.end());
    }
    return result;
}

std::set<llvm::Instruction*> ControlVar::getDepend(llvm::Module* M){
    std::set<llvm::Instruction*> result;
    for(llvm::Function& F: *M){
        auto depend = getDepend(&F);
        result.insert(depend.begin(), depend.end());
    }
    return result;
}

std::set<llvm::Instruction*> ControlVar::extendTouch(std::set<llvm::Instruction*> S){
    std::set<llvm::Instruction*> result;
    for(llvm::Instruction* I: S){
        for(llvm::Instruction* i: instTouch(I)){
            result.insert(i);
        }
    }
    return result;
}

std::set<llvm::Instruction*> ControlVar::extendDepend(std::set<llvm::Instruction *> S){
    std::set<llvm::Instruction*> result;
    for(llvm::Instruction* I: S){
        for(llvm::Instruction* i: instDepend(I)){
            result.insert(i);
        }
    }
    return result;
}

std::set<llvm::Instruction*> instTouchImp(llvm::Instruction* I, std::unordered_set<llvm::Instruction*>& visited){
    std::set<llvm::Instruction*> result;
    
    if (visited.find(I) != visited.end()) return result;
    visited.insert(I);

    for(auto* U: I->users()){
        if(llvm::Instruction* i = llvm::dyn_cast<llvm::Instruction>(U)){
            result.insert(i);
            for(llvm::Instruction* j: instTouchImp(i,visited)){
                result.insert(j);
            }
        }
    }
    return result;
}

std::set<llvm::Instruction*> ControlVar::instTouch(llvm::Instruction* I){
    auto visited = std::unordered_set<llvm::Instruction*>();
    auto result = instTouchImp(I, visited);
    result.insert(I);
    return result;
}

std::set<llvm::Instruction*> instDependImp(llvm::Instruction* I, std::unordered_set<llvm::Instruction*>& visited){
    std::set<llvm::Instruction*> result;
    
    if (visited.find(I) != visited.end()) return result;
    visited.insert(I);

    for(auto& U: I->operands()){
        if(llvm::Instruction* i = llvm::dyn_cast<llvm::Instruction>(U)){
            result.insert(i);
            for(llvm::Instruction* j: instDependImp(i,visited)){
                result.insert(j);
            }
        }
    }
    return result;
}

std::set<llvm::Instruction*> ControlVar::instDepend(llvm::Instruction* I){
    auto visited = std::unordered_set<llvm::Instruction*>();
    auto result = instDependImp(I, visited);
    result.insert(I);
    return result;
}

llvm::Instruction* dummyReturn(llvm::Function* F){
    llvm::Type* returnType = F->getReturnType();
    if (returnType->isVoidTy()) {
        // void type does not accept undef value 
        return llvm::ReturnInst::Create(F->getContext());
    }
    return llvm::ReturnInst::Create(F->getContext(), llvm::UndefValue::get(returnType));
}

void ControlVar::erase(llvm::Instruction* I){
    I->replaceAllUsesWith(llvm::UndefValue::get(I->getType()));
    I->eraseFromParent();
}

void ControlVar::erase(std::set<llvm::Instruction*> all, std::set<llvm::Instruction*> controlDependent){
    std::set<llvm::Instruction*> eraseNormal;
    std::set<llvm::Instruction*> eraseReturn;
    for(auto* I: all){
        if(controlDependent.find(I) != controlDependent.end()) continue;
        if(llvm::ReturnInst* R = llvm::dyn_cast<llvm::ReturnInst>(I)){
            eraseReturn.insert(R);
        }
        else{
            eraseNormal.insert(I);
        }
    }
    for(auto* I: eraseNormal){
        erase(I);
    }
    for(auto* R: eraseReturn){
        auto newR = dummyReturn(R->getParent()->getParent());
        newR->insertBefore(R);
        erase(R);
    }
}