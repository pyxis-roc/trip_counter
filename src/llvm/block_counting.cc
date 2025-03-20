// From bploeckelman/count-bb.cpp https://gist.github.com/bploeckelman/3614316
// at 12/17/2024  

#include "llvm/IR/Function.h"
#include "llvm/IR/Instructions.h"
#include "llvm/IR/GlobalVariable.h"
#include "llvm/IR/IRBuilder.h"
#include <llvm/IR/BasicBlock.h>
#include <llvm/IR/Constant.h>
#include <llvm/IR/DerivedTypes.h>
#include <llvm/IR/Value.h>
#include <llvm/IR/ValueHandle.h>
#include <llvm/IR/Type.h>
#include <llvm/IRReader/IRReader.h>
#include "llvm/ADT/Twine.h"
#include <llvm/ADT/StringRef.h>
#include <llvm/Analysis/ScalarEvolution.h>
#include <llvm/Support/Error.h>
#include <llvm/Support/SourceMgr.h>
#include <llvm/Support/raw_ostream.h>
#include <llvm/Transforms/Utils/Cloning.h>
#include <llvm/Linker/Linker.h>
#include "llvm/Transforms/Utils/ScalarEvolutionExpander.h"
#include <map>
#include <cassert>
#include <cstdlib>
#include "block_counting.hpp"
#include "loop_summary.hpp"

// From IR_plugin/print.ll import the external print_counter function
// into the current module
llvm::Function* getPrint(llvm::Module &M){

    // parse the .ll file to get the function
    llvm::SMDiagnostic Error;
    auto path = IR_PLUGIN_PATH "/print.ll";
    std::unique_ptr<llvm::Module> external_M = llvm::parseIRFile(path, Error ,M.getContext());
    if (!external_M) {
        llvm::errs() << "Failed to load " << path << "\n";
        return nullptr;
    }

    // Link the external module to the original one
    llvm::Linker linker(M);
    if (linker.linkInModule(std::move(external_M))) {
        llvm::errs() << "Failed to link external module\n";
        return nullptr;
    }

    llvm::Function* print_counter = M.getFunction("print_counter");
    if (!print_counter) {
        llvm::errs() << "Failed to load print_counter function in\n";
        return nullptr;
    }

    return print_counter;
}

// At the end of the module, print the count of each basic block
llvm::Function* createReport(llvm::Function& F, std::map<llvm::BasicBlock*, llvm::GlobalVariable*> counters){
    auto reportFuncName = (F.getName() + "_print_bb_count").str();
    if (auto f = F.getParent()->getFunction(reportFuncName)) {
        return f;
    }

    llvm::FunctionType *printType = llvm::FunctionType::get(
        llvm::Type::getVoidTy(F.getContext()),
        {},
        false
    );
    llvm::Function *printAll = llvm::Function::Create(
        printType,
        llvm::Function::ExternalLinkage,
        llvm::Twine(reportFuncName),
        F.getParent()
    );

    llvm::BasicBlock *entry = llvm::BasicBlock::Create(F.getContext(), "entry", printAll);
    llvm::IRBuilder<> builder(entry);
    llvm::Function* printUtil = getPrint(*F.getParent());

    for(auto [bb,var]: counters){
        llvm::Value *val = new llvm::LoadInst(llvm::Type::getInt64Ty(F.getContext()), var, "bb.count", entry);
        builder.CreateCall(printUtil, 
            {
            llvm::ConstantInt::get(llvm::Type::getInt32Ty(F.getContext()), std::hash<llvm::BasicBlock*>{}(bb)),
            builder.CreateGlobalStringPtr(bb->getName()),
            val});
    }

    builder.CreateRetVoid();
    return printAll;
}

void CountBasicBlocks::buildProxy(llvm::Function &F, std::set<LoopSummary*> SL) {
    for (auto summary: SL){
        instrumentSummarizedLoop(summary);
    }

    for(auto &B: F){
        if(isInstrumented(&B)) continue;
        instrumentNormalBlock(&B);
    }

    // create a call to the report function before the return instruction
    llvm::Function* report = createReport(F, counters);
    for(auto &B: F){
        if(llvm::ReturnInst* R = llvm::dyn_cast<llvm::ReturnInst>(B.getTerminator())){
            llvm::IRBuilder<> builder(R);
            builder.CreateCall(report);
        }
    }
}

void CountBasicBlocks::instrumentBlock(llvm::BasicBlock* B, llvm::Value* increment){
    auto F = B->getParent();
    //create a global variable for each basic block to store the count
    llvm::GlobalVariable *bbCounter = new llvm::GlobalVariable(
        *F->getParent(),
        llvm::Type::getInt64Ty(F->getContext()),
        false,
        llvm::GlobalValue::CommonLinkage,
        llvm::ConstantInt::get(llvm::Type::getInt64Ty(F->getContext()), 0),
        B->getName() + "_bbCounter"
    );

    //insert the increment instruction at the end of the basic block
    auto InsertPos = B->getTerminator(); 
    llvm::Value *OldVal = new llvm::LoadInst(llvm::Type::getInt64Ty(B->getContext()), bbCounter, "old.bb.count", InsertPos);
    llvm::Value *NewVal = llvm::BinaryOperator::Create(
                llvm::Instruction::Add
            , OldVal
            , increment
            , "new.bb.count"
            , InsertPos);
    new llvm::StoreInst(NewVal, bbCounter, InsertPos);

    counters[B] = bbCounter;
}

void CountBasicBlocks::instrumentNormalBlock(llvm::BasicBlock* B){
    instrumentBlock(B, llvm::ConstantInt::get(llvm::Type::getInt64Ty(B->getContext()), 1));
}

llvm::Value* materializeSCEV(llvm::BasicBlock* B, llvm::ScalarEvolution &SE, const llvm::SCEV* scev){
    llvm::IRBuilder<> builder(B->getContext());
    llvm::SCEVExpander expander(SE,  B->getDataLayout(), "scev");

    auto val = expander.expandCodeFor(scev, scev->getType(), B->begin());
    return val;
}

void CountBasicBlocks::instrumentSummarizedBlock(llvm::BasicBlock* B, const llvm::SCEV* backedgeCount, llvm::ScalarEvolution &SE){
    auto builder = llvm::IRBuilder<>(B->getContext());
    auto bcount = materializeSCEV(B, SE, backedgeCount);
            
    if (bcount->getType() == llvm::Type::getInt64Ty(B->getContext())){
        instrumentBlock(B, bcount);
    }
    // else if (bcount->getType() == llvm::Type::getInt32Ty(B->getContext())){
    //     auto trunc = new llvm::TruncInst(bcount, llvm::Type::getInt32Ty(B->getContext()), "trunc", B->getTerminator());
    //     instrumentBlock(B, trunc);
    // }
    else{
        assert(false && "unsupported backedge count type, only support 64-bit integer");
    }
}

void populateSymCounts(LoopSummary* LS, std::map<llvm::BasicBlock*, const llvm::SCEV*> &symCounts){

    for(auto B: LS->L.getBlocks()){
        auto backPlusOne = LS->SE.getAddExpr(LS->backedgeCount, LS->SE.getOne(LS->backedgeCount->getType()));
        symCounts[B] = LS->SE.getMulExpr(symCounts[B], backPlusOne);
    }
    for(auto c: LS->child){
        populateSymCounts(c, symCounts);
    }
}

std::map<llvm::BasicBlock*, const llvm::SCEV*> getSymCounts(LoopSummary* LS){
    std::map<llvm::BasicBlock*, const llvm::SCEV*> symCounts;
    for (auto B: LS->L.getBlocks()){
        symCounts[B] = LS->SE.getOne(LS->backedgeCount->getType());
    }
    populateSymCounts(LS, symCounts);
    return symCounts;
}

void CountBasicBlocks::instrumentSummarizedLoop(LoopSummary* LS){
    auto symCounts = getSymCounts(LS);
    for(auto [B, count]: symCounts){
        instrumentSummarizedBlock(B, count, LS->SE);
    }
}

bool CountBasicBlocks::isInstrumented(llvm::BasicBlock* B){
    return counters.find(B) != counters.end();
}