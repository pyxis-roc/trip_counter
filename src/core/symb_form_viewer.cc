#include "symb_form.hpp"

#include "llvm/Support/raw_ostream.h"

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
    showGraph(G->G, os, indent);
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
        return j;
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
        return j;
    }

    j["id"] = G->id;
    j["basic_graph"] = basicGraphToJson(G->BG);
    j["next_graph"] = G->G ? graphToJson(G->G) : nlohmann::json::object();

    return j;
}

nlohmann::json GraphViewer::basicGraphToJson(shared_ptr<BasicGraph> BG) {
    nlohmann::json j;
    if (!BG) {
        return j;
    }

    j["id"] = BG->id;
    j["name"] = BG->name;
    j["count"] = BG->count.str();
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
        return j;
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
        return j;
    }

    j["id"] = BR->id;
    j["name"] = BR->name;
    j["true_ratio"] = {{"num", BR->trueRatioNum.str()}, {"den", BR->trueRatioDen.str()}};
    j["false_ratio"] = {{"num", BR->falseRatioNum.str()}, {"den", BR->falseRatioDen.str()}};
    j["G1"] = BR->G1 ? graphToJson(BR->G1) : nlohmann::json::object();
    j["G2"] = BR->G2 ? graphToJson(BR->G2) : nlohmann::json::object();
    j["graph_type"] = "Branch";

    return j;
}

nlohmann::json GraphViewer::loopToJson(shared_ptr<Loop> L) {
    nlohmann::json j;
    if (!L) {
        return j;
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
