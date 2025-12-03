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

// Subcommands for clearer interface
static cl::SubCommand KernelCmd("kernel", "Generate kernel-only instance (no main)");
static cl::SubCommand InstanceCmd("instance", "Generate test instance (with main and parsing)");
static cl::SubCommand FormulaCmd("formula", "Show symbolic formula/graphs (text or JSON)");
static cl::SubCommand CharacterizeCmd("characterize", "Run characterization metrics only");

static cl::opt<std::string> InputFilename(
    cl::Positional, 
    cl::desc("<input LLVM IR file>"), 
    cl::Required, 
    cl::sub(cl::SubCommand::getAll())
);
static cl::opt<std::string> FunctionName(
    cl::Positional, 
    cl::desc("<function name to analyze>"), 
    cl::Required, cl::value_desc("function name"), 
    cl::sub(cl::SubCommand::getAll())
);
static cl::opt<std::string> OutputJsonFilename(
    "json",
    cl::desc("Output symbolic form as JSON to the specified file"),
    cl::value_desc("filename"),
    cl::init(""),
    cl::sub(FormulaCmd)
);
static cl::opt<std::string> SubstitutionFile(
    "subs",
    cl::desc("Substitution JSON file to apply for symbolic expressions"),
    cl::value_desc("filename"),
    cl::init(""),
    cl::sub(FormulaCmd)
);
static cl::opt<bool> Quiet(
    "quiet",
    cl::desc("Suppress textual formula output (only JSON if -json is set)"),
    cl::init(false),
    cl::sub(FormulaCmd)
);
static cl::opt<bool> Time(
    "time",
    cl::desc("Print execution time"),
    cl::init(false),
    cl::sub(FormulaCmd)
);
// Characterization now via 'characterize' subcommand (removed -char flag)
// Options under subcommands
static cl::opt<bool> OutputToFile(
    "output-to-file",
    cl::desc("Write results to file instead of stdout (better performance)"), 
    cl::init(false), 
    cl::sub(KernelCmd),
    cl::sub(InstanceCmd)
);
llvm::cl::opt<bool> Help("h", llvm::cl::desc("Print help message"));

void printHelpMessage() {
    llvm::outs() << "Usage:\n";
    llvm::outs() << "  symb_viewer <subcommand> <input.ll> <func> [options]\n\n";
    llvm::outs() << "Subcommands:\n";
    llvm::outs() << "  kernel        Generate kernel instance (no main)\n";
    llvm::outs() << "  instance      Generate test instance (with main)\n";
    llvm::outs() << "  formula       Show symbolic formula (text or -json)\n";
    llvm::outs() << "  characterize  Run characterization metrics only\n\n";
    llvm::outs() << "Global Options:\n";
    llvm::outs() << "  -h                  Print help message\n\n";
    llvm::outs() << "Formula Options (use with 'formula'):\n";
    llvm::outs() << "  -json=<file>        Emit JSON file of symbolic graphs\n";
    llvm::outs() << "  -subs=<file>        Apply substitutions from JSON\n";
    llvm::outs() << "  -time               Print execution time metrics\n\n";
    llvm::outs() << "  -quiet              Suppress textual output (use with -json)\n\n";
    llvm::outs() << "Kernel/Instance Options:\n";
    llvm::outs() << "  (add --output-to-file to write results binary)\n\n";
    llvm::outs() << "Examples:\n";
    llvm::outs() << "  symb_viewer kernel input.ll foo --output-to-file\n";
    llvm::outs() << "  symb_viewer instance input.ll foo\n";
    llvm::outs() << "  symb_viewer formula input.ll foo -json=foo.json -subs=vals.json\n";
    llvm::outs() << "  symb_viewer characterize input.ll foo -time\n";
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

    // Determine active subcommand modes
    bool kernelMode = (bool) KernelCmd;
    bool instanceMode = (bool) InstanceCmd;
    bool formulaMode = (bool) FormulaCmd;
    bool characterizeMode = (bool) CharacterizeCmd;

    // Apply substitutions only in formula mode
    if (formulaMode && !SubstitutionFile.empty()) {
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

    // Show symbolic formula (formula subcommand only)
    if (formulaMode) {
        if (!OutputJsonFilename.empty()) {
            std::ofstream jsonOut(OutputJsonFilename);
            GraphViewer::showAllBasicGraphsAsJson(program, jsonOut);
        } else if (!Quiet) {
            GraphViewer::showProgram(program);
        }
    }

    auto t_end = std::chrono::high_resolution_clock::now();

    if (instanceMode || kernelMode) {
        SymbInstance instance;
        std::vector<SymbolicExpr> exprs; // Populate this with symbolic expressions
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

        // generateTestMain: true for instance subcommand, false for kernel
        bool generateTestMain = instanceMode;
        // Use instance subcommand flag when active, otherwise kernel's flag
        auto module = instance.create(
            exprs, 
            basicBlockNames, 
            generateTestMain, 
            !OutputToFile
        );
        llvm::errs() << "Generated symbolic instance module.\n";
        module->print(llvm::outs(), nullptr);
    }

    if (Time) {
        llvm::outs() << "Total time: " 
                     << std::chrono::duration<double, std::milli>(t_end - t_start).count() << "ms\n";
        if (formulaMode && !SubstitutionFile.empty()) {
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

    // Perform program characterization (characterize subcommand)
    if (characterizeMode) {
        analyzeModule(M, *TargetFunc);
        llvm::outs() << "Number of symbolic loop counts: " << GB.SEM.loopCountNames.size() << "\n";
        llvm::outs() << "Number of symbolic true ratios: " << GB.SEM.trueRatioNames.size() << "\n";
        llvm::outs() << "Number of early exits: " << GB.earlyExits.size()/2 << "\n";
        llvm::outs() << "Number of composite symbolic expressions: " << GB.numComposite << "\n";
    }

    return 0;
}