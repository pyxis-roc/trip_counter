#include "symb_form.hpp"
#include "printer.hpp"
#include "utils.hpp"
#include "llvm/Analysis/LoopInfo.h"
#include "llvm/Analysis/ScalarEvolution.h"
#include <llvm/IR/BasicBlock.h>
#include <memory>
#include <string>
#include <tuple>


shared_ptr<Program> GraphBuilder::createProgram(llvm::Function * F){

    auto args = F->arg_begin();
    auto argList = std::vector<std::shared_ptr<Symbol>>();
    for (; args != F->arg_end(); ++args) {
        auto argName = getName(args);
        auto symbol = std::make_shared<Symbol>(argName);
        argList.push_back(symbol);
    }

    auto graph = createGraph(std::make_shared<Symbol>("1"), &F->getEntryBlock());

    return std::make_shared<Program>(Program(argList, graph));
}

shared_ptr<Graph> GraphBuilder::createGraph(shared_ptr<Symbol> initCount, 
        llvm::BasicBlock* startBB, llvm::BasicBlock* endBB){

    if (!startBB || startBB == endBB) return nullptr;

    auto blockID = getBlockID(startBB);
    auto graph = make_shared<Graph>(blockID);
    auto nextHead = nextGraphHead(startBB, endBB);

    auto BG = createBasicGraph(initCount, startBB, nextHead);
    graph->BG = BG;
    auto nextGraph = createGraph(initCount, nextHead, endBB);
    graph->G = nextGraph;

    return graph;
}

llvm::BasicBlock* GraphBuilder::nextGraphHead(llvm::BasicBlock* startBB, llvm::BasicBlock* endBB){
    
    switch (getGraphType(startBB, endBB)) {
        
        case GraphType::BasicBlock:{
            // there are two cases, one is simple basic block, the other is a loop header
            if (LI.isLoopHeader(startBB)) {
                auto loop = LI.getLoopFor(startBB);
                for (auto *succ : llvm::successors(startBB)) {
                    if (loop->contains(succ)) {
                        return succ;
                    }
                }
                llvm::errs() << "Error: GraphBuilder::nextGraphHead: No successor of loop header is inside the loop\n";
                return nullptr;
            }
            else{
                return startBB->getSingleSuccessor();
            }
        }


        case GraphType::Branch:{
            auto trueSide = startBB->getTerminator()->getSuccessor(0);
            auto falseSide = startBB->getTerminator()->getSuccessor(1);
            
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
        
        case GraphType::Loop:{
            auto loop = LI.getLoopFor(startBB);
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
            
        default:{
            llvm::errs() << "Error: GraphBuilder::nextGraphHead: Unknown graph type for block " << (startBB ? getName(startBB) : "null") << "\n";
            return nullptr;
        }
    }
}

shared_ptr<BasicGraph> GraphBuilder::createBasicGraph(std::shared_ptr<Symbol> count, 
        llvm::BasicBlock* startBB, llvm::BasicBlock* endBB){
    
    if (!startBB || startBB == endBB) return nullptr;

    auto blockID = getBlockID(startBB);
    auto name = getName(startBB);
    auto BG = std::make_shared<BasicGraph>(blockID, name, count);

    switch (getGraphType(startBB, endBB)) {
        case GraphType::BasicBlock:
            return createBasicBlock(BG, startBB, endBB);
        case GraphType::Branch:
            return createBranch(BG, startBB, endBB);
        case GraphType::Loop:
            return createLoop(BG, startBB, endBB);
        default:
            llvm::errs() << "Error: GraphBuilder::createBasicGraph: Unknown graph type for block " << name << "\n";
            return nullptr;
    }
}

GraphType GraphBuilder::getGraphType(llvm::BasicBlock* startBB, llvm::BasicBlock* endBB){

    // check if it is a loop graph 
    if(LI.isLoopHeader(startBB)){
        auto loop = LI.getLoopFor(startBB);
        
        if(!loop->contains(endBB)){
            return GraphType::Loop;
        }
        
    }

    // cannot be a loop graph, check for basic block or branch graph
    if (startBB->getTerminator()->getNumSuccessors() <= 1) {
        return GraphType::BasicBlock;
    }

    if (startBB->getTerminator()->getNumSuccessors() == 2) {
        // can be due to if statement (target) or a loop (latch or exit)
        
        if (auto loop = LI.getLoopFor(startBB)) {
            if (loop->isLoopLatch(startBB) || loop->isLoopExiting(startBB)){
                return GraphType::BasicBlock;
            }
            else{
                return GraphType::Branch;
            }
        }
        // not inside a loop, then it is a branch graph
        return GraphType::Branch;
    }
    
    llvm::errs() << "Error: GraphBuilder::getGraphType: Unsupported number of successors for block " 
                 << getName(startBB) << ": " << startBB->getTerminator()->getNumSuccessors() << "\n";
    return GraphType::Unknown;
}

shared_ptr<BasicBlock> GraphBuilder:: createBasicBlock(std::shared_ptr<BasicGraph> BG, 
        llvm::BasicBlock* startBB, llvm::BasicBlock* endBB){
  
    if (!startBB || startBB == endBB) return nullptr;
    return make_shared<BasicBlock>(BasicBlock(BG));
}

shared_ptr<Branch> GraphBuilder::createBranch(std::shared_ptr<BasicGraph> BG, 
        llvm::BasicBlock* startBB, llvm::BasicBlock* endBB){

    if (!startBB || startBB == endBB) return nullptr;

    auto trueRatio_literal = "TR_" + getName(startBB);
    auto falseRatio_literal = "(1 - " + trueRatio_literal + ")";
    auto trueRatio = make_shared<Symbol>(trueRatio_literal);
    auto falseRatio = make_shared<Symbol>(falseRatio_literal);

    auto incoming_count = BG->count;
    auto trueSide = startBB->getTerminator()->getSuccessor(0);
    auto falseSide = startBB->getTerminator()->getSuccessor(1);
    auto G1 = createGraph(trueRatio->multiply(incoming_count), trueSide, endBB);
    auto G2 = createGraph(falseRatio->multiply(incoming_count), falseSide, endBB);

    return make_shared<Branch>(
        Branch(
            BG, 
            trueRatio, 
            falseRatio, 
            G1, 
            G2
        )
    );
}

shared_ptr<BasicGraph> GraphBuilder::getLoopHeadGraph(shared_ptr<Symbol> initCount, llvm::Loop* loop) {
    auto bodyCount = getLoopCount(loop);

    if (!loop) {
        llvm::errs() << "Error: getLoopHead: Loop is null\n";
        return nullptr;
    }

    auto BG = make_shared<BasicGraph>(
        getBlockID(loop->getHeader()), 
        getName(loop->getHeader())
    );

    if (loop->isLoopExiting(loop->getHeader())){
        // header exiting, header count = backedge count + 1, body count = backedge count
        BG->count = bodyCount->addOne()->multiply(initCount);
    }
    else{
        // tail exiting, both header and body count = backedge count + 1
        BG->count = bodyCount->multiply(initCount);
    }

    auto BB = createBasicBlock(BG, loop->getHeader());
    return BB;
}

// get the start and end blocks of the loop body 
tuple<llvm::BasicBlock*, llvm::BasicBlock*> getLoopBody(llvm::Loop* loop){
    if (!loop) {
        llvm::errs() << "Error: getLoopBody: Loop is null\n";
        return {nullptr, nullptr};
    }

    auto header = loop->getHeader();
    if (!header) {
        llvm::errs() << "Error: getLoopBody: Loop header is null\n";
        return {nullptr, nullptr};
    }

    auto exitingBlocks = llvm::SmallVector<llvm::BasicBlock*, 8>();
    loop->getExitingBlocks(exitingBlocks);
    
    if (exitingBlocks.size() != 1) {
        llvm::errs() << "Error: getLoopBody: Loop has multiple exit blocks\n";
        return {nullptr, nullptr};
    }

    auto exitingBlock = exitingBlocks[0];
    // First, try to find a successor that is inside the loop and not the exiting block
    for (auto *succ : llvm::successors(header)) {
        if (loop->contains(succ) && succ != exitingBlock) {
            return {succ, exitingBlock};
        }
    }
    // Fallback: if not found, return any successor that is inside the loop (could be the exiting block itself)
    for (auto *succ : llvm::successors(header)) {
        if (loop->contains(succ)) {
            return {succ, exitingBlock};
        }
    }
    llvm::errs() << "Error: getLoopBody: No successor of exit block is inside the loop\n";
    return {nullptr, nullptr};
    
}

shared_ptr<Loop> GraphBuilder::createLoop(std::shared_ptr<BasicGraph> BG, 
        llvm::BasicBlock* startBB, llvm::BasicBlock* endBB){

    if (!startBB || startBB == endBB) return nullptr;

    auto loop = LI.getLoopFor(startBB);
    auto incoming_count = BG->count;
    auto loopCount = getLoopCount(loop);
    auto [bodyStart, bodyEnd] = getLoopBody(loop);

    auto head = getLoopHeadGraph(incoming_count, loop);
    auto Gb = createGraph(loopCount->multiply(incoming_count), 
        bodyStart, bodyEnd);
    
    return make_shared<Loop>(
        Loop(
            BG, 
            loopCount, 
            head,
            Gb
        )
    );
}

// expand the symbolic count to an expression that only uses program inputs
string getExpandedSCEV(const llvm::SCEV* scev){
    if (!scev) {
        llvm::errs() << "Error: getExpandedSCEV: SCEV is null\n";
        return "unknown";
    }

    std::string scevStr;
    llvm::raw_string_ostream rso(scevStr);
    Debug::printRootExpr(*scev, rso);
    rso.flush();

    // Expand the SCEV to a string representation
    return scevStr;
}

shared_ptr<Symbol> GraphBuilder::getLoopCount(llvm::Loop* loop){
    if (!loop) {
        llvm::errs() << "Error: getLoopCount: Loop is null\n";
        return nullptr;
    }

    // Use ScalarEvolution to get the backedge taken count
    llvm::ScalarEvolution *SE = &this->SE;
    if (!SE) {
        llvm::errs() << "Error: getLoopCount: ScalarEvolution is null\n";
        return nullptr;
    }

    const llvm::SCEV *backedgeCount = SE->getBackedgeTakenCount(loop);
    if (llvm::isa<llvm::SCEVCouldNotCompute>(backedgeCount)) {
        llvm::errs() << "Warning: getLoopCount: Could not compute backedge count for loop " << getName(loop) << "\n";
        // Fallback to symbolic name
        auto loopCount_literal = "LC_" + getName(loop);
        return make_shared<Symbol>(loopCount_literal);
    }

    // SCEV gives backedge count, but we want trip count = backedge count + 1
    auto loopCount_literal = getExpandedSCEV(backedgeCount);
    return make_shared<Symbol>(loopCount_literal);
}

void GraphViewer::showProgram(shared_ptr<Program> program, std::ostream& os, int indent) {
    std::string pad(indent, ' ');
    if (!program) {
        os << pad << "Program is null\n";
        return;
    }

    os << pad << "Program:\n";
    os << pad << "Inputs: ";
    for (const auto& input : program->inputs) {
        os << input->literal << " ";
    }
    os << "\n";
    showGraph(program->G, os, indent + 2);
}

void GraphViewer::showGraph(shared_ptr<Graph> G, std::ostream& os, int indent) {
    std::string pad(indent, ' ');
    if (!G) {
        os << pad << "Graph is null\n";
        return;
    }
    
    showBasicGraph(G->BG, os, indent);
    showGraph(G->G, os, indent);    // subsequent graph
}

void GraphViewer::showBasicGraph(shared_ptr<BasicGraph> BG, std::ostream& os, int indent){
    std::string pad(indent, ' ');
    if (!BG) {
        os << pad << "BasicGraph is null\n";
        return;
    }

    switch (BG->getGraphType()) {
        case GraphType::BasicBlock:
            showBasicBlock(static_pointer_cast<BasicBlock>(BG), os, indent);
            break;
        
        case GraphType::Branch:
            showBranch(static_pointer_cast<Branch>(BG), os, indent);
            break;
        
        case GraphType::Loop:
            showLoop(static_pointer_cast<Loop>(BG), os, indent);
            break;
        
        default:
            os << pad << "Unknown graph type for BasicGraph: " << BG->id << "\n";
            return;
    }
}

void GraphViewer::showBasicBlock(shared_ptr<BasicBlock> BB, std::ostream& os, int indent) {
    std::string pad(indent, ' ');
    if (!BB) {
        os << pad << "BasicBlock is null\n";
        return;
    }

    os << pad << "BasicBlock: " << BB->name << "\n";
    os << pad << "Count: " << (BB ? BB->count->literal : "N/A") << "\n";
}

void GraphViewer::showBranch(shared_ptr<Branch> BR, std::ostream& os, int indent) {
    std::string pad(indent, ' ');
    if (!BR) {
        os << pad << "Branch is null\n";
        return;
    }

    os << pad << "Branch: " << BR->name << "\n";
    os << pad << "True Ratio: " << BR->trueRatio->literal << "\n";
    os << pad << "False Ratio: " << BR->falseRatio->literal << "\n";
    os << pad << "True Side Graph:\n";
    showGraph(BR->G1, os, indent + 2);
    os << pad << "False Side Graph:\n";
    showGraph(BR->G2, os, indent + 2);
}

void GraphViewer::showLoop(shared_ptr<Loop> L, std::ostream& os, int indent) {
    std::string pad(indent, ' ');
    if (!L) {
        os << pad << "Loop is null\n";
        return;
    }

    os << pad << "Loop: " << L->name << "\n";
    os << pad << "Loop Count: " << L->loopCount->literal << "\n";
    os << pad << "Head Graph:\n";
    showBasicGraph(L->head, os, indent + 2);
    os << pad << "Body Graph:\n";
    showGraph(L->Gb, os, indent + 2);
}

std::string GraphBuilder::getName(llvm::BasicBlock* BB) {
    if(!BB) {
        return "null";
    }
    std::string name;
    llvm::raw_string_ostream rso(name);
    BB->printAsOperand(rso, false);
    return rso.str();
}

std::string GraphBuilder::getName(llvm::Argument* arg) {
    if (!arg) {
        return "null";
    }
    std::string name;
    llvm::raw_string_ostream rso(name);
    arg->printAsOperand(rso, false);
    return rso.str();
}

std::string GraphBuilder::getName(llvm::Loop* loop) {
    if(!loop) {
        return "null";
    }
    std::string name;
    llvm::raw_string_ostream rso(name);
    loop->getHeader()->printAsOperand(rso, false);
    return rso.str();
}