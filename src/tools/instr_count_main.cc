/*

This tool counts the number of instructions (arithmetic, memory, etc.) for each
basic block in a function and prints the counts to the standard output in the format:
    <block_ID> <block_name> arithmetic_count memory_count

command line interface:
    inst-count <IR_file> <function_name> [-o <output_file>]
    -o <output_file> : output the result to a json file instead of stdout
    -h : print this help message
*/

#include <nlohmann/json.hpp>

#include <llvm/IR/LLVMContext.h>
#include <llvm/IR/Module.h>
#include <llvm/IR/Function.h>
#include <llvm/IR/BasicBlock.h>
#include <llvm/IR/Instruction.h>
#include <llvm/IR/Instructions.h>
#include <llvm/Support/CommandLine.h>
#include <llvm/Support/FileSystem.h>
#include <llvm/Support/SourceMgr.h>
#include <llvm/Support/raw_ostream.h>
#include <llvm/IRReader/IRReader.h>
#include <fstream>
#include <iostream>
#include <string>
#include <set>
#include "utils.hpp"

using json = nlohmann::json;

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


// Command-line options
llvm::cl::opt<std::string> InputIRFile(llvm::cl::Positional, llvm::cl::desc("<IR_file>"), llvm::cl::Required);
llvm::cl::opt<std::string> FunctionName(llvm::cl::Positional, llvm::cl::desc("<function_name>"), llvm::cl::Required);
llvm::cl::opt<std::string> OutputFile("o", llvm::cl::desc("Specify output file (JSON format)"), llvm::cl::value_desc("output_file"));
llvm::cl::opt<bool> Help("h", llvm::cl::desc("Print help message"));

void printHelp() {
    llvm::outs() << "Usage: inst-count <IR_file> <function_name> [-o <output_file>]\n"
                 << "Options:\n"
                 << "  -o <output_file> : Output the result to a JSON file instead of stdout\n"
                 << "  -h               : Print this help message\n";
}

void analyzeFunction(llvm::Function &F, std::ostream &output) {
    json result;
    std::map<std::string, unsigned> categoryCounts;

    for (auto &BB : F) {
        std::map<std::string, unsigned> instructionCounts;
        std::map<std::string, unsigned> blockCategoryCounts;

        for (auto &I : BB) {
            std::string opcodeName = I.getOpcodeName();
            ++instructionCounts[opcodeName];

            // Update category counts
            for (const auto &category : LLVM_CATEGORIES) {
                if (category.second.count(opcodeName)) {
                    ++categoryCounts[category.first];
                    ++blockCategoryCounts[category.first];
                    break;
                }
            }
        }

        std::string blockName;
        if (BB.hasName()) {
            blockName = BB.getName().str();
        } else {
            blockName = "<unnamed>";
        }

        std::string blockID = getBlockID(&BB);

        json blockData = {
            {"block_ID", blockID},
            {"block_name", blockName},
            {"instruction_counts", instructionCounts},
            {"category_counts", blockCategoryCounts}
        };

        result.emplace_back(blockData);

        if (OutputFile.empty()) {
            output << blockID << " " << blockName << "\n";
            for (const auto &entry : instructionCounts) {
                output << "  " << entry.first << ": " << entry.second << "\n";
            }
            output << "  Category Summary:\n";
            for (const auto &entry : blockCategoryCounts) {
                output << "    " << entry.first << ": " << entry.second << "\n";
            }
        }
    }

    if (!OutputFile.empty()) {
        std::ofstream outFile(OutputFile);
        outFile << result.dump(4);
    } else {
        output << "\nCategory Summary:\n";
        for (const auto &entry : categoryCounts) {
            output << entry.first << ": " << entry.second << "\n";
        }
    }
}

int main(int argc, char **argv) {
    llvm::cl::ParseCommandLineOptions(argc, argv);

    if (Help) {
        printHelp();
        return 0;
    }

    llvm::LLVMContext Context;
    llvm::SMDiagnostic Err;
    std::unique_ptr<llvm::Module> Mod = llvm::parseIRFile(InputIRFile, Err, Context);

    if (!Mod) {
        llvm::errs() << "Error reading IR file: " << InputIRFile << "\n";
        Err.print(argv[0], llvm::errs());
        return 1;
    }

    llvm::Function *F = Mod->getFunction(FunctionName);
    if (!F) {
        llvm::errs() << "Function not found: " << FunctionName << "\n";
        return 1;
    }

    if (OutputFile.empty()) {
        analyzeFunction(*F, std::cout);
    } else {
        std::ofstream outFile(OutputFile);
        analyzeFunction(*F, outFile);
    }

    return 0;
}