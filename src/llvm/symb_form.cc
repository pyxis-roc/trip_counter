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
#include <cstdlib>
#include <llvm/IR/BasicBlock.h>
#include "llvm/Analysis/ScalarEvolutionExpressions.h"
#include <llvm/IR/InstrTypes.h>
#include <memory>
#include <optional>
#include <string>
#include <tuple>
#include <utility>
#include <vector>

shared_ptr<Symbol> Symbol::multiply(const shared_ptr<Symbol>& other) const {
    return make_shared<Symbol>("scMul(" + literal + ", " + other->literal + ")");
}
shared_ptr<Symbol> Symbol::subtract(const shared_ptr<Symbol>& other) const {
    return make_shared<Symbol>("scSub(" + literal + ", " + other->literal + ")");
}
shared_ptr<Symbol> Symbol::add(const shared_ptr<Symbol>& other) const {
    return make_shared<Symbol>("scAdd(" + literal + ", " + other->literal + ")");
}
shared_ptr<Symbol> Symbol::addOne() const {
    return make_shared<Symbol>("scAdd(" + literal + ", 1)");
}

shared_ptr<Symbol> Symbol::one() {
    return make_shared<Symbol>("1");
}

bool Symbol::substitute(string original, string with){
    size_t pos = 0;
    bool changed = false;
    while ((pos = literal.find(original, pos)) != std::string::npos) {
        // Check if match is a standalone variable (not part of a longer identifier)
        bool atStart = (pos == 0);
        bool atEnd = (pos + original.length() == literal.length());
        bool beforeOK = atStart || !std::isalnum(literal[pos - 1]) && literal[pos - 1] != '.';
        bool afterOK = atEnd || !std::isalnum(literal[pos + original.length()]) && literal[pos + original.length()] != '.';
        if (beforeOK && afterOK) {
            literal.replace(pos, original.length(), with);
            pos += with.length();
            changed = true;
        } else {
            pos += original.length();
        }
    }
    return changed;
}

void Symbol::show(std::ostream& os) const {
    os << literal << std::endl;
}

void GraphBuilder::record(shared_ptr<BasicGraph> graph, const llvm::BasicBlock* bb){
    if (graph2bb.find(graph) == graph2bb.end()){
        graph2bb[graph] = bb;
    }
    if (bb2graph.find(bb) == bb2graph.end()){
        bb2graph[bb] = vector<shared_ptr<BasicGraph>>{graph};
    }
    else{
        bb2graph[bb].push_back(graph);
    }
}

std::shared_ptr<BasicGraph> GraphBuilder::bbTwin(const llvm::BasicBlock* bb, GraphType type) {
    if (bb2graph.find(bb) != bb2graph.end()) {
        for (const auto& graph : bb2graph[bb]) {
            if (graph->getGraphType() == type) {
                return graph;
            }
        }
    }
    return nullptr;
}

void GraphBuilder::addFlow(shared_ptr<BasicGraph> BG, shared_ptr<BasicGraph> toAdd) {
    if (!BG || !toAdd) return;
    earlyExits.insert(BG);
    substitute(BG, {BG->count}, {toAdd->count + BG->count});
}

shared_ptr<Program> GraphBuilder::createProgram(llvm::Function * F){

    auto args = F->arg_begin();
    auto argList = std::vector<SymbolicExpr>();
    for (; args != F->arg_end(); ++args) {
        auto symbol = SEM.bvValue(*args);
        argList.push_back(symbol);
    }

    auto graph = createGraph(SEM.one(), &F->getEntryBlock());
    auto P = std::make_shared<Program>(Program(argList, graph));
    Analysis a(LI, SE, SEM, P, graph2bb);

    // debug tracking
    numComposite = a.compositePHIs.size();
    return P;
}

shared_ptr<Graph> GraphBuilder::createGraph(SymbolicExpr initCount, 
        llvm::BasicBlock* startBB, llvm::BasicBlock* endBB){

    if (!startBB || startBB == endBB) return nullptr;

    auto blockID = getBlockID(startBB);
    auto graph = make_shared<Graph>(blockID);
    auto nextType = getGraphType(startBB, endBB);
    auto nextHead = nextGraphHead(nextType, startBB);

    auto BG = createBasicGraph(initCount, startBB, nextHead);
    graph->BG = BG;
    auto nextGraph = createGraph(initCount, nextHead, endBB);
    graph->G = nextGraph;

    return graph;
}

llvm::BasicBlock* GraphBuilder::nextGraphHead(GraphType type, llvm::BasicBlock* startBB){

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
}

shared_ptr<BasicGraph> GraphBuilder::createBasicGraph(SymbolicExpr count, 
        llvm::BasicBlock* startBB, llvm::BasicBlock* endBB){
    
    if (!startBB || startBB == endBB) return nullptr;

    auto blockID = getBlockID(startBB);
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
}

GraphType GraphBuilder::getGraphType(llvm::BasicBlock* startBB, llvm::BasicBlock* endBB){

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
}

shared_ptr<BasicBlock> GraphBuilder:: createBasicBlock(std::shared_ptr<BasicGraph> BG, 
        llvm::BasicBlock* startBB, llvm::BasicBlock* endBB){
  
    if (!startBB || startBB == endBB) return nullptr;
    if (auto twin = bbTwin(startBB, GraphType::BasicBlock)) {
        // If a twin already exists, add current flow to it
        addFlow(twin, BG);
        return std::static_pointer_cast<BasicBlock>(twin);
    }

    auto graph = make_shared<BasicBlock>(BasicBlock(BG));
    record(graph, startBB);
    return graph;
}

shared_ptr<Branch> GraphBuilder::createBranch(std::shared_ptr<BasicGraph> BG, 
        llvm::BasicBlock* startBB, llvm::BasicBlock* endBB){

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
    auto trueRatioNum = SEM.symbTrueRatio(trNum_literal);
    auto trueRatioDen = SEM.symbTrueRatio(trDen_literal);
    auto falseRatioNum = trueRatioDen - trueRatioNum;
    auto falseRatioDen = trueRatioDen;

    auto incoming_count = BG->count;
    auto trueSide = startBB->getTerminator()->getSuccessor(0);
    auto falseSide = startBB->getTerminator()->getSuccessor(1);
    auto G1 = createGraph((trueRatioNum * incoming_count) / trueRatioDen, trueSide, endBB);
    auto G2 = createGraph((falseRatioNum * incoming_count) / falseRatioDen, falseSide, endBB);

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

    auto loop = LI.getLoopFor(startBB);
    if (!loop){
        llvm::errs() << "Error: GraphBuilder::getLoopHeadGraph: it is not a loop\n";
        return nullptr;
    }

    shared_ptr<BasicGraph> BG = nullptr;
    if(isHeaderExiting(loop)){
        // header exiting, header is executed one more time than body
        BG = make_shared<BasicGraph>(
            getBlockID(startBB),
            getName(startBB),
            (bodyCount + SEM.one()) * initCount
        );
    }
    else{
        // tail exiting, both header and body execute the same time
        BG = make_shared<BasicGraph>(
            getBlockID(startBB),
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
}

shared_ptr<Loop> GraphBuilder::createLoop(std::shared_ptr<BasicGraph> BG, 
        llvm::BasicBlock* startBB, llvm::BasicBlock* endBB){

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

    auto incoming_count = BG->count;
    auto bodyCount = SEM.symbLoopCount("LC_" + getName(loop));

    auto headGraph = getLoopHeadGraph(incoming_count, bodyCount, startBB, exitBlock);
    auto headType = headGraph->getGraphType();

    auto bodyStart = nextGraphHead(headType, startBB);
    auto bodyEnd = isHeaderExiting(loop) ? startBB : exitBlock;
    auto Gb = createGraph(bodyCount * incoming_count, 
    bodyStart, bodyEnd);
    
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

using GA = GraphBuilder::Analysis;

void GA::prepareBaseFactor(shared_ptr<Program>P){
    traverse(P->G);
}

optional<SymbolicExpr> GA::getFactor(const llvm::BasicBlock* from, const llvm::BasicBlock* to){
    if (!from || !to) {
        llvm::errs() << "Error: getFactor: from or to is null\n";
        return std::nullopt;
    }
    // llvm::errs() << "DEBUG: From BasicBlock: " << GraphBuilder::getName(from) << "\n";
    // llvm::errs() << "DEBUG: To BasicBlock: " << GraphBuilder::getName(to) << "\n";
    auto p = make_pair(from, to);
    return baseFactor.at(p);
}

void GA::addFactor(const llvm::BasicBlock* from, const llvm::BasicBlock* to, SymbolicExpr factor){
    auto p = make_pair(from, to);
    baseFactor.emplace(p, factor);
}

// returns all the basic graphs at the end of current graph,
// which are used to connect the previous end with the next start
vector<shared_ptr<BasicGraph>> GA::traverse(shared_ptr<Graph> G){
    if (!G) return{};

    auto last1 = traverse(G->BG);
    auto last2 = traverse(G->G);

    if(G->G){   // connect to next start
        for(auto prev : last1){
            addFactor(graph2bb[prev], graph2bb[G->G->BG], G->BG->count);
        }
        return last2; // return the last graphs of the next graph
    }
    else{
        // if G->G is null, it means we are at the end of the graph
        // return the last graphs of the current graph
        return last1;
    }
}

vector<shared_ptr<BasicGraph>> GA::traverse(shared_ptr<BasicGraph> BG){
    vector<shared_ptr<BasicGraph>> last;
    if(!BG) return last;

    switch (BG->getGraphType()) {
        case GraphType::BasicBlock:
            last.push_back(BG);
            return last;
        case GraphType::Branch: {
            auto branch = std::static_pointer_cast<Branch>(BG);
            //connect head to true and false branches
            if (branch->G1) {
                addFactor(graph2bb[BG], graph2bb[branch->G1->BG],
                          (branch->trueRatioNum * branch->count) / branch->trueRatioDen);
                auto lastBR1 = traverse(branch->G1);
                last.insert(last.end(), lastBR1.begin(), lastBR1.end());
            }
            if (branch->G2){
                addFactor(graph2bb[BG], graph2bb[branch->G2->BG],
                          (branch->falseRatioNum * branch->count) / branch->falseRatioDen);
                auto lastBR2 = traverse(branch->G2);
                last.insert(last.end(), lastBR2.begin(), lastBR2.end());
            }
            if (!branch->G1 || !branch->G2){
                // both branches are null, return the branch itself as last
                last.push_back(BG);
            }

            return last;
        }
        case GraphType::Loop: {
            auto loop = std::static_pointer_cast<Loop>(BG);
            auto last_head = traverse(loop->head);
            auto last_Gb = traverse(loop->Gb);

            if (loop->Gb){
                // body is not empty
                addFactor(graph2bb[loop->head], graph2bb[loop->Gb->BG], loop->count);
                return last_Gb;
            }
            return last_head; // if Gb is null, return the last graphs of the head
        }
        case GraphType::Unknown:
            // Do nothing for unknown graph type
            break;
    }
    return last;

}

void GA::refine(shared_ptr<Graph> G){
    if (!G) return;
    refine(G->BG);
    refine(G->G);
}

void GA::refine(shared_ptr<BasicGraph> BG){
    switch (BG->getGraphType()) {
        case GraphType::BasicBlock:
            // No further traversal needed for BasicBlock
            break;
        case GraphType::Branch: {
            auto branch = std::static_pointer_cast<Branch>(BG);
            refine(branch->G1);
            refine(branch->G2);
            if(auto TRexpanded = getTrueRatio(graph2bb[branch])){
                auto [trNum, trDen] = TRexpanded.value();
                update(branch, make_pair(branch->trueRatioNum, trNum));
                update(branch, make_pair(branch->trueRatioDen, trDen));
            }
            break;
        }
        case GraphType::Loop: {
            auto loop = std::static_pointer_cast<Loop>(BG);
            refine(loop->head);
            refine(loop->Gb);
            if(auto LCexpanded = getLoopCount(LI.getLoopFor(graph2bb[loop]))){
                update(loop, make_pair(loop->loopCount, LCexpanded.value()));
            }
            break;
        }
        case GraphType::Unknown:
            // Do nothing for unknown graph type
            break;
    }
}

void GA::update(shared_ptr<Graph> G, pair<SymbolicExpr, SymbolicExpr> subs){
    if(!G) return;

    update(G->BG, subs);
    update(G->G, subs);
}

void GA::update(shared_ptr<BasicGraph> BG, pair<SymbolicExpr, SymbolicExpr> subs){
    if(! BG) return;

    auto original = subs.first;
    auto updated = subs.second;

    BG->count.substitute(original, updated);
    BG->count.simplify();

    switch (BG->getGraphType()) {
        case GraphType::BasicBlock:
            break;
        case GraphType::Branch: {
            auto branch = std::static_pointer_cast<Branch>(BG);
            branch->trueRatioNum.substitute(original, updated);
            branch->trueRatioDen.substitute(original, updated);
            branch->falseRatioNum.substitute(original, updated);
            branch->falseRatioDen.substitute(original, updated);
            update(branch->G1, subs);
            update(branch->G2, subs);
            break;
        }
        case GraphType::Loop: {
            auto loop = std::static_pointer_cast<Loop>(BG);
            loop->loopCount.substitute(original, updated);
            update(loop->head, subs);
            update(loop->Gb, subs);
            break;
        }
        case GraphType::Unknown:
            // Do nothing for unknown graph type
            break;
    }
}

// ============================================================
// Affine Condition Analysis for getTrueRatio
// See affine-conditions-solving.txt for the mathematical detail.
// All symbolic range arithmetic uses 64-bit signed bitvectors.
// ============================================================
namespace {

// A range: range(s, e, anchor, step, D) =
// { n ∈ ℤ | s ≤ n ≤ e, n ≡ anchor (mod step), n ∉ D }
struct AffineRange {
    SymbolicExpr s;                  // start (inclusive)
    SymbolicExpr e;                  // end   (inclusive)
    SymbolicExpr anchor;             // congruence anchor of the arithmetic progression
    uint64_t step;                   // constant positive stride
    std::vector<SymbolicExpr> D;     // deleted points
    AffineRange(SymbolicExpr s, SymbolicExpr e,
        SymbolicExpr anchor, uint64_t step,
        std::vector<SymbolicExpr> D = {})
    : s(std::move(s)), e(std::move(e)),
      anchor(std::move(anchor)), step(step), D(std::move(D)) {}
};

// Relational operator (from the grammar in affine-conditions-solving.txt)
// Keep signed/unsigned variants explicit so range transfer uses correct semantics.
enum class RangeOp { SLT, SLE, SGT, SGE, ULT, ULE, UGT, UGE, EQ, NE};

// A single range condition: iv <rop> v  (iv always on the left after normalisation)
struct RangeCondition {
    RangeOp      op;
    SymbolicExpr v;   // the loop-invariant right-hand side, 64-bit
};

using Term           = std::vector<RangeCondition>; // conjunction of RCs
using AffineCondition = std::vector<Term>;          // disjunction (DNF)

// Signed minimum via select: min(a,b) = a ≤ b ? a : b
static SymbolicExpr smin(const SymbolicExpr& a, const SymbolicExpr& b) {
    return SymbolicExpr::select(SymbolicExpr::sle(a, b), a, b);
}

static SymbolicExpr umin(const SymbolicExpr& a, const SymbolicExpr& b) {
    return SymbolicExpr::select(SymbolicExpr::ule(a, b), a, b);
}

static SymbolicExpr umax(const SymbolicExpr& a, const SymbolicExpr& b) {
    return SymbolicExpr::select(SymbolicExpr::uge(a, b), a, b);
}

static bool isUnsignedRangeOp(RangeOp op) {
    switch (op) {
        case RangeOp::ULT:
        case RangeOp::ULE:
        case RangeOp::UGT:
        case RangeOp::UGE:
            return true;
        default:
            return false;
    }
}

static bool hasUnsignedOps(const AffineCondition& ac) {
    for (const auto& term : ac)
        for (const auto& rc : term)
            if (isUnsignedRangeOp(rc.op))
                return true;
    return false;
}

static bool containsDeletedPoint(const std::vector<SymbolicExpr>& points,
                                 const SymbolicExpr& point) {
    auto key = point.str();
    for (const auto& p : points) {
        if (p.str() == key)
            return true;
    }
    return false;
}

static void appendDeletedPointUnique(std::vector<SymbolicExpr>& points,
                                     const SymbolicExpr& point) {
    if (!containsDeletedPoint(points, point))
        points.push_back(point);
}

static std::vector<SymbolicExpr> unionDeletedPoints(const std::vector<SymbolicExpr>& a,
                                                    const std::vector<SymbolicExpr>& b) {
    std::vector<SymbolicExpr> merged;
    merged.reserve(a.size() + b.size());
    for (const auto& p : a)
        appendDeletedPointUnique(merged, p);
    for (const auto& p : b)
        appendDeletedPointUnique(merged, p);
    return merged;
}

// Check if a Value is loop-invariant (lives outside the loop body)
static bool isLI(const llvm::Value* v, llvm::Loop* loop) {
    if (!v || !loop) return false;
    if (llvm::isa<llvm::Constant>(v)) return true;
    if (llvm::isa<llvm::Argument>(v)) return true;
    if (auto* I = llvm::dyn_cast<llvm::Instruction>(v))
        return !loop->contains(I->getParent());
    return false;
}

// Find the principal induction variable of a loop:
// prefer LLVM's canonical IV; fall back to the first affine AddRec PHI.
static const llvm::PHINode* findLoopIV(llvm::Loop* loop,
                                       llvm::ScalarEvolution& SE) {
    if (auto* iv = loop->getInductionVariable(SE))
        return iv;
    auto* hdr = loop->getHeader();
    if (!hdr) return nullptr;
    for (auto& inst : *hdr) {
        if (auto* phi = llvm::dyn_cast<llvm::PHINode>(&inst)) {
            if (auto* ar = llvm::dyn_cast<llvm::SCEVAddRecExpr>(SE.getSCEV(phi)))
                if (ar->getLoop() == loop && ar->isAffine())
                    return phi;
        }
    }
    return nullptr;
}

static SymbolicExpr stepExpr(uint64_t step, SymbolicExprManager& SEM) {
    return SEM.bvVal(step, 64);
}

// Smallest point of the progression anchor + k*step that is >= lower.
static SymbolicExpr alignLower(const SymbolicExpr& lower,
                               const SymbolicExpr& anchor,
                               uint64_t step,
                               SymbolicExprManager& SEM,
                               bool useUnsignedCmp = false) {
    auto stepBV = stepExpr(step, SEM);
    auto one = SEM.bvVal(1, 64);
    auto delta = lower - anchor;
    auto ceilQ = (delta + stepBV - one) / stepBV;
    auto aligned = anchor + ceilQ * stepBV;
    auto le = useUnsignedCmp ? SymbolicExpr::ule(lower, anchor)
                             : SymbolicExpr::sle(lower, anchor);
    return SymbolicExpr::select(le, anchor, aligned);
}

// Largest point of the progression anchor + k*step that is <= upper.
// If upper is below the first progression point, return anchor-step so that
// callers can detect emptiness by checking start > end.
static SymbolicExpr alignUpper(const SymbolicExpr& upper,
                               const SymbolicExpr& anchor,
                               uint64_t step,
                               SymbolicExprManager& SEM,
                               bool useUnsignedCmp = false) {
    auto stepBV = stepExpr(step, SEM);
    auto delta = upper - anchor;
    auto floorQ = delta / stepBV;
    auto aligned = anchor + floorQ * stepBV;
    auto le = useUnsignedCmp ? SymbolicExpr::ule(anchor, upper)
                             : SymbolicExpr::sle(anchor, upper);
    return SymbolicExpr::select(le, aligned, anchor - stepBV);
}

static SymbolicExpr isAlignedToRange(const SymbolicExpr& value,
                                     const AffineRange& R,
                                     SymbolicExprManager& SEM) {
    auto zero = SEM.bvVal(0, 64);
    auto stepBV = stepExpr(R.step, SEM);
    return SymbolicExpr::eq((value - R.anchor) % stepBV, zero);
}

// Apply one transfer function F_{iv op v}(R) → refined range
static AffineRange applyRC(const AffineRange& R,
                           const RangeCondition& rc,
                           SymbolicExprManager& SEM) {
    auto one = SEM.bvVal(1, 64);
    auto maxFn = isUnsignedRangeOp(rc.op) ? umax : SymbolicExpr::smax;
    auto minFn = isUnsignedRangeOp(rc.op) ? umin : smin;

    // llvm::errs() << "DEBUG: applyRC "<< "\n";    
    switch (rc.op) {
        case RangeOp::SLE:
        case RangeOp::ULE:
            // llvm::errs() << "DEBUG: Applying RC: iv <= v, adjusting end from " << R.e.str() << " to min(" << R.e.str() << ", " << rc.v.str() << ")\n";
            return AffineRange(R.s, minFn(R.e, rc.v), R.anchor, R.step, R.D);
        case RangeOp::SLT:
        case RangeOp::ULT:
            // llvm::errs() << "DEBUG: Applying RC: iv < v, adjusting end from " << R.e.str() << " to min(" << R.e.str() << ", " << (rc.v - one).str() << ")\n";
            return AffineRange(R.s, minFn(R.e, rc.v - one), R.anchor, R.step, R.D);
        case RangeOp::SGE:
        case RangeOp::UGE:
            // llvm::errs() << "DEBUG: Applying RC: iv >= v, adjusting start from " << R.s.str() << " to max(" << R.s.str() << ", " << rc.v.str() << ")\n";
            return AffineRange(maxFn(R.s, rc.v), R.e, R.anchor, R.step, R.D);
        case RangeOp::SGT:
        case RangeOp::UGT:
            // llvm::errs() << "DEBUG: Applying RC: iv > v, adjusting start from " << R.s.str() << " to max(" << R.s.str() << ", " << (rc.v + one).str() << ")\n";
            return AffineRange(maxFn(R.s, rc.v + one), R.e, R.anchor, R.step, R.D);
        case RangeOp::NE: {
            // llvm::errs() << "DEBUG: Applying RC: iv != v, adjusting range\n";
            auto D2 = R.D;
            appendDeletedPointUnique(D2, rc.v);
            return AffineRange(R.s, R.e, R.anchor, R.step, std::move(D2));
        }
        case RangeOp::EQ:
            // llvm::errs() << "DEBUG: Applying RC: iv == v, adjusting range to single point " << rc.v.str() << "\n";
            // F_{iv==v}(R) = range(max(s,v), min(e,v), D)
            // equals range(v,v,D) when v∈[s,e]; s>e (empty) otherwise
            return AffineRange(maxFn(R.s, rc.v),
                               minFn(R.e, rc.v), R.anchor, R.step, R.D);
    }
    return R;
}

// Apply a full conjunctive term T by composing transfer functions
static AffineRange applyTerm(const AffineRange& R0,
                             const Term& term,
                             SymbolicExprManager& SEM) {
    AffineRange R = R0;
    // llvm::errs() << "DEBUG: Applying Term with " << term.size() << " RCs\n";
    for (const auto& rc : term) {
        // llvm::errs() << "DEBUG: Range before applying RC: " << R.s.str() << " to " << R.e.str() << ", anchor " << R.anchor.str() << ", step " << R.step << ", D size " << R.D.size() << "\n";
        R = applyRC(R, rc, SEM);
        // llvm::errs() << "DEBUG: Range after applying RC: " << R.s.str() << " to " << R.e.str() << ", anchor " << R.anchor.str() << ", step " << R.step << ", D size " << R.D.size() << "\n";
    }
    return R;
}

// len(range(s,e,anchor,step,D)) =
// max(0, floor((alignedEnd-alignedStart)/step)+1) minus deleted aligned points.
static SymbolicExpr computeLen(const AffineRange& R,
                               SymbolicExprManager& SEM,
                               bool useUnsignedCmp = false) {
    auto zero = SEM.bvVal(0, 64);
    auto one  = SEM.bvVal(1, 64);
    auto stepBV = stepExpr(R.step, SEM);
    auto alignedStart = alignLower(R.s, R.anchor, R.step, SEM, useUnsignedCmp);
    auto alignedEnd = alignUpper(R.e, R.anchor, R.step, SEM, useUnsignedCmp);
    auto le = useUnsignedCmp ? SymbolicExpr::ule(alignedStart, alignedEnd)
                             : SymbolicExpr::sle(alignedStart, alignedEnd);
    // base length: ((alignedEnd-alignedStart)/step)+1 when alignedStart≤alignedEnd, else 0
    auto base = SymbolicExpr::select(
        le,
        ((alignedEnd - alignedStart) / stepBV) + one,
        zero);
    // subtract deleted points that lie within [alignedStart, alignedEnd]
    // and are on the same arithmetic progression.
    auto del = zero;
    for (const auto& d : R.D) {
        auto inRange = useUnsignedCmp
            ? (SymbolicExpr::ule(alignedStart, d) & SymbolicExpr::ule(d, alignedEnd))
            : (SymbolicExpr::sle(alignedStart, d) & SymbolicExpr::sle(d, alignedEnd));
        auto aligned = isAlignedToRange(d, R, SEM);
        del = del + SymbolicExpr::select(inRange & aligned, one, zero);
    }
    return base - del;
}

// Ω(I_i, I_j) = range(max(s_i,s_j), min(e_i,e_j), D_i ∪ D_j)
// For set intersection (I_i ∩ I_j), deleted points are unioned.
static AffineRange computeOverlap(const AffineRange& a,
                                  const AffineRange& b,
                                  SymbolicExprManager& SEM,
                                  bool useUnsignedCmp = false) {
    auto maxFn = useUnsignedCmp ? umax : SymbolicExpr::smax;
    auto minFn = useUnsignedCmp ? umin : smin;
    auto overlapD = unionDeletedPoints(a.D, b.D);
    return AffineRange(maxFn(a.s, b.s),
                       minFn(a.e, b.e),
                       a.anchor,
                       a.step,
                       std::move(overlapD));
}

} // anonymous namespace
// ============================================================

optional<pair<SymbolicExpr, SymbolicExpr>> GA::tryAffineTrueRatio(const llvm::BasicBlock* bb) {
    if (!bb) return std::nullopt;

    // Only makes sense for a block inside a loop
    auto* loop = LI.getLoopFor(const_cast<llvm::BasicBlock*>(bb));
    if (!loop) return std::nullopt;

    // Terminator must be a conditional branch
    auto* termBr = llvm::dyn_cast<llvm::BranchInst>(bb->getTerminator());
    if (!termBr || !termBr->isConditional()) return std::nullopt;

    auto* condVal = termBr->getCondition();
    if (!condVal) return std::nullopt;

    // Locate the canonical induction variable
    const llvm::PHINode* iv = findLoopIV(loop, SE);
    if (!iv) return std::nullopt;

    // -------------------------------------------------------
    // Parse the branch condition into DNF (AffineCondition)
    // -------------------------------------------------------

    // Parse a single ICmpInst as a RangeCondition on iv (nullopt if not eligible)
    auto parseSingleRC = [&](const llvm::ICmpInst* cmp)
            -> std::optional<RangeCondition> {
        // llvm::errs() << "DEBUG: getTrueRatio: Parsing ICmpInst: " << *cmp << "\n";
        auto* op0 = cmp->getOperand(0);
        auto* op1 = cmp->getOperand(1);
        bool ivLeft  = (op0 == iv);
        bool ivRight = (op1 == iv);
        if (!ivLeft && !ivRight) return std::nullopt;
        auto* nonIv = ivLeft ? op1 : op0;
        if (!isLI(nonIv, loop))   return std::nullopt;
        // llvm::errs() << "DEBUG: getTrueRatio: Non-IV operand is loop-invariant: " << *nonIv << "\n";

        auto pred = cmp->getPredicate();
        if (ivRight) pred = llvm::ICmpInst::getSwappedPredicate(pred);

        RangeOp op;
        switch (pred) {
            case llvm::CmpInst::ICMP_SLT: op = RangeOp::SLT; break;
            case llvm::CmpInst::ICMP_ULT: op = RangeOp::ULT; break;
            case llvm::CmpInst::ICMP_SLE: op = RangeOp::SLE; break;
            case llvm::CmpInst::ICMP_ULE: op = RangeOp::ULE; break;
            case llvm::CmpInst::ICMP_SGT: op = RangeOp::SGT; break;
            case llvm::CmpInst::ICMP_UGT: op = RangeOp::UGT; break;
            case llvm::CmpInst::ICMP_SGE: op = RangeOp::SGE; break;
            case llvm::CmpInst::ICMP_UGE: op = RangeOp::UGE; break;
            case llvm::CmpInst::ICMP_EQ:  op = RangeOp::EQ; break;
            case llvm::CmpInst::ICMP_NE:  op = RangeOp::NE; break;
            default: return std::nullopt;  // unsigned predicates not handled
        }
        auto v = value2Expr(*nonIv);
        // Normalise to 64-bit using predicate semantics
        if (v.getBitwidth() < 64) {
            if (isUnsignedRangeOp(op)) v = v.zeroExtend(64 - v.getBitwidth());
            else                       v = v.signedExtend(64 - v.getBitwidth());
        }
        else if (v.getBitwidth() > 64) return std::nullopt;

        // llvm::errs() << "DEBUG: getTrueRatio: get range condition " << "\n";
        return RangeCondition{op, v};
    };

    // Recursively parse a Value into DNF
    std::function<std::optional<AffineCondition>(const llvm::Value*)> parseAC;
    parseAC = [&](const llvm::Value* val) -> std::optional<AffineCondition> {
        if (!val) return std::nullopt;

        // llvm::errs() << "DEBUG: getTrueRatio: get AC Parsing Value: " << *val << "\n";

        // if it is a freeze instruction, skip it and parse its operand (e.g., icmp freeze (iv) vs icmp (iv))
        if (auto* freeze = llvm::dyn_cast<llvm::FreezeInst>(val))
            return parseAC(freeze->getOperand(0));

        if (auto* cmp = llvm::dyn_cast<llvm::ICmpInst>(val)) {
            auto rc = parseSingleRC(cmp);
            if (!rc) return std::nullopt;
            return AffineCondition{{*rc}};
        }
        if (auto* inst = llvm::dyn_cast<llvm::Instruction>(val)) {
            if (inst->getOpcode() == llvm::Instruction::And) {
                auto ac0 = parseAC(inst->getOperand(0));
                auto ac1 = parseAC(inst->getOperand(1));
                if (!ac0 || !ac1) return std::nullopt;
                // AND: cross-product of terms (distribute over OR)
                AffineCondition result;
                for (auto& t0 : *ac0)
                    for (auto& t1 : *ac1) {
                        Term merged;
                        merged.insert(merged.end(), t0.begin(), t0.end());
                        merged.insert(merged.end(), t1.begin(), t1.end());
                        result.push_back(std::move(merged));
                    }
                return result;
            }
            if (inst->getOpcode() == llvm::Instruction::Or) {
                auto ac0 = parseAC(inst->getOperand(0));
                auto ac1 = parseAC(inst->getOperand(1));
                if (!ac0 || !ac1) return std::nullopt;
                // OR: union of terms
                AffineCondition result;
                result.insert(result.end(), ac0->begin(), ac0->end());
                result.insert(result.end(), ac1->begin(), ac1->end());
                return result;
            }
        }
        return std::nullopt;
    };

    auto negateRangeOp = [&](RangeOp op) -> RangeOp {
        switch (op) {
            case RangeOp::SLT: return RangeOp::SGE;
            case RangeOp::SLE: return RangeOp::SGT;
            case RangeOp::SGT: return RangeOp::SLE;
            case RangeOp::SGE: return RangeOp::SLT;
            case RangeOp::ULT: return RangeOp::UGE;
            case RangeOp::ULE: return RangeOp::UGT;
            case RangeOp::UGT: return RangeOp::ULE;
            case RangeOp::UGE: return RangeOp::ULT;
            case RangeOp::EQ:  return RangeOp::NE;
            case RangeOp::NE:  return RangeOp::EQ;
        }
        return op;
    };

    auto andAC = [&](const AffineCondition& lhs, const AffineCondition& rhs) -> AffineCondition {
        if (lhs.empty() || rhs.empty()) return {};
        AffineCondition out;
        out.reserve(lhs.size() * rhs.size());
        for (const auto& lt : lhs)
            for (const auto& rt : rhs) {
                Term merged;
                merged.reserve(lt.size() + rt.size());
                merged.insert(merged.end(), lt.begin(), lt.end());
                merged.insert(merged.end(), rt.begin(), rt.end());
                out.push_back(std::move(merged));
            }
        return out;
    };

    auto orAC = [&](const AffineCondition& lhs, const AffineCondition& rhs) -> AffineCondition {
        AffineCondition out;
        out.reserve(lhs.size() + rhs.size());
        out.insert(out.end(), lhs.begin(), lhs.end());
        out.insert(out.end(), rhs.begin(), rhs.end());
        return out;
    };

    auto negateAC = [&](const AffineCondition& input) -> AffineCondition {
        if (input.empty()) return AffineCondition{Term{}}; // ¬false = true
        AffineCondition out{Term{}};                       // true
        for (const auto& term : input) {
            if (term.empty()) return AffineCondition{};    // ¬true = false
            AffineCondition notTerm;
            notTerm.reserve(term.size());
            for (const auto& rc : term)
                notTerm.push_back(Term{RangeCondition{negateRangeOp(rc.op), rc.v}});
            out = andAC(out, notTerm);
            if (out.empty()) break;
        }
        return out;
    };

    auto trueAC = AffineCondition{Term{}}; // tautology in DNF
    auto currentAC = parseAC(condVal);
    if (!currentAC || currentAC->empty()) return std::nullopt;

    auto edgeAC = [&](const llvm::BasicBlock* from, const llvm::BasicBlock* to) -> AffineCondition {
        auto* br = llvm::dyn_cast<llvm::BranchInst>(from->getTerminator());
        if (!br || !br->isConditional() || br->getNumSuccessors() != 2)
            return trueAC;
        auto parsed = parseAC(br->getCondition());
        if (!parsed || parsed->empty())
            return trueAC;
        if (br->getSuccessor(0) == to)
            return *parsed;
        if (br->getSuccessor(1) == to)
            return negateAC(*parsed);
        return trueAC;
    };

    auto* header = loop->getHeader();
    if (!header) return std::nullopt;

    AffineCondition pathAC;
    bool hasPath = false;
    size_t exploredPaths = 0;
    constexpr size_t kMaxPaths = 2048;
    constexpr size_t kMaxTerms = 8192;

    std::function<void(const llvm::BasicBlock*, const AffineCondition&, std::set<const llvm::BasicBlock*>&)> dfs;
    dfs = [&](const llvm::BasicBlock* node,
              const AffineCondition& acc,
              std::set<const llvm::BasicBlock*>& visited) {
        if (!node || exploredPaths >= kMaxPaths) return;
        if (node == bb) {
            hasPath = true;
            ++exploredPaths;
            pathAC = pathAC.empty() ? acc : orAC(pathAC, acc);
            if (pathAC.size() > kMaxTerms) {
                pathAC.resize(kMaxTerms);
            }
            return;
        }

        for (const auto* succ : llvm::successors(node)) {
            if (!succ || !loop->contains(const_cast<llvm::BasicBlock*>(succ)))
                continue;
            if (visited.count(succ))
                continue;
            auto nextAcc = andAC(acc, edgeAC(node, succ));
            if (nextAcc.empty())
                continue;
            if (nextAcc.size() > kMaxTerms)
                nextAcc.resize(kMaxTerms);
            visited.insert(succ);
            dfs(succ, nextAcc, visited);
            visited.erase(succ);
            if (exploredPaths >= kMaxPaths)
                return;
        }
    };

    std::set<const llvm::BasicBlock*> visited;
    visited.insert(header);
    dfs(header, trueAC, visited);

    auto baseAC = hasPath ? pathAC : trueAC;
    auto effectiveAC = andAC(baseAC, *currentAC);
    if (effectiveAC.empty()) {
        // current condition is unsatisfiable under path constraints
        effectiveAC = AffineCondition{};
    }

    auto useUnsignedCmp = hasUnsignedOps(baseAC) || hasUnsignedOps(effectiveAC);
    // llvm::errs() << "DEBUG: getTrueRatio: parsed affine condition with " << ac->size() << " terms\n";

    // -------------------------------------------------------
    // Get the loop's iteration range R0 as an arithmetic progression.
    // -------------------------------------------------------
    const auto* addRec = llvm::dyn_cast<llvm::SCEVAddRecExpr>(
        SE.getSCEV(const_cast<llvm::PHINode*>(iv)));
    if (!addRec || !addRec->isAffine()) return std::nullopt;
    // llvm::errs() << "DEBUG: getTrueRatio: found affine AddRec for IV: " << *addRec << "\n";

    const auto* constStep = llvm::dyn_cast<llvm::SCEVConstant>(
        addRec->getStepRecurrence(SE));
    if (!constStep) return std::nullopt;
    auto stepValue = constStep->getValue()->getSExtValue();
    if (stepValue == 0) return std::nullopt;
    // llvm::errs() << "DEBUG: getTrueRatio: found constant step for IV: " << *constStep << "\n";

    const llvm::SCEV* btc = SE.getBackedgeTakenCount(loop);
    if (llvm::isa<llvm::SCEVCouldNotCompute>(btc)) return std::nullopt;
    // llvm::errs() << "DEBUG: getTrueRatio: backedge taken count SCEV: " << *btc << "\n";

    // Build R0
    auto S = SCEV2Expr(*addRec->getStart());
    if (S.getBitwidth() < 64)
        S = useUnsignedCmp ? S.zeroExtend(64 - S.getBitwidth())
                           : S.signedExtend(64 - S.getBitwidth());

    auto BTC = SCEV2Expr(*btc);
    if (BTC.getBitwidth() < 64) BTC = BTC.zeroExtend(64 - BTC.getBitwidth());

    auto stepExpr64 = SEM.bvVal(static_cast<uint64_t>(stepValue), 64);
    auto last = S + BTC * stepExpr64;
    auto absStep = static_cast<uint64_t>(std::llabs(static_cast<long long>(stepValue)));

    // Normalize to an ascending arithmetic progression while preserving the
    // exact set of IV values.
    AffineRange R0 = (stepValue > 0)
        ? AffineRange(S, last, S, absStep /*, D={} */)
        : AffineRange(last, S, last, absStep /*, D={} */);

    auto countUnionRanges = [&](const std::vector<AffineRange>& ranges) {
        auto cnt = SEM.bvVal(0, 64);
        for (const auto& Ri : ranges)
            cnt = cnt + computeLen(Ri, SEM, useUnsignedCmp);
        for (size_t i = 0; i < ranges.size(); ++i)
            for (size_t j = i + 1; j < ranges.size(); ++j)
                cnt = cnt - computeLen(computeOverlap(ranges[i], ranges[j], SEM, useUnsignedCmp),
                                       SEM, useUnsignedCmp);
        return cnt;
    };

    // -------------------------------------------------------
    // Apply transfer functions over path-conditioned base range.
    // baseAC captures conditions on the path to bb (for denominator),
    // effectiveAC = baseAC AND currentAC (for numerator).
    // -------------------------------------------------------
    std::vector<AffineRange> BaseRanges;
    BaseRanges.reserve(baseAC.size());
    for (const auto& term : baseAC) {
        BaseRanges.push_back(applyTerm(R0, term, SEM));
    }

    std::vector<AffineRange> Iranges;
    Iranges.reserve(effectiveAC.size());
    for (const auto& term : effectiveAC){
        Iranges.push_back(applyTerm(R0, term, SEM));    
    }

    // -------------------------------------------------------
    // Inclusion-exclusion: trueCount = Σlen(I_i) − Σlen(Ω(I_i,I_j))
    // -------------------------------------------------------
    auto lenR0     = countUnionRanges(BaseRanges);
    auto trueCount = countUnionRanges(Iranges);

    // Return (numerator, denominator) without performing bitvector division.
    // The caller is responsible for combining the two expressions as needed.

    // llvm::errs() << "DEBUG: getTrueRatio: computed affine true count for block " << GraphBuilder::getName(bb) << ": " << trueCount.str() << " out of " << lenR0.str() << "\n";

    return make_pair(trueCount, lenR0);
}

optional<pair<SymbolicExpr, SymbolicExpr>> GA::getTrueRatio(const llvm::BasicBlock* bb){
    if (!bb) {
        llvm::errs() << "Error: getTrueRatio: BasicBlock is null\n";
        return std::nullopt;
    }
    const llvm::Instruction* term = bb->getTerminator();
    if (!term) {
        llvm::errs() << "Error: getTrueRatio: Terminator is null for block " << GraphBuilder::getName(bb) << "\n";
        return std::nullopt;
    }

    if (isSolvable(term)){
        // denominator = 1 for loop-invariant conditions (exact ratio, no fractional part)
        auto cond = inst2Expr(*term); //1-bit vector return
        // llvm::errs() << "DEBUG: getTrueRatio: Solvable terminator for block " << GraphBuilder::getName(bb) << ": , with condition: " << cond.str() << "\n";
        // llvm::errs() << "DEBUG: getTrueRatio: Solvable terminator for block " << GraphBuilder::getName(bb) << ": " << *term << ", trueCount = " << cond.str() << "\n";
        return make_pair(cond.zeroExtend(63), SEM.bvVal(1, 64));
    }

    // attempt the affine-condition analysis for loop-varying branches
    if (auto affineResult = tryAffineTrueRatio(bb)) {
        return affineResult;  // already a (numerator, denominator) pair
    }
    
    llvm::errs() << "Warning: getTrueRatio: Terminator not solvable for block " << GraphBuilder::getName(bb) << "\n";
    return std::nullopt;
}

optional<SymbolicExpr> GA::getLoopCount(llvm::Loop* loop){
    if (!loop) {
        llvm::errs() << "Error: getLoopCount: Loop is null\n";
        return std::nullopt;
    }

    // Use ScalarEvolution to get the backedge taken count
    llvm::ScalarEvolution *SE = &this->SE;
    if (!SE) {
        llvm::errs() << "Error: getLoopCount: ScalarEvolution is null\n";
        return std::nullopt;
    }

    const llvm::SCEV *backedgeCount = SE->getBackedgeTakenCount(loop);
    if (llvm::isa<llvm::SCEVCouldNotCompute>(backedgeCount)) {
        llvm::errs() << "Warning: getLoopCount: Could not compute backedge count for loop " << getName(loop) << "\n";
        // Fallback to symbolic name
        auto loopCount_literal = "LC_" + getName(loop);
        return SEM.symbLoopCount(loopCount_literal);
    }

    // SCEV gives backedge count, but we want trip count = backedge count + 1
    auto backedgeCountExpr = SCEV2Expr(*backedgeCount);
    if(backedgeCountExpr.getBitwidth() == 64){
        // good, default loop count is 64 bits, we can directly use it
        return backedgeCountExpr + SEM.one64();
    }
    else if (backedgeCountExpr.getBitwidth() < 64){
        // if it is smaller than 64 bits, we can zero extend it to 64 bits
        return backedgeCountExpr.zeroExtend(64 - backedgeCountExpr.getBitwidth()) + SEM.one64();
    }
    else{
        //print 
        llvm::errs() << "Error: Loop " << getName(loop) << " backedge count SCEV: ";
        backedgeCount->print(llvm::errs());
        llvm::errs() << " is not 64 bits, type incompatible\n";
        exit(1);
    }
    
}

SymbolicExpr GA::SCEV2Expr(const llvm::SCEV& scev) {
    // scev.print(llvm::errs());
    // llvm::errs() << "\n";
    auto & ctx = SEM.context();

    vector<SymbolicExpr> args;
    for (const auto& op : scev.operands()) {
        args.push_back(SCEV2Expr(*op));
    }

    switch (scev.getSCEVType()) {
        case llvm::scAddExpr:{
            SymbolicExpr sum = args.size() > 0 ? args[0] : SEM.intVal(0);
            for (unsigned i = 1; i < args.size(); ++i) {
                sum = sum + args[i];
            }
            return sum;
        }
        case llvm::scMulExpr:{
            SymbolicExpr product = args.size() > 0 ? args[0] : SEM.intVal(1);
            for (unsigned i = 1; i < args.size(); ++i) {
                product = product * args[i];
            }
            return product;
        }
        case llvm::scZeroExtend:{
            if (args.size() == 1) {
                // Get the target bitwidth from the SCEV type
                unsigned targetBitwidth = scev.getType()->getPrimitiveSizeInBits();
                unsigned srcBitwidth = args[0].getBitwidth();
                if (targetBitwidth > srcBitwidth) {
                    return args[0].zeroExtend(targetBitwidth - srcBitwidth);
                } else if (targetBitwidth == srcBitwidth) {
                    return args[0];
                } else {
                    llvm::errs() << "Error: ZeroExtend target bitwidth is less than source bitwidth.\n";
                }
            }
            llvm::errs() << "Error: ZeroExtend requires exactly one operand.\n";
            break;
        }            
        case llvm::scTruncate:{
            if (args.size() == 1) {
                // Get the target bitwidth from the SCEV type
                unsigned targetBitwidth = scev.getType()->getPrimitiveSizeInBits();
                unsigned srcBitwidth = args[0].getBitwidth();
                if (targetBitwidth < srcBitwidth) {
                    return args[0].truncate(targetBitwidth);
                } else if (targetBitwidth == srcBitwidth) {
                    return args[0];
                } else {
                    llvm::errs() << "Error: Truncate target bitwidth is greater than source bitwidth.\n";
                }
            }
            llvm::errs() << "Error: Truncate requires exactly one operand.\n";
            break;
        }
        case llvm::scUDivExpr:{
            if (args.size() == 2) {
                return args[0] / args[1];
            }
            llvm::errs() << "Error: UDivExpr requires exactly two operands.\n";
            break;
        }
        case llvm::scSignExtend:{
            if (args.size() == 1) {
                // Get the target bitwidth from the SCEV type
                unsigned targetBitwidth = scev.getType()->getPrimitiveSizeInBits();
                unsigned srcBitwidth = args[0].getBitwidth();
                if (targetBitwidth > srcBitwidth) {
                    return args[0].signedExtend(targetBitwidth - srcBitwidth);
                } else if (targetBitwidth == srcBitwidth) {
                    return args[0];
                } else {
                    llvm::errs() << "Error: SignExtend target bitwidth is less than source bitwidth.\n";
                }
            }
            llvm::errs() << "Error: SignExtend requires exactly one operand.\n";
            break;
        }
        case llvm::scSMaxExpr:{
            if (args.size() == 2) {
                return SymbolicExpr::smax(args[0], args[1]);
            }
            llvm::errs() << "Error: SMaxExpr requires exactly two operands.\n";
            break;
        }
        case llvm::scConstant:{
            const llvm::SCEVConstant* scevConst = llvm::cast<llvm::SCEVConstant>(&scev);
            unsigned bitwidth = scevConst->getType()->getPrimitiveSizeInBits();
            return SEM.bvVal(scevConst->getValue()->getSExtValue(), bitwidth);
        }        
        case llvm::scUnknown:{
            unsigned bitwidth = scev.getType()->getPrimitiveSizeInBits();
            if (const llvm::SCEVUnknown* scevUnknown = llvm::dyn_cast<llvm::SCEVUnknown>(&scev)) {
                if (const llvm::Value* val = scevUnknown->getValue()) {
                    return value2Expr(*val);
                }
            }
            llvm::errs() << "Error: SCEVUnknown without value.\n";
        }
        default:{
            llvm::errs() << "Error: Unsupported SCEV type: " << scev.getSCEVType() << "\n";
            scev.print(llvm::errs());
            llvm::errs() << "\n";
        }
    }
    return SEM.bvSCEV(scev);
}

SymbolicExpr GA::call2Expr(const llvm::CallInst& C) {
    auto bitwidth = SEM.getBitWidth(static_cast<const llvm::Instruction&>(C));
    auto getCalledName = [&]() -> std::optional<std::string> {
        if (const auto* callee = C.getCalledFunction()) {
            return callee->getName().str();
        }

        const auto* calledOperand = C.getCalledOperand()->stripPointerCasts();
        if (const auto* global = llvm::dyn_cast<llvm::GlobalValue>(calledOperand)) {
            return global->getName().str();
        }

        if (const auto* load = llvm::dyn_cast<llvm::LoadInst>(calledOperand)) {
            const auto* pointerOperand = load->getPointerOperand()->stripPointerCasts();
            if (const auto* global = llvm::dyn_cast<llvm::GlobalValue>(pointerOperand)) {
                return global->getName().str();
            }
        }

        return std::nullopt;
    };

    auto id = C.getIntrinsicID();
    if (id == llvm::Intrinsic::not_intrinsic) {
        if (auto calledName = getCalledName()) {
            llvm::StringRef name(*calledName);
            if (name.starts_with("llvm.smax.")) {
                if (C.arg_size() == 2) {
                    return SymbolicExpr::smax(value2Expr(*C.getArgOperand(0)),
                                              value2Expr(*C.getArgOperand(1)));
                }
            }

            if (name == "__TVMBackendFreeWorkspace") {
                return SEM.bvVal(0, bitwidth);
            }
        }
        llvm::errs() << "Warning: call2Expr unsupported intrinsic call, assumed to be 1: ";
        C.print(llvm::errs());
        llvm::errs() << "\n";

        return SEM.bvVal(1, bitwidth);
    }

    auto selectMinSigned = [&](const SymbolicExpr& a, const SymbolicExpr& b) {
        return SymbolicExpr::select(SymbolicExpr::sle(a, b), a, b);
    };
    auto selectMaxUnsigned = [&](const SymbolicExpr& a, const SymbolicExpr& b) {
        return SymbolicExpr::select(SymbolicExpr::uge(a, b), a, b);
    };
    auto selectMinUnsigned = [&](const SymbolicExpr& a, const SymbolicExpr& b) {
        return SymbolicExpr::select(SymbolicExpr::ule(a, b), a, b);
    };

    switch (id) {
        case llvm::Intrinsic::smax:
            if (C.arg_size() == 2)
                return SymbolicExpr::smax(value2Expr(*C.getArgOperand(0)),
                                          value2Expr(*C.getArgOperand(1)));
            break;
        case llvm::Intrinsic::smin:
            if (C.arg_size() == 2)
                return selectMinSigned(value2Expr(*C.getArgOperand(0)),
                                       value2Expr(*C.getArgOperand(1)));
            break;
        case llvm::Intrinsic::umax:
            if (C.arg_size() == 2)
                return selectMaxUnsigned(value2Expr(*C.getArgOperand(0)),
                                         value2Expr(*C.getArgOperand(1)));
            break;
        case llvm::Intrinsic::umin:
            if (C.arg_size() == 2)
                return selectMinUnsigned(value2Expr(*C.getArgOperand(0)),
                                         value2Expr(*C.getArgOperand(1)));
            break;
        case llvm::Intrinsic::abs:
            if (C.arg_size() >= 1) {
                auto x = value2Expr(*C.getArgOperand(0));
                auto zero = SEM.bvVal(0, x.getBitwidth());
                return SymbolicExpr::select(SymbolicExpr::sge(x, zero), x, -x);
            }
            break;
        default:
            break;
    }

    llvm::errs() << "Warning: call2Expr unsupported intrinsic call, assumed to be 1: ";
    C.print(llvm::errs());
    llvm::errs() << "\n";

    return SEM.bvVal(1, bitwidth);
}

// expands an instruction into a symbolic expression
SymbolicExpr GA::inst2Expr(const llvm::Instruction& I) {

    auto & ctx_ = SEM.context();

    // debug print the instruction being converted
    // llvm::errs() << "DEBUG: Converting instruction to expression: ";
    // I.print(llvm::errs());
    // llvm::errs() << "\n";

    switch (I.getOpcode()) {

        // PHI node: weighted average based on incoming edge factors
        // the linear property is due to the linearity of value's effect on LC or TR
        case llvm::Instruction::PHI:{
            auto phi = llvm::dyn_cast<llvm::PHINode>(&I);
            auto sum = SEM.intVal(0);
            auto total_factor = SEM.intVal(0);
            for (unsigned i = 0; i < phi->getNumIncomingValues(); ++i) {
                auto incomingBB = phi->getIncomingBlock(i);
                auto currentBB = const_cast<llvm::BasicBlock*>(phi->getParent());
                auto incomingVal = phi->getIncomingValue(i);

                // debug info of incombingBB currentBB
                // llvm::errs() << "Debug: printExpandedPHI processing incoming edge from "
                //         << GraphBuilder::getName(incomingBB) << " to "
                //         << GraphBuilder::getName(currentBB) << "\n";


                if (auto baseFactor = getFactor(incomingBB, currentBB)) {
                    if(isSolvableExitValue(incomingVal, incomingBB, currentBB)){
                        auto exit_value = getExitValueSCEV(incomingVal, incomingBB, currentBB);
                        sum = sum + baseFactor.value() * SCEV2Expr(*exit_value);
                    }
                    else{
                        sum = sum + baseFactor.value() * value2Expr(*incomingVal);
                    }
                    total_factor = total_factor + baseFactor.value();
                } else {
                    llvm::errs() << "Warning: inst2Expr PHI: No base factor found for edge from "
                                 << GraphBuilder::getName(incomingBB) << " to "
                                 << GraphBuilder::getName(currentBB) << "\n";
                    return SEM.bvInst(I);
                }
            }
            // Debug tracking, record the number of composite PHI nodes processed
            compositePHIs.insert(phi);

            // Normalize by the total factor
            auto normalized_expr = sum / total_factor;
            auto non_zero_total = SymbolicExpr::ne(total_factor, SEM.intVal(0));
            return SymbolicExpr::select(non_zero_total, normalized_expr, SEM.intVal(0));
        
        }
        case llvm::Instruction::Or:{
            auto op0 = I.getOperand(0);
            auto op1 = I.getOperand(1);
            auto expr0 = value2Expr(*op0);
            auto expr1 = value2Expr(*op1);
            return expr0 | expr1;
        }
        case llvm::Instruction::And:{
            auto op0 = I.getOperand(0);
            auto op1 = I.getOperand(1);
            auto expr0 = value2Expr(*op0);
            auto expr1 = value2Expr(*op1);
            return expr0 & expr1;
        }
        case llvm::Instruction::Add:{
            auto op0 = I.getOperand(0);
            auto op1 = I.getOperand(1);
            auto expr0 = value2Expr(*op0);
            auto expr1 = value2Expr(*op1);
            return expr0 + expr1;
        }
        case llvm::Instruction::Sub:{
            auto op0 = I.getOperand(0);
            auto op1 = I.getOperand(1);
            auto expr0 = value2Expr(*op0);
            auto expr1 = value2Expr(*op1);
            return expr0 - expr1;
        }
        case llvm::Instruction::Mul:{
            auto op0 = I.getOperand(0);
            auto op1 = I.getOperand(1);
            auto expr0 = value2Expr(*op0);
            auto expr1 = value2Expr(*op1);
            return expr0 * expr1;
        }
        case llvm::Instruction::UDiv:{
            auto op0 = I.getOperand(0);
            auto op1 = I.getOperand(1);
            auto expr0 = value2Expr(*op0);
            auto expr1 = value2Expr(*op1);
            return expr0 / expr1;
        }
        case llvm::Instruction::ZExt:{
            auto op = I.getOperand(0);
            auto expr = value2Expr(*op);
            unsigned targetBitwidth = I.getType()->getPrimitiveSizeInBits();
            return expr.zeroExtend(targetBitwidth - expr.getBitwidth());
        }
        case llvm::Instruction::SExt:{
            auto op = I.getOperand(0);
            auto expr = value2Expr(*op);
            unsigned targetBitwidth = I.getType()->getPrimitiveSizeInBits();
            return expr.signedExtend(targetBitwidth - expr.getBitwidth());
        }
        case llvm::Instruction::Br:{
            auto cond = I.getOperand(0);
            return value2Expr(*cond);
        }
        case llvm::Instruction::ICmp:{
            auto op0 = I.getOperand(0);
            auto op1 = I.getOperand(1);
            auto expr0 = value2Expr(*op0);
            auto expr1 = value2Expr(*op1);

            // llvm::errs() << "Debug: ICmp instruction: ";
            // I.print(llvm::errs());
            // llvm::errs() << "\n";
            // llvm::errs() << "Debug: Operand 0 expression: " << expr0.getBitwidth() << " ";
            // op0->print(llvm::errs(), false);
            // llvm::errs() << "\n";
            // llvm::errs() << "Debug: Operand 1 expression: " << expr1.getBitwidth() << " ";
            // op1->print(llvm::errs(), false);
            // llvm::errs() << "\n";
            
            auto cmpInst = llvm::cast<llvm::ICmpInst>(&I);
            switch (cmpInst->getPredicate()) {
                case llvm::CmpInst::ICMP_EQ:
                    return SymbolicExpr::eq(expr0, expr1);
                case llvm::CmpInst::ICMP_NE:
                    return SymbolicExpr::ne(expr0, expr1);
                case llvm::CmpInst::ICMP_ULT:
                    return SymbolicExpr::ult(expr0, expr1);
                case llvm::CmpInst::ICMP_ULE:
                    return SymbolicExpr::ule(expr0, expr1);
                case llvm::CmpInst::ICMP_UGT:
                    return SymbolicExpr::ugt(expr0, expr1);
                case llvm::CmpInst::ICMP_UGE:
                    return SymbolicExpr::uge(expr0, expr1);
                case llvm::CmpInst::ICMP_SLT:
                    return SymbolicExpr::slt(expr0, expr1);
                case llvm::CmpInst::ICMP_SLE:
                    return SymbolicExpr::sle(expr0, expr1);
                case llvm::CmpInst::ICMP_SGT:
                    return SymbolicExpr::sgt(expr0, expr1);
                case llvm::CmpInst::ICMP_SGE:
                    return SymbolicExpr::sge(expr0, expr1);
                default: {
                    llvm::errs() << "Warning: inst2Expr ICmp unsupported predicate: " << cmpInst->getPredicate() << "\n";
                    return SEM.bvInst(I);
                }
            }
        }
        case llvm::Instruction::Select:{
            auto cond = I.getOperand(0);
            auto trueVal = I.getOperand(1);
            auto falseVal = I.getOperand(2);
            auto condExpr = value2Expr(*cond);
            auto trueExpr = value2Expr(*trueVal);
            auto falseExpr = value2Expr(*falseVal);
            return SymbolicExpr::select(condExpr, trueExpr, falseExpr);
        }
        case llvm::Instruction::AShr:{
            auto op0 = I.getOperand(0);
            auto op1 = I.getOperand(1);
            auto expr0 = value2Expr(*op0);
            auto expr1 = value2Expr(*op1);
            return SymbolicExpr::ashr(expr0, expr1);
        }
        case llvm::Instruction::Shl:{
            auto op0 = I.getOperand(0);
            auto op1 = I.getOperand(1);
            auto expr0 = value2Expr(*op0);
            auto expr1 = value2Expr(*op1);
            return SymbolicExpr::shl(expr0, expr1);
        }
        case llvm::Instruction::Trunc:{
            auto op = I.getOperand(0);
            auto expr = value2Expr(*op);
            unsigned targetBitwidth = I.getType()->getPrimitiveSizeInBits();
            unsigned srcBitwidth = expr.getBitwidth();
            if (targetBitwidth < srcBitwidth) {
                return expr.truncate(targetBitwidth);
            } else if (targetBitwidth == srcBitwidth) {
                return expr;
            } else {
                llvm::errs() << "Warning: Trunc target bitwidth greater than source bitwidth: "
                             << targetBitwidth << " > " << srcBitwidth << "\n";
                return SEM.bvInst(I);
            }
        }
        case llvm::Instruction::Freeze:{
            auto op = I.getOperand(0);
            return value2Expr(*op);
        }
        case llvm::Instruction::Call: {
            if (auto *call = llvm::dyn_cast<llvm::CallInst>(&I)) {
                return call2Expr(*call);
            }
            return SEM.bvInst(I);
        }
        default:
            llvm::errs() << "Warning: inst2Expr Unsupported instruction, assumed to return 1 " << I.getOpcodeName() ;
            I.print(llvm::errs());
            llvm::errs() << "\n";
            auto bitwidth = SEM.getBitWidth(I);
            return SEM.bvVal(1, bitwidth);

    }
    // return SEM.bvInst(I);
}

SymbolicExpr GA::value2Expr(const llvm::Value& V) {
    // V.print(llvm::errs(), false);
    // llvm::errs() << "\n";

    // constants
    unsigned bitwidth = SEM.getBitWidth(V);
    if (auto* constant = llvm::dyn_cast<llvm::ConstantInt>(&V)) {
        return SEM.bvVal(constant->getValue().getSExtValue(), bitwidth);
    }
    if (auto* constant = llvm::dyn_cast<llvm::ConstantFP>(&V)) {
        // For floating point, use realVal or convert to bv if needed
        return SEM.realVal(constant->getValueAPF().convertToDouble());
    }
    if (llvm::isa<llvm::Argument>(&V)) {
        return SEM.bvValue(V);
    }
    if (llvm::isa<llvm::ConstantPointerNull>(&V)) {
        return SEM.bvVal(0, bitwidth);
    }
    
    // expanded variable
    if (auto* instruction = llvm::dyn_cast<llvm::Instruction>(&V)) {
        if (isSolvable(const_cast<llvm::Value*>(&V))) {
            return inst2Expr(*instruction);
        }
        llvm::errs() << "Warning: value2Expr unsolvable: " << V.getName() << "\n";
    }
    llvm::errs() << "Warning: value2Expr Unsupported value type: " << V.getType()->getTypeID() << " for value: ";
    V.printAsOperand(llvm::errs(), false);
    llvm::errs() << "\n";
    return SEM.bvValue(V);
}

// expand the symbolic count to an expression that only uses program inputs
string GA::getExpandedSCEV(const llvm::SCEV* scev){
    if (!scev) {
        llvm::errs() << "Error: getExpandedSCEV: SCEV is null\n";
        return "unknown";
    }

    std::string scevStr;
    llvm::raw_string_ostream rso(scevStr);
    printRootExpr(*scev, rso);
    rso.flush();

    // Expand the SCEV to a string representation
    return scevStr;
}

void GA::printRootExpr(const llvm::SCEV& E, llvm::raw_ostream &os){
    // Print the SCEV expression, replacing internal variables with printExpanded,
    // keeping original operations and constants untouched.
    if (const llvm::SCEVUnknown* u = llvm::dyn_cast<llvm::SCEVUnknown>(&E)) {
        // Replace variable with expanded form
        printExpanded(const_cast<llvm::Value*>(u->getValue()), os);
    } else if (const llvm::SCEVConstant* c = llvm::dyn_cast<llvm::SCEVConstant>(&E)) {
        // Print constant as is
        c->getValue()->printAsOperand(os, false);
    } else {
        // Print operation name
        // Print the SCEV type as a string instead of integer
        switch (E.getSCEVType()) {
            case llvm::scConstant:              os << "scConst("; break;
            case llvm::scVScale:                os << "scVScale("; break;
            case llvm::scTruncate:              os << "scTrunc("; break;
            case llvm::scZeroExtend:            os << "scZeroExt("; break;
            case llvm::scSignExtend:            os << "scSignExt("; break;
            case llvm::scAddExpr:               os << "scAdd("; break;
            case llvm::scMulExpr:               os << "scMul("; break;
            case llvm::scUDivExpr:              os << "scUDiv("; break;
            case llvm::scAddRecExpr:            os << "scAddRecExpr("; break;
            case llvm::scUMaxExpr:              os << "scUMax("; break;
            case llvm::scSMaxExpr:              os << "scSMax("; break;
            case llvm::scUMinExpr:              os << "scUMin("; break;
            case llvm::scSMinExpr:              os << "scSMin("; break;
            case llvm::scSequentialUMinExpr:    os << "scSequentialUMin("; break;
            case llvm::scPtrToInt:              os << "scPtrToInt("; break;
            case llvm::scUnknown:               os << "scUnknown("; break;
            case llvm::scCouldNotCompute:       os << "scCouldNotCompute("; break;
            default:                            os << "scOtherSCEV("; break;
        }
        bool first = true;
        for (const llvm::SCEV* op : E.operands()) {
            if (!first) os << ", ";
            first = false;
            printRootExpr(*op, os);
        }
        os << ")";
    }
}

void GA::printExpanded(const llvm::Value* I, llvm::raw_ostream &os){
    if (!isSolvable(I)){
        I->printAsOperand(os, false);
        return;
    }
    //expand cases
    if(const llvm::Instruction* i = llvm::dyn_cast<llvm::Instruction>(I)){
        if (i->getOpcode() == llvm::Instruction::PHI){
            printExpandedPHI(i, os);
            return;
        }
        // Map LLVM opcodes to SCEV operator names (with parentheses for consistency)
        switch (i->getOpcode()) {
            case llvm::Instruction::Add:    os << "scAdd(";     break;
            case llvm::Instruction::Mul:    os << "scMul(";     break;
            case llvm::Instruction::Sub:    os << "scSub(";     break;
            case llvm::Instruction::UDiv:   os << "scUDiv(";    break;
            case llvm::Instruction::SDiv:   os << "scSDiv(";    break;
            case llvm::Instruction::URem:   os << "scURem(";    break;
            case llvm::Instruction::SRem:   os << "scSRem(";    break;
            case llvm::Instruction::Shl:    os << "scShl(";     break;
            case llvm::Instruction::LShr:   os << "scLShr(";    break;
            case llvm::Instruction::AShr:   os << "scAShr(";    break;
            case llvm::Instruction::And:    os << "scAnd(";     break;
            case llvm::Instruction::Or:     os << "scOr(";      break;
            case llvm::Instruction::Xor:    os << "scXor(";     break;
            case llvm::Instruction::Trunc:  os << "scTrunc(";   break;
            case llvm::Instruction::ZExt:   os << "scZeroExt("; break;
            case llvm::Instruction::SExt:   os << "scSignExt("; break;
            default:
            os << "scOtherSCEV(";
            break;
        }
        bool first = true;
        for (const llvm::Use& opr : i->operands()) {
            if (!first) os << ", ";
            first = false;
            printExpanded(llvm::dyn_cast<llvm::Value>(opr.get()), os);
        }
        os << ")";
    }
    //basic cases
    else{
        I->printAsOperand(os, false);
    }
}

void GA::printExpandedPHI(const llvm::Value* I, llvm::raw_ostream & os){
    if (!I) {
        llvm::errs() << "Error: printExpandedPHI: Value is null\n";
        os << "unknown";
        return;
    }
    const llvm::PHINode* phi = llvm::dyn_cast<llvm::PHINode>(I);
    if (!phi) {
        llvm::errs() << "Error: printExpandedPHI: Not a PHI node\n";
        os << "unknown";
        return;
    }
    os << "scAdd(";
    for (unsigned i = 0; i < phi->getNumIncomingValues(); ++i) {
        if (i > 0) os << ", ";
        llvm::BasicBlock* incomingBB = phi->getIncomingBlock(i);
        const llvm::BasicBlock* currentBB = phi->getParent();
        llvm::Value* incomingVal = phi->getIncomingValue(i);
        if (auto baseFactor = getFactor(incomingBB, currentBB)) {
            os << "scMul(";
            os << baseFactor->str() << ", ";
            printExpanded(incomingVal, os);
            os << ")";
        } else {
            llvm::errs() << "printExpandedPHI: no TR expression for phi: ";
            phi->printAsOperand(llvm::errs(), false);
            llvm::errs() << " from basic block: " << GraphBuilder::getName(incomingBB) << "\n";
            phi->printAsOperand(os, false);
            os << "unknown";
        }
    }
    os << ")";
}

bool GA::isSolvableExitValue(const llvm::Value* v, const llvm::BasicBlock* from, const llvm::BasicBlock* to){
    
    //check if from belongs to a loop and to is outside the loop 
    if (!v || !from || !to) return false;
    llvm::Loop* loop = LI.getLoopFor(const_cast<llvm::BasicBlock*>(from));
    if (!loop) return false;
    if (loop->contains(const_cast<llvm::BasicBlock*>(to))) return false;

    // check if SCEV can compute the exit value of v at the loop exit
    llvm::ScalarEvolution *SE = &this->SE;
    if (!SE) return false;

    const llvm::SCEV* scev = SE->getSCEVAtScope(const_cast<llvm::Value*>(v), loop->getParentLoop());
    if (llvm::isa<llvm::SCEVCouldNotCompute>(scev)) {
        return false;
    }
    return true;
}

llvm::SCEV* GA::getExitValueSCEV(const llvm::Value* v, const llvm::BasicBlock* from, const llvm::BasicBlock* to){
    if (!v || !from || !to) return nullptr;

    llvm::Loop* loop = LI.getLoopFor(const_cast<llvm::BasicBlock*>(from));
    if (!loop) return nullptr;
    if (loop->contains(const_cast<llvm::BasicBlock*>(to))) return nullptr;

    llvm::ScalarEvolution *SE = &this->SE;
    if (!SE) return nullptr;

    const llvm::SCEV* scev = SE->getSCEVAtScope(const_cast<llvm::Value*>(v), loop->getParentLoop());
    if (llvm::isa<llvm::SCEVCouldNotCompute>(scev)) {
        return nullptr;
    }
    return const_cast<llvm::SCEV*>(scev);
}

bool GA::isSolvable(const llvm::Value* v){
    if (!v) return false;
    std::set<const llvm::Value*> visited;
    std::set<const llvm::Value*> recStack;

    std::function<bool(const llvm::Value*)> hasCircularDependency = [&](const llvm::Value* V) -> bool {
        
        if (recStack.count(V)) return true;
        if (visited.count(V)) return false;

        visited.insert(V);
        recStack.insert(V);

        if (auto *phi = llvm::dyn_cast<llvm::PHINode>(V)) {
            for (unsigned i = 0; i < phi->getNumIncomingValues(); ++i) {
                // handle outsider induction variables whose values can be computed through SCEV
                if(isSolvableExitValue(phi->getIncomingValue(i), phi->getIncomingBlock(i), phi->getParent())){
                    continue;
                }

                if (hasCircularDependency(phi->getIncomingValue(i)))
                    return true;
            }
        }
        else if (auto *I = llvm::dyn_cast<llvm::Instruction>(V)) {
            for (auto &Op : I->operands()) {
                if (hasCircularDependency(Op.get()))
                    return true;
            }
        } 

        recStack.erase(V);
        return false;
    };

    return !hasCircularDependency(v);
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
        os << input.str() << " ";
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
    os << pad << "Count: " << (BB ? BB->count.str() : "N/A") << "\n";
}

void GraphViewer::showBranch(shared_ptr<Branch> BR, std::ostream& os, int indent) {
    std::string pad(indent, ' ');
    if (!BR) {
        os << pad << "Branch is null\n";
        return;
    }

    os << pad << "Branch: " << BR->name << "\n";
    os << pad << "True Ratio: " << BR->trueRatioNum.str() << " / " << BR->trueRatioDen.str() << "\n";
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
    os << pad << "Loop Count: " << L->loopCount.str() << "\n";
    os << pad << "Head Graph:\n";
    showBasicGraph(L->head, os, indent + 2);
    os << pad << "Body Graph:\n";
    showGraph(L->Gb, os, indent + 2);
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

void GraphViewer::showProgramAsJson(shared_ptr<Program> program, std::ostream& os) {
    if (!program) {
        os << "{}\n";
        return;
    }
    
    nlohmann::json j;
    j["inputs"] = nlohmann::json::array();
    for (const auto& input : program->inputs) {
        j["inputs"].push_back(input.str());
    }

    j["graph"] = program->G ? GraphViewer::graphToJson(program->G) : nlohmann::json::object();

    os << j.dump(4) << "\n";
}

void GraphViewer::showGraphAsJson(shared_ptr<Graph> G, std::ostream& os) {
    if (!G) {
        os << "{}\n";
        return;
    }

    nlohmann::json j = graphToJson(G);
    os << j.dump(4) << "\n";
}

void GraphViewer::showBasicGraphAsJson(shared_ptr<BasicGraph> BG, std::ostream& os) {
    if (!BG) {
        os << "{}\n";
        return;
    }

    nlohmann::json j = basicGraphToJson(BG);
    os << j.dump(4) << "\n";
}

void GraphViewer::showBasicBlockAsJson(shared_ptr<BasicBlock> BB, std::ostream& os) {
    if (!BB) {
        os << "{}\n";
        return;
    }
    
    nlohmann::json j = basicBlockToJson(BB);
    os << j.dump(4) << "\n";
}

void GraphViewer::showBranchAsJson(shared_ptr<Branch> BR, std::ostream& os) {
    if (!BR) {
        os << "{}\n";
        return;
    }

    nlohmann::json j = branchToJson(BR);
    os << j.dump(4) << "\n";
}

void GraphViewer::showLoopAsJson(shared_ptr<Loop> L, std::ostream& os) {
    if (!L) {
        os << "{}\n";
        return;
    }

    nlohmann::json j = loopToJson(L);
    os << j.dump(4) << "\n";
}


void GraphViewer::showAllBasicGraphsAsJson(shared_ptr<Program> program, std::ostream& os) {
    if (!program || !program->G) {
        os << "{}\n";
        return;
    }

    std::vector<shared_ptr<BasicGraph>> allBasicGraphs;
    getAllBasicGraphs(program, allBasicGraphs);
    if (allBasicGraphs.empty()) {
        os << "{}\n";
        return;
    }

    nlohmann::json j;
    j["args"] = nlohmann::json::array();
    for (const auto& input : program->inputs) {
        j["args"].push_back(input.str());
    }
    j["basic_graphs"] = nlohmann::json::array();
    for (const auto& bg : allBasicGraphs) {
        if (bg) {
            j["basic_graphs"].push_back(basicGraphToJson(bg));
        }
    }
    os << j.dump(4) << "\n";
}

nlohmann::json GraphViewer::programToJson(shared_ptr<Program> program) {
    nlohmann::json j;
    if (!program) {
        return j; // return empty json
    }

    j["inputs"] = nlohmann::json::array();
    for (const auto& input : program->inputs) {
        j["inputs"].push_back(input.str());
    }

    j["graph"] = program->G ? graphToJson(program->G) : nlohmann::json::object();

    return j;
}

nlohmann::json GraphViewer::graphToJson(shared_ptr<Graph> G) {
    nlohmann::json j;
    if (!G) {
        return j; // return empty json
    }

    j["id"] = G->id;
    j["basic_graph"] = basicGraphToJson(G->BG);
    j["next_graph"] = G->G ? graphToJson(G->G) : nlohmann::json::object();

    return j;
}

nlohmann::json GraphViewer::basicGraphToJson(shared_ptr<BasicGraph> BG) {
    nlohmann::json j;
    if (!BG) {
        return j; // return empty json
    }

    j["id"] = BG->id;
    j["name"] = BG->name;
    j["count"] = BG->count.str();
    // Map GraphType enum to string for JSON output
    switch (BG->getGraphType()) {
        case GraphType::BasicBlock:
            j["graph_type"] = "BasicBlock";
            break;
        case GraphType::Branch:
            j["graph_type"] = "Branch";
            break;
        case GraphType::Loop:
            j["graph_type"] = "Loop";
            break;
        default:
            j["graph_type"] = "Unknown";
            break;
    }

    return j;
}

nlohmann::json GraphViewer::basicBlockToJson(shared_ptr<BasicBlock> BB) {
    nlohmann::json j;
    if (!BB) {
        return j; // return empty json
    }

    j["id"] = BB->id;
    j["name"] = BB->name;
    j["count"] = BB->count.str();
    j["graph_type"] = "BasicBlock";

    return j;
}

nlohmann::json GraphViewer::branchToJson(shared_ptr<Branch> BR) {
    nlohmann::json j;
    if (!BR) {
        return j; // return empty json
    }

    j["id"] = BR->id;
    j["name"] = BR->name;
    j["true_ratio"] = { {"num", BR->trueRatioNum.str()}, {"den", BR->trueRatioDen.str()} };
    j["false_ratio"] = { {"num", BR->falseRatioNum.str()}, {"den", BR->falseRatioDen.str()} };
    j["G1"] = BR->G1 ? graphToJson(BR->G1) : nlohmann::json::object();
    j["G2"] = BR->G2 ? graphToJson(BR->G2) : nlohmann::json::object();
    j["graph_type"] = "Branch";

    return j;
}

nlohmann::json GraphViewer::loopToJson(shared_ptr<Loop> L) {
    nlohmann::json j;
    if (!L) {
        return j; // return empty json
    }

    j["id"] = L->id;
    j["name"] = L->name;
    j["loop_count"] = L->loopCount.str();
    j["head"] = basicGraphToJson(L->head);
    j["Gb"] = L->Gb ? graphToJson(L->Gb) : nlohmann::json::object();
    j["graph_type"] = "Loop";

    return j;
}

void GraphViewer::getAllBasicGraphs(shared_ptr<Program> P, std::vector<shared_ptr<BasicGraph>>& collection) {
    if (!P || !P->G) return;

    getAllBasicGraphs(P->G, collection);
}

void GraphViewer::getAllBasicGraphs(shared_ptr<Graph> G,vector<shared_ptr<BasicGraph>>& collection) {
    if (!G->BG) return;

    GraphViewer::getAllBasicGraphs(G->BG, collection);
    if (G->G) {
        GraphViewer::getAllBasicGraphs(G->G, collection);
    }
}

void GraphViewer::getAllBasicGraphs(shared_ptr<BasicGraph> BG, vector<shared_ptr<BasicGraph>>& collection) {
    switch (BG->getGraphType()) {
        case GraphType::BasicBlock: {
            collection.push_back(BG);
            break;
        }
        case GraphType::Branch: {
            auto branch = static_pointer_cast<Branch>(BG);
            collection.push_back(branch);
            if (branch->G1) {
                getAllBasicGraphs(branch->G1, collection);
            }
            if (branch->G2) {
                getAllBasicGraphs(branch->G2, collection);
            }
            break;
        }
        case GraphType::Loop: {
            auto loop = static_pointer_cast<Loop>(BG);
            collection.push_back(loop);
            if (loop->head) {
                getAllBasicGraphs(loop->head, collection);
            }
            if (loop->Gb) {
                getAllBasicGraphs(loop->Gb, collection);
            }
            break;
        }
        default:
            llvm::errs() << "Error: GraphViewer::getAllBasicGraphs: Unknown graph type for BasicGraph: " << BG->id << "\n";
    }
}
