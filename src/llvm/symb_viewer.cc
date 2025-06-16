/*
    This file contains a command line tool that generate a symbolic count
    for a given LLVM IR file.
*/

#include "symb_form.hpp"

#include <llvm/IR/LLVMContext.h>
#include <llvm/IR/Module.h>
#include <llvm/IRReader/IRReader.h>
#include <llvm/Support/SourceMgr.h>
#include <llvm/Support/CommandLine.h>
#include <llvm/Support/InitLLVM.h>
#include <llvm/Support/raw_ostream.h>
#include <llvm/Analysis/LoopInfo.h>
#include <llvm/Analysis/PostDominators.h>
#include <llvm/Analysis/ScalarEvolution.h>
#include <llvm/Analysis/ScalarEvolutionAliasAnalysis.h>
#include <llvm/Passes/PassBuilder.h>
#include <llvm/IR/LegacyPassManager.h>
#include <memory>
#include <fstream>
#include "llvm/Transforms/Utils/Mem2Reg.h"

using namespace llvm;

static cl::opt<std::string> InputFilename(cl::Positional, cl::desc("<input LLVM IR file>"), cl::Required);
static cl::opt<std::string> FunctionName(cl::Positional, cl::desc("<function name to analyze>"), 
    cl::Required, cl::value_desc("function name"));
static cl::opt<std::string> OutputJsonFilename(
    "json",
    cl::desc("Output symbolic form as JSON to the specified file"),
    cl::value_desc("filename"),
    cl::init("")
);
llvm::cl::opt<bool> Help("h", llvm::cl::desc("Print help message"));

void printHelpMessage() {
    llvm::outs() << "Usage: symb_viewer <input LLVM IR file> <function name to analyze> [options]\n";
    llvm::outs() << "Options:\n";
    llvm::outs() << "  -json=<filename>   Output symbolic form as JSON to the specified file\n";
    llvm::outs() << "  -h                 Print help message\n";
    llvm::outs() << "\n";
    llvm::outs() << "Example:\n";
    llvm::outs() << "  symb_viewer input.ll my_function -json=output.json\n";
}


int main(int argc, char **argv) {
    if (argc < 3 || Help) {
        printHelpMessage();
        return 0;
    }

    InitLLVM X(argc, argv);
    cl::ParseCommandLineOptions(argc, argv, "LLVM IR Loop/PDom/SE Analysis\n");

    LLVMContext Context;
    SMDiagnostic Err;
    std::unique_ptr<Module> M = parseIRFile(InputFilename, Err, Context);
    if (!M) {
        Err.print(argv[0], errs());
        return 1;
    }

    PassBuilder PB;
    LoopAnalysisManager LAM;
    FunctionAnalysisManager FAM;
    CGSCCAnalysisManager CGAM;
    ModuleAnalysisManager MAM;
    FunctionPassManager FPM;

    PB.registerModuleAnalyses(MAM);
    PB.registerCGSCCAnalyses(CGAM);
    PB.registerFunctionAnalyses(FAM);
    PB.registerLoopAnalyses(LAM);
    PB.crossRegisterProxies(LAM, FAM, CGAM, MAM);

    FAM.registerPass([&] { return ScalarEvolutionAnalysis(); });
    FAM.registerPass([&] { return LoopAnalysis(); });
    FAM.registerPass([&] { return PostDominatorTreeAnalysis(); });

    // FPM.addPass(PromotePass());

    Function *TargetFunc = M->getFunction(FunctionName);
    if (!TargetFunc || TargetFunc->isDeclaration()) {
        errs() << "Function '" << FunctionName << "' not found or is a declaration.\n";
        return 1;
    }

    FPM.run(*TargetFunc, FAM);

    // Loop Analysis
    auto &LI = FAM.getResult<LoopAnalysis>(*TargetFunc);

    // ScalarEvolution Analysis
    auto &SE = FAM.getResult<ScalarEvolutionAnalysis>(*TargetFunc);
    
    // Post Dominator Analysis
    auto &PDT = FAM.getResult<PostDominatorTreeAnalysis>(*TargetFunc);

    // build symbolic form for the function
    auto GB = GraphBuilder(LI, PDT, SE);
    auto program = GB.createProgram(TargetFunc);
    if (!program) {
        errs() << "Failed to create program from function: " << FunctionName << "\n";
        return 1;
    }

    // show the symbolic form or output as JSON
    if (!OutputJsonFilename.empty()) {
        std::ofstream jsonOut(OutputJsonFilename);
        GraphViewer::showAllBasicGraphsAsJson(program, jsonOut);
    } else {
        GraphViewer::showProgram(program);
    }

    return 0;
}