#include "loop_summary.hpp"
#include "control_variable.hpp"
#include <algorithm>
#include <cstdlib>
#include <iterator>
#include <llvm/IR/Instruction.h>
#include <llvm/Support/raw_ostream.h>
#include <set>

std::set<llvm::Instruction*> LoopSummary::getAffectInstructions(llvm::Module* M){
    auto loopDirect = ControlVar::getDirect(&L);
    auto moduleDirect = ControlVar::getDirect(M);
    std::set<llvm::Instruction*> externalDirect; 
    std::set_difference(moduleDirect.begin(), moduleDirect.end(), 
                    loopDirect.begin(), loopDirect.end(), 
                    std::inserter(externalDirect, externalDirect.begin()));
    auto allExternal = ControlVar::extened(externalDirect);

    for (auto i: allExternal){
        i->print(llvm::errs());
        llvm::errs() << "\n";
    }

    llvm::errs() << "----------\n";
    
    std::set<llvm::Instruction*> result;
    auto loopAffected = ControlVar::getAffected(&L);
    std::set_intersection(loopAffected.begin(), loopAffected.end(), 
                        allExternal.begin(), allExternal.end(), 
                        std::inserter(result, result.begin()));
    for (auto i: loopAffected){
        i->print(llvm::errs());
        llvm::errs() << "\n";
    }
    exit(0);
    
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