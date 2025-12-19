/*
Symbolic instance is to instanciate symbolic expressions into executables
that can be run with concrete inputs to produce concrete outputs.

For example, given a symbolic expression x + y, we can instantiate it into
a function that takes two integers as input and returns their sum f(x, y) = x + y.
*/

#include "symb_expr.hpp"
#include "symb_instance.hpp"

#include <llvm/IR/IRBuilder.h>
#include <llvm/IR/LLVMContext.h>
#include <llvm/IR/Function.h>
#include <llvm/IR/BasicBlock.h>
#include <llvm/IR/Constants.h>

#include <cstdlib>
#include <llvm/IR/Type.h>
#include <llvm/Support/raw_ostream.h>
#include <string>
#include <memory>
#include <vector>
#include <set>

// Helper to collect uninterpreted symbols
void collectSymbols(const z3::expr& e, std::set<std::string>& symbols) {
    if (e.is_const() && e.decl().decl_kind() == Z3_OP_UNINTERPRETED) {
        symbols.insert(e.decl().name().str());
    }
    for (unsigned i = 0; i < e.num_args(); ++i) {
        collectSymbols(e.arg(i), symbols);
    }
}

std::unique_ptr<llvm::Module> SymbInstance::create(const std::vector<SymbolicExpr>& exprs,
                                                    const std::vector<std::string>& basicBlocks,
                                                    bool generateTestMain,
                                                    bool outputToStdout) {
    // Collect all uninterpreted symbols from expressions
    std::set<std::string> symbolSet;
    for (const auto& expr : exprs) {
        collectSymbols(expr.z3expr(), symbolSet);
    }
    std::vector<std::string> inputs(symbolSet.begin(), symbolSet.end());
    std::sort(inputs.begin(), inputs.end(), 
    [](const std::string& a, const std::string& b) {
        if (a.size() != b.size()) return a.size() < b.size();
        return a < b;
    });

    // Setup module and context
    llvm::LLVMContext *ctx = nullptr;
    std::unique_ptr<llvm::Module> module;
    setupModule(module, ctx);

    // Clear maps
    variableMap.clear();
    exprCache.clear();

    // Build kernel and entry builder
    llvm::Function* kernelFunc = buildKernel(module.get(), *ctx, inputs);
    llvm::BasicBlock* entryBlock = llvm::BasicBlock::Create(*ctx, "entry", kernelFunc);
    llvm::IRBuilder<> builder(entryBlock);

    // Declarations used by body/timing helpers
    llvm::Type* int64Ty = llvm::Type::getInt64Ty(*ctx);
    llvm::Type* voidPtrTy = llvm::PointerType::get(*ctx, 0);
    llvm::FunctionType* printfType = llvm::FunctionType::get(
        llvm::Type::getInt32Ty(*ctx), {voidPtrTy}, true);
    llvm::FunctionCallee printfFunc = module->getOrInsertFunction("printf", printfType);
    llvm::Value *endTime = nullptr;
    llvm::Value* resultsArray = nullptr;

    emitKernelBody(module.get(), *ctx, builder, exprs, basicBlocks, outputToStdout,
                   resultsArray, printfFunc, endTime);

    emitTiming(module.get(), *ctx, builder, printfFunc, endTime);

    // Optional test main
    if (generateTestMain) {
        buildTestMain(module.get(), *ctx, kernelFunc, inputs, printfFunc);
    }

    builder.CreateRet(llvm::ConstantInt::get(llvm::Type::getInt64Ty(*ctx), 0));
    return module;
}

void SymbInstance::setupModule(std::unique_ptr<llvm::Module>& module, llvm::LLVMContext*& ctx) {
    ctx = new llvm::LLVMContext();
    module = std::make_unique<llvm::Module>("SymbolicInstanceModule", *ctx);
}

llvm::Function* SymbInstance::buildKernel(llvm::Module* module, llvm::LLVMContext& ctx,
                                          const std::vector<std::string>& inputs) {
    std::vector<llvm::Type*> argTypes(inputs.size(), llvm::Type::getInt64Ty(ctx));
    auto kernelFuncType = llvm::FunctionType::get(llvm::Type::getInt64Ty(ctx), argTypes, false);
    auto kernelFunc = llvm::Function::Create(kernelFuncType, llvm::Function::ExternalLinkage, "kernel", module);
    size_t argIdx = 0;
    for (auto& arg : kernelFunc->args()) {
        std::string name = inputs[argIdx];
        arg.setName(name);
        variableMap[name] = &arg;
        argIdx++;
    }
    return kernelFunc;
}

void SymbInstance::emitKernelBody(llvm::Module* module, llvm::LLVMContext& ctx,
                                  llvm::IRBuilder<>& builder,
                                  const std::vector<SymbolicExpr>& exprs,
                                  const std::vector<std::string>& basicBlocks,
                                  bool outputToStdout,
                                  llvm::Value*& resultsArray,
                                  llvm::FunctionCallee& printfFunc,
                                  llvm::Value*& endTime) {
    llvm::Type* int64Ty = llvm::Type::getInt64Ty(ctx);
    llvm::Type* voidPtrTy = llvm::PointerType::get(ctx, 0);
    // printf decl is passed in
    
    // Use RDTSC for cycle-accurate timing (llvm.readcyclecounter intrinsic)
    llvm::FunctionType* rdtscType = llvm::FunctionType::get(int64Ty, {}, false);
    llvm::FunctionCallee rdtscFunc = module->getOrInsertFunction("llvm.readcyclecounter", rdtscType);
    
    // Capture start cycles
    llvm::Value* startCycles = builder.CreateCall(rdtscFunc);

    // Defer array materialization until after computing all results

    llvm::Value* fmtBlock = nullptr;
    if (outputToStdout) {
        fmtBlock = builder.CreateGlobalString("%s: %ld\n", "fmt_block");
    }

    // Collect computed results locally first
    std::vector<llvm::Value*> localResults;
    std::vector<std::string> blockNames;
    localResults.reserve(exprs.size());
    blockNames.reserve(exprs.size());
    for (size_t i = 0; i < exprs.size(); ++i) {
        std::string blockName = (i < basicBlocks.size()) ? basicBlocks[i] : "unknown_block";
        llvm::Value* value = createValueFromExpr(ctx, builder, exprs[i]);
        localResults.push_back(value);
        blockNames.push_back(blockName);
    }
    
    // Capture end cycles and compute elapsed
    llvm::Value* endCycles = builder.CreateCall(rdtscFunc);
    llvm::Value* elapsedCycles = builder.CreateSub(endCycles, startCycles);
    
    // Store elapsed cycles for emitTiming
    endTime = builder.CreateAlloca(int64Ty, nullptr, "elapsed_cycles");
    builder.CreateStore(elapsedCycles, endTime);

    // Print to stdout after all values computed
    if (outputToStdout) {
        for (size_t i = 0; i < localResults.size(); ++i) {
            llvm::Value* blockNamePtr = builder.CreateGlobalString(blockNames[i], "blkname");
            builder.CreateCall(printfFunc, {fmtBlock, blockNamePtr, localResults[i]});
        }
    }
    
    // Write results to text file if file mode (before timing ends)
    if (!outputToStdout) {
        // Materialize array and store all local results before printing
        llvm::ArrayType* arrayType = llvm::ArrayType::get(int64Ty, exprs.size());
        resultsArray = builder.CreateAlloca(arrayType, nullptr, "results");
        for (size_t i = 0; i < localResults.size(); ++i) {
            llvm::Value* indicesStore[] = {
                llvm::ConstantInt::get(llvm::Type::getInt32Ty(ctx), 0),
                llvm::ConstantInt::get(llvm::Type::getInt32Ty(ctx), (uint64_t)i)
            };
            llvm::Value* elementPtrStore = builder.CreateInBoundsGEP(arrayType, resultsArray, indicesStore);
            builder.CreateStore(localResults[i], elementPtrStore);
        }
        llvm::Type* filePtrTy = llvm::PointerType::get(llvm::Type::getInt8Ty(ctx), 0);
        llvm::FunctionType* fopenType = llvm::FunctionType::get(filePtrTy, {voidPtrTy, voidPtrTy}, false);
        llvm::FunctionCallee fopenFunc = module->getOrInsertFunction("fopen", fopenType);
        // int fprintf(FILE*, const char*, ...)
        llvm::FunctionType* fprintfType = llvm::FunctionType::get(llvm::Type::getInt32Ty(ctx), true);
        llvm::FunctionCallee fprintfFunc = module->getOrInsertFunction("fprintf", fprintfType);
        llvm::FunctionType* fcloseType = llvm::FunctionType::get(llvm::Type::getInt32Ty(ctx), {filePtrTy}, false);
        llvm::FunctionCallee fcloseFunc = module->getOrInsertFunction("fclose", fcloseType);

        llvm::Value* filename = builder.CreateGlobalString("results.txt", "filename_txt");
        llvm::Value* mode = builder.CreateGlobalString("w", "mode_txt");
        llvm::Value* file = builder.CreateCall(fopenFunc, {filename, mode});

        // Format string for lines
        llvm::Value* fmtLine = builder.CreateGlobalString("%ld\n", "fmt_line");
        // Iterate and print each stored element
        for (size_t i = 0; i < exprs.size(); ++i) {
            llvm::Value* indicesPrint[] = {
                llvm::ConstantInt::get(llvm::Type::getInt32Ty(ctx), 0),
                llvm::ConstantInt::get(llvm::Type::getInt32Ty(ctx), (uint64_t)i)
            };
            llvm::Value* elemPtr = builder.CreateInBoundsGEP(arrayType, resultsArray, indicesPrint);
            llvm::Value* elemVal = builder.CreateLoad(int64Ty, elemPtr);
            builder.CreateCall(fprintfFunc, {file, fmtLine, elemVal});
        }
        builder.CreateCall(fcloseFunc, {file});
    }
    
}

void SymbInstance::emitTiming(llvm::Module* module, llvm::LLVMContext& ctx,
                                       llvm::IRBuilder<>& builder,
                                       llvm::FunctionCallee& printfFunc,
                                       llvm::Value* endTime) {
    llvm::Type* int64Ty = llvm::Type::getInt64Ty(ctx);
    llvm::Type* doubleTy = llvm::Type::getDoubleTy(ctx);
    
    // Load elapsed cycles from storage
    llvm::Value* elapsedCycles = builder.CreateLoad(int64Ty, endTime, "elapsed_cycles");
    
    // Convert cycles to nanoseconds using lowest CPU frequency: 800 MHz = 0.8 GHz
    // nanoseconds = cycles / GHz = cycles / 0.8
    llvm::Value* cyclesDouble = builder.CreateUIToFP(elapsedCycles, doubleTy, "cycles_fp");
    llvm::Value* cpuFreqGHz = llvm::ConstantFP::get(doubleTy, 0.8);
    llvm::Value* nanoseconds = builder.CreateFDiv(cyclesDouble, cpuFreqGHz, "nanoseconds");
    
    // Print both cycles and nanoseconds
    llvm::Value* fmtTime = builder.CreateGlobalString("Kernel execution time: %ld cycles (%.2f ns @ 0.8 GHz)", "fmt_cycles_ns");
    builder.CreateCall(printfFunc, {fmtTime, elapsedCycles, nanoseconds});
}

void SymbInstance::buildTestMain(llvm::Module* module, llvm::LLVMContext& ctx,
                                 llvm::Function* kernelFunc,
                                 const std::vector<std::string>& inputs,
                                 llvm::FunctionCallee printfFunc) {
    llvm::Type* int64Ty = llvm::Type::getInt64Ty(ctx);
    llvm::Type* voidPtrTy = llvm::PointerType::get(ctx, 0);
    llvm::FunctionType* mainType = llvm::FunctionType::get(
        llvm::Type::getInt32Ty(ctx),
        {llvm::Type::getInt32Ty(ctx), llvm::PointerType::get(llvm::PointerType::get(llvm::Type::getInt8Ty(ctx), 0), 0)},
        false);
    llvm::Function* mainFunc = llvm::Function::Create(mainType, llvm::Function::ExternalLinkage, "main", module);
    auto it = mainFunc->arg_begin();
    llvm::Argument* argcArg = &*it; argcArg->setName("argc"); ++it;
    llvm::Argument* argvArg = &*it; argvArg->setName("argv");
    llvm::BasicBlock* mainEntry = llvm::BasicBlock::Create(ctx, "entry", mainFunc);
    llvm::IRBuilder<> mBuilder(mainEntry);
    llvm::FunctionType* atollType = llvm::FunctionType::get(int64Ty, {voidPtrTy}, false);
    llvm::FunctionCallee atollFunc = module->getOrInsertFunction("atoll", atollType);
    std::vector<llvm::Value*> kernelArgs;
    llvm::Value* one32 = llvm::ConstantInt::get(llvm::Type::getInt32Ty(ctx), 1);
    llvm::Value* provided = mBuilder.CreateSub(argcArg, one32);
    
    for (size_t i = 0; i < inputs.size(); ++i) {
        llvm::Value* idx = llvm::ConstantInt::get(llvm::Type::getInt32Ty(ctx), (uint64_t)(i + 1));
        llvm::Type* i8ptrTy = llvm::PointerType::get(llvm::Type::getInt8Ty(ctx), 0);
        llvm::Value* one64 = llvm::ConstantInt::get(int64Ty, 1);
        llvm::Value* i32const = llvm::ConstantInt::get(llvm::Type::getInt32Ty(ctx), (uint64_t)i);
        llvm::Value* cond = mBuilder.CreateICmpSGT(provided, i32const);
        llvm::BasicBlock* thenBB = llvm::BasicBlock::Create(ctx, "parse_then", mainFunc);
        llvm::BasicBlock* elseBB = llvm::BasicBlock::Create(ctx, "parse_else", mainFunc);
        llvm::BasicBlock* mergeBB = llvm::BasicBlock::Create(ctx, "parse_merge", mainFunc);
        mBuilder.CreateCondBr(cond, thenBB, elseBB);
        llvm::Value* parsedVal = nullptr;
        {
            llvm::IRBuilder<> thenBuilder(thenBB);
            llvm::Value* gep = thenBuilder.CreateInBoundsGEP(i8ptrTy, argvArg, idx);
            llvm::Value* argPtr = thenBuilder.CreateLoad(i8ptrTy, gep);
            llvm::Value* parsed = thenBuilder.CreateCall(atollFunc, {argPtr});
            thenBuilder.CreateBr(mergeBB);
            parsedVal = parsed;
        }
        {
            llvm::IRBuilder<> elseBuilder(elseBB);
            elseBuilder.CreateBr(mergeBB);
        }
        llvm::IRBuilder<> mergeBuilder(mergeBB);
        llvm::PHINode* phi = mergeBuilder.CreatePHI(int64Ty, 2);
        phi->addIncoming(parsedVal, thenBB);
        phi->addIncoming(one64, elseBB);
        llvm::Value* inputNamePtr = mergeBuilder.CreateGlobalString(inputs[i], "input_name");
        llvm::Value* fmtInput = mergeBuilder.CreateGlobalString("Input %s: %ld\n", "fmt_input");
        mergeBuilder.CreateCall(printfFunc, {fmtInput, inputNamePtr, phi});
        kernelArgs.push_back(phi);
        llvm::BasicBlock* contBB = llvm::BasicBlock::Create(ctx, "cont", mainFunc);
        mergeBuilder.CreateBr(contBB);
        mBuilder.SetInsertPoint(contBB);
    }
    llvm::Value* kernelCall = mBuilder.CreateCall(kernelFunc, kernelArgs);
    (void)kernelCall;
    mBuilder.CreateRet(llvm::ConstantInt::get(llvm::Type::getInt32Ty(ctx), 0));
}

llvm::Value* SymbInstance::createValueFromExpr(llvm::LLVMContext& ctx, llvm::IRBuilder<>& builder, const SymbolicExpr& expr) {
    return createValueFromZ3Expr(ctx, builder, expr.z3expr());
}

namespace {
    // Helper function to check if expression needs lazy evaluation
    bool needsLazyEvaluation(const z3::expr& e) {
        Z3_decl_kind k = e.decl().decl_kind();
        if (k == Z3_OP_BSDIV || k == Z3_OP_BSDIV_I ||
            k == Z3_OP_BUDIV || k == Z3_OP_BUDIV_I ||
            k == Z3_OP_BSREM || k == Z3_OP_BUREM) {
            return true;
        }
        for (unsigned i = 0; i < e.num_args(); ++i) {
            Z3_decl_kind arg_k = e.arg(i).decl().decl_kind();
            if (arg_k == Z3_OP_BSDIV || arg_k == Z3_OP_BSDIV_I ||
                arg_k == Z3_OP_BUDIV || arg_k == Z3_OP_BUDIV_I ||
                arg_k == Z3_OP_BSREM || arg_k == Z3_OP_BUREM) {
                return true;
            }
        }
        return false;
    }
}

llvm::Value* SymbInstance::createValueFromZ3Expr(llvm::LLVMContext& ctx, llvm::IRBuilder<>& builder, const z3::expr& expr) {
    // Check cache first
    unsigned exprId = expr.id();
    auto it = exprCache.find(exprId);
    if (it != exprCache.end()) {
        return it->second;
    }
    
    // Determine integer type from Z3 bit-vector width when available, else i64
    llvm::Type* int64Ty = llvm::Type::getInt64Ty(ctx);
    unsigned bitWidth = 64;
    if (expr.get_sort().is_bv()) {
        unsigned bw = expr.get_sort().bv_size();
        if (bw == 1) bitWidth = 1;
        else if (bw <= 32) bitWidth = 32;
        else if (bw <= 64) bitWidth = 64;
        else bitWidth = bw;
    }
    llvm::Type* intTy = llvm::IntegerType::get(ctx, bitWidth);

    (void)expr;

    if (expr.is_numeral()) {
        // Try to parse as integer constant
        std::string s = expr.to_string();
        int64_t val = 0;
        try {
            if (s.size() >= 2 && s[0] == '#' && s[1] == 'x') {
                val = static_cast<int64_t>(std::stoull(s.substr(2), nullptr, 16));
            } else if (s.size() >= 2 && s[0] == '#' && s[1] == 'b') {
                val = static_cast<int64_t>(std::stoull(s.substr(2), nullptr, 2));
            } else {
                val = std::stoll(s);
            }
        } catch (...) {
            // Fallback: try Z3 API directly
            uint64_t uval = 0;
            if (Z3_get_numeral_uint64(expr.ctx(), expr, &uval)) {
                val = static_cast<int64_t>(uval);
            } else {
                val = 0; 
            }
        }
        // Use the expression's bit-width for bit-vectors, otherwise i64
        llvm::Type* constTy = expr.get_sort().is_bv() ? intTy : int64Ty;
        llvm::Value* constVal = llvm::ConstantInt::get(constTy, (uint64_t)val);
        exprCache[exprId] = constVal;
        return constVal;
    }

    Z3_decl_kind kind = expr.decl().decl_kind();
    
    // Special handling for ITE - use lazy evaluation only if branches contain unsafe operations
    if (kind == Z3_OP_ITE) {
        // Check if either branch needs lazy evaluation (contains division/remainder)
        bool needsLazy = needsLazyEvaluation(expr.arg(1)) || needsLazyEvaluation(expr.arg(2));
        
        if (needsLazy) {
            // Use branching for lazy evaluation
            llvm::Value* condVal = createValueFromZ3Expr(ctx, builder, expr.arg(0));
            
            // Ensure condition is i1 for branch
            if (condVal->getType()->isIntegerTy() && condVal->getType()->getIntegerBitWidth() > 1) {
                condVal = builder.CreateTrunc(condVal, llvm::Type::getInt1Ty(ctx), "condtrunc");
            }
            
            // Get current function for creating basic blocks
            llvm::Function* parentFunc = builder.GetInsertBlock()->getParent();
            
            // Create basic blocks for then, else, and merge
            llvm::BasicBlock* thenBB = llvm::BasicBlock::Create(ctx, "ite_then", parentFunc);
            llvm::BasicBlock* elseBB = llvm::BasicBlock::Create(ctx, "ite_else", parentFunc);
            llvm::BasicBlock* mergeBB = llvm::BasicBlock::Create(ctx, "ite_merge", parentFunc);
            
            // Create conditional branch
            builder.CreateCondBr(condVal, thenBB, elseBB);
            
            // Generate then branch - only evaluate expr.arg(1) in this branch
            builder.SetInsertPoint(thenBB);
            llvm::Value* thenVal = createValueFromZ3Expr(ctx, builder, expr.arg(1));
            builder.CreateBr(mergeBB);
            llvm::BasicBlock* thenExitBB = builder.GetInsertBlock();
            
            // Generate else branch - only evaluate expr.arg(2) in this branch
            builder.SetInsertPoint(elseBB);
            llvm::Value* elseVal = createValueFromZ3Expr(ctx, builder, expr.arg(2));
            builder.CreateBr(mergeBB);
            llvm::BasicBlock* elseExitBB = builder.GetInsertBlock();
            
            // Merge results with PHI node
            builder.SetInsertPoint(mergeBB);
            llvm::PHINode* phi = builder.CreatePHI(intTy, 2, "itetmp");
            phi->addIncoming(thenVal, thenExitBB);
            phi->addIncoming(elseVal, elseExitBB);
            
            exprCache[exprId] = phi;
            return phi;
        }
        // Fall through to use efficient Select instruction if no lazy evaluation needed
    }
    
    // Recursively lower operands for all other operations
    std::vector<llvm::Value*> llvmOps;
    unsigned num_args = expr.num_args();
    for (unsigned i = 0; i < num_args; ++i) {
        llvmOps.push_back(createValueFromZ3Expr(ctx, builder, expr.arg(i)));
    }

    (void)kind; (void)expr;
    
    // Helper to cache and return value
    auto cacheAndReturn = [&](llvm::Value* val) -> llvm::Value* {
        exprCache[exprId] = val;
        return val;
    };
    
    switch (kind) {
        case Z3_OP_BADD: {
            llvm::Value* result = llvmOps[0];
            for (size_t i = 1; i < llvmOps.size(); ++i) {
                result = builder.CreateAdd(result, llvmOps[i], "addtmp");
            }
            return cacheAndReturn(result);
        }
        case Z3_OP_BSUB: {
            llvm::Value* result = llvmOps[0];
            for (size_t i = 1; i < llvmOps.size(); ++i) {
                result = builder.CreateSub(result, llvmOps[i], "subtmp");
            }
            return cacheAndReturn(result);
        }
        case Z3_OP_BMUL: {
            llvm::Value* result = llvmOps[0];
            for (size_t i = 1; i < llvmOps.size(); ++i) {
                result = builder.CreateMul(result, llvmOps[i], "multmp");
            }
            return cacheAndReturn(result);
        }
        case Z3_OP_BSDIV:
        case Z3_OP_BSDIV_I:{
            return cacheAndReturn(builder.CreateSDiv(llvmOps[0], llvmOps[1], "sdivtmp"));
        }
        case Z3_OP_BUDIV:
        case Z3_OP_BUDIV_I:{
            return cacheAndReturn(builder.CreateUDiv(llvmOps[0], llvmOps[1], "udivtmp"));
        }
        case Z3_OP_BSREM:
            return cacheAndReturn(builder.CreateSRem(llvmOps[0], llvmOps[1], "sremtmp"));
        case Z3_OP_BUREM:
            return cacheAndReturn(builder.CreateURem(llvmOps[0], llvmOps[1], "uremtmp"));
        case Z3_OP_BNEG:
            return cacheAndReturn(builder.CreateNeg(llvmOps[0], "negtmp"));
        case Z3_OP_AND: {
            llvm::Value* result = llvmOps[0];
            for (size_t i = 1; i < llvmOps.size(); ++i) {
                result = builder.CreateAnd(result, llvmOps[i], "bool_and_tmp");
            }
            return cacheAndReturn(result);
        }
        case Z3_OP_XOR: {
            llvm::Value* result = llvmOps[0];
            for (size_t i = 1; i < llvmOps.size(); ++i) {
                result = builder.CreateXor(result, llvmOps[i], "bool_xor_tmp");
            }
            return cacheAndReturn(result);
        }
        case Z3_OP_OR: {
            llvm::Value* result = llvmOps[0];
            for (size_t i = 1; i < llvmOps.size(); ++i) {
                result = builder.CreateOr(result, llvmOps[i], "bool_or_tmp");
            }
            return cacheAndReturn(result);
        }
        case Z3_OP_BXOR: {
            llvm::Value* result = llvmOps[0];
            for (size_t i = 1; i < llvmOps.size(); ++i) {
                result = builder.CreateXor(result, llvmOps[i], "xortmp");
            }
            return cacheAndReturn(result);
        }
        case Z3_OP_BNOT:
            return cacheAndReturn(builder.CreateXor(
                llvmOps[0],
                llvm::ConstantInt::get(llvmOps[0]->getType(), 1), 
                "bnottmp")
            );
        case Z3_OP_NOT:
            return cacheAndReturn(builder.CreateNot(llvmOps[0], "nottmp"));
        case Z3_OP_BSHL:
            return cacheAndReturn(builder.CreateShl(llvmOps[0], llvmOps[1], "shltmp"));
        case Z3_OP_BLSHR:
            return cacheAndReturn(builder.CreateLShr(llvmOps[0], llvmOps[1], "lshrtmp"));
        case Z3_OP_BASHR:
            return cacheAndReturn(builder.CreateAShr(llvmOps[0], llvmOps[1], "ashrtmp"));
            
        case Z3_OP_ITE: {
            // Use efficient Select instruction (both branches already evaluated)
            llvm::Value* cond = llvmOps[0];
            if (cond->getType()->isIntegerTy() && cond->getType()->getIntegerBitWidth() > 1) {
                cond = builder.CreateTrunc(cond, llvm::Type::getInt1Ty(ctx), "condtrunc");
            }
            return cacheAndReturn(
                builder.CreateSelect(cond, llvmOps[1], llvmOps[2], "selecttmp")
            );
        }

        case Z3_OP_EQ:
            return cacheAndReturn(
                builder.CreateZExt(
                    builder.CreateICmpEQ(llvmOps[0], llvmOps[1]),
                    int64Ty,
                    "eqtmp"
                )
            );
        case Z3_OP_DISTINCT:
            return cacheAndReturn(
                builder.CreateZExt(
                    builder.CreateICmpNE(llvmOps[0], llvmOps[1]),
                    int64Ty,
                    "netmp"
                )
            );
             
        case Z3_OP_SLT: {
            return cacheAndReturn(
                builder.CreateZExt(
                    builder.CreateICmpSLT(llvmOps[0], llvmOps[1]),
                    int64Ty,
                    "slttmp"
                )
            );
        }
        case Z3_OP_SLEQ: {
            return cacheAndReturn(
                builder.CreateZExt(
                    builder.CreateICmpSLE(llvmOps[0], llvmOps[1]),
                    int64Ty,
                    "sletmp"
                )
            );
        }
        case Z3_OP_SGT: {
            return cacheAndReturn(
                builder.CreateZExt(
                    builder.CreateICmpSGT(llvmOps[0], llvmOps[1]),
                    int64Ty,
                    "sgttmp"
                )
            );
        }
        case Z3_OP_SGEQ: {
            return cacheAndReturn(
                builder.CreateZExt(
                    builder.CreateICmpSGE(llvmOps[0], llvmOps[1]),
                    int64Ty,
                    "sgetmp"
                )
            );
        }
        case Z3_OP_ULT: {
            return cacheAndReturn(
                builder.CreateZExt(
                    builder.CreateICmpULT(llvmOps[0], llvmOps[1]),
                    int64Ty,
                    "ulttmp"
                )
            );
        }
        case Z3_OP_ULEQ: {
            return cacheAndReturn(
                builder.CreateZExt(
                    builder.CreateICmpULE(llvmOps[0], llvmOps[1]),
                    int64Ty,
                    "uletmp"
                )
            );
        }
        case Z3_OP_UGT: {
            return cacheAndReturn(
                builder.CreateZExt(
                    builder.CreateICmpUGT(llvmOps[0], llvmOps[1]),
                    int64Ty,
                    "ugttmp"
                )
            );
        }
        case Z3_OP_UGEQ: {
            return cacheAndReturn(
                builder.CreateZExt(
                    builder.CreateICmpUGE(llvmOps[0], llvmOps[1]),
                    int64Ty,
                    "ugetmp"
                )
            );
        }

        case Z3_OP_SIGN_EXT: {
            // Extend operand to the destination bit-width of this expr
            unsigned src_size = llvmOps[0]->getType()->getIntegerBitWidth();
            unsigned dst_size = bitWidth;
            if (src_size < dst_size) {
                llvm::Type* dstTy = llvm::IntegerType::get(ctx, dst_size);
                return cacheAndReturn(builder.CreateSExt(llvmOps[0], dstTy));
            }
            return cacheAndReturn(llvmOps[0]);
        }
        case Z3_OP_ZERO_EXT: {
            // Zero-extend operand to the destination bit-width of this expr
            unsigned src_size = llvmOps[0]->getType()->getIntegerBitWidth();
            unsigned dst_size = bitWidth;
            if (src_size < dst_size) {
                llvm::Type* dstTy = llvm::IntegerType::get(ctx, dst_size);
                return cacheAndReturn(builder.CreateZExt(llvmOps[0], dstTy));
            }
            return cacheAndReturn(llvmOps[0]);
        }
            
        case Z3_OP_EXTRACT: {
            unsigned lo = expr.lo();
            unsigned hi = expr.hi();
            unsigned width = hi - lo + 1; // destination bit-width
            llvm::Value* val = llvmOps[0];                   // operand value (original width)
            unsigned opWidth = val->getType()->getIntegerBitWidth();
            if (lo > 0) {
                val = builder.CreateLShr(val, llvm::ConstantInt::get(val->getType(), lo));
            }
            if (bitWidth < opWidth) {
                llvm::Type* dstTy = llvm::IntegerType::get(ctx, bitWidth);
                val = builder.CreateTrunc(val, dstTy);
            }
            if (width < bitWidth) {
                llvm::Value* mask = llvm::ConstantInt::get(val->getType(), (1ULL << width) - 1);
                val = builder.CreateAnd(val, mask, "extract_mask");
            }
            return cacheAndReturn(val);
        }
        
        case Z3_OP_CONCAT: {
            unsigned low_width = expr.arg(1).get_sort().bv_size();
            unsigned dst_width = bitWidth;
            llvm::Type* dstTy = llvm::IntegerType::get(ctx, dst_width);
            llvm::Value* high = llvmOps[0];
            llvm::Value* low = llvmOps[1];
            // Extend parts to destination width
            if (high->getType() != dstTy) high = builder.CreateZExt(high, dstTy);
            if (low->getType() != dstTy) low = builder.CreateZExt(low, dstTy);
            llvm::Value* high_shifted = builder.CreateShl(
                high, 
                llvm::ConstantInt::get(dstTy, low_width)
            );
            return cacheAndReturn(builder.CreateOr(high_shifted, low));
        }

        case Z3_OP_UNINTERPRETED: {
            std::string name = expr.decl().name().str();
            if (variableMap.find(name) != variableMap.end()) {
                llvm::Value* var = variableMap[name]; // kernel arg is i64
                if (expr.get_sort().is_bv()) {
                    unsigned dst_width = bitWidth;
                    llvm::Type* dstTy = llvm::IntegerType::get(ctx, dst_width);
                    unsigned src_width = var->getType()->getIntegerBitWidth();
                    if (src_width == dst_width) {
                        return cacheAndReturn(var);
                    } else if (src_width > dst_width) {
                        return cacheAndReturn(builder.CreateTrunc(var, dstTy));
                    } else {
                        return cacheAndReturn(builder.CreateZExt(var, dstTy));
                    }
                }
                return cacheAndReturn(var);
            }
            (void)name;
            return cacheAndReturn(llvm::ConstantInt::get(int64Ty, 0));
        }

        // Additional bit-vector operations
        case Z3_OP_BAND:
            return cacheAndReturn(builder.CreateAnd(llvmOps[0], llvmOps[1], "bandtmp"));
        case Z3_OP_BOR:
            return cacheAndReturn(builder.CreateOr(llvmOps[0], llvmOps[1], "bortmp"));
        case Z3_OP_BNAND:
            return cacheAndReturn(builder.CreateNot(builder.CreateAnd(
                llvmOps[0], 
                llvmOps[1], 
                "andtmp"), 
                "bnandtmp")
            );
        case Z3_OP_BNOR:
            return cacheAndReturn(builder.CreateNot(
                builder.CreateOr(llvmOps[0], llvmOps[1], "ortmp"), 
                "bnortmp")
            );
        case Z3_OP_BXNOR:
            return cacheAndReturn(builder.CreateNot(
                builder.CreateXor(llvmOps[0], llvmOps[1], "xortmp"), "bxnortmp")
            );
        
        // Bit-vector rotation operations
        case Z3_OP_ROTATE_LEFT: {
            unsigned rotateAmount = expr.get_sort().bv_size();
            if (expr.num_args() == 2) {
                // Variable rotation
                llvm::Value* shl = builder.CreateShl(llvmOps[0], llvmOps[1]);
                llvm::Value* width = llvm::ConstantInt::get(llvmOps[1]->getType(), bitWidth);
                llvm::Value* shrAmount = builder.CreateSub(width, llvmOps[1]);
                llvm::Value* shr = builder.CreateLShr(llvmOps[0], shrAmount);
                return cacheAndReturn(builder.CreateOr(shl, shr, "rotltmp"));
            } else {
                // Fixed rotation amount from decl parameter
                rotateAmount = expr.decl().num_parameters() > 0 ? 
                    Z3_get_decl_int_parameter(expr.ctx(), expr.decl(), 0) : 0;
                llvm::Value* shl = builder.CreateShl(llvmOps[0], llvm::ConstantInt::get(intTy, rotateAmount));
                llvm::Value* shr = builder.CreateLShr(llvmOps[0], llvm::ConstantInt::get(intTy, bitWidth - rotateAmount));
                return cacheAndReturn(builder.CreateOr(shl, shr, "rotltmp"));
            }
        }
        case Z3_OP_ROTATE_RIGHT: {
            unsigned rotateAmount = expr.get_sort().bv_size();
            if (expr.num_args() == 2) {
                // Variable rotation
                llvm::Value* shr = builder.CreateLShr(llvmOps[0], llvmOps[1]);
                llvm::Value* width = llvm::ConstantInt::get(llvmOps[1]->getType(), bitWidth);
                llvm::Value* shlAmount = builder.CreateSub(width, llvmOps[1]);
                llvm::Value* shl = builder.CreateShl(llvmOps[0], shlAmount);
                return cacheAndReturn(builder.CreateOr(shr, shl, "rotrtmp"));
            } else {
                // Fixed rotation amount from decl parameter
                rotateAmount = expr.decl().num_parameters() > 0 ? 
                    Z3_get_decl_int_parameter(expr.ctx(), expr.decl(), 0) : 0;
                llvm::Value* shr = builder.CreateLShr(
                    llvmOps[0], 
                    llvm::ConstantInt::get(intTy, rotateAmount)
                );
                llvm::Value* shl = builder.CreateShl(
                    llvmOps[0], 
                    llvm::ConstantInt::get(intTy, bitWidth - rotateAmount)
                );
                return cacheAndReturn(builder.CreateOr(shr, shl, "rotrtmp"));
            }
        }
        
        // Bit-vector extension operations (already handled above, but adding for completeness)
        case Z3_OP_EXT_ROTATE_LEFT:
        case Z3_OP_EXT_ROTATE_RIGHT:
            // These are typically expanded by Z3 into standard operations
            llvm::errs() << "Warning: Extended rotation operations should be expanded by Z3\n";
            return cacheAndReturn(llvmOps[0]);
        
        // Bit-vector reduction operations
        case Z3_OP_BCOMP: {
            // Bit-vector comparison: returns 1-bit result (1 if equal, 0 otherwise)
            llvm::Value* cmp = builder.CreateICmpEQ(llvmOps[0], llvmOps[1]);
            return cacheAndReturn(builder.CreateZExt(cmp, intTy, "bcomptmp"));
        }
        
        case Z3_OP_BREDAND: {
            // Reduction AND: result is 1 if all bits are 1
            llvm::Value* allOnes = llvm::ConstantInt::get(llvmOps[0]->getType(), -1);
            llvm::Value* cmp = builder.CreateICmpEQ(llvmOps[0], allOnes);
            return cacheAndReturn(builder.CreateZExt(cmp, intTy, "bredandtmp"));
        }
        
        case Z3_OP_BREDOR: {
            // Reduction OR: result is 1 if any bit is 1
            llvm::Value* zero = llvm::ConstantInt::get(llvmOps[0]->getType(), 0);
            llvm::Value* cmp = builder.CreateICmpNE(llvmOps[0], zero);
            return cacheAndReturn(builder.CreateZExt(cmp, intTy, "bredortmp"));
        }
        
        // Integer to bit-vector conversion
        case Z3_OP_INT2BV: {
            // Convert integer to bit-vector of specified width
            if (llvmOps[0]->getType()->getIntegerBitWidth() == bitWidth) {
                return cacheAndReturn(llvmOps[0]);
            } else if (llvmOps[0]->getType()->getIntegerBitWidth() < bitWidth) {
                return cacheAndReturn(builder.CreateZExt(llvmOps[0], intTy, "int2bv"));
            } else {
                return cacheAndReturn(builder.CreateTrunc(llvmOps[0], intTy, "int2bv"));
            }
        }
        
        // Bit-vector to integer conversion
        case Z3_OP_BV2INT: {
            // Convert bit-vector to integer (already in integer representation)
            return cacheAndReturn(llvmOps[0]);
        }
        
        // Bit-vector carry operations
        case Z3_OP_CARRY: {
            // Carry bit from addition: (x + y) < x
            llvm::Value* sum = builder.CreateAdd(llvmOps[0], llvmOps[1]);
            llvm::Value* carry = builder.CreateICmpULT(sum, llvmOps[0]);
            return cacheAndReturn(builder.CreateZExt(carry, intTy, "carrytmp"));
        }
        
        // Bit-vector repeat operation
        case Z3_OP_REPEAT: {
            unsigned repeatCount = expr.decl().num_parameters() > 0 ? 
                Z3_get_decl_int_parameter(expr.ctx(), expr.decl(), 0) : 1;
            llvm::Value* result = llvmOps[0];
            unsigned srcWidth = llvmOps[0]->getType()->getIntegerBitWidth();
            for (unsigned i = 1; i < repeatCount; ++i) {
                llvm::Value* shifted = builder.CreateShl(
                    result, 
                    llvm::ConstantInt::get(intTy, srcWidth)
                );
                llvm::Value* extended = builder.CreateZExt(llvmOps[0], result->getType());
                result = builder.CreateOr(shifted, extended, "repeattmp");
            }
            return cacheAndReturn(result);
        }

        default:
            // Fallback: treat as constant zero
            (void)kind;
            llvm::errs() << "Warning: Unhandled Z3 expression kind " << kind << ", defaulting to zero.\n";
            return cacheAndReturn(llvm::ConstantInt::get(int64Ty, 0));
    }
}