#include "llvm/IR/Module.h"
#include "llvm/IR/Function.h"
#include "llvm/IR/Instructions.h"
#include "llvm/IR/PassManager.h"
#include "llvm/Analysis/LoopInfo.h"
#include "llvm/Analysis/LoopPass.h"
#include "llvm/Analysis/ScalarEvolution.h"
#include "llvm/Passes/PassBuilder.h"
#include "llvm/Support/raw_ostream.h"
#include <memory>
#include <algorithm>

void analyzeModule(std::unique_ptr<llvm::Module> &module, llvm::Function& func) {
    using namespace llvm;

    int numBasicBlocks = 0;
    int maxLoopDepth = 0;
    int phiNodeCount = 0;

    std::function<void(Loop *)> analyzeLoop = [&](Loop *loop) {
        // Calculate max loop depth
        maxLoopDepth = std::max(maxLoopDepth, int(loop->getLoopDepth()));

        // Recursively analyze nested loops
        for (auto *subLoop : loop->getSubLoops()) {
            analyzeLoop(subLoop);
        }
    };

    
    if (func.isDeclaration()) return;

    PassBuilder PB;
    LoopAnalysisManager LAM;
    FunctionAnalysisManager FAM;
    CGSCCAnalysisManager CGAM;
    ModuleAnalysisManager MAM;

    PB.registerModuleAnalyses(MAM);
    PB.registerCGSCCAnalyses(CGAM);
    PB.registerFunctionAnalyses(FAM);
    PB.registerLoopAnalyses(LAM);
    PB.crossRegisterProxies(LAM, FAM, CGAM, MAM);

    FAM.registerPass([&] { return ScalarEvolutionAnalysis(); });
    FAM.registerPass([&] { return LoopAnalysis(); });

    auto &loopInfo = FAM.getResult<LoopAnalysis>(func);

    // Analyze all top-level loops and their sub-loops recursively
    for (auto *loop : loopInfo) {
        analyzeLoop(loop);
    }

    // Count basic blocks and phi nodes
    for (auto &block : func) {
        ++numBasicBlocks; // Increment basic block count
        for (auto &instr : block) {
            if (isa<PHINode>(&instr)) {
                ++phiNodeCount;
            }
        }
    }

    // Output the results
    outs() << "Number of Basic Blocks: " << numBasicBlocks << "\n";
    outs() << "Max Loop Depth: " << maxLoopDepth << "\n";
    outs() << "Phi Nodes: " << phiNodeCount << "\n";
}
