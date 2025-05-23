#include "symb_form.hpp"
#include "utils.hpp"
#include <llvm/IR/BasicBlock.h>
#include <memory>
#include <utility>

unique_ptr<Program> GraphBuilder::createProgram(llvm::Function * F){
    auto args = F->arg_begin();
    auto argList = std::vector<std::unique_ptr<Symbol>>();
    for (; args != F->arg_end(); ++args) {
        auto argName = args->getName().str();
        auto symbol = std::make_unique<Symbol>(argName);
        argList.push_back(std::move(symbol));
    }

    auto graph = createGraph(&F->getEntryBlock(), std::make_unique<Symbol>("1"));

    return std::make_unique<Program>(Program(std::move(argList), std::move(graph)));
}

unique_ptr<Graph> GraphBuilder::createGraph(llvm::BasicBlock* BB, unique_ptr<Symbol> initCount){

    auto blockID = getBlockID(BB);
    auto graph = make_unique<Graph>(Graph(blockID, initCount->copy()));
    auto BG = createBasicGraph(BB, std::move(graph));
    graph->BG = std::move(BG);
    
    auto nextHead = nextGraphHead(BB);
    if (!nextHead){
        return graph;
    }
    auto nextGraph = createGraph(nextHead, initCount->copy());
    graph->G = std::move(nextGraph);

    return graph;
}

llvm::BasicBlock* GraphBuilder::nextGraphHead(llvm::BasicBlock* BB){

    if(is_BasicBlock_graph(BB)){
        auto succ = BB->getSingleSuccessor();
        return succ;
    }
    else if (is_Loop_graph(BB)){
        auto loop = LI.getLoopFor(BB);
        auto exitBlocks = llvm::SmallVector<llvm::BasicBlock*, 8>();
        loop->getExitBlocks(exitBlocks);
        if(exitBlocks.size() == 1){
            return exitBlocks[0];
        }
        else{
            llvm::errs() << "Error: GraphBuilder::nextGraphHead: Loop has multiple exit blocks\n";
            return nullptr;
        }
    }
    else if (is_Branch_graph(BB)){
        auto trueSide = BB->getTerminator()->getSuccessor(0);
        auto falseSide = BB->getTerminator()->getSuccessor(1);

        auto postDomTrue = PDT.getNode(trueSide);
        auto postDomFalse = PDT.getNode(falseSide);

        if (!postDomTrue || !postDomFalse) {
            llvm::errs() << "Error: GraphBuilder::nextGraphHead: Post dominator not found for one of the sides\n";
            return nullptr;
        }

        auto commonPostDom = PDT.findNearestCommonDominator(trueSide, falseSide);
        if (!commonPostDom) {
            llvm::errs() << "Error: GraphBuilder::nextGraphHead: No common post dominator found\n";
            return nullptr;
        }

        return commonPostDom;
    }
    else {
        llvm::errs() << "Error: GraphBuilder::nextGraphHead: Unknown graph type for block " << getBlockID(BB) << "\n";
        return nullptr;
    }
}

unique_ptr<BasicGraph> GraphBuilder::createBasicGraph(llvm::BasicBlock* BB, std::unique_ptr<Graph> G){
    auto blockID = getBlockID(BB);
    auto name = BB->getName().str();
    auto BG = std::make_unique<BasicGraph>(BasicGraph(blockID, name, std::move(G)));

    if (is_BasicBlock_graph(BB)){
        return createBasicBlock(BB, std::move(BG));
    }
    else if(is_Branch_graph(BB)){
        return createBranch(BB, std::move(BG));
    }
    else if (is_Loop_graph(BB)){
        return createLoop(BB, std::move(BG));
    }
    else {
        llvm::errs() << "Error: BasicGraph::createBasicGraph: Unknown graph type for block " << blockID << "\n";
        return nullptr;
    }
}

bool GraphBuilder::is_BasicBlock_graph(llvm::BasicBlock* BB){
    return BB->getSinglePredecessor() != nullptr && BB->getSingleSuccessor() != nullptr;
}

bool GraphBuilder::is_Branch_graph(llvm::BasicBlock* BB){
    if (BB->getTerminator()->getNumSuccessors() != 2) {
        return false;
    }
    if (LI.getLoopFor(BB) == nullptr) {
        return true;
    }
    // check if the block is a loop latch
    return LI.getLoopFor(BB)->isLoopLatch(BB);
}

bool GraphBuilder::is_Loop_graph(llvm::BasicBlock* BB){
    return LI.isLoopHeader(BB);
}

unique_ptr<BasicBlock> GraphBuilder:: createBasicBlock(llvm::BasicBlock* BB, std::unique_ptr<BasicGraph> BG){
    return make_unique<BasicBlock>(BasicBlock(std::move(BG)));
}

unique_ptr<Branch> GraphBuilder::createBranch(llvm::BasicBlock* BB, std::unique_ptr<BasicGraph> BG){

    auto trueRatio_literal = "true_ratio_" + BB->getName().str();
    auto falseRatio_literal = "1 - " + trueRatio_literal;
    auto trueRatio = make_unique<Symbol>(trueRatio_literal);
    auto falseRatio = make_unique<Symbol>(falseRatio_literal);

    auto incoming_count = BG->G->count->copy();
    auto trueSide = BB->getTerminator()->getSuccessor(0);
    auto falseSide = BB->getTerminator()->getSuccessor(1);
    auto G1 = createGraph(trueSide, trueRatio->multiply(incoming_count));
    auto G2 = createGraph(falseSide, falseRatio->multiply(incoming_count));

    return make_unique<Branch>(
        Branch(
            std::move(BG), 
            std::move(trueRatio), 
            std::move(falseRatio), 
            std::move(G1), 
            std::move(G2)
        )
    );
}

unique_ptr<Loop> GraphBuilder::createLoop(llvm::BasicBlock* BB, std::unique_ptr<BasicGraph> BG){
    auto incoming_count = BG->G->count->copy();
    auto loopCount = getLoopCount(BB);
    auto Gb = createGraph(BB, loopCount->multiply(incoming_count));

    return make_unique<Loop>(
        Loop(
            std::move(BG), 
            std::move(loopCount), 
            std::move(Gb)
        )
    );
}

unique_ptr<Symbol> GraphBuilder::getLoopCount(llvm::BasicBlock* BB){
    auto loopCount_literal = "loop_count_" + BB->getName().str();
    auto loopCount = make_unique<Symbol>(loopCount_literal);
    return loopCount;
}