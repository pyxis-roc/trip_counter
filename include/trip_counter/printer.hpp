#include "llvm/Passes/PassBuilder.h"
#include "llvm/Support/raw_ostream.h"

using v_set = std::set<const llvm::Value*>;

namespace Debug {
    void printLoopBlocks(llvm::Loop &L, llvm::raw_ostream &os = llvm::errs());
    void printLoopInfo(llvm::Loop &L, llvm::ScalarEvolution &SE, llvm::raw_ostream &os = llvm::errs(), v_set keep_unexpanded = v_set(), \
        int depth = 0);
    void printRootExpr(const llvm::SCEV& E, llvm::raw_ostream &os = llvm::errs(), v_set keep_unexpanded = v_set());
    void printExpanded(llvm::Value*, llvm::raw_ostream &os = llvm::errs(), v_set keep_unexpanded = v_set());
    void analyzeLoop(llvm::Module &M);
};

