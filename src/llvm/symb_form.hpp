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

using namespace std;

// symbolic execution count
class Symbol{
public:
    string literal;
    Symbol(string literal) : literal(literal) {}

    unique_ptr<Symbol> copy() {
        return make_unique<Symbol>(this->literal);
    }
    unique_ptr<Symbol> multiply(const unique_ptr<Symbol>& other) const {
        return make_unique<Symbol>("(" + literal + " * " + other->literal + ")");
    }
};

class Graph;

class Program{
public:
    vector<unique_ptr<Symbol>> inputs;
    unique_ptr<Graph> G;

    Program(vector<unique_ptr<Symbol>> inputs, unique_ptr<Graph> G)
        : inputs(std::move(inputs)), G(std::move(G)) {}
    
};

/*
    ⟨𝐺⟩ ::= ⟨𝐵𝐺⟩ | ⟨𝐵𝐺⟩ ⟨𝐺⟩
    ⟨𝐵𝐺⟩ ::= ⟨𝐵𝐵⟩ | ⟨𝐵𝑅⟩ | ⟨𝐴𝐿⟩ | ⟨𝐺𝐿⟩
    ⟨𝐵𝐵⟩ ::= stmts
    ⟨𝐵𝑅⟩ ::= if (𝐶) ⟨𝐺1⟩, ⟨𝐺2⟩
    ⟨𝐴𝐿⟩ ::= from 𝑆 to 𝐸 in 𝐾 for ⟨𝐺𝑏⟩, ⟨𝐺𝑒 ⟩
    ⟨𝐺𝐿⟩ ::= while (𝑁) ⟨𝐺𝑏⟩, ⟨𝐺𝑒 ⟩
*/

class BasicGraph;

class Graph{
public:
    string id;
    unique_ptr<Symbol> count;
    unique_ptr<BasicGraph> BG;
    unique_ptr<Graph> G;

    Graph(std::string id, std::unique_ptr<Symbol> count, std::unique_ptr<BasicGraph> BG, std::unique_ptr<Graph> G)
        : id(id), count(std::move(count)), BG(std::move(BG)), G(std::move(G)) {}
    Graph(std::string id, std::unique_ptr<Symbol> count, std::unique_ptr<BasicGraph> BG)
        : id(id), count(std::move(count)), BG(std::move(BG)), G(nullptr) {}
    Graph(std::string id, std::unique_ptr<Symbol> count)
        : id(id), count(std::move(count)), BG(nullptr), G(nullptr) {}
    Graph(std::string id)
        : id(id), count(nullptr), BG(nullptr), G(nullptr) {}

};


class BasicBlock;
class Branch;
class Loop;

class BasicGraph{
public:
    string id;
    string name;
    unique_ptr<Graph> G; //parent

    BasicGraph(std::string id, std::string name, std::unique_ptr<Graph> G)
        : id(id), name(name), G(std::move(G)) {}

    // subclass type check
    virtual bool is_BasicBlock() const { return false; }
    virtual bool is_Branch() const { return false; }
    virtual bool is_Loop() const { return false; }
};


class BasicBlock : public BasicGraph{
public:
    BasicBlock(unique_ptr<BasicGraph> BG)
        : BasicGraph(BG->id, BG->name, std::move(BG->G)) {}
    
    bool is_BasicBlock() const override { return true; }
};


class Branch : public BasicGraph{
public:
    unique_ptr<Symbol> trueRatio;
    unique_ptr<Symbol> falseRatio;
    unique_ptr<Graph> G1;
    unique_ptr<Graph> G2;

    Branch(unique_ptr<BasicGraph> BG, std::unique_ptr<Symbol> trueRatio, 
            std::unique_ptr<Symbol> falseRatio, std::unique_ptr<Graph> G1, 
            std::unique_ptr<Graph> G2): 
        BasicGraph(BG->id, BG->name, std::move(BG->G)), 
        trueRatio(std::move(trueRatio)),
        falseRatio(std::move(falseRatio)), 
        G1(std::move(G1)),
        G2(std::move(G2)){}
    
    bool is_Branch() const override { return true; }
};


class Loop : public BasicGraph{
public:
    unique_ptr<Symbol> loopCount;
    unique_ptr<Graph> Gb;

    Loop(unique_ptr<BasicGraph> BG, std::unique_ptr<Symbol> loopCount, 
            std::unique_ptr<Graph> Gb): 
        BasicGraph(BG->id, BG->name, std::move(BG->G)), 
        loopCount(std::move(loopCount)), 
        Gb(std::move(Gb)) {}
    
    bool is_Loop() const override { return true; }

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

    GraphBuilder(llvm::LoopInfo& LI, llvm::PostDominatorTree& PDT, llvm::ScalarEvolution& SE) : LI(LI), PDT(PDT), SE(SE) {}


    // create a program from llvm function class
    unique_ptr<Program> createProgram(llvm::Function*);

    // create a graph rooted at BB
    unique_ptr<Graph> createGraph(llvm::BasicBlock* BB, unique_ptr<Symbol> initCount);

    // reduce the graph, then find the next graph root
    llvm::BasicBlock* nextGraphHead(llvm::BasicBlock* BB);

    // instantiate basic graph to a specific subgraphs
    unique_ptr<BasicGraph> createBasicGraph(llvm::BasicBlock* BB, std::unique_ptr<Graph> G);
    
    bool is_BasicBlock_graph(llvm::BasicBlock* BB);
    bool is_Branch_graph(llvm::BasicBlock* BB);
    bool is_Loop_graph(llvm::BasicBlock* BB);

    // builder for specific subgraph
    unique_ptr<BasicBlock> createBasicBlock(llvm::BasicBlock* BB, std::unique_ptr<BasicGraph> BG);
    unique_ptr<Branch> createBranch(llvm::BasicBlock* BB, std::unique_ptr<BasicGraph> BG);
    unique_ptr<Loop> createLoop(llvm::BasicBlock* BB, std::unique_ptr<BasicGraph> BG);
    unique_ptr<Symbol> getLoopCount(llvm::BasicBlock* BB);

};;