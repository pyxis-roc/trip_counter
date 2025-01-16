// From bploeckelman/count-bb.cpp https://gist.github.com/bploeckelman/3614316
// at 12/17/2024  

#pragma once

#include <vector>
#include "llvm/IR/GlobalVariable.h"
#include "llvm/IR/Module.h"

class CountBasicBlocks{
    public:    
    // for each basic block in the module, insert a counter
    // at the end of the module, print the count of each basic block
    static std::vector<llvm::GlobalVariable*> insertCounter(llvm::Module &M);
};