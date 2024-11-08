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
#include <iostream>
#include <llvm/Analysis/ScalarEvolutionExpressions.h>
#include <llvm/IR/CFG.h>
#include <llvm/IR/Instructions.h>
#include <llvm/Support/Casting.h>
#include "llvm/IR/Dominators.h"
#include "llvm/Analysis/ScalarEvolution.h"
#include <memory>

using namespace llvm;

void printLoopInfo(Loop &L, ScalarEvolution &SE, int depth = 0);

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
            printLoopInfo(*L, SE);
        }
    }
}

void printLoopInfo(Loop &L, ScalarEvolution &SE, int depth){
    std::string indent(depth*2, ' ');

    errs() << indent << "Loop: " << L.getName() << "\n";
    errs() << indent;
    L.getLatchCmpInst() ->print(errs());
    errs() << "\n";

    if (PHINode* i = L.getInductionVariable(SE)) {
        const SCEVAddRecExpr* expr = cast<SCEVAddRecExpr>(SE.getSCEV(i));
        const SCEV* start = expr->getStart();
        const SCEV* step = expr->getStepRecurrence(SE);
        const SCEV* bcount = SE.getBackedgeTakenCount(&L);
        const SCEV* end = SE.getAddExpr(start, SE.getMulExpr(bcount, step));

        errs() << indent << "  InVar: ";
        i->printAsOperand(errs());
        expr->print(errs());
        errs() << " | ";
        start->print(errs());
        errs() << " ";
        step->print(errs());
        errs() << " | ";
        end->print(errs());

        errs() << "\n";
    }
    else {
        assert(0 && "No induction variable found");
    }

    for (Loop* SL : L.getSubLoops()) {
        printLoopInfo(*SL, SE, depth + 1);
    }
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