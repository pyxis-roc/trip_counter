#include <llvm/IR/Module.h>
#include <llvm/Analysis/ScalarEvolutionExpressions.h>
#include "printer.hpp"
#include "llvm/Analysis/ScalarEvolution.h"

using namespace llvm;


void Debug::analyzeLoop(Module &M) {
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

void Debug::printLoopInfo(Loop &L, ScalarEvolution &SE, llvm::raw_ostream &os, v_set keep_unexpanded, int depth){
    std::string indent(depth*2, ' ');

    os << indent << "Loop: " << L.getName() << "\n";

    PHINode* i = L.getInductionVariable(SE);
    if (!i) assert(0 && "No induction variable found");
    
    keep_unexpanded.insert(static_cast<const Value*>(i));
    const SCEVAddRecExpr* expr = cast<SCEVAddRecExpr>(SE.getSCEV(i));
    const SCEV* start = expr->getStart();
    const SCEV* step = expr->getStepRecurrence(SE);
    const SCEV* bcount = SE.getBackedgeTakenCount(&L);
    const SCEV* end = SE.getAddExpr(start, SE.getMulExpr(bcount, step));

    os << indent << "  InVar: ";
    i->printAsOperand(os);
    os << " | ";
    expr->print(os);
    os << "\n";

    os << indent << "  start: ";
    start->print(os);
    os << " | ";
    printRootExpr(*start);
    os << "\n";

    os << indent << "  step: ";
    step->print(os);
    os << " | ";
    printRootExpr(*step);
    os << "\n";

    os << indent << "  end: ";
    end->print(os);
    os << " | ";
    printRootExpr(*end);
    os << "\n";

    for (Loop* SL : L.getSubLoops()) {
        printLoopInfo(*SL, SE, os,  keep_unexpanded, depth + 1);
    }
    keep_unexpanded.erase(i);
}

void Debug::printRootExpr(const SCEV& E, llvm::raw_ostream &os,  v_set keep_unexpanded){
    // Print the SCEV expression, replacing internal variables with printExpanded,
    // keeping original operations and constants untouched.
    if (const SCEVUnknown* u = dyn_cast<SCEVUnknown>(&E)) {
        // Replace variable with expanded form
        printExpanded(const_cast<Value*>(u->getValue()), os, keep_unexpanded);
    } else if (const SCEVConstant* c = dyn_cast<SCEVConstant>(&E)) {
        // Print constant as is
        c->getValue()->printAsOperand(os, false);
    } else {
        // Print operation name
        // Print the SCEV type as a string instead of integer
        switch (E.getSCEVType()) {
            case scConstant:              os << "scConst("; break;
            case scVScale:                os << "scVScale("; break;
            case scTruncate:              os << "scTrunc("; break;
            case scZeroExtend:            os << "scZeroExt("; break;
            case scSignExtend:            os << "scSignExt("; break;
            case scAddExpr:               os << "scAdd("; break;
            case scMulExpr:               os << "scMul("; break;
            case scUDivExpr:              os << "scUDiv("; break;
            case scAddRecExpr:            os << "scAddRecExpr("; break;
            case scUMaxExpr:              os << "scUMax("; break;
            case scSMaxExpr:              os << "scSMax("; break;
            case scUMinExpr:              os << "scUMin("; break;
            case scSMinExpr:              os << "scSMin("; break;
            case scSequentialUMinExpr:    os << "scSequentialUMin("; break;
            case scPtrToInt:              os << "scPtrToInt("; break;
            case scUnknown:               os << "scUnknown("; break;
            case scCouldNotCompute:       os << "scCouldNotCompute("; break;
            default:                      os << "scOtherSCEV("; break;
        }
        bool first = true;
        for (const SCEV* op : E.operands()) {
            if (!first) os << ", ";
            first = false;
            printRootExpr(*op, os, keep_unexpanded);
        }
        os << ")";
    }
}

void Debug::printExpanded(Value* I, llvm::raw_ostream &os, v_set keep_unexpanded){
    //expand cases
    if(Instruction* i = dyn_cast<Instruction>(I)){
        if (i->getOpcode() == Instruction::PHI){
            i->print(os);
            return;
        }
        os << "(";
        os << i->getOpcodeName();
        for(Use& opr: i->operands()){
            os << " ";
            printExpanded(dyn_cast<Value>(opr.get()), os,  keep_unexpanded);
        }
        os << ")";
    }
    //basic cases
    else{
        I->printAsOperand(os, false);
    }
}

void Debug::printLoopBlocks(llvm::Loop &L, llvm::raw_ostream &os){
    os << "Loop: " << L.getName() << "\n";
    for (BasicBlock* BB : L.getBlocks()){
        os << "  " << BB->getName() << "\n";
    }
}