// From bploeckelman/count-bb.cpp https://gist.github.com/bploeckelman/3614316
// at 12/17/2024  

#include "llvm/ADT/Twine.h"
#include "llvm/IR/Function.h"
#include "llvm/IR/Instructions.h"
#include "llvm/IR/GlobalVariable.h"
#include "llvm/IR/IRBuilder.h"
#include <cassert>
#include <cstdlib>
#include <llvm/ADT/StringRef.h>
#include <llvm/Analysis/ScalarEvolution.h>
#include <llvm/IR/BasicBlock.h>
#include <llvm/IR/Constant.h>
#include <llvm/IR/DerivedTypes.h>
#include <llvm/IR/Value.h>
#include <llvm/Support/Error.h>
#include <llvm/Support/raw_ostream.h>
#include <llvm/IR/Type.h>
#include <map>
#include "llvm/Transforms/Utils/ScalarEvolutionExpander.h"
#include "block_counting.hpp"
#include "loop_summary.hpp"


llvm::Function* getPrint(llvm::Module &M){
    if (auto f = M.getFunction("_Z13print_counteriPci")) {
        return f;
    }

    llvm::FunctionType *printType = llvm::FunctionType::get(
        llvm::Type::getVoidTy(M.getContext()),
        {
            llvm::Type::getInt32Ty(M.getContext()), 
            llvm::PointerType::getInt8Ty(M.getContext()),
            llvm::Type::getInt32Ty(M.getContext())},
        false
    );
    return llvm::Function::Create(
        printType,
        llvm::Function::ExternalLinkage,
        llvm::Twine("_Z13print_counteriPci"),
        M
    );
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
        llvm::ConstantInt::get(llvm::Type::getInt32Ty(F->getContext()), 0),
        B->getName() + "_bbCounter"
    );

    //insert the increment instruction at the end of the basic block
    auto InsertPos = B->getTerminator(); 
    llvm::Value *OldVal = new llvm::LoadInst(llvm::Type::getInt32Ty(B->getContext()), bbCounter, "old.bb.count", InsertPos);
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
    instrumentBlock(B, llvm::ConstantInt::get(llvm::Type::getInt32Ty(B->getContext()), 1));
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
            
    if (bcount->getType() == llvm::Type::getInt32Ty(B->getContext())){
        instrumentBlock(B, bcount);
    }
    else if (bcount->getType() == llvm::Type::getInt64Ty(B->getContext())){
        auto trunc = new llvm::TruncInst(bcount, llvm::Type::getInt32Ty(B->getContext()), "trunc", B->getTerminator());
        instrumentBlock(B, trunc);
    }
    else{
        assert(false && "unsupported backedge count type, only support 32-bit and 64-bit integer");
    }
}

void populateSymCounts(LoopSummary* LS, std::map<llvm::BasicBlock*, const llvm::SCEV*> &symCounts){

    for(auto B: LS->L.getBlocks()){
        if (B == LS->L.getHeader()){
            // loop header will be executed one more time than the loop body
            auto backPlusOne = LS->SE.getAddExpr(LS->backedgeCount, LS->SE.getOne(LS->backedgeCount->getType()));
            symCounts[B] = LS->SE.getMulExpr(symCounts[B], backPlusOne);
        }
        else{
            symCounts[B] = LS->SE.getMulExpr(symCounts[B], LS->backedgeCount);
        }
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