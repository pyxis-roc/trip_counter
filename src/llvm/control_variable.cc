#include "control_variable.hpp"
#include <llvm/IR/Function.h>
#include <llvm/IR/Instruction.h>
#include <set>
#include <unordered_set>


std::set<llvm::Instruction*> ControlVar::getDirect(llvm::Module* M){
    std::set<llvm::Instruction*> result;
    for(llvm::Function& F: *M)
    for(llvm::BasicBlock& B: F)
    for(llvm::Instruction& I: B)
    for(llvm::Instruction* i: instDirect(&I)){
        result.insert(i);
    }
    return result;
}

std::set<llvm::Instruction*> ControlVar::getDirect(llvm::Function* F){
    std::set<llvm::Instruction*> result;
    for(llvm::BasicBlock& B: *F)
    for(llvm::Instruction& I: B)
    for(llvm::Instruction* i: instDirect(&I)){
        result.insert(i);
    }
    return result;
}

std::set<llvm::Instruction*> ControlVar::getDirect(llvm::BasicBlock* B){
    std::set<llvm::Instruction*> result;
    for(llvm::Instruction& I: *B)
    for(llvm::Instruction* i: instDirect(&I)){
        result.insert(i);
    }
    return result;
}

std::set<llvm::Instruction*> ControlVar::getDirect(llvm::Instruction* I){
    return instDirect(I);
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

std::set<llvm::Instruction*> ControlVar::instDirect(llvm::Instruction* I){
    std::set<llvm::Instruction*> result;
    if(I->isTerminator())
        result.insert(I);
    return result;
}

std::set<llvm::Instruction*> ControlVar::extened(std::set<llvm::Instruction*> S){
    std::set<llvm::Instruction*> result;
    for(llvm::Instruction* I: S){
        result.insert(I);
        for(llvm::Instruction* i: instRelated(I)){
            result.insert(i);
        }
    }
    return result;
}

std::set<llvm::Instruction*> instRelatedImp(llvm::Instruction* I, std::unordered_set<llvm::Instruction*>& visited){
    std::set<llvm::Instruction*> result;
    
    if (visited.find(I) != visited.end()) return result;
    visited.insert(I);

    for(llvm::Use& U: I->operands()){
        if(llvm::Instruction* i = llvm::dyn_cast<llvm::Instruction>(U.get())){
            result.insert(i);
            for(llvm::Instruction* j: instRelatedImp(i,visited)){
                result.insert(j);
            }
        }
    }
    return result;
}

std::set<llvm::Instruction*> ControlVar::instRelated(llvm::Instruction* I){
    auto visited = std::unordered_set<llvm::Instruction*>();
    return instRelatedImp(I, visited);
}