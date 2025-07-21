#include "symb_form.hpp"
#include "nlohmann/json_fwd.hpp"
#include "utils.hpp"
#include "llvm/Analysis/LoopInfo.h"
#include "llvm/Analysis/ScalarEvolution.h"
#include "llvm/IR/Instructions.h"
#include "llvm/IR/Value.h"
#include "llvm/Support/raw_ostream.h"
#include <llvm/IR/BasicBlock.h>
#include "llvm/Analysis/ScalarEvolutionExpressions.h"
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

bool Symbol::substitude(string original, string with){
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

void GraphBuilder::record(shared_ptr<BasicGraph> graph, llvm::BasicBlock* bb){
    if (graph2bb.find(graph) == graph2bb.end()){
        graph2bb[graph] = bb;
    }
}

shared_ptr<Program> GraphBuilder::createProgram(llvm::Function * F){

    auto args = F->arg_begin();
    auto argList = std::vector<SymbolicExpr>();
    for (; args != F->arg_end(); ++args) {
        auto argName = getName(args);
        auto symbol = SEM.named(argName);
        argList.push_back(symbol);
    }

    auto graph = createGraph(SEM.one(), &F->getEntryBlock());
    auto P = std::make_shared<Program>(Program(argList, graph));
    Analysis a(LI, SE, SEM, P, graph2bb);
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

    auto graph = make_shared<BasicBlock>(BasicBlock(BG));
    record(graph, startBB);
    return graph;
}

shared_ptr<Branch> GraphBuilder::createBranch(std::shared_ptr<BasicGraph> BG, 
        llvm::BasicBlock* startBB, llvm::BasicBlock* endBB){

    if (!startBB || startBB == endBB) return nullptr;

    auto trueRatio_literal = "TR_" + getName(startBB);
    auto trueRatio = SEM.named(trueRatio_literal);
    auto falseRatio = SEM.one() - trueRatio;

    auto incoming_count = BG->count;
    auto trueSide = startBB->getTerminator()->getSuccessor(0);
    auto falseSide = startBB->getTerminator()->getSuccessor(1);
    auto G1 = createGraph(trueRatio * incoming_count, trueSide, endBB);
    auto G2 = createGraph(falseRatio * incoming_count, falseSide, endBB);

    auto graph = make_shared<Branch>(
        Branch(
            BG, 
            trueRatio, 
            falseRatio, 
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
    auto bodyCount = SEM.named("LC_" + getName(loop));
    
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

using GA = GraphBuilder::Analysis;

void GA::prepareBaseFactor(shared_ptr<Program>P){
    vector<shared_ptr<BasicGraph>> stack{nullptr};
    traverse(P->G, stack);
}

optional<SymbolicExpr> GA::getFactor(llvm::BasicBlock* from, llvm::BasicBlock* to){
    auto p = make_pair(from, to);
    return baseFactor.at(p);
}

void GA::addFactor(llvm::BasicBlock* from, llvm::BasicBlock* to, SymbolicExpr factor){
    auto p = make_pair(from, to);
    baseFactor.emplace(p, factor);
}

void GA::traverse(shared_ptr<Graph> G, vector<shared_ptr<BasicGraph>>& stack){
    if (!G) return;

    traverse(G->BG, stack);
    traverse(G->G, stack);
}

void GA::traverse(shared_ptr<BasicGraph> BG, vector<shared_ptr<BasicGraph>>& stack){
    if(!BG) return;
    
    auto prev = stack.back();
    
    addFactor(graph2bb[prev], graph2bb[BG], BG->count);    //add connection from prev to current

    switch (BG->getGraphType()) {
        case GraphType::BasicBlock:
            stack.push_back(BG);
            // No further traversal needed for BasicBlock
            break;
        case GraphType::Branch: {
            auto branch = std::static_pointer_cast<Branch>(BG);
            stack.push_back(BG);
            traverse(branch->G1, stack);
            stack.push_back(BG);
            traverse(branch->G2, stack);
            break;
        }
        case GraphType::Loop: {
            auto loop = std::static_pointer_cast<Loop>(BG);
            stack.push_back(BG);
            traverse(loop->head, stack);
            traverse(loop->Gb, stack);
            break;
        }
        case GraphType::Unknown:
            // Do nothing for unknown graph type
            break;
    }

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
                // llvm::errs() << branch->trueRatio.str() << '\n';
                // llvm::errs() << TRexpanded->str() << '\n';
                // update(branch, make_pair(branch->trueRatio->literal, TRexpanded->literal));
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
    
    BG->count.substitude(original, updated);

    switch (BG->getGraphType()) {
        case GraphType::BasicBlock:
            break;
        case GraphType::Branch: {
            auto branch = std::static_pointer_cast<Branch>(BG);
            branch->trueRatio.substitude(original, updated);
            branch->falseRatio.substitude(original, updated);
            update(branch->G1, subs);
            update(branch->G2, subs);
            break;
        }
        case GraphType::Loop: {
            auto loop = std::static_pointer_cast<Loop>(BG);
            loop->loopCount.substitude(original, updated);
            update(loop->head, subs);
            update(loop->Gb, subs);
            break;
        }
        case GraphType::Unknown:
            // Do nothing for unknown graph type
            break;
    }
}

optional<SymbolicExpr> GA::getTrueRatio(llvm::BasicBlock* bb){
    if (!bb) {
        llvm::errs() << "Error: getTrueRatio: BasicBlock is null\n";
        return std::nullopt;
    }
    llvm::Instruction* term = bb->getTerminator();
    if (!term) {
        llvm::errs() << "Error: getTrueRatio: Terminator is null for block " << GraphBuilder::getName(bb) << "\n";
        return std::nullopt;
    }
    if (!isSolvable(term)) {
        llvm::errs() << "Warning: getTrueRatio: Terminator not solvable for block " << GraphBuilder::getName(bb) << "\n";
        return std::nullopt;
    }

    std::string name;
    llvm::raw_string_ostream rso(name);
    printExpanded(term, rso);
    rso.flush();
    return SEM.named("TR_" + name);
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
        return SEM.named(loopCount_literal);
    }

    // SCEV gives backedge count, but we want trip count = backedge count + 1
    return SEM.fromSCEV(*backedgeCount) + SEM.one();
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

void GA::printExpanded(llvm::Value* I, llvm::raw_ostream &os){
    if (!isSolvable(I)){
        I->printAsOperand(os, false);
        return;
    }
    //expand cases
    if(llvm::Instruction* i = llvm::dyn_cast<llvm::Instruction>(I)){
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
        for (llvm::Use& opr : i->operands()) {
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

void GA::printExpandedPHI(llvm::Value* I, llvm::raw_ostream & os){
    if (!I) {
        llvm::errs() << "Error: printExpandedPHI: Value is null\n";
        os << "unknown";
        return;
    }
    llvm::PHINode* phi = llvm::dyn_cast<llvm::PHINode>(I);
    if (!phi) {
        llvm::errs() << "Error: printExpandedPHI: Not a PHI node\n";
        os << "unknown";
        return;
    }
    os << "scAdd(";
    for (unsigned i = 0; i < phi->getNumIncomingValues(); ++i) {
        if (i > 0) os << ", ";
        llvm::BasicBlock* incomingBB = phi->getIncomingBlock(i);
        llvm::BasicBlock* currentBB = phi->getParent();
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

bool GA::isSolvable(llvm::Value* v){
    if (!v) return false;
    std::set<llvm::Value*> visited;
    std::set<llvm::Value*> recStack;

    std::function<bool(llvm::Value*)> hasCircularDependency = [&](llvm::Value* V) -> bool {
        if (recStack.count(V)) return true;
        if (visited.count(V)) return false;

        visited.insert(V);
        recStack.insert(V);

        if (auto *I = llvm::dyn_cast<llvm::Instruction>(V)) {
            for (auto &Op : I->operands()) {
                if (hasCircularDependency(Op.get()))
                    return true;
            }
        } else if (auto *phi = llvm::dyn_cast<llvm::PHINode>(V)) {
            for (unsigned i = 0; i < phi->getNumIncomingValues(); ++i) {
                if (hasCircularDependency(phi->getIncomingValue(i)))
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
    os << pad << "True Ratio: " << BR->trueRatio.str() << "\n";
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
    j["true_ratio"] = BR->trueRatio.str();
    j["false_ratio"] = BR->falseRatio.str();
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
