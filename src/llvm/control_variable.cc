#include <cstdlib>
#include <unordered_set>
#include "llvm/IR/BasicBlock.h"
#include "llvm/IR/Function.h"
#include "llvm/IR/Instruction.h"
#include "llvm/IR/Instructions.h"
#include "llvm/Support/Casting.h"
#include "llvm/Transforms/Utils/LoopUtils.h"
#include "control_variable.hpp"


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
        for(llvm::Instruction* i: getDepend(&I)){
            result.insert(i);
        }
    }
    return result;
}

std::set<llvm::Instruction*> ControlVar::getDepend(llvm::Function* F){
    std::set<llvm::Instruction*> result;
    for(llvm::BasicBlock& B: *F){
        for(llvm::Instruction* I: getDepend(&B)){
            result.insert(I);
        }
    }
    return result;
}

std::set<llvm::Instruction*> ControlVar::getDepend(llvm::Module* M){
    std::set<llvm::Instruction*> result;
    for(llvm::Function& F: *M){
        for(llvm::Instruction* I: getDepend(&F)){
            result.insert(I);
        }
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

llvm::BasicBlock* ControlVar::replaceWithControl(llvm::BasicBlock* B){
    llvm::BasicBlock* newBlock = llvm::BasicBlock::Create(B->getContext(), "newBlock", B->getParent());
    auto controlDependent = ControlVar::getDepend(B);

    for(auto& I: *B){
        if(controlDependent.find(&I) != controlDependent.end()){
            llvm::Instruction* newInst = I.clone();
            newInst->insertInto(newBlock, newBlock->end());
        }
    }

    B->replaceAllUsesWith(newBlock);
    llvm::BranchInst::Create(B->getUniqueSuccessor(), newBlock);
    // B->eraseFromParent();

    return newBlock;
}

llvm::BasicBlock* ControlVar::eraseComputation(llvm::BasicBlock* B){
    auto controlDependent = ControlVar::getDepend(B);

    std::set<llvm::Instruction*> toErase;
    for(auto& I: *B){
        if(controlDependent.find(&I) == controlDependent.end()){
            I.replaceAllUsesWith(llvm::UndefValue::get(I.getType()));
            toErase.insert(&I);
        }
    }
    for(auto* I: toErase){
        I->eraseFromParent();
    }

    return B;
}