#pragma once

#include <llvm/IR/Function.h>

#include <string>

void analyzeInstructionCount(llvm::Function &F, const std::string &outputFile);
