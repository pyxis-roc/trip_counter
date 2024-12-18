#include "llvm/IRReader/IRReader.h"
#include "llvm/Passes/PassBuilder.h"
#include <iostream>
#include <llvm/Support/raw_ostream.h>
#include <vector>
#include "loop_summary.hpp"
#include "block_counting.hpp"
#include "printer.hpp"
                                     
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

    FPM.addPass(LoopSimplifyPass());
    FPM.addPass(ScalarEvolutionVerifierPass());

    for (Function& F: M) {
        if (F.isDeclaration()) continue;

        FPM.run(F, FAM);
        LoopInfo &LI = FAM.getResult<LoopAnalysis>(F);
        ScalarEvolution &SE = FAM.getResult<ScalarEvolutionAnalysis>(F);
        
        for (Loop *L : LI) {
            LoopSummary LS(M, *L, SE);
            if(!LS.isSummarizable()) continue;

            Debug::printLoopInfo(*L, SE);
            LS.trySummarize();
        }
    }
    CountBasicBlocks::insertCounter(M);
    
    M.dump();
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