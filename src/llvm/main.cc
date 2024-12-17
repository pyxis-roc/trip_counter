#include "llvm/IR/LLVMContext.h"
#include "llvm/IR/Module.h"
#include "llvm/IR/Function.h"
#include "llvm/IR/BasicBlock.h"
#include "llvm/IR/Instruction.h"
#include "llvm/IRReader/IRReader.h"
#include "llvm/Support/SourceMgr.h"
#include "llvm/Support/raw_ostream.h"
#include "llvm/Transforms/Utils/LoopSimplify.h"
#include "llvm/Passes/PassBuilder.h"
#include "llvm/Passes/PassPlugin.h"
#include "llvm/Analysis/LoopInfo.h"
#include "llvm/Support/SourceMgr.h"
#include "llvm/Support/raw_ostream.h"
#include "llvm/Transforms/Scalar.h"
#include <cassert>
#include <cerrno>
#include <csignal>
#include <iostream>
#include <llvm/Analysis/ScalarEvolutionExpressions.h>
#include <llvm/IR/Argument.h>
#include <llvm/IR/CFG.h>
#include <llvm/IR/InstrTypes.h>
#include <llvm/IR/Instructions.h>
#include <llvm/IR/Operator.h>
#include <llvm/IR/Use.h>
#include <llvm/IR/Value.h>
#include <llvm/Support/Casting.h>
#include "llvm/IR/Dominators.h"
#include "llvm/Analysis/ScalarEvolution.h"
#include <memory>
#include "control_variable.hpp"
#include "loop_summary.hpp"

using namespace llvm;

void analyzeLoop(Module &M) {
    LLVMContext &Context = M.getContext();

    // Initialize pass managers
    LoopAnalysisManager LAM;
    FunctionAnalysisManager FAM;
    FunctionPassManager FPM;
    ModulePassManager MPM;

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
            LS.trySummarize();
        }
    }
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