/*
    This file contains a command line tool that generate a symbolic count
    for a given LLVM IR file.
*/

#include "symb_form.hpp"
#include "characterize.hpp"
#include "symb_instance.hpp"

#include <llvm/IR/LLVMContext.h>
#include <llvm/IR/Module.h>
#include <llvm/IRReader/IRReader.h>
#include <llvm/Support/SourceMgr.h>
#include <llvm/Support/CommandLine.h>
#include <llvm/Support/InitLLVM.h>
#include <llvm/Support/raw_ostream.h>
#include <llvm/Analysis/LoopInfo.h>
#include <llvm/Analysis/PostDominators.h>
#include <llvm/Analysis/ScalarEvolution.h>
#include <llvm/Analysis/ScalarEvolutionAliasAnalysis.h>
#include <llvm/Passes/PassBuilder.h>
#include <llvm/IR/LegacyPassManager.h>
#include <memory>
#include <fstream>
#include <chrono>

#include "llvm/Transforms/Utils/Mem2Reg.h"

using namespace llvm;

static cl::opt<std::string> InputFilename(cl::Positional, cl::desc("<input LLVM IR file>"), cl::Required);
static cl::opt<std::string> FunctionName(cl::Positional, cl::desc("<function name to analyze>"), 
    cl::Required, cl::value_desc("function name"));
static cl::opt<std::string> OutputJsonFilename(
    "json",
    cl::desc("Output symbolic form as JSON to the specified file"),
    cl::value_desc("filename"),
    cl::init("")
);
static cl::opt<std::string> SubstitutionFile(
    "subs",
    cl::desc("Substitution JSON file to apply for symbolic expressions"),
    cl::value_desc("filename"),
    cl::init("")
);
static cl::opt<bool> Quiet(
    "quiet",
    cl::desc("Suppress all standard output"),
    cl::init(false)
);
static cl::opt<bool> Time(
    "time",
    cl::desc("Print execution time"),
    cl::init(false)
);
static cl::opt<bool> Characterize(
    "char",
    cl::desc("Enable program characterization"),
    cl::init(false)
);
static cl::opt<bool> ShowSymbolicInstance(
    "show-instance",
    cl::desc("Enable showing symbolic instances"),
    cl::init(false)
);

llvm::cl::opt<bool> Help("h", llvm::cl::desc("Print help message"));

void printHelpMessage() {
    llvm::outs() << "Usage: symb_viewer <input LLVM IR file> <function name to analyze> [options]\n";
    llvm::outs() << "Options:\n";
    llvm::outs() << "  -json=<filename>   Output symbolic form as JSON to the specified file\n";
    llvm::outs() << "  -subs=<filename>   Substitution JSON file to apply for symbolic expressions\n";
    llvm::outs() << "  -h                 Print help message\n";
    llvm::outs() << "\n";
    llvm::outs() << "Example:\n";
    llvm::outs() << "  symb_viewer input.ll my_function -json=output.json\n";
}


int main(int argc, char **argv) {
    if (argc < 3 || Help) {
        printHelpMessage();
        return 0;
    }

    auto t_start = std::chrono::high_resolution_clock::now();

    InitLLVM X(argc, argv);
    cl::ParseCommandLineOptions(argc, argv, "LLVM IR Loop/PDom/SE Analysis\n");

    LLVMContext Context;
    SMDiagnostic Err;
    std::unique_ptr<Module> M = parseIRFile(InputFilename, Err, Context);
    if (!M) {
        Err.print(argv[0], errs());
        return 1;
    }

    PassBuilder PB;
    LoopAnalysisManager LAM;
    FunctionAnalysisManager FAM;
    CGSCCAnalysisManager CGAM;
    ModuleAnalysisManager MAM;
    FunctionPassManager FPM;

    PB.registerModuleAnalyses(MAM);
    PB.registerCGSCCAnalyses(CGAM);
    PB.registerFunctionAnalyses(FAM);
    PB.registerLoopAnalyses(LAM);
    PB.crossRegisterProxies(LAM, FAM, CGAM, MAM);

    FAM.registerPass([&] { return ScalarEvolutionAnalysis(); });
    FAM.registerPass([&] { return LoopAnalysis(); });
    FAM.registerPass([&] { return PostDominatorTreeAnalysis(); });

    // FPM.addPass(PromotePass());

    Function *TargetFunc = M->getFunction(FunctionName);
    if (!TargetFunc || TargetFunc->isDeclaration()) {
        errs() << "Function '" << FunctionName << "' not found or is a declaration.\n";
        return 1;
    }

    FPM.run(*TargetFunc, FAM);

    // Loop Analysis
    auto &LI = FAM.getResult<LoopAnalysis>(*TargetFunc);

    // ScalarEvolution Analysis
    auto &SE = FAM.getResult<ScalarEvolutionAnalysis>(*TargetFunc);
    
    // Post Dominator Analysis
    auto &PDT = FAM.getResult<PostDominatorTreeAnalysis>(*TargetFunc);

    // build symbolic form for the function
    auto GB = GraphBuilder(LI, PDT, SE);
    auto program = GB.createProgram(TargetFunc);
    if (!program) {
        errs() << "Failed to create program from function: " << FunctionName << "\n";
        return 1;
    }

    std::chrono::duration<double> t_subs{0};
    std::chrono::duration<double> t_check_subs{0}, t_parse_subs{0}, t_apply_subs{0};

    // Apply substitutions if provided
    if (!SubstitutionFile.empty()) {
        auto t_subs_start = std::chrono::high_resolution_clock::now();

        std::ifstream subsFile(SubstitutionFile);
        if (!subsFile.is_open()) {
            errs() << "Failed to open substitution file: " << SubstitutionFile << "\n";
            return 1;
        }

        auto t_check_start = std::chrono::high_resolution_clock::now();
        nlohmann::json subsJson;
        subsFile >> subsJson;
        auto t_check_end = std::chrono::high_resolution_clock::now();
        t_check_subs = t_check_end - t_check_start;

        auto t_parse_start = std::chrono::high_resolution_clock::now();
        vector<SymbolicExpr> inputs;
        vector<int> inputValues;
        for (auto &var : GB.SEM.getAllProgramExpr()) {
            if (subsJson.contains(var.str())) {
                inputs.push_back(var);
                auto sub = subsJson[var.str()];
                if (sub.is_number_integer()) {
                    inputValues.push_back(sub.get<int>());
                } else if (sub.is_string()) {
                    try {
                        int val = std::stoi(sub.get<std::string>());
                        inputValues.push_back(val);
                    } catch (...) {
                        errs() << "Substitution for " << var.str() << " is not a valid integer. Use 0\n";
                        inputValues.push_back(0);
                    }
                } else {
                    errs() << "Substitution for " << var.str() << " is not a valid integer. Use 0\n";
                    inputValues.push_back(0);
                }
            }
        }
        auto t_parse_end = std::chrono::high_resolution_clock::now();
        t_parse_subs = t_parse_end - t_parse_start;

        auto t_apply_start = std::chrono::high_resolution_clock::now();
        GraphBuilder::substitute(program, inputs, inputValues);
        auto t_apply_end = std::chrono::high_resolution_clock::now();
        t_apply_subs = t_apply_end - t_apply_start;

        auto t_subs_end = std::chrono::high_resolution_clock::now();
        t_subs = t_subs_end - t_subs_start;
    }

    // show the symbolic form or output as JSON
    if(!Quiet){
        if (!OutputJsonFilename.empty()) {
            std::ofstream jsonOut(OutputJsonFilename);
            GraphViewer::showAllBasicGraphsAsJson(program, jsonOut);
        } else {
            GraphViewer::showProgram(program);
        }
    }

    auto t_end = std::chrono::high_resolution_clock::now();
    
    if (ShowSymbolicInstance) {
        SymbInstance instance;
        std::vector<SymbolicExpr> exprs; // Populate this with symbolic expressions
        std::vector<std::string> inputs; // Populate this with input symbolic expressions
        std::vector<std::string> basicBlockNames; // Populate this with basic block names

        std::vector<std::shared_ptr<BasicGraph>> basicGraphPtrs;
        GraphViewer::getAllBasicGraphs(program, basicGraphPtrs);

        for (const auto& bgPtr : basicGraphPtrs) {
            if (bgPtr->getGraphType() == GraphType::Loop) {
                continue; // Skip non-basic block graphs
            }
            exprs.push_back(bgPtr->count);

            if (GB.graph2bb.find(bgPtr) != GB.graph2bb.end()) {
                basicBlockNames.push_back(GB.graph2bb[bgPtr]->getName().str());
            } else {
                basicBlockNames.push_back("unknown_bb");
            }
        }

        /*
        for (const auto& input : program->inputs) {
            inputs.push_back(input.z3expr().decl().name().str());
        }
        */

        auto module = instance.create(exprs, basicBlockNames);
        module->print(llvm::outs(), nullptr);
    }

    if (Time) {
        llvm::outs() << "Total time: " 
                     << std::chrono::duration<double, std::milli>(t_end - t_start).count() << "ms\n";
        if (!SubstitutionFile.empty()) {
            llvm::outs() << "Substitution time: " 
                         << std::chrono::duration<double, std::milli>(t_subs).count() << "ms\n";
            llvm::outs() << "  - File check time: " 
                         << std::chrono::duration<double, std::milli>(t_check_subs).count() << "ms\n";
            llvm::outs() << "  - Parsing substitutions time: " 
                         << std::chrono::duration<double, std::milli>(t_parse_subs).count() << "ms\n";
            llvm::outs() << "  - Applying substitutions time: " 
                         << std::chrono::duration<double, std::milli>(t_apply_subs).count() << "ms\n";
        }
    }

    // Perform program characterization if the flag is enabled
    if (Characterize) {
        analyzeModule(M, *TargetFunc);
        llvm::outs() << "Number of symbolic loop counts: " << GB.SEM.loopCountNames.size() << "\n";
        llvm::outs() << "Number of symbolic true ratios: " << GB.SEM.trueRatioNames.size() << "\n";
        llvm::outs() << "Number of early exits: " << GB.earlyExits.size()/2 << "\n";
        llvm::outs() << "Number of composite symbolic expressions: " << GB.numComposite << "\n";
    }

    return 0;
}