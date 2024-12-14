#include "control_variable.hpp"
#include <llvm/IR/Function.h>
#include <llvm/IR/Instruction.h>
#include <llvm/IR/Instructions.h>
#include <llvm/Support/Casting.h>
#include <llvm/Support/raw_ostream.h>
#include <llvm/Transforms/Utils/LoopUtils.h>
#include <set>
#include <unordered_set>


std::set<llvm::Instruction*> ControlVar::getDirect(llvm::Module* M){
    std::set<llvm::Instruction*> result;
    for(llvm::Function& F: *M)
    for(llvm::BasicBlock& B: F)
    for(llvm::Instruction& I: B){
        if (isDirect(&I)) result.insert(&I);
    }
    return result;
}

std::set<llvm::Instruction*> ControlVar::getDirect(llvm::Function* F){
    std::set<llvm::Instruction*> result;
    for(llvm::BasicBlock& B: *F)
    for(llvm::Instruction& I: B){
        if (isDirect(&I)) result.insert(&I);
    }
    return result;
}

std::set<llvm::Instruction*> ControlVar::getDirect(llvm::BasicBlock* B){
    std::set<llvm::Instruction*> result;
    for(llvm::Instruction& I: *B){
        if (isDirect(&I)) result.insert(&I);
    }
    return result;
}

std::set<llvm::Instruction*> ControlVar::getDirect(llvm::Loop* L){
    std::set<llvm::Instruction*> result;
    for(llvm::BasicBlock* B: L->getBlocks()){
        for(llvm::Instruction* I: getDirect(B)){
            result.insert(I);
        }
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
    // native implementation, not considering the case where the control is determined by outside
    // through a intermediate variable
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
    return I->isTerminator();
}

std::set<llvm::Instruction*> ControlVar::extendTouch(std::set<llvm::Instruction*> S){
    std::set<llvm::Instruction*> result;
    for(llvm::Instruction* I: S){
        result.insert(I);
        for(llvm::Instruction* i: instTouch(I)){
            result.insert(i);
        }
    }
    return result;
}

std::set<llvm::Instruction*> ControlVar::extendDepend(std::set<llvm::Instruction *> S){
    std::set<llvm::Instruction*> result;
    for(llvm::Instruction* I: S){
        result.insert(I);
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
    return instTouchImp(I, visited);
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
    return instDependImp(I, visited);
}