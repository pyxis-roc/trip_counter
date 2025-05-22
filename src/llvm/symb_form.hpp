#include "llvm/IR/BasicBlock.h"
#include "llvm/IR/Function.h"
#include <memory>
#include <string>
#include <vector>

using namespace std;

// symbolic execution count
class Symbol{
public:
    string count;
    Symbol(string count) : count(count) {}
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


    static unique_ptr<Graph> createGraph(llvm::BasicBlock* BB, unique_ptr<Symbol> initCount);
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

    static unique_ptr<BasicGraph> createBasicGraph(llvm::BasicBlock* BB);
    static unique_ptr<BasicBlock> createBasicBlock(llvm::BasicBlock* BB);
    static unique_ptr<Branch> createBranch(llvm::BasicBlock* BB);
    static unique_ptr<Loop> createLoop(llvm::BasicBlock* BB);
};


class BasicBlock : public BasicGraph{
public:
    BasicBlock(unique_ptr<BasicGraph> BG)
        : BasicGraph(BG->id, BG->name, std::move(BG->G)) {}
};


class Branch : public BasicGraph{
public:
    unique_ptr<Symbol> trueRatio;
    unique_ptr<Symbol> falseRatio;
    unique_ptr<Graph> G1;
    unique_ptr<Graph> G2;

    Branch(unique_ptr<BasicGraph> BG, std::unique_ptr<Symbol> trueRatio, 
            std::unique_ptr<Graph> G1, std::unique_ptr<Graph> G2): 
        BasicGraph(BG->id, BG->name, std::move(BG->G)), 
        trueRatio(std::move(trueRatio)), 
        G1(std::move(G1)), 
        G2(std::move(G2)) {
            falseRatio = make_unique<Symbol>("1 - " + this->trueRatio->count);
        }
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
};


class Program{
public:
    vector<unique_ptr<Symbol>> inputs;
    unique_ptr<Graph> G;

    Program(vector<unique_ptr<Symbol>> inputs, unique_ptr<Graph> G)
        : inputs(std::move(inputs)), G(std::move(G)) {}
    
    static unique_ptr<Program> createProgram(llvm::Function*);

};