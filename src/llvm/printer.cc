#include <llvm/IR/Module.h>
#include "printer.hpp"

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

void Debug::printLoopInfo(Loop &L, ScalarEvolution &SE,v_set keep_unexpanded, int depth){
    std::string indent(depth*2, ' ');

    errs() << indent << "Loop: " << L.getName() << "\n";

    PHINode* i = L.getInductionVariable(SE);
    if (!i) assert(0 && "No induction variable found");
    
    keep_unexpanded.insert(static_cast<const Value*>(i));
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

    for (Loop* SL : L.getSubLoops()) {
        printLoopInfo(*SL, SE, keep_unexpanded, depth + 1);
    }
    keep_unexpanded.erase(i);
}

void Debug::printRootExpr(const SCEV& E, v_set keep_unexpanded){
    for(const SCEV* op: E.operands()){
        if(const SCEVUnknown* u = dyn_cast<SCEVUnknown>(op)){
            u->print(errs());
            errs() << " ";
            printExpanded(dyn_cast<Instruction>(u->getValue()), keep_unexpanded);
            errs() << " | ";
        }
    }
}

void Debug::printExpanded(Value* I, v_set keep_unexpanded){
    //expand cases
    if(Instruction* i = dyn_cast<Instruction>(I)){
        if (i->getOpcode() == Instruction::PHI){
            i->print(errs());
            return;
        }
        errs() << "(";
        errs() << i->getOpcodeName();
        for(Use& opr: i->operands()){
            errs() << " ";
            printExpanded(dyn_cast<Value>(opr.get()), keep_unexpanded);
        }
        errs() << ")";
    }
    //basic cases
    else{
        I->printAsOperand(errs(), false);
    }
}

void Debug::printLoopBlocks(llvm::Loop &L){
    errs() << "Loop: " << L.getName() << "\n";
    for (BasicBlock* BB : L.getBlocks()){
        errs() << "  " << BB->getName() << "\n";
    }
}