#include "utils.hpp"
#include <llvm/Support/raw_ostream.h>

std::uint64_t fnv1a_hash(const std::string& data) {
    std::uint64_t hash = 14695981039346656037ull;
    for (char c : data) {
        hash ^= static_cast<std::uint8_t>(c);
        hash *= 1099511628211ull;
    }
    return hash;
}

std::string getBlockID(llvm::BasicBlock* BB) {
    std::string blockID;
    if (BB->size() >= 6) {
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

        blockID = std::to_string(fnv1a_hash(firstThree + lastThree));
    } else {
        std::string allInstructions;

        for (auto &I : *BB) {
            std::string instStr;
            llvm::raw_string_ostream rso(instStr);
            I.print(rso);
            allInstructions += rso.str();
        }

        blockID = std::to_string(fnv1a_hash(allInstructions));
    }
    
    return blockID;
}