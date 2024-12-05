#include "loop_summary.hpp"
#include "control_variable.hpp"
#include <algorithm>
#include <iterator>
#include <llvm/IR/Instruction.h>
#include <set>

std::set<llvm::Instruction*> LoopSummary::getAffectInstructions(llvm::Module* M){
    auto loopDirect = ControlVar::getDirect(&L);
    auto moduleDirect = ControlVar::getDirect(M);
    std::set<llvm::Instruction*> externalDirect; 
    std::set_difference(moduleDirect.begin(), moduleDirect.end(), 
                    loopDirect.begin(), loopDirect.end(), 
                    std::inserter(externalDirect, externalDirect.begin()));
    auto allExternal = ControlVar::extened(externalDirect);
    
    std::set<llvm::Instruction*> result;
    for(auto* basicBlock: L.getBlocks()){
        for(auto& instruction: *basicBlock ){
            if(allExternal.find(&instruction) != allExternal.end()){
                result.insert(&instruction);
            }
        }
    }
    return result;
}

bool LoopSummary::isAffect(llvm::Module* M){
    return !getAffectInstructions(M).empty();
}

void LoopSummary::showAll(llvm::Module* M){
    for(auto* I: getAffectInstructions(M)){
        I->print(llvm::errs());
        llvm::errs() << "\n";
    }
}