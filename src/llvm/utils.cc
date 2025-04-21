#include "utils.hpp"
#include <llvm/Support/raw_ostream.h>


std::string getBlockID(llvm::BasicBlock* BB) {
    std::string blockID;
    if (BB->size() >= 6) {
        std::hash<std::string> hasher;
        std::string firstThree, lastThree;

        auto it = BB->begin();
        for (int i = 0; i < 3; ++i, ++it) {
        std::string instStr;
        llvm::raw_string_ostream rso(instStr);
        it->print(rso);
        firstThree += rso.str();
        }

        auto rit = BB->rbegin();
        for (int i = 0; i < 3; ++i, ++rit) {
        std::string instStr;
        llvm::raw_string_ostream rso(instStr);
        rit->print(rso);
        lastThree += rso.str();
        }

        blockID = std::to_string(hasher(firstThree + lastThree));
    } else {
        std::hash<std::string> hasher;
        std::string allInstructions;

        for (auto &I : *BB) {
            std::string instStr;
            llvm::raw_string_ostream rso(instStr);
            I.print(rso);
            allInstructions += rso.str();
        }

        blockID = std::to_string(hasher(allInstructions));
    }
    
    return blockID;
}