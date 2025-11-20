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
#include <llvm/Support/raw_ostream.h>
#include <string>
#include <memory>
#include <vector>
#include <set>
#include <algorithm>
#include <z3_api.h>

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
                                                    const std::vector<std::string>& basicBlocks) {
    // Collect all uninterpreted symbols from expressions
    std::set<std::string> symbolSet;
    for (const auto& expr : exprs) {
        collectSymbols(expr.z3expr(), symbolSet);
    }
    std::vector<std::string> inputs(symbolSet.begin(), symbolSet.end());
    
    // Create an LLVM context and module
    llvm::LLVMContext *ctx = new llvm::LLVMContext();
    auto module = std::make_unique<llvm::Module>("SymbolicInstanceModule", *ctx);

    // Clear variable map
    variableMap.clear();

    // Define the kernel function
    std::vector<llvm::Type*> argTypes(inputs.size(), llvm::Type::getInt64Ty(*ctx));
    auto kernelFuncType = llvm::FunctionType::get(llvm::Type::getInt64Ty(*ctx), argTypes, false);
    auto kernelFunc = llvm::Function::Create(kernelFuncType, llvm::Function::ExternalLinkage, "kernel", module.get());

    // Map inputs to arguments
    size_t argIdx = 0;
    for (auto& arg : kernelFunc->args()) {
        std::string name = inputs[argIdx];
        arg.setName(name);
        variableMap[name] = &arg;
        argIdx++;
    }

    // Create a basic block for the kernel function
    auto entryBlock = llvm::BasicBlock::Create(*ctx, "entry", kernelFunc);
    llvm::IRBuilder<> builder(entryBlock);

    // Create global variable for results
    llvm::ArrayType* resultArrType = llvm::ArrayType::get(llvm::Type::getInt64Ty(*ctx), exprs.size());
    llvm::GlobalVariable* resultsVar = new llvm::GlobalVariable(
        *module,
        resultArrType,
        false, // isConstant
        llvm::GlobalValue::ExternalLinkage,
        llvm::ConstantAggregateZero::get(resultArrType), // Initializer
        "results"
    );

    for (size_t i = 0; i < exprs.size(); ++i) {
        // Print the value and the corresponding basic block name
        std::string blockName = (i < basicBlocks.size()) ? basicBlocks[i] : "unknown_block";
        llvm::errs() << "Creating print for expression " << i << " in block " << blockName << "\n";

        // Create a value from the symbolic expression
        llvm::Value* value = createValueFromExpr(*ctx, builder, exprs[i]);

        // Store value to results[i]
        std::vector<llvm::Value*> indices;
        indices.push_back(llvm::ConstantInt::get(llvm::Type::getInt64Ty(*ctx), 0)); // Array index (pointer arithmetic)
        indices.push_back(llvm::ConstantInt::get(llvm::Type::getInt64Ty(*ctx), i)); // Element index
        
        llvm::Value* ptr = builder.CreateInBoundsGEP(
            resultArrType,
            resultsVar,
            indices
        );
        builder.CreateStore(value, ptr);
    }

    /*
    // Manifest results to file
    llvm::Type* voidPtrTy = llvm::PointerType::get(*ctx, 0);
    llvm::Type* int64Ty = llvm::Type::getInt64Ty(*ctx);

    // FILE* fopen(const char*, const char*)
    llvm::FunctionType* fopenType = llvm::FunctionType::get(voidPtrTy, {voidPtrTy, voidPtrTy}, false);
    llvm::FunctionCallee fopenFunc = module->getOrInsertFunction("fopen", fopenType);

    // size_t fwrite(const void*, size_t, size_t, FILE*)
    llvm::FunctionType* fwriteType = llvm::FunctionType::get(int64Ty, {voidPtrTy, int64Ty, int64Ty, voidPtrTy}, false);
    llvm::FunctionCallee fwriteFunc = module->getOrInsertFunction("fwrite", fwriteType);

    // int fclose(FILE*)
    llvm::FunctionType* fcloseType = llvm::FunctionType::get(llvm::Type::getInt32Ty(*ctx), {voidPtrTy}, false);
    llvm::FunctionCallee fcloseFunc = module->getOrInsertFunction("fclose", fcloseType);

    llvm::Value* filename = builder.CreateGlobalString("results.bin", "filename");
    llvm::Value* mode = builder.CreateGlobalString("wb", "mode");

    llvm::Value* filePtr = builder.CreateCall(fopenFunc, {filename, mode});
    
    llvm::Value* elemSize = llvm::ConstantInt::get(int64Ty, 8);
    llvm::Value* numElems = llvm::ConstantInt::get(int64Ty, exprs.size());
    llvm::Value* dataPtr = builder.CreateBitCast(resultsVar, voidPtrTy);
    
    builder.CreateCall(fwriteFunc, {dataPtr, elemSize, numElems, filePtr});
    builder.CreateCall(fcloseFunc, {filePtr});
    */

    builder.CreateRet(llvm::ConstantInt::get(llvm::Type::getInt64Ty(*ctx), 0));
    return module;
}

llvm::Value* SymbInstance::createValueFromExpr(llvm::LLVMContext& ctx, llvm::IRBuilder<>& builder, const SymbolicExpr& expr) {
    return createValueFromZ3Expr(ctx, builder, expr.z3expr());
}

llvm::Value* SymbInstance::createValueFromZ3Expr(llvm::LLVMContext& ctx, llvm::IRBuilder<>& builder, const z3::expr& expr) {
    // Default type is int64
    llvm::Type* int64Ty = llvm::Type::getInt64Ty(ctx);

    llvm::errs() << "Processing Z3 expr: " << expr.to_string() << "\n";

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
        llvm::errs() << "  -> Constant: " << val << "\n";
        return llvm::ConstantInt::get(int64Ty, val);
    }

    // Recursively lower operands
    std::vector<llvm::Value*> llvmOps;
    unsigned num_args = expr.num_args();
    for (unsigned i = 0; i < num_args; ++i) {
        llvmOps.push_back(createValueFromZ3Expr(ctx, builder, expr.arg(i)));
    }

    Z3_decl_kind kind = expr.decl().decl_kind();
    llvm::errs() << "  -> Kind: " << kind << "\n";

    switch (kind) {
        case Z3_OP_BADD: {
            llvm::Value* result = llvmOps[0];
            for (size_t i = 1; i < llvmOps.size(); ++i) {
                result = builder.CreateAdd(result, llvmOps[i], "addtmp");
            }
            return result;
        }
        case Z3_OP_BSUB: {
            llvm::Value* result = llvmOps[0];
            for (size_t i = 1; i < llvmOps.size(); ++i) {
                result = builder.CreateSub(result, llvmOps[i], "subtmp");
            }
            return result;
        }
        case Z3_OP_BMUL: {
            llvm::Value* result = llvmOps[0];
            for (size_t i = 1; i < llvmOps.size(); ++i) {
                result = builder.CreateMul(result, llvmOps[i], "multmp");
            }
            return result;
        }
        case Z3_OP_BSDIV:
        case Z3_OP_BSDIV_I:
            return builder.CreateSDiv(llvmOps[0], llvmOps[1], "sdivtmp");
        case Z3_OP_BUDIV:
        case Z3_OP_BUDIV_I:
            return builder.CreateUDiv(llvmOps[0], llvmOps[1], "udivtmp");
        case Z3_OP_BSREM:
            return builder.CreateSRem(llvmOps[0], llvmOps[1], "sremtmp");
        case Z3_OP_BUREM:
            return builder.CreateURem(llvmOps[0], llvmOps[1], "uremtmp");
        case Z3_OP_BNEG:
            return builder.CreateNeg(llvmOps[0], "negtmp");
        case Z3_OP_BAND: {
            llvm::Value* result = llvmOps[0];
            for (size_t i = 1; i < llvmOps.size(); ++i) {
                result = builder.CreateAnd(result, llvmOps[i], "andtmp");
            }
            return result;
        }
        case Z3_OP_BOR: {
            llvm::Value* result = llvmOps[0];
            for (size_t i = 1; i < llvmOps.size(); ++i) {
                result = builder.CreateOr(result, llvmOps[i], "ortmp");
            }
            return result;
        }
        case Z3_OP_OR: {
            llvm::Value* result = llvmOps[0];
            for (size_t i = 1; i < llvmOps.size(); ++i) {
                result = builder.CreateOr(result, llvmOps[i], "bool_or_tmp");
            }
            return result;
        }
        case Z3_OP_BXOR: {
            llvm::Value* result = llvmOps[0];
            for (size_t i = 1; i < llvmOps.size(); ++i) {
                result = builder.CreateXor(result, llvmOps[i], "xortmp");
            }
            return result;
        }
        case Z3_OP_AND: {
            llvm::Value* result = llvmOps[0];
            for (size_t i = 1; i < llvmOps.size(); ++i) {
                result = builder.CreateAnd(result, llvmOps[i], "bool_and_tmp");
            }
            return result;
        }
        case Z3_OP_XOR: {
            llvm::Value* result = llvmOps[0];
            for (size_t i = 1; i < llvmOps.size(); ++i) {
                result = builder.CreateXor(result, llvmOps[i], "bool_xor_tmp");
            }
            return result;
        }
        case Z3_OP_BNOT:
            return builder.CreateNot(llvmOps[0], "nottmp");
        case Z3_OP_NOT:
            // Boolean NOT: 1 -> 0, 0 -> 1.
            // Assuming input is 0 or 1 (int64).
            return builder.CreateXor(llvmOps[0], llvm::ConstantInt::get(int64Ty, 1), "bool_not_tmp");
        case Z3_OP_BSHL:
            return builder.CreateShl(llvmOps[0], llvmOps[1], "shltmp");
        case Z3_OP_BLSHR:
            return builder.CreateLShr(llvmOps[0], llvmOps[1], "lshrtmp");
        case Z3_OP_BASHR:
            return builder.CreateAShr(llvmOps[0], llvmOps[1], "ashrtmp");
            
        case Z3_OP_ITE: {
            llvm::Value* cond = llvmOps[0];
            // Ensure condition is i1 for Select
            if (cond->getType()->isIntegerTy() && cond->getType()->getIntegerBitWidth() > 1) {
                cond = builder.CreateTrunc(cond, llvm::Type::getInt1Ty(ctx), "condtrunc");
            }
            return builder.CreateSelect(cond, llvmOps[1], llvmOps[2], "selecttmp");
        }

        case Z3_OP_EQ:
            return builder.CreateZExt(builder.CreateICmpEQ(llvmOps[0], llvmOps[1]), int64Ty, "eqtmp");
        case Z3_OP_DISTINCT:
            return builder.CreateZExt(builder.CreateICmpNE(llvmOps[0], llvmOps[1]), int64Ty, "netmp");
             
        case Z3_OP_SLT: return builder.CreateZExt(builder.CreateICmpSLT(llvmOps[0], llvmOps[1]), int64Ty, "slttmp");
        case Z3_OP_SLEQ: return builder.CreateZExt(builder.CreateICmpSLE(llvmOps[0], llvmOps[1]), int64Ty, "sletmp");
        case Z3_OP_SGT: return builder.CreateZExt(builder.CreateICmpSGT(llvmOps[0], llvmOps[1]), int64Ty, "sgttmp");
        case Z3_OP_SGEQ: return builder.CreateZExt(builder.CreateICmpSGE(llvmOps[0], llvmOps[1]), int64Ty, "sgetmp");
        case Z3_OP_ULT: return builder.CreateZExt(builder.CreateICmpULT(llvmOps[0], llvmOps[1]), int64Ty, "ulttmp");
        case Z3_OP_ULEQ: return builder.CreateZExt(builder.CreateICmpULE(llvmOps[0], llvmOps[1]), int64Ty, "uletmp");
        case Z3_OP_UGT: return builder.CreateZExt(builder.CreateICmpUGT(llvmOps[0], llvmOps[1]), int64Ty, "ugttmp");
        case Z3_OP_UGEQ: return builder.CreateZExt(builder.CreateICmpUGE(llvmOps[0], llvmOps[1]), int64Ty, "ugetmp");

        case Z3_OP_SIGN_EXT: {
            unsigned src_size = expr.arg(0).get_sort().bv_size();
            if (src_size < 64) {
                // Shift left then right to sign extend
                llvm::Value* val = llvmOps[0];
                unsigned shiftAmt = 64 - src_size;
                llvm::Value* shiftVal = llvm::ConstantInt::get(int64Ty, shiftAmt);
                val = builder.CreateShl(val, shiftVal);
                val = builder.CreateAShr(val, shiftVal);
                return val;
            }
            return llvmOps[0];
        }
        case Z3_OP_ZERO_EXT: {
            unsigned src_size = expr.arg(0).get_sort().bv_size();
            if (src_size < 64) {
                // Mask
                llvm::Value* val = llvmOps[0];
                uint64_t mask = (1ULL << src_size) - 1;
                return builder.CreateAnd(val, llvm::ConstantInt::get(int64Ty, mask));
            }
            return llvmOps[0];
        }
            
        case Z3_OP_EXTRACT: {
            unsigned lo = expr.lo();
            unsigned hi = expr.hi();
            unsigned width = hi - lo + 1;
            
            llvm::Value* val = llvmOps[0];
            if (lo > 0) {
                val = builder.CreateLShr(val, llvm::ConstantInt::get(int64Ty, lo));
            }
            if (width < 64) {
                uint64_t mask = (1ULL << width) - 1;
                val = builder.CreateAnd(val, llvm::ConstantInt::get(int64Ty, mask));
            }
            return val;
        }
        
        case Z3_OP_CONCAT: {
            unsigned low_width = expr.arg(1).get_sort().bv_size();
            llvm::Value* high = llvmOps[0];
            llvm::Value* low = llvmOps[1];
            
            llvm::Value* high_shifted = builder.CreateShl(high, llvm::ConstantInt::get(int64Ty, low_width));
            return builder.CreateOr(high_shifted, low);
        }

        case Z3_OP_UNINTERPRETED: {
            std::string name = expr.decl().name().str();
            if (variableMap.find(name) != variableMap.end()) {
                return variableMap[name];
            }
            llvm::errs() << "Warning: Variable " << name << " not found in map, using 0.\n";
            return llvm::ConstantInt::get(int64Ty, 0);
        }

        default:
            // Fallback: treat as constant zero
            llvm::errs() << "  -> Unknown kind " << kind << ", fallback to 0\n";
            return llvm::ConstantInt::get(int64Ty, 0);
    }
}