#include "instr_count_subcommand.hpp"

#include "utils.hpp"
#include "symb_form.hpp"

#include <nlohmann/json.hpp>

#include <llvm/Support/raw_ostream.h>

#include <fstream>
#include <map>
#include <set>
#include <string>

const std::map<std::string, std::set<std::string>> LLVM_CATEGORIES = {
    {"arithmetic", {"add", "fadd", "sub", "fsub", "mul", "fmul", "udiv", "sdiv", "fdiv", "urem", "srem", "frem"}},
    {"bitwise", {"shl", "lshr", "ashr", "and", "or", "xor"}},
    {"memory", {"alloca", "load", "store", "getelementptr", "fence", "cmpxchg", "atomicrmw"}},
    {"conversion", {"trunc", "zext", "sext", "fptrunc", "fpext", "fptoui", "fptosi", "uitofp", "sitofp", "ptrtoint", "inttoptr", "bitcast", "addrspacecast"}},
    {"compare", {"icmp", "fcmp"}},
    {"control_flow", {"br", "switch", "indirectbr", "invoke", "resume", "unreachable", "callbr"}},
    {"vector", {"extractelement", "insertelement", "shufflevector", "extractvalue", "insertvalue"}},
    {"other", {"phi", "select", "call", "va_arg", "ret", "landingpad", "catchpad", "cleanuppad", "catchret", "cleanupret", "catchswitch"}}
};

void analyzeInstructionCount(llvm::Function &F, const std::string &outputFile) {
    nlohmann::json result;
    std::map<std::string, unsigned> categoryCounts;

    for (auto &BB : F) {
        std::map<std::string, unsigned> instructionCounts;
        std::map<std::string, unsigned> blockCategoryCounts;

        for (auto &I : BB) {
            std::string opcodeName = I.getOpcodeName();
            ++instructionCounts[opcodeName];

            for (const auto &category : LLVM_CATEGORIES) {
                if (category.second.count(opcodeName)) {
                    ++categoryCounts[category.first];
                    ++blockCategoryCounts[category.first];
                    break;
                }
            }
        }

        std::string blockName = GraphBuilder::getName(&BB);

        nlohmann::json blockData = {
            {"block_name", blockName},
            {"instruction_counts", instructionCounts},
            {"category_counts", blockCategoryCounts}
        };
        result.emplace_back(blockData);

        if (outputFile.empty()) {
            llvm::outs() << blockName << "\n";
            for (const auto &entry : instructionCounts) {
                llvm::outs() << "  " << entry.first << ": " << entry.second << "\n";
            }
            llvm::outs() << "  Category Summary:\n";
            for (const auto &entry : blockCategoryCounts) {
                llvm::outs() << "    " << entry.first << ": " << entry.second << "\n";
            }
        }
    }

    if (!outputFile.empty()) {
        std::ofstream outFile(outputFile);
        if (!outFile.is_open()) {
            llvm::errs() << "Failed to open output file: " << outputFile << "\n";
            return;
        }
        outFile << result.dump(4);
    } else {
        llvm::outs() << "\nCategory Summary:\n";
        for (const auto &entry : categoryCounts) {
            llvm::outs() << entry.first << ": " << entry.second << "\n";
        }
    }
}
