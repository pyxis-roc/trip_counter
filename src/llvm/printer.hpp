#include "llvm/Passes/PassBuilder.h"

using v_set = std::set<const llvm::Value*>;

namespace Debug {
    void printLoopBlocks(llvm::Loop &L);
    void printLoopInfo(llvm::Loop &L, llvm::ScalarEvolution &SE, v_set keep_unexpanded = v_set(), int depth = 0);
    void printRootExpr(const llvm::SCEV& E, v_set keep_unexpanded = v_set());
    void printExpanded(llvm::Value*, v_set keep_unexpanded = v_set());
    void analyzeLoop(llvm::Module &M);
};

