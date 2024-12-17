#include "loop_summary.hpp"
#include "control_variable.hpp"
#include <algorithm>
#include <cstdlib>
#include <iterator>
#include <llvm/ADT/STLExtras.h>
#include <llvm/ADT/SmallVector.h>
#include <llvm/Analysis/LoopInfo.h>
#include <llvm/IR/BasicBlock.h>
#include <llvm/IR/Instruction.h>
#include <llvm/IR/Intrinsics.h>
#include <llvm/Support/raw_ostream.h>
#include <set>

std::set<llvm::Instruction*> LoopSummary::getAffectOutside(){
    auto loopControlDirect = ControlVar::getDirect(&L);
    auto moduleControlDirect = ControlVar::getDirect(&M);
    std::set<llvm::Instruction*> externalDirect; 
    std::set_difference(moduleControlDirect.begin(), moduleControlDirect.end(), 
                    loopControlDirect.begin(), loopControlDirect.end(), 
                    std::inserter(externalDirect, externalDirect.begin()));
    auto allExternalControlDepend = ControlVar::extendDepend(externalDirect);
    
    std::set<llvm::Instruction*> result;
    auto loopAffected = ControlVar::getAffected(&L);
    std::set_intersection(loopAffected.begin(), loopAffected.end(), 
                        allExternalControlDepend.begin(), allExternalControlDepend.end(), 
                        std::inserter(result, result.begin()));

    return result;
}

// sub loops are assumed to be summarizable, backedges are ignored, 
// check the remaining control is determined by outside 
bool LoopSummary::isOutsideDetermined(){
    auto controlDirect = ControlVar::getDirect(&L);
    std::set<llvm::Instruction*> subLoopControlDirect = ControlVar::getDirect(&L.getSubLoops());
    
    llvm::SmallVector<llvm::BasicBlock*> latches;
    L.getLoopLatches(latches);
    std::set<llvm::Instruction*> latchDirect = ControlVar::getDirect(&latches);

    std::set<llvm::Instruction*> internalControlDirect;
    std::set_difference(controlDirect.begin(), controlDirect.end(), 
                        subLoopControlDirect.begin(), subLoopControlDirect.end(), 
                        std::inserter(internalControlDirect, internalControlDirect.begin()));
    std::set_difference(internalControlDirect.begin(), internalControlDirect.end(),
                        latchDirect.begin(), latchDirect.end(),
                        std::inserter(internalControlDirect, internalControlDirect.begin()));

    return isOutsideDetermined(internalControlDirect);
}

bool LoopSummary::isOutsideDetermined(llvm::Instruction* I){
    // native implementation, not considering the case where the control is determined by outside
    // through a intermediate variable
    return ControlVar::isExternal(I, &L);
}

bool LoopSummary::isOutsideDetermined(std::set<llvm::Instruction*> S){
    for(auto* I: S){
        if(!isOutsideDetermined(I)) return false;
    }
    return true;
}

std::set<llvm::Instruction*> LoopSummary::filterOutsideDetermined(std::set<llvm::Instruction*> S){
    std::set<llvm::Instruction*> result;
    for(auto* I: S){
        if(!isOutsideDetermined(I)) result.insert(I);
    }
    return result;
}

bool LoopSummary::isAffectOutside(){
    return !getAffectOutside().empty();
}

void LoopSummary::showAll(){
    llvm::errs() << "affect outside: \n";
    for(auto* I: getAffectOutside()){
        I->print(llvm::errs());
        llvm::errs() << "\n";
    }
}

// a loop is summarizable if 
// 1. no outside control variable is affected 
// 2. the control inside the loop is determined by outside
// 3. there is only one latch
// 4. all sub loops are summarizable
bool LoopSummary::isSummarizable(){
    if(isAffectOutside()) return false;
    if(!isOutsideDetermined()) return false;

    llvm::SmallVector<llvm::BasicBlock*> latches;
    L.getLoopLatches(latches);
    if(latches.size() != 1) return false;

    for(auto& subLoop: L.getSubLoops()){
        LoopSummary LS(M, *subLoop, SE);
        if(!LS.isSummarizable()) return false;
    }
    return true;
}

llvm::Loop* LoopSummary::trySummarize(){
    if(!isSummarizable()) return nullptr;
    
    for(auto& subLoop: L.getSubLoops()){
        LoopSummary LS(M, *subLoop, SE);
        LS.trySummarize();
    }

    // remove backedge from the single latch, create a acyclic control 
    llvm::BasicBlock* latch = L.getLoopLatch();
    llvm::BasicBlock* exit = L.getExitBlock();
    llvm::BranchInst::Create(exit, latch->getTerminator());
    latch->getTerminator()->eraseFromParent();

    // remove computation in the loop
    for(auto* B: L.getBlocks()){
        ControlVar::eraseComputation(B);
    }

    return &L;
}