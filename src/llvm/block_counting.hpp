// From bploeckelman/count-bb.cpp https://gist.github.com/bploeckelman/3614316
// at 12/17/2024  

#pragma once

#include <set>
#include <llvm/IR/Module.h>

class CountBasicBlocks{
    public:
    static std::set<std::string> insertCounter(llvm::Module &M);

};