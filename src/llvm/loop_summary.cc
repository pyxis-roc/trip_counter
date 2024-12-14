#include "loop_summary.hpp"
#include "control_variable.hpp"
#include <algorithm>
#include <cstdlib>
#include <iterator>
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

bool LoopSummary::isOutsideDetermined(){
    auto allDirect = ControlVar::getDirect(&L);
    std::set<llvm::Instruction*> allSubLoopDirect = ControlVar::getDirect(L.getSubLoops());
    
    llvm::SmallVector<llvm::BasicBlock*, 8> latches;
    L.getLoopLatches(latches);
    std::set<llvm::Instruction*> latchDirect = ControlVar::getDirect(latches);

    std::set<llvm::Instruction*> internalControlDirect;
    std::set_difference(allDirect.begin(), allDirect.end(), 
                        allSubLoopDirect.begin(), allSubLoopDirect.end(), 
                        std::inserter(internalControlDirect, internalControlDirect.begin()));
    std::set_difference(internalControlDirect.begin(), internalControlDirect.end(),
                        latchDirect.begin(), latchDirect.end(),
                        std::inserter(internalControlDirect, internalControlDirect.begin()));

    for(auto* I: internalControlDirect){
        if(!ControlVar::isExternal(I, &L)) {
            I->print(llvm::errs());
            return false;
        }
    }
    return true;
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

bool LoopSummary::isSummarizable(){
    for(auto& subLoop: L.getSubLoops()){
        LoopSummary LS(M, *subLoop, SE);
        if(!LS.isSummarizable()) return false;
    }
    return !isAffectOutside() && isOutsideDetermined();
}