#include "instr_count_subcommand.hpp"

#include "utils.hpp"
#include "symb_form.hpp"

#include <nlohmann/json.hpp>

#include <llvm/IR/IntrinsicInst.h>
#include <llvm/IR/Intrinsics.h>
#include <llvm/Support/raw_ostream.h>

#include <fstream>
#include <map>
#include <optional>
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

namespace {

std::string normalizeCallName(const llvm::CallBase &C) {
    if (C.isInlineAsm()) {
        return "inlineasm";
    }

    if (const auto *callee = C.getCalledFunction()) {
        const auto intrinsicID = callee->getIntrinsicID();
        if (intrinsicID != llvm::Intrinsic::not_intrinsic) {
            llvm::StringRef baseName = llvm::Intrinsic::getBaseName(intrinsicID);
            return baseName.consume_front("llvm.") ? baseName.str() : baseName.str();
        }
        return callee->getName().str();
    }

    const llvm::Value *calledOperand = C.getCalledOperand()->stripPointerCasts();
    if (const auto *global = llvm::dyn_cast<llvm::GlobalValue>(calledOperand)) {
        return global->getName().str();
    }

    return C.getOpcodeName();
}

std::optional<std::string> categoryForInstruction(const llvm::Instruction &I,
                                                  llvm::StringRef instructionName) {
    for (const auto &category : LLVM_CATEGORIES) {
        if (category.second.count(instructionName.str())) {
            return category.first;
        }
    }

    const auto *call = llvm::dyn_cast<llvm::CallBase>(&I);
    if (!call) {
        return std::nullopt;
    }

    if (const auto *intrinsic = llvm::dyn_cast<llvm::IntrinsicInst>(call)) {
        if (llvm::isa<llvm::MemIntrinsic>(intrinsic)) {
            return "memory";
        }
        if (intrinsic->isAssumeLikeIntrinsic() ||
            llvm::isDbgInfoIntrinsic(intrinsic->getIntrinsicID()) ||
            llvm::isLifetimeIntrinsic(intrinsic->getIntrinsicID())) {
            return "other";
        }
    }

    if (instructionName.contains("barrier") || instructionName.contains("trap")) {
        return "control_flow";
    }

    if (instructionName.contains("gather") || instructionName.contains("scatter") ||
        instructionName.starts_with("mem")) {
        return "memory";
    }

    if (instructionName.starts_with("bit") || instructionName == "bswap" ||
        instructionName == "ctlz" || instructionName == "cttz" ||
        instructionName == "ctpop") {
        return "bitwise";
    }

    if (instructionName.starts_with("vector.")) {
        return "vector";
    }

    if (instructionName == "is.fpclass" || instructionName.starts_with("cmp")) {
        return "compare";
    }

    static const std::set<std::string> arithmeticCalls = {
        "abs",      "canonicalize", "ceil",    "cos",    "exp",       "exp2",
        "fabs",     "floor",        "fma",     "fmuladd","log",       "log10",
        "log2",     "max",          "maximum", "maxnum", "min",       "minimum",
        "minnum",   "nearbyint",    "pow",     "powi",   "rint",      "round",
        "roundeven","sin",          "sqrt",    "smax",   "smin",      "trunc",
        "umax",     "umin"
    };
    if (arithmeticCalls.count(instructionName.str())) {
        return "arithmetic";
    }

    return "other";
}

std::string instructionNameForCount(const llvm::Instruction &I) {
    if (const auto *call = llvm::dyn_cast<llvm::CallBase>(&I)) {
        return normalizeCallName(*call);
    }
    return I.getOpcodeName();
}

}  // namespace

void analyzeInstructionCount(llvm::Function &F, const std::string &outputFile) {
    nlohmann::json result;
    std::map<std::string, unsigned> categoryCounts;

    for (auto &BB : F) {
        std::map<std::string, unsigned> instructionCounts;
        std::map<std::string, unsigned> blockCategoryCounts;

        for (auto &I : BB) {
            std::string instructionName = instructionNameForCount(I);
            ++instructionCounts[instructionName];

            if (auto category = categoryForInstruction(I, instructionName)) {
                ++categoryCounts[*category];
                ++blockCategoryCounts[*category];
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
