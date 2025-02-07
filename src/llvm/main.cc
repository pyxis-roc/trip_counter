#include <llvm/Analysis/AssumptionCache.h>
#include <llvm/Analysis/ScalarEvolution.h>
#include <llvm/Analysis/LoopInfo.h>
#include <llvm/IR/Dominators.h>
#include <llvm/IRReader/IRReader.h>
#include <llvm/Passes/PassBuilder.h>
#include <llvm/IR/Module.h>
#include <iostream>
#include <llvm/Support/raw_ostream.h>
#include "loop_summary.hpp"
#include "block_counting.hpp"
#include "printer.hpp"
#include "control_variable.hpp"
#include "llvm/Analysis/LoopInfo.h"
#include "llvm/Transforms/Utils/Mem2Reg.h"

                                     
using namespace llvm;

void analyzeLoop(Module &M) {
    LLVMContext &Context = M.getContext();

    // Initialize pass managers
    LoopAnalysisManager LAM;
    FunctionAnalysisManager FAM;
    FunctionPassManager FPM;
    ModulePassManager MPM;
    ModuleAnalysisManager MAM;

    PassBuilder PB;

    PB.registerFunctionAnalyses(FAM);
    PB.registerLoopAnalyses(LAM);

    FAM.registerPass([&] { return ScalarEvolutionAnalysis(); });
    FAM.registerPass([&] { return LoopAnalysis(); });

    FPM.addPass(PromotePass());
    FPM.addPass(LoopSimplifyPass());
    // FPM.addPass(ScalarEvolutionPrinterPass(llvm::errs()));

    
    for (Function& F: M) {
        if (F.isDeclaration()) continue;

        FPM.run(F, FAM);
        LoopInfo &LI = FAM.getResult<LoopAnalysis>(F);
        ScalarEvolution &SE = FAM.getResult<ScalarEvolutionAnalysis>(F);
        
        ControlVar::eraseComputation(&F);
        std::set<LoopSummary*> summaries;
        for (Loop *L : LI) {
            auto LS = LoopSummary(M, *L, SE);
            summaries.insert(&LS);
        }
        CountBasicBlocks().buildProxy(F, summaries);
    }
    
    M.print(errs(), nullptr);
}


int main (int argc, char** argv){
    if(argc < 2){
        std::cerr << "Usage: " << argv[0] << " <LLVM IR file>\n";
        return 1;
    }

    LLVMContext Context;
    SMDiagnostic Error;
    std::unique_ptr<Module> M = parseIRFile(argv[1], Error, Context);

    if (!M) {
        std::cerr << "Error reading IR file: ";
        Error.print(argv[0], errs());
        return 1;
    }

    analyzeLoop(*M);
    
    return 0;
}