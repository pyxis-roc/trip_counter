#include "symb_form.hpp"
#include "nlohmann/json_fwd.hpp"
#include "printer.hpp"
#include "utils.hpp"
#include "llvm/Analysis/LoopInfo.h"
#include "llvm/Analysis/ScalarEvolution.h"
#include "llvm/Support/raw_ostream.h"
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

    auto type = getGraphType(startBB, endBB);
    auto nextHead = nextGraphHead(type, startBB);

    switch (type) {
        case GraphType::BasicBlock:
            return createBasicBlock(BG, startBB, nextHead);
        case GraphType::Branch:
            return createBranch(BG, startBB, nextHead);
        case GraphType::Loop:
            return createLoop(BG, startBB, nextHead);
        default:
            llvm::errs() << "Error: GraphBuilder::createBasicGraph: Unknown graph type for block " << name << "\n";
            return nullptr;
    }
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

shared_ptr<BasicGraph> GraphBuilder::getLoopHeadGraph(shared_ptr<Symbol> initCount, 
        llvm::BasicBlock* startBB, llvm::BasicBlock* endBB){
    
    auto loop = LI.getLoopFor(startBB);
    if (!loop){
        llvm::errs() << "Error: GraphBuilder::getLoopHeadGraph: it is not a loop\n";
        return nullptr;
    }

    auto bodyCount = getLoopCount(loop);
    shared_ptr<Symbol> count;
    if(isHeaderExiting(loop)){
        // header exiting, header is executed one more time than body
        count = bodyCount->addOne()->multiply(initCount);
    }
    else{
        // tail exiting, both header and body execute the same time
        count = bodyCount->multiply(initCount);
    }

    auto BG = make_shared<BasicGraph>(
        getBlockID(startBB),
        getName(startBB),
        count
    );

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
    
    auto headGraph = getLoopHeadGraph(incoming_count, startBB, exitBlock);
    auto headType = headGraph->getGraphType();

    auto bodyStart = nextGraphHead(headType, startBB);
    auto bodyEnd = isHeaderExiting(loop) ? startBB : exitBlock;
    auto bodyCount = getLoopCount(loop);
    auto Gb = createGraph(bodyCount->multiply(incoming_count), 
    bodyStart, bodyEnd);
    
    return make_shared<Loop>(
        Loop(
            BG, 
            bodyCount, 
            headGraph,
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

void GraphViewer::showProgramAsJson(shared_ptr<Program> program, std::ostream& os) {
    if (!program) {
        os << "{}\n";
        return;
    }
    
    nlohmann::json j;
    j["inputs"] = nlohmann::json::array();
    for (const auto& input : program->inputs) {
        j["inputs"].push_back(input->literal);
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
        j["args"].push_back(input->literal);
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
        j["inputs"].push_back(input->literal);
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
    j["count"] = BG->count ? BG->count->literal : "N/A";
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
    j["count"] = BB->count ? BB->count->literal : "N/A";
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
    j["true_ratio"] = BR->trueRatio ? BR->trueRatio->literal : "N/A";
    j["false_ratio"] = BR->falseRatio ? BR->falseRatio->literal : "N/A";
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
    j["loop_count"] = L->loopCount ? L->loopCount->literal : "N/A";
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