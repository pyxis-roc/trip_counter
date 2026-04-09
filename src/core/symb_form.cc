#include "symb_form.hpp"
#include "nlohmann/json_fwd.hpp"
#include "symb_expr.hpp"
#include "utils.hpp"
#include "llvm/Analysis/LoopInfo.h"
#include "llvm/Analysis/ScalarEvolution.h"
#include "llvm/IR/Instruction.h"
#include "llvm/IR/Instructions.h"
#include "llvm/IR/Intrinsics.h"
#include "llvm/IR/Value.h"
#include "llvm/Support/Casting.h"
#include "llvm/Support/raw_ostream.h"
#include <cctype>
#include <cstdlib>
#include <llvm/IR/BasicBlock.h>
#include "llvm/Analysis/ScalarEvolutionExpressions.h"
#include <llvm/IR/InstrTypes.h>
#include <llvm/Support/Error.h>
#include <memory>
#include <optional>
#include <string>
#include <tuple>
#include <utility>
#include <vector>

void GraphBuilder::record(shared_ptr<BasicGraph> graph, const llvm::BasicBlock* bb){
    timeComponent(timingStats.recordMs, [&]() {
        if (graph2bb.find(graph) == graph2bb.end()){
            graph2bb[graph] = bb;
        }
        if (bb2graph.find(bb) == bb2graph.end()){
            bb2graph[bb] = vector<shared_ptr<BasicGraph>>{graph};
        }
        else{
            bb2graph[bb].push_back(graph);
        }
    });
}

std::shared_ptr<BasicGraph> GraphBuilder::bbTwin(const llvm::BasicBlock* bb, GraphType type) {
    return timeComponent(timingStats.bbTwinMs, [&]() -> std::shared_ptr<BasicGraph> {
        if (bb2graph.find(bb) != bb2graph.end()) {
            for (const auto& graph : bb2graph[bb]) {
                if (graph->getGraphType() == type) {
                    return graph;
                }
            }
        }
        return nullptr;
    });
}

void GraphBuilder::addFlow(shared_ptr<BasicGraph> BG, shared_ptr<BasicGraph> toAdd) {
    timeComponent(timingStats.addFlowMs, [&]() {
        if (!BG || !toAdd) return;
        earlyExits.insert(BG);
        substitute(BG, {BG->count}, {toAdd->count + BG->count});
    });
}

shared_ptr<Program> GraphBuilder::createProgram(llvm::Function * F){
    auto t_program_start = std::chrono::high_resolution_clock::now();

    auto args = F->arg_begin();
    auto argList = std::vector<SymbolicExpr>();
    argList.reserve(F->arg_size());
    for (; args != F->arg_end(); ++args) {
        argList.emplace_back(SEM.bvValue(*args));
    }

    auto t_graph_start = std::chrono::high_resolution_clock::now();
    auto graph = createGraph(SEM.one(), &F->getEntryBlock());
    auto t_graph_end = std::chrono::high_resolution_clock::now();
    if (timingEnabled) {
        timingStats.createGraphMs +=
            std::chrono::duration<double, std::milli>(t_graph_end - t_graph_start).count();
    }

    auto P = std::make_shared<Program>(Program(argList, graph));
    Analysis a(LI, SE, SEM, P, graph2bb, &timingStats, timingEnabled);

    auto t_program_end = std::chrono::high_resolution_clock::now();
    if (timingEnabled) {
        timingStats.createProgramMs +=
            std::chrono::duration<double, std::milli>(t_program_end - t_program_start).count();
    }

    // debug tracking
    numComposite = a.compositePHIs.size();
    return P;
}

shared_ptr<Graph> GraphBuilder::createGraph(SymbolicExpr initCount, 
        llvm::BasicBlock* startBB, llvm::BasicBlock* endBB){

    return timeComponent(timingStats.createGraphFrameMs, [&]() -> shared_ptr<Graph> {
        if (!startBB || startBB == endBB) return nullptr;

        auto blockID = getName(startBB);
        auto graph = make_shared<Graph>(blockID);
        auto nextType = getGraphType(startBB, endBB);
        auto nextHead = nextGraphHead(nextType, startBB);

        auto BG = createBasicGraph(initCount, startBB, nextHead);
        graph->BG = BG;

        auto nextGraph = createGraph(initCount, nextHead, endBB);
        graph->G = nextGraph;

        return graph;
    });
}

llvm::BasicBlock* GraphBuilder::nextGraphHead(GraphType type, llvm::BasicBlock* startBB){
    return timeComponent(timingStats.nextGraphHeadMs, [&]() -> llvm::BasicBlock* {
        switch (type) {
        
        case GraphType::BasicBlock:{
            if(startBB->getTerminator()->getNumSuccessors() == 0){
                return nullptr;
            }
            if (startBB->getTerminator()->getNumSuccessors() == 1) {
                return startBB->getSingleSuccessor();
            }
            if (startBB->getTerminator()->getNumSuccessors() == 2 && LI.getLoopFor(startBB)){ 
                //special case for loop internal blocks
                //case 1: loop exit
                if (LI.getLoopFor(startBB)->isLoopExiting(startBB)){

                    // if it is a loop exit, return the successor that is outside the loop
                    auto loop = LI.getLoopFor(startBB);
                    auto succ0 = startBB->getTerminator()->getSuccessor(0);
                    auto succ1 = startBB->getTerminator()->getSuccessor(1);
                    auto internalSucc = (loop->contains(succ0)) ? succ0 : succ1;
                    auto externalSucc = (loop->contains(succ0)) ? succ1 : succ0;

                    if (LI.isLoopHeader(startBB) && internalSucc != startBB) {
                        // header exiting, return the successor that is inside the loop
                        return internalSucc;
                    }
                    else{
                        // end of loop, there is no following internal graph 
                        return nullptr;
                    }
                }
                //case 2: loop latch
                else{
                    llvm::errs() << "Error: GraphBuilder::nextGraphHead: unsupported case for loop multi-succ, non-exit block" 
                         << getName(startBB) << " has two successors, which is not supported\n";
                }
            }
            // If none of the above, return nullptr (no next head)
            llvm::errs() << "Error: GraphBuilder::nextGraphHead: Unsupported number of successors for basic block " 
                 << getName(startBB) << ": " << startBB->getTerminator()->getNumSuccessors() << "\n";
            return nullptr;
        }


        case GraphType::Branch:{
            
            auto trueSide = startBB->getTerminator()->getSuccessor(0);
            auto falseSide = startBB->getTerminator()->getSuccessor(1);
            
            // Check if either side is unreachable
            bool trueSideUnreachable = !trueSide->empty() && 
                                        llvm::isa<llvm::UnreachableInst>(trueSide->getTerminator());
            bool falseSideUnreachable = !falseSide->empty() && 
                                         llvm::isa<llvm::UnreachableInst>(falseSide->getTerminator());
            
            if (trueSideUnreachable && falseSideUnreachable) {
                llvm::errs() << "Warning: GraphBuilder::nextGraphHead: Both sides are unreachable\n";
                return nullptr;
            }
            
            if (trueSideUnreachable) {
                llvm::errs() << "Info: GraphBuilder::nextGraphHead: True side is unreachable, taking false side\n";
                return falseSide;
            }
            
            if (falseSideUnreachable) {
                llvm::errs() << "Info: GraphBuilder::nextGraphHead: False side is unreachable, taking true side\n";
                return trueSide;
            }
            
            auto postDomTrue = PDT.getNode(trueSide);
            auto postDomFalse = PDT.getNode(falseSide);
            
            if (!postDomTrue || !postDomFalse) {
                llvm::errs() << "Error: GraphBuilder::nextGraphHead: Post dominator not found for one of the sides\n";
                return nullptr;
            }
            
            auto commonPostDom = PDT.findNearestCommonDominator(trueSide, falseSide);
            if (!commonPostDom) {
                llvm::errs() << "Error: GraphBuilder::nextGraphHead: No common post dominator found.\n";
                // If no common post dominator is found, it likely means one side is unreachable. We can choose the other side as the next head.
                

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
            llvm::errs() << "Error: GraphBuilder::nextGraphHead: Unknown graph type for block " \
            << (startBB ? getName(startBB) : "null") << "\n";
            return nullptr;
        }
        }
    });
}

shared_ptr<BasicGraph> GraphBuilder::createBasicGraph(SymbolicExpr count, 
        llvm::BasicBlock* startBB, llvm::BasicBlock* endBB){
    return timeComponent(timingStats.createBasicGraphMs, [&]() -> shared_ptr<BasicGraph> {
        if (!startBB || startBB == endBB) return nullptr;

        auto blockID = getName(startBB);
        auto name = getName(startBB);
        auto BG = std::make_shared<BasicGraph>(blockID, name, count);

        auto type = getGraphType(startBB, endBB);
        auto nextHead = nextGraphHead(type, startBB);

        shared_ptr<BasicGraph> graph = nullptr;
        switch (type) {
            case GraphType::BasicBlock:
                graph = createBasicBlock(BG, startBB, nextHead);
                break;
            case GraphType::Branch:
                graph = createBranch(BG, startBB, nextHead);
                break;
            case GraphType::Loop:
                graph = createLoop(BG, startBB, nextHead);
                break;
            default:
                llvm::errs() << "Error: GraphBuilder::createBasicGraph: Unknown graph type for block " << name << "\n";
                return nullptr;
        }
        return graph;
    });
}

GraphType GraphBuilder::getGraphType(llvm::BasicBlock* startBB, llvm::BasicBlock* endBB){
    return timeComponent(timingStats.getGraphTypeMs, [&]() -> GraphType {
        // check if it is a loop graph 
        if(LI.isLoopHeader(startBB)){
            auto loop = LI.getLoopFor(startBB);
            
            // case 1: when current loop is a subgraph of a larger graph
            if(!loop->contains(endBB)){
                return GraphType::Loop;
            }
            // case 2: inside a loop, we are looking for the inside subgraph
            // either it is a basic block or a branch
            if (startBB->getTerminator()->getNumSuccessors() < 2) {
                // no successors, it is a basic block
                return GraphType::BasicBlock;
            }

            if (startBB->getTerminator()->getNumSuccessors() == 2) {
                auto succ0 = startBB->getTerminator()->getSuccessor(0);
                auto succ1 = startBB->getTerminator()->getSuccessor(1);
                bool succ0InLoop = loop->contains(succ0);
                bool succ1InLoop = loop->contains(succ1);

                // If either successor is outside the loop, it's a loop exit (basic block)
                if (!succ0InLoop || !succ1InLoop) {
                    return GraphType::BasicBlock;
                }
                // Both successors are inside the loop, it's a branch
                return GraphType::Branch;
            }
            
            llvm::errs() << "Error: GraphBuilder::getGraphType: Unsupported number of successors for loop header block " 
                    << getName(startBB) << ": " << startBB->getTerminator()->getNumSuccessors() << "\n";
            return GraphType::Unknown;
            
        }

        // cannot be a loop graph, check for basic block or branch graph
        if (startBB->getTerminator()->getNumSuccessors() < 2) {
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
    });
}

shared_ptr<BasicBlock> GraphBuilder:: createBasicBlock(std::shared_ptr<BasicGraph> BG, 
        llvm::BasicBlock* startBB, llvm::BasicBlock* endBB){
    return timeComponent(timingStats.createBasicBlockMs, [&]() -> shared_ptr<BasicBlock> {
        if (!startBB || startBB == endBB) return nullptr;
        if (auto twin = bbTwin(startBB, GraphType::BasicBlock)) {
            // If a twin already exists, add current flow to it
            addFlow(twin, BG);
            return std::static_pointer_cast<BasicBlock>(twin);
        }

        auto graph = make_shared<BasicBlock>(BasicBlock(BG));
        record(graph, startBB);
        return graph;
    });
}

shared_ptr<Branch> GraphBuilder::createBranch(std::shared_ptr<BasicGraph> BG, 
        llvm::BasicBlock* startBB, llvm::BasicBlock* endBB){
    return timeComponent(timingStats.createBranchMs, [&]() -> shared_ptr<Branch> {
        if (!startBB || startBB == endBB) return nullptr;
        if (auto twin = bbTwin(startBB, GraphType::Branch)) {
            // If a twin already exists, add current flow to it
            addFlow(twin, BG);
            return std::static_pointer_cast<Branch>(twin);
        }

        // TrueRatio is represented as a fraction (trueRatioNum / trueRatioDen)
        // to avoid bitvector integer division truncation.
        auto trNum_literal = "TR_num_" + getName(startBB);
        auto trDen_literal = "TR_den_" + getName(startBB);
        const auto& trueRatioNumRef = SEM.symbTrueRatioRef(trNum_literal);
        const auto& trueRatioDenRef = SEM.symbTrueRatioRef(trDen_literal);
        SymbolicExpr trueRatioNum = trueRatioNumRef;
        SymbolicExpr trueRatioDen = trueRatioDenRef;
        auto falseRatioNum = trueRatioDen - trueRatioNum;
        auto falseRatioDen = trueRatioDen;

        const auto& incoming_count = BG->count;
        auto trueSide = startBB->getTerminator()->getSuccessor(0);
        auto falseSide = startBB->getTerminator()->getSuccessor(1);
        auto trueCount = (trueRatioNum * incoming_count) / trueRatioDen;
        auto falseCount = (falseRatioNum * incoming_count) / falseRatioDen;
        auto G1 = createGraph(std::move(trueCount), trueSide, endBB);
        auto G2 = createGraph(std::move(falseCount), falseSide, endBB);

        auto graph = make_shared<Branch>(
            Branch(
                BG,
                trueRatioNum, trueRatioDen,
                falseRatioNum, falseRatioDen,
                G1,
                G2
            )
        );
        record(graph, startBB);
        return graph;
    });
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

GraphType GraphBuilder::getLoopHeadType(llvm::BasicBlock* startBB, llvm::BasicBlock* endBB){
    // distinguish from basic block and branch

    if (startBB->getTerminator()->getNumSuccessors() < 2) {
        return GraphType::BasicBlock;
    }

    if (startBB->getTerminator()->getNumSuccessors() == 2) {
        // can be due to if statement (target) or a loop (latch or exit)
        
        if (auto loop = LI.getLoopFor(startBB)) {
            if (loop->isLoopLatch(startBB) || loop->isLoopExiting(startBB)){
                return GraphType::BasicBlock;
            }
        }
        // not inside a loop, then it is a branch graph
        return GraphType::Branch;
    }
    
    llvm::errs() << "Error: GraphBuilder::getGraphType: Unsupported number of successors for block " 
                 << getName(startBB) << ": " << startBB->getTerminator()->getNumSuccessors() << "\n";
    return GraphType::Unknown;
}

shared_ptr<BasicGraph> GraphBuilder::getLoopHeadGraph(SymbolicExpr initCount, 
    SymbolicExpr bodyCount, llvm::BasicBlock* startBB, llvm::BasicBlock* endBB){
    return timeComponent(timingStats.getLoopHeadGraphMs, [&]() -> shared_ptr<BasicGraph> {
        auto loop = LI.getLoopFor(startBB);
        if (!loop){
            llvm::errs() << "Error: GraphBuilder::getLoopHeadGraph: it is not a loop\n";
            return nullptr;
        }

        shared_ptr<BasicGraph> BG = nullptr;
        if(isHeaderExiting(loop)){
            // header exiting, header is executed one more time than body
            BG = make_shared<BasicGraph>(
                getName(startBB),
                getName(startBB),
                (bodyCount + SEM.one()) * initCount
            );
        }
        else{
            // tail exiting, both header and body execute the same time
            BG = make_shared<BasicGraph>(
                getName(startBB),
                getName(startBB),
                bodyCount * initCount
            );
        }

        auto headType = getLoopHeadType(startBB, endBB);
        auto nextHead = nextGraphHead(headType, startBB);

        switch (headType) {
            
            case GraphType::BasicBlock: {
                return createBasicBlock(BG, startBB, nextHead);
            }

            case GraphType::Branch: {
                return createBranch(BG, startBB, nextHead);
            }

            default:{
                llvm::errs() << "Error: GraphBuilder::getLoopHeadGraph: Unknown graph type for loop header block " 
                            << getName(startBB) << "\n";
                return nullptr;
            }
        }
    });
}

shared_ptr<Loop> GraphBuilder::createLoop(std::shared_ptr<BasicGraph> BG, 
        llvm::BasicBlock* startBB, llvm::BasicBlock* endBB){
    return timeComponent(timingStats.createLoopMs, [&]() -> shared_ptr<Loop> {
        if (!startBB || startBB == endBB) return nullptr;
        if (auto twin = bbTwin(startBB, GraphType::Loop)) {
            addFlow(twin, BG);
            return std::static_pointer_cast<Loop>(twin);
        }

        auto loop = LI.getLoopFor(startBB);
        if (!loop) {
            llvm::errs() << "Error: createLoop: Loop is null for block " << getName(startBB) << "\n";
            return nullptr;
        }

        auto exitBlock = loop->getExitBlock();
        if (!exitBlock) {
            llvm::errs() << "Error: createLoop: Loop has multiple or zero exit blocks\n";
            return nullptr;
        }

        const auto& incoming_count = BG->count;
        const auto& bodyCountRef = SEM.symbLoopCountRef("LC_" + getName(loop));
        SymbolicExpr bodyCount = bodyCountRef;

        auto headGraph = getLoopHeadGraph(incoming_count, bodyCount, startBB, exitBlock);
        auto headType = headGraph->getGraphType();

        auto bodyStart = nextGraphHead(headType, startBB);
        auto bodyEnd = isHeaderExiting(loop) ? startBB : exitBlock;
        auto loopBodyIncoming = bodyCount * incoming_count;
        auto Gb = createGraph(std::move(loopBodyIncoming), bodyStart, bodyEnd);
        
        auto graph = make_shared<Loop>(
            Loop(
                BG, 
                bodyCount, 
                headGraph,
                Gb
            )
        );
        record(graph, startBB);
        return graph;
    });
}

bool GraphBuilder::isHeaderExiting(llvm::Loop* loop){
    auto header = loop->getHeader();
    // The header is exiting and the loop has more than one block
    return loop->isLoopExiting(header) && (loop->getBlocks().size() > 1);
}
bool GraphBuilder::isTailExiting(llvm::Loop* loop){
    return !isHeaderExiting(loop);
}

void GraphBuilder::substitute(shared_ptr<Program> P, const vector<SymbolicExpr>& originals, const vector<int>& withs){
    substitute(P->G, originals, withs);
}

void GraphBuilder::substitute(shared_ptr<Graph> G, const vector<SymbolicExpr>& originals, const vector<int>& withs){
    if (!G) return;

    substitute(G->BG, originals, withs);
    substitute(G->G, originals, withs);
}

void GraphBuilder::substitute(shared_ptr<BasicGraph> BG, const vector<SymbolicExpr>& originals, const vector<int>& withs){
    if (!BG) return;

    BG->count.substitute(originals, withs);
    BG->count.simplify();

    switch (BG->getGraphType()) {
        case GraphType::BasicBlock:
            // No further traversal needed for BasicBlock
            break;
        case GraphType::Branch: {
            auto branch = std::static_pointer_cast<Branch>(BG);
            branch->trueRatioNum.substitute(originals, withs);
            branch->trueRatioDen.substitute(originals, withs);
            branch->falseRatioNum.substitute(originals, withs);
            branch->falseRatioDen.substitute(originals, withs);
            branch->trueRatioNum.simplify();
            branch->trueRatioDen.simplify();
            branch->falseRatioNum.simplify();
            branch->falseRatioDen.simplify();
            substitute(branch->G1, originals, withs);
            substitute(branch->G2, originals, withs);
            break;
        }
        case GraphType::Loop: {
            auto loop = std::static_pointer_cast<Loop>(BG);
            loop->loopCount.substitute(originals, withs);
            loop->loopCount.simplify();
            substitute(loop->head, originals, withs);
            substitute(loop->Gb, originals, withs);
            break;
        }
        case GraphType::Unknown:
            // Do nothing for unknown graph type
            break;
    }
}

void GraphBuilder::substitute(shared_ptr<Program> P, const vector<SymbolicExpr>& originals, const vector<SymbolicExpr>& withs){
    substitute(P->G, originals, withs);
}

void GraphBuilder::substitute(shared_ptr<Graph> G, const vector<SymbolicExpr>& originals, const vector<SymbolicExpr>& withs){
    if (!G) return;

    substitute(G->BG, originals, withs);
    substitute(G->G, originals, withs);
}

void GraphBuilder::substitute(shared_ptr<BasicGraph> BG, const vector<SymbolicExpr>& originals, const vector<SymbolicExpr>& withs){
    if (!BG) return;

    BG->count.substitute(originals, withs);
    BG->count.simplify();

    switch (BG->getGraphType()) {
        case GraphType::BasicBlock:
            // No further traversal needed for BasicBlock
            break;
        case GraphType::Branch: {
            auto branch = std::static_pointer_cast<Branch>(BG);
            branch->trueRatioNum.substitute(originals, withs);
            branch->trueRatioDen.substitute(originals, withs);
            branch->falseRatioNum.substitute(originals, withs);
            branch->falseRatioDen.substitute(originals, withs);
            branch->trueRatioNum.simplify();
            branch->trueRatioDen.simplify();
            branch->falseRatioNum.simplify();
            branch->falseRatioDen.simplify();
            substitute(branch->G1, originals, withs);
            substitute(branch->G2, originals, withs);
            break;
        }
        case GraphType::Loop: {
            auto loop = std::static_pointer_cast<Loop>(BG);
            loop->loopCount.substitute(originals, withs);
            loop->loopCount.simplify();
            substitute(loop->head, originals, withs);
            substitute(loop->Gb, originals, withs);
            break;
        }
        case GraphType::Unknown:
            // Do nothing for unknown graph type
            break;
    }
}

std::string GraphBuilder::getName(const llvm::BasicBlock* BB) {
    if(!BB) {
        return "null";
    }
    std::string name;
    llvm::raw_string_ostream rso(name);
    BB->printAsOperand(rso, false);
    return rso.str();
}

std::string GraphBuilder::getName(const llvm::Argument* arg) {
    if (!arg) {
        return "null";
    }
    std::string name;
    llvm::raw_string_ostream rso(name);
    arg->printAsOperand(rso, false);
    return rso.str();
}

std::string GraphBuilder::getName(const llvm::Loop* loop) {
    if(!loop) {
        return "null";
    }
    std::string name;
    llvm::raw_string_ostream rso(name);
    loop->getHeader()->printAsOperand(rso, false);
    return rso.str();
}
