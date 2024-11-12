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
#include <llvm/IR/InstrTypes.h>
#include <llvm/IR/Instructions.h>
#include <llvm/IR/Operator.h>
#include <llvm/IR/Use.h>
#include <llvm/Support/Casting.h>
#include "llvm/IR/Dominators.h"
#include "llvm/Analysis/ScalarEvolution.h"
#include <memory>

using namespace llvm;

void printLoopInfo(Loop &L, ScalarEvolution &SE, int depth = 0);
void printRootExpr(const SCEV& E);
void printExpanded(Instruction& I);

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
        errs() << " | ";
        expr->print(errs());
        errs() << "\n";

        errs() << indent << "  start: ";
        start->print(errs());
        errs() << " | ";
        printRootExpr(*start);
        errs() << "\n";

        errs() << indent << "  step: ";
        step->print(errs());
        errs() << " | ";
        printRootExpr(*step);
        errs() << "\n";

        errs() << indent << "  end: ";
        end->print(errs());
        errs() << " | ";
        printRootExpr(*end);
        errs() << "\n";

    }
    else {
        assert(0 && "No induction variable found");
    }

    for (Loop* SL : L.getSubLoops()) {
        printLoopInfo(*SL, SE, depth + 1);
    }
}

void printRootExpr(const SCEV& E){
    for(const SCEV* op: E.operands()){
        if(const SCEVUnknown* u = dyn_cast<SCEVUnknown>(op)){
            u->print(errs());
            errs() << " ";
            printExpanded(*dyn_cast<Instruction>(u->getValue()));
            errs() << " | ";
        }
    }
}

void printExpanded(Instruction& I){
    if (I.isBinaryOp() || I.isUnaryOp()) {
        errs() << I.getOpcodeName() << " ";
        for (Use& opr : I.operands()) {
            if (Instruction* op = dyn_cast<Instruction>(opr.get())) {
                errs() << "(";
                printExpanded(*op);
                errs() << ")";
            }
            else {
                opr->printAsOperand(errs(), false);
            }
            errs() << " ";
        }
    }
    else{
        errs() << I.getOpcodeName() << " ";
        for (Use& opr : I.operands()) {
            opr->printAsOperand(errs(), false);
            errs() << " ";
        }
    }
}

void analyzeExpandedExpr(Module& M){
    for (Function& F: M) 
    for (BasicBlock& B: F) 
    for (Instruction& I: B) {
        I.print(errs());
        errs() << "\n";
        errs() << " " << I.getName() << " = ";
        printExpanded(I);
        errs() << "\n";
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
    // analyzeExpandedExpr(*M);
    
    return 0;
}