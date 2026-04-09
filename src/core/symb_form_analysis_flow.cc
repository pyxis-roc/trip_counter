#include "symb_form.hpp"

#include "llvm/Support/raw_ostream.h"

#include <utility>
#include <vector>

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
    baseFactor.emplace(p, std::move(factor));
}

// returns all the basic graphs at the end of current graph,
// which are used to connect the previous end with the next start
vector<shared_ptr<BasicGraph>> GA::traverse(shared_ptr<Graph> G){
    if (!G) return{};

    auto last1 = traverse(G->BG);
    auto last2 = traverse(G->G);

    if(G->G){   // connect to next start
        auto totalCount = G->BG->count;
        auto distributedCount = SEM.bvVal(0, 64);
        bool needInfer = false;

        for(auto prev : last1){
            if (prev == G->BG){
                needInfer = true;
                continue;       // that means the count is not distributed, which can not represent portion
            }
            addFactor(graph2bb[prev], graph2bb[G->G->BG], G->BG->count);
            distributedCount = distributedCount + G->BG->count;
        }
        if (needInfer){
            // there is a portion that is directly exported from the head
            auto inferredCount = totalCount - distributedCount;
            addFactor(graph2bb[G->BG], graph2bb[G->G->BG], inferredCount);
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
            last.emplace_back(BG);
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
                last.emplace_back(BG);
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
                vector<SymbolicExpr> originals;
                vector<SymbolicExpr> withs;
                originals.reserve(2);
                withs.reserve(2);
                originals.emplace_back(branch->trueRatioNum);
                withs.emplace_back(std::move(trNum));
                originals.emplace_back(branch->trueRatioDen);
                withs.emplace_back(std::move(trDen));
                update(branch, originals, withs);
            }
            break;
        }
        case GraphType::Loop: {
            auto loop = std::static_pointer_cast<Loop>(BG);
            refine(loop->head);
            refine(loop->Gb);
            if(auto LCexpanded = getLoopCount(LI.getLoopFor(graph2bb[loop]))){
                vector<SymbolicExpr> originals;
                vector<SymbolicExpr> withs;
                originals.reserve(1);
                withs.reserve(1);
                originals.emplace_back(loop->loopCount);
                withs.emplace_back(LCexpanded.value());
                update(loop, originals, withs);
            }
            break;
        }
        case GraphType::Unknown:
            // Do nothing for unknown graph type
            break;
    }
}

void GA::update(shared_ptr<Graph> G, const pair<SymbolicExpr, SymbolicExpr>& subs){
    if(!G) return;

    update(G->BG, subs);
    update(G->G, subs);
}

void GA::update(shared_ptr<BasicGraph> BG, const pair<SymbolicExpr, SymbolicExpr>& subs){
    if(! BG) return;

    const auto& original = subs.first;
    const auto& updated = subs.second;

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

void GA::update(shared_ptr<Graph> G, const vector<SymbolicExpr>& originals, const vector<SymbolicExpr>& withs){
    if(!G) return;

    update(G->BG, originals, withs);
    update(G->G, originals, withs);
}

void GA::update(shared_ptr<BasicGraph> BG, const vector<SymbolicExpr>& originals, const vector<SymbolicExpr>& withs){
    if(!BG) return;
    if (originals.size() != withs.size()) return;

    for (size_t i = 0; i < originals.size(); ++i) {
        BG->count.substitute(originals[i], withs[i]);
    }
    BG->count.simplify();

    switch (BG->getGraphType()) {
        case GraphType::BasicBlock:
            break;
        case GraphType::Branch: {
            auto branch = std::static_pointer_cast<Branch>(BG);
            for (size_t i = 0; i < originals.size(); ++i) {
                branch->trueRatioNum.substitute(originals[i], withs[i]);
                branch->trueRatioDen.substitute(originals[i], withs[i]);
                branch->falseRatioNum.substitute(originals[i], withs[i]);
                branch->falseRatioDen.substitute(originals[i], withs[i]);
            }
            update(branch->G1, originals, withs);
            update(branch->G2, originals, withs);
            break;
        }
        case GraphType::Loop: {
            auto loop = std::static_pointer_cast<Loop>(BG);
            for (size_t i = 0; i < originals.size(); ++i) {
                loop->loopCount.substitute(originals[i], withs[i]);
            }
            update(loop->head, originals, withs);
            update(loop->Gb, originals, withs);
            break;
        }
        case GraphType::Unknown:
            break;
    }
}
