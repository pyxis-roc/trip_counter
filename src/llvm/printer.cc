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
#include <iostream>

using namespace llvm;

void printLoopInfo(Loop *L, unsigned depth = 0) {
    errs().indent(2 * depth) << "Loop at depth " << depth << "\n";

    // Print loop header
    if (BasicBlock *header = L->getHeader()) {
        errs().indent(2 * depth) << "Header: ";
        header->printAsOperand(errs(), false);
        errs() << "\n";
    }

    // Print loop preheader
    if (BasicBlock *preheader = L->getLoopPreheader()) {
        errs().indent(2 * depth) << "Preheader: ";
        preheader->printAsOperand(errs(), false);
        errs() << "\n";
    }

    // Print loop exit blocks
    SmallVector<BasicBlock*, 4> exitBlocks;
    L->getExitBlocks(exitBlocks);
    for (BasicBlock *exitBlock : exitBlocks) {
        errs().indent(2 * depth) << "Exit Block: ";
        exitBlock->printAsOperand(errs(), false);
        errs() << "\n";
    }

    // Recursively print nested loops
    for (Loop *SubLoop : L->getSubLoops()) {
        printLoopInfo(SubLoop, depth + 1);
    }
}

void runLoopSimplifyAndPrint(Module &M) {
    LLVMContext &Context = M.getContext();
    
    // Initialize pass managers
    LoopAnalysisManager LAM;
    FunctionAnalysisManager FAM;
    FunctionPassManager FPM;
    ModulePassManager MPM;
    
    // Register LoopInfo analysis
    PassBuilder PB;
    PB.registerFunctionAnalyses(FAM);
    PB.registerLoopAnalyses(LAM);

    // Add LoopSimplify and LoopInfo passes
    FPM.addPass(LoopSimplifyPass());

    // Run LoopSimplify on each function and print loop information
    for (Function &F : M) {
        if (F.isDeclaration()) continue;

        // Run the LoopSimplify pass
        FPM.run(F, FAM);

        // Get the LoopInfo for the function
        LoopInfo &LI = FAM.getResult<LoopAnalysis>(F);

        errs() << "Function: " << F.getName() << "\n";
        for (Loop *L : LI) {
            printLoopInfo(L);
        }
    }
}

int main(int argc, char **argv) {
    // Check if the user provided an input file
    if (argc < 2) {
        std::cerr << "Usage: " << argv[0] << " <LLVM IR file>\n";
        return 1;
    }

    // Initialize LLVM Context
    LLVMContext context;
    SMDiagnostic error;

    // Parse the LLVM IR file
    std::unique_ptr<Module> module = parseIRFile(argv[1], error, context);
    if (!module) {
        std::cerr << "Error reading IR file: ";
        error.print(argv[0], errs());
        return 1;
    }

    // runLoopSimplifyAndPrint(*module);

    // Print out the module's content
    std::cout << "Module Name: " << module->getName().str() << "\n";

    for (const Function &F : *module) {
        std::cout << "Function: " << F.getName().str() << "\n";
        for (const BasicBlock &BB : F) {
            std::cout << "  BasicBlock: ";
            BB.printAsOperand(outs(), false);
            std::cout << "\n";
        }
    }

    return 0;
}
