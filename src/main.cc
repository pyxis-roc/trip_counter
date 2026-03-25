#include <llvm/Analysis/AssumptionCache.h>
#include <llvm/Analysis/ScalarEvolution.h>
#include <llvm/Analysis/LoopInfo.h>
#include <llvm/IR/Dominators.h>
#include <llvm/IR/Function.h>
#include <llvm/IRReader/IRReader.h>
#include <llvm/Passes/PassBuilder.h>
#include <llvm/IR/Module.h>
#include <iostream>
#include <llvm/Support/raw_ostream.h>
#include <memory>
#include <vector>
#include "loop_summary.hpp"
#include "block_counting.hpp"
#include "printer.hpp"
#include "control_variable.hpp"
#include "llvm/Analysis/LoopInfo.h"
#include "llvm/Transforms/Utils/Mem2Reg.h"
#include "llvm/IR/LegacyPassManager.h"
#include "llvm/IR/Module.h"
#include "utils.hpp"
                                     
using namespace llvm;

void analyzeLoop(Module &M, std::string targetFunctionName = "main") {
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

    // record all current functions, avoid newly created helper functions
    std::vector<Function*> functions;
    for (Function& F: M) {
        functions.push_back(&F);
    }

    for (auto F: functions) {
        if (F->isDeclaration()) continue;
        if (F->getName() != targetFunctionName) continue;

        // basic information from original function
        std::map<llvm::BasicBlock*, std::string> bbIDs;
        for (auto &B: *F) {
            bbIDs[&B] = getBlockID(&B);
        }

        // Initialize the analysis manager for the function
        FPM.run(*F, FAM);
        LoopInfo &LI = FAM.getResult<LoopAnalysis>(*F);
        ScalarEvolution &SE = FAM.getResult<ScalarEvolutionAnalysis>(*F);

        // program slicing to remove all unnecessary instructions
        ControlVar::eraseComputation(F);

        // analyze summaries 
        std::set<LoopSummary*> summaries;
        for (Loop *L : LI) {
            auto LS = new LoopSummary(M, *L, SE);
            if(auto l = LS->trySummarize()){
                summaries.insert(LS);
            }
            else{
                delete LS;
            }
        }

        // insert counters
        CountBasicBlocks().buildProxy(*F, summaries, bbIDs);
    }
    M.print(llvm::outs(), nullptr);
}


int main (int argc, char** argv){
    if(argc < 3){
        std::cerr << "Usage: " << argv[0] << " <LLVM IR file> <target function name>\n";
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

    analyzeLoop(*M, argv[2]);
    
    return 0;
}