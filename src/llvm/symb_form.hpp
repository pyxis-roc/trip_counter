/*
    This file contains two parts:

    -first part defines the graph structure for symbolic counting
    
    -second part defines the graph builder that builds the graph structure
        from a llvm control flow graph    
*/

#include "llvm/IR/BasicBlock.h"
#include "llvm/IR/Function.h"
#include <memory>
#include <string>
#include <vector>
#include <iostream>

using namespace std;

// symbolic execution count
class Symbol{
public:
    string literal;
    Symbol(string literal) : literal(literal) {}

    shared_ptr<Symbol> multiply(const shared_ptr<Symbol>& other) const {
        return make_shared<Symbol>("(" + literal + " * " + other->literal + ")");
    }
    shared_ptr<Symbol> add(const shared_ptr<Symbol>& other) const {
        return make_shared<Symbol>("(" + literal + " + " + other->literal + ")");
    }
    shared_ptr<Symbol> addOne() const {
        return make_shared<Symbol>("(" + literal + " + 1)");
    }

    void show(std::ostream& os = std::cout) const {
        os << literal << std::endl;
    }
};

class Graph;

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
    shared_ptr<BasicGraph> guard; // the loop guard basic block sometimes have different execution count to the body
    shared_ptr<Graph> Gb;

    Loop(shared_ptr<BasicGraph> BG, std::shared_ptr<Symbol> loopCount, std::shared_ptr<BasicGraph> guard, 
            std::shared_ptr<Graph> Gb): 
        BasicGraph(BG->id, BG->name, BG->count), 
        loopCount(loopCount), 
        guard(guard),
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

    GraphBuilder(llvm::LoopInfo& LI, llvm::PostDominatorTree& PDT, llvm::ScalarEvolution& SE) 
        : LI(LI), PDT(PDT), SE(SE) {}

    // create a program from llvm function class
    shared_ptr<Program> createProgram(llvm::Function*);

    // create a graph rooted at BB
    shared_ptr<Graph> createGraph(shared_ptr<Symbol> initCount, 
        llvm::BasicBlock* startBB, llvm::BasicBlock* endBB = nullptr);

    // reduce the basic graph, then find the next graph head
    llvm::BasicBlock* nextGraphHead(llvm::BasicBlock* startBB, llvm::BasicBlock* endBB = nullptr);

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

    shared_ptr<BasicGraph> getLoopGuardGraph(llvm::Loop* loop, shared_ptr<Symbol> bodyCount);
    shared_ptr<Symbol> getLoopCount(llvm::Loop* loop);

};

class GraphViewer{
public:
    static void showProgram(shared_ptr<Program> program, std::ostream& os = std::cout, int indent = 0);
    static void showGraph(shared_ptr<Graph> G, std::ostream& os = std::cout, int indent = 0);
    static void showBasicGraph(shared_ptr<BasicGraph> BG, std::ostream& os = std::cout, int indent = 0);
    static void showBasicBlock(shared_ptr<BasicBlock> BB, std::ostream& os = std::cout, int indent = 0);
    static void showBranch(shared_ptr<Branch> BR, std::ostream& os = std::cout, int indent = 0);
    static void showLoop(shared_ptr<Loop> L, std::ostream& os = std::cout, int indent = 0);
};