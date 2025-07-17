/*
    This file contains two parts:

    -first part defines the graph structure for symbolic counting
    
    -second part defines the graph builder that builds the graph structure
        from a llvm control flow graph    
*/

#pragma once

#include "llvm/IR/Argument.h"
#include "llvm/IR/BasicBlock.h"
#include "llvm/IR/Function.h"
#include <map>
#include <memory>
#include <set>
#include <string>
#include <vector>
#include <iostream>
#include <nlohmann/json.hpp>


using namespace std;

// symbolic execution count
class Symbol{
public:
    string literal;
    Symbol(string literal) : literal(literal) {}

    shared_ptr<Symbol> multiply(const shared_ptr<Symbol>& other) const;
    shared_ptr<Symbol> subtract(const shared_ptr<Symbol>& other) const;
    shared_ptr<Symbol> add(const shared_ptr<Symbol>& other) const;
    shared_ptr<Symbol> addOne() const;

    static shared_ptr<Symbol> one();

    bool substitude(string original, string with);

    void show(std::ostream& os = std::cout) const;
};

class Graph;
class BasicGraph;

class Program{
public:
    vector<shared_ptr<Symbol>> inputs;
    shared_ptr<Graph> G;

    Program(vector<shared_ptr<Symbol>> inputs, shared_ptr<Graph> G)
        : inputs(inputs), G(G) {}
        
};

/*
    ⟨𝐺⟩ ::= ⟨𝐵𝐺⟩ | ⟨𝐵𝐺⟩ ⟨𝐺⟩
    ⟨𝐵𝐺⟩ ::= ⟨𝐵𝐵⟩ | ⟨𝐵𝑅⟩ | ⟨𝐴𝐿⟩ | ⟨𝐺𝐿⟩
    ⟨𝐵𝐵⟩ ::= stmts
    ⟨𝐵𝑅⟩ ::= if (𝐶) ⟨𝐺1⟩, ⟨𝐺2⟩
    ⟨𝐴𝐿⟩ ::= from 𝑆 to 𝐸 in 𝐾 for ⟨𝐺𝑏⟩, ⟨𝐺𝑒⟩
    ⟨𝐺𝐿⟩ ::= while (𝑁) ⟨𝐺𝑏⟩, ⟨𝐺𝑒⟩
*/

class BasicGraph;

class Graph{
public:
    string id;
    shared_ptr<BasicGraph> BG;
    shared_ptr<Graph> G;

    Graph(std::string id, std::shared_ptr<BasicGraph> BG, std::shared_ptr<Graph> G)
        : id(id), BG(BG), G(G) {}
    Graph(std::string id, std::shared_ptr<BasicGraph> BG)
        : id(id), BG(BG), G(nullptr) {}
    Graph(std::string id)
        : id(id), BG(nullptr), G(nullptr) {}
    
};


class BasicBlock;
class Branch;
class Loop;

enum class GraphType{
    BasicBlock, // a single basic block
    Branch,     // a branch with two subgraphs
    Loop,       // a loop with a body and an exit
    Unknown     // unknown graph type
};

class BasicGraph{
public:
    string id;
    string name;
    shared_ptr<Symbol> count;

    BasicGraph(std::string id, std::string name, std::shared_ptr<Symbol> count)
        : id(id), name(name), count(count) {}
    BasicGraph(std::string id, std::string name)
        : id(id), name(name), count(make_shared<Symbol>("1")) {} // default count is 1

    // subclass type check
    virtual GraphType getGraphType() const{
        return GraphType::Unknown;
    }
};


class BasicBlock : public BasicGraph{
public:
    BasicBlock(shared_ptr<BasicGraph> BG)
        : BasicGraph(BG->id, BG->name, BG->count) {}
    
    GraphType getGraphType() const override {
        return GraphType::BasicBlock;
    }
};


class Branch : public BasicGraph{
public:
    shared_ptr<Symbol> trueRatio;
    shared_ptr<Symbol> falseRatio;
    shared_ptr<Graph> G1;
    shared_ptr<Graph> G2;

    Branch(shared_ptr<BasicGraph> BG, std::shared_ptr<Symbol> trueRatio, 
            std::shared_ptr<Symbol> falseRatio, std::shared_ptr<Graph> G1, 
            std::shared_ptr<Graph> G2): 
        BasicGraph(BG->id, BG->name, BG->count), 
        trueRatio(trueRatio),
        falseRatio(falseRatio), 
        G1(G1),
        G2(G2){}
    
    GraphType getGraphType() const override {
        return GraphType::Branch;
    }
};

class Loop : public BasicGraph{
public:
    shared_ptr<Symbol> loopCount;
    shared_ptr<BasicGraph> head; // the loop head basic block sometimes have different execution count to the body
    shared_ptr<Graph> Gb;

    Loop(shared_ptr<BasicGraph> BG, std::shared_ptr<Symbol> loopCount, std::shared_ptr<BasicGraph> head, 
            std::shared_ptr<Graph> Gb): 
        BasicGraph(BG->id, BG->name, BG->count), 
        loopCount(loopCount), 
        head(head),
        Gb(Gb) {}
    
    GraphType getGraphType() const override {
        return GraphType::Loop;
    }
};


// class to build a graph from llvm control flow graph
#include "llvm/Analysis/LoopInfo.h"
#include "llvm/Analysis/ScalarEvolution.h"
#include "llvm/Analysis/PostDominators.h"

class GraphBuilder{
public:
    llvm::LoopInfo& LI;
    llvm::PostDominatorTree& PDT;
    llvm::ScalarEvolution& SE;
    
    // map basicblock to the twin BasicGraph
    std::map<shared_ptr<BasicGraph>, llvm::BasicBlock*> graph2bb;
    void record(shared_ptr<BasicGraph>, llvm::BasicBlock*);

    GraphBuilder(llvm::LoopInfo& LI, llvm::PostDominatorTree& PDT, llvm::ScalarEvolution& SE) 
        : LI(LI), PDT(PDT), SE(SE) {}

    // create a program from llvm function class
    shared_ptr<Program> createProgram(llvm::Function*);

    // create a graph rooted at BB
    //     startBB: the starting basic block of the graph 
    //     endBB: the (first) basic block that is not included in the graph,
    //            it can be nullptr, which means the graph goes freely without constraint
    shared_ptr<Graph> createGraph(shared_ptr<Symbol> initCount, 
        llvm::BasicBlock* startBB, llvm::BasicBlock* endBB = nullptr);

    // reduce the first basic graph, then find the next graph head
    llvm::BasicBlock* nextGraphHead(GraphType type, llvm::BasicBlock* startBB);

    // instantiate basic graph to a specific subgraphs
    shared_ptr<BasicGraph> createBasicGraph(shared_ptr<Symbol> initCount, 
        llvm::BasicBlock* startBB, llvm::BasicBlock* endBB = nullptr);

    GraphType getGraphType(llvm::BasicBlock* startBB, llvm::BasicBlock* endBB = nullptr);

    // builder for specific subgraph
    shared_ptr<BasicBlock> createBasicBlock(std::shared_ptr<BasicGraph> BG, 
        llvm::BasicBlock* startBB, llvm::BasicBlock* endBB = nullptr);

    shared_ptr<Branch> createBranch(std::shared_ptr<BasicGraph> BG, 
        llvm::BasicBlock* startBB, llvm::BasicBlock* endBB = nullptr);

    shared_ptr<Loop> createLoop(std::shared_ptr<BasicGraph> BG, 
        llvm::BasicBlock* startBB, llvm::BasicBlock* endBB = nullptr);

    // create a loop head graph, which is a basic graph that contains the loop head
    GraphType getLoopHeadType(llvm::BasicBlock* startBB, llvm::BasicBlock* endBB);
    
    shared_ptr<BasicGraph> getLoopHeadGraph(shared_ptr<Symbol> initCount, shared_ptr<Symbol> bodyCount,
    llvm::BasicBlock* startBB, llvm::BasicBlock* endBB = nullptr);

    
    bool isHeaderExiting(llvm::Loop* loop);
    bool isTailExiting(llvm::Loop* loop);

    
    // previous logic builds a simple framework graph, this class tries to solve for
    // each place holder
    class Analysis{
        public:
        llvm::LoopInfo& LI;
        llvm::ScalarEvolution& SE;
        shared_ptr<Program> P;
        std::map<shared_ptr<BasicGraph>, llvm::BasicBlock *> graph2bb;

        // base factor of a control flow, which represent the execution count of this path
        std::map<std::pair<llvm::BasicBlock*, llvm::BasicBlock*>, shared_ptr<Symbol>> baseFactor;

        Analysis(llvm::LoopInfo& LI, llvm::ScalarEvolution& SE, shared_ptr<Program> P, 
                std::map<shared_ptr<BasicGraph>, llvm::BasicBlock *> graph2bb):
                LI(LI), SE(SE), P(P), graph2bb(graph2bb){
            prepareBaseFactor(P);
            refine(P->G);
        }

        // initializing base factors 
        void prepareBaseFactor(shared_ptr<Program> P);
        void traverse(shared_ptr<Graph> current, vector<shared_ptr<BasicGraph>>& stack);
        void traverse(shared_ptr<BasicGraph> current, vector<shared_ptr<BasicGraph>>& stack);

        void addFactor(llvm::BasicBlock*, llvm::BasicBlock*, shared_ptr<Symbol>);
        shared_ptr<Symbol> getFactor(llvm::BasicBlock*, llvm::BasicBlock*);

        // solve for loop count and true ratio //

        // DFS to solve each individual LC TR, then update bottom up
        void refine(shared_ptr<Graph>);
        void refine(shared_ptr<BasicGraph>);

        // replace original string with the expanded one
        void update(shared_ptr<Graph>, pair<string, string>);
        void update(shared_ptr<BasicGraph>, pair<string, string>);

        shared_ptr<Symbol> getLoopCount(llvm::Loop* loop);
        string getExpandedSCEV(const llvm::SCEV* scev);
        void printRootExpr(const llvm::SCEV&, llvm::raw_ostream&);
        void printExpanded(llvm::Value*, llvm::raw_ostream &);
        void printPHI(llvm::Value*, llvm::raw_ostream &);

        shared_ptr<Symbol> getTrueRatio(llvm::BasicBlock*);
    };

    // some utility functions
    
    static std::string getName(llvm::BasicBlock*);
    static std::string getName(llvm::Argument*);
    static std::string getName(llvm::Loop*);
};

class GraphViewer{
public:
    static void showProgram(shared_ptr<Program> program, std::ostream& os = std::cout, int indent = 0);
    static void showGraph(shared_ptr<Graph> G, std::ostream& os = std::cout, int indent = 0);
    static void showBasicGraph(shared_ptr<BasicGraph> BG, std::ostream& os = std::cout, int indent = 0);
    static void showBasicBlock(shared_ptr<BasicBlock> BB, std::ostream& os = std::cout, int indent = 0);
    static void showBranch(shared_ptr<Branch> BR, std::ostream& os = std::cout, int indent = 0);
    static void showLoop(shared_ptr<Loop> L, std::ostream& os = std::cout, int indent = 0);

    static void showProgramAsJson(shared_ptr<Program> program, std::ostream& os = std::cout);
    static void showGraphAsJson(shared_ptr<Graph> G, std::ostream& os = std::cout);
    static void showBasicGraphAsJson(shared_ptr<BasicGraph> BG, std::ostream& os = std::cout);
    static void showBasicBlockAsJson(shared_ptr<BasicBlock> BB, std::ostream& os = std::cout);
    static void showBranchAsJson(shared_ptr<Branch> BR, std::ostream& os = std::cout);
    static void showLoopAsJson(shared_ptr<Loop> L, std::ostream& os = std::cout);

    static void getAllBasicGraphs(shared_ptr<Program> program, std::vector<shared_ptr<BasicGraph>>& collection);
    static void getAllBasicGraphs(shared_ptr<Graph> G, std::vector<shared_ptr<BasicGraph>>& collection);
    static void getAllBasicGraphs(shared_ptr<BasicGraph> BG, std::vector<shared_ptr<BasicGraph>>& collection);

    static void showAllBasicGraphsAsJson(shared_ptr<Program> program, std::ostream& os = std::cout);

    static nlohmann::json programToJson(shared_ptr<Program> program);
    static nlohmann::json graphToJson(shared_ptr<Graph> G);
    static nlohmann::json basicGraphToJson(shared_ptr<BasicGraph> BG);
    static nlohmann::json basicBlockToJson(shared_ptr<BasicBlock> BB);
    static nlohmann::json branchToJson(shared_ptr<Branch> BR);
    static nlohmann::json loopToJson(shared_ptr<Loop> L);
};