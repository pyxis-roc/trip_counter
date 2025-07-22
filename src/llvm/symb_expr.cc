#include <z3++.h>
#include "symb_expr.hpp"
#include "llvm/Analysis/ScalarEvolutionExpressions.h"
#include "llvm/IR/Instruction.h"
#include "llvm/Support/raw_ostream.h"


// Constructors
SymbolicExpr::SymbolicExpr(z3::context& ctx, const z3::expr& expr)
    : ctx_(ctx), expr_(expr) {}

// Copy/move
SymbolicExpr::SymbolicExpr(const SymbolicExpr& other)
    : ctx_(other.ctx_), expr_(other.expr_) {}

SymbolicExpr::SymbolicExpr(SymbolicExpr&& other) noexcept
    : ctx_(other.ctx_), expr_(std::move(other.expr_)) {}

SymbolicExpr& SymbolicExpr::operator=(const SymbolicExpr& other) {
    if (this != &other) {
        // ctx_ is a reference, assumed to be the same context
        expr_ = other.expr_;
    }
    return *this;
}

SymbolicExpr& SymbolicExpr::operator=(SymbolicExpr&& other) noexcept {
    if (this != &other) {
        expr_ = std::move(other.expr_);
        // ctx_ is a reference, assumed to be the same context
    }
    return *this;
}

// Manipulation
SymbolicExpr SymbolicExpr::simplify() const {
    return SymbolicExpr(ctx_, expr_.simplify());
}

SymbolicExpr SymbolicExpr::operator+(const SymbolicExpr& rhs) const {
    return SymbolicExpr(ctx_, expr_ + rhs.expr_);
}

SymbolicExpr SymbolicExpr::operator-(const SymbolicExpr& rhs) const {
    return SymbolicExpr(ctx_, expr_ - rhs.expr_);
}

SymbolicExpr SymbolicExpr::operator*(const SymbolicExpr& rhs) const {
    return SymbolicExpr(ctx_, expr_ * rhs.expr_);
}

SymbolicExpr SymbolicExpr::operator/(const SymbolicExpr& rhs) const {
    return SymbolicExpr(ctx_, expr_ / rhs.expr_);
}

SymbolicExpr SymbolicExpr::operator-() const {
    return SymbolicExpr(ctx_, -expr_);
}

bool SymbolicExpr::substitude(const SymbolicExpr& original, const SymbolicExpr& with) {
    // Use Z3's substitute API to replace all occurrences of the variable named 'original' with 'with.expr_'
    z3::expr_vector from(ctx_);
    z3::expr_vector to(ctx_);
    from.push_back(original.expr_);
    to.push_back(with.expr_);
    z3::expr new_expr = expr_.substitute(from, to);
    bool changed = !z3::eq(expr_, new_expr);
    expr_ = new_expr;
    return changed;
}

std::string SymbolicExpr::str() const {
    std::string s = expr_.to_string();
    s.erase(std::remove(s.begin(), s.end(), '\n'), s.end());
    return s;
}

// Access underlying Z3 expr
const z3::expr& SymbolicExpr::expr() const {
    return expr_;
}

// SymbolicExprManager implementation
SymbolicExprManager::SymbolicExprManager() : ctx_() {}
SymbolicExprManager::~SymbolicExprManager() {}

// Static API for constants
SymbolicExpr SymbolicExprManager::zero() {
    return zero64();
}
SymbolicExpr SymbolicExprManager::zero32() {
    return SymbolicExpr(ctx_, ctx_.bv_val(0, 32));
}
SymbolicExpr SymbolicExprManager::zero64() {
    return SymbolicExpr(ctx_, ctx_.bv_val(0, 64));
}

SymbolicExpr SymbolicExprManager::one() {
    return one64();
}
SymbolicExpr SymbolicExprManager::one32() {
    return SymbolicExpr(ctx_, ctx_.bv_val(1, 32));
}
SymbolicExpr SymbolicExprManager::one64() {
    return SymbolicExpr(ctx_, ctx_.bv_val(1, 64));
}
// Static API for named symbol
SymbolicExpr SymbolicExprManager::named(const std::string& name) {
    return named64(name);
}

SymbolicExpr SymbolicExprManager::named32(const std::string& name) {
    return SymbolicExpr(ctx_, ctx_.bv_const(name.c_str(), 32));
}

SymbolicExpr SymbolicExprManager::named64(const std::string& name) {
    return SymbolicExpr(ctx_, ctx_.bv_const(name.c_str(), 64));
}

SymbolicExpr SymbolicExprManager::intVal(int val) {
    return intVal64(val);
}

SymbolicExpr SymbolicExprManager::intVal32(int val) {
    return SymbolicExpr(ctx_, ctx_.bv_val(val, 32));
}
SymbolicExpr SymbolicExprManager::intVal64(int val) {
    return SymbolicExpr(ctx_, ctx_.bv_val(val, 64));
}
SymbolicExpr SymbolicExprManager::realVal(double val) {
    // Use string conversion to avoid ambiguity in real_val overloads
    return SymbolicExpr(ctx_, ctx_.real_val(std::to_string(val).c_str()));
}

SymbolicExpr SymbolicExprManager::fromSCEV(const llvm::SCEV& scev) {
    // scev.print(llvm::errs());
    // llvm::errs() << "\n";

    z3::expr_vector args(ctx_);
    for (const auto& op : scev.operands()) {
        args.push_back(fromSCEV(*op).expr());
    }

    switch (scev.getSCEVType()) {
        case llvm::scAddExpr:{
            z3::expr sum = args.size() > 0 ? args[0] : ctx_.int_val(0);
            for (unsigned i = 1; i < args.size(); ++i) {
                sum = sum + args[i];
            }
            return SymbolicExpr(ctx_, sum);
        }
        case llvm::scMulExpr:{
            z3::expr product = args.size() > 0 ? args[0] : ctx_.int_val(1);
            for (unsigned i = 1; i < args.size(); ++i) {
                product = product * args[i];
            }
            return SymbolicExpr(ctx_, product);
        }               
        case llvm::scZeroExtend:{
            if (args.size() == 1) {
                // Get the target bitwidth from the SCEV type
                unsigned targetBitwidth = scev.getType()->getPrimitiveSizeInBits();
                unsigned srcBitwidth = args[0].get_sort().bv_size();
                if (targetBitwidth > srcBitwidth) {
                    return SymbolicExpr(ctx_, z3::zext(args[0], targetBitwidth - srcBitwidth));
                } else if (targetBitwidth == srcBitwidth) {
                    return SymbolicExpr(ctx_, args[0]);
                } else {
                    llvm::errs() << "Error: ZeroExtend target bitwidth is less than source bitwidth.\n";
                }
            }
            llvm::errs() << "Error: ZeroExtend requires exactly one operand.\n";
            break;
        }            
        case llvm::scTruncate:{
            if (args.size() == 1) {
                // Get the target bitwidth from the SCEV type
                unsigned targetBitwidth = scev.getType()->getPrimitiveSizeInBits();
                unsigned srcBitwidth = args[0].get_sort().bv_size();
                if (targetBitwidth < srcBitwidth) {
                    return SymbolicExpr(ctx_, args[0].extract(targetBitwidth - 1, 0));
                } else if (targetBitwidth == srcBitwidth) {
                    return SymbolicExpr(ctx_, args[0]);
                } else {
                    llvm::errs() << "Error: Truncate target bitwidth is greater than source bitwidth.\n";
                }
            }
            llvm::errs() << "Error: Truncate requires exactly one operand.\n";
            break;
        }
        case llvm::scUDivExpr:{
            if (args.size() == 2) {
                return SymbolicExpr(ctx_, args[0] / args[1]);
            }
            llvm::errs() << "Error: UDivExpr requires exactly two operands.\n";
            break;
        }
        case llvm::scSignExtend:{
            if (args.size() == 1) {
                // Sign-extend to 64 bits
                return SymbolicExpr(ctx_, z3::sext(args[0], 64 - args[0].get_sort().bv_size()));
            }
            llvm::errs() << "Error: SignExtend requires exactly one operand.\n";
            break;
        }
        case llvm::scConstant:{
            const llvm::SCEVConstant* scevConst = llvm::cast<llvm::SCEVConstant>(&scev);
            unsigned bitwidth = scevConst->getType()->getPrimitiveSizeInBits();
            return SymbolicExpr(ctx_, ctx_.bv_val(scevConst->getValue()->getSExtValue(), bitwidth));
        }
        case llvm::scUnknown:{
            unsigned bitwidth = scev.getType()->getPrimitiveSizeInBits();
            if (const llvm::SCEVUnknown* scevUnknown = llvm::dyn_cast<llvm::SCEVUnknown>(&scev)) {
                if (const llvm::Value* val = scevUnknown->getValue()) {
                    // Use the value's name if available, otherwise generate a unique name
                    if (val->hasName()) {
                        return SymbolicExpr(ctx_, ctx_.bv_const(val->getName().str().c_str(), bitwidth));
                    } else {
                        static int unknown_counter = 0;
                        std::string name = "unnamed_val_" + std::to_string(++unknown_counter);
                        return SymbolicExpr(ctx_, ctx_.bv_const(name.c_str(), bitwidth));
                    }
                }
            }
            llvm::errs() << "Error: SCEVUnknown without value.\n";
            static int unknown_counter = 0;
            std::string name = "unknown_val_" + std::to_string(++unknown_counter);
            return SymbolicExpr(ctx_, ctx_.bv_const(name.c_str(), bitwidth));
        }
        default:{
            llvm::errs() << "Error: Unsupported SCEV type: " << scev.getSCEVType() << "\n";
            scev.print(llvm::errs());
            llvm::errs() << "\n";
        }
    }
    static int counter = 0;
    std::string name = "unknown_" + std::to_string(++counter);
    return named(name);
}

SymbolicExpr SymbolicExprManager::fromInst(const llvm::Instruction& I) {

    // Convert an LLVM instruction to a symbolic expression
    z3::expr_vector args(ctx_);
    for (const auto& op : I.operands()) {
        if (auto* val = llvm::dyn_cast<llvm::Value>(op)) {
            args.push_back(fromValue(*val).expr());
        }
    }

    switch (I.getOpcode()) {
        case llvm::Instruction::Add:
            return SymbolicExpr(ctx_, args[0] + args[1]);
        case llvm::Instruction::Sub:
            return SymbolicExpr(ctx_, args[0] - args[1]);
        case llvm::Instruction::Mul:
            return SymbolicExpr(ctx_, args[0] * args[1]);
        case llvm::Instruction::UDiv:
            return SymbolicExpr(ctx_, args[0] / args[1]);
        default:
            llvm::errs() << "Error: Unsupported instruction opcode: " << I.getOpcodeName() << "\n";
            static int counter = 0;
            std::string name = "unknown_inst_" + std::to_string(++counter);
            return named(name);
    }
}

SymbolicExpr SymbolicExprManager::fromValue(const llvm::Value& V) {
    // Convert an LLVM value to a symbolic expression
    if (auto* constant = llvm::dyn_cast<llvm::ConstantInt>(&V)) {
        return intVal(constant->getValue().getSExtValue());
    }
    if (auto* constant = llvm::dyn_cast<llvm::ConstantFP>(&V)) {
        return realVal(constant->getValueAPF().convertToDouble());
    }
    if (auto* instruction = llvm::dyn_cast<llvm::Instruction>(&V)) {
        return fromInst(*instruction);
    }
    llvm::errs() << "Error: Unsupported value type: " << V.getType()->getTypeID() << "\n";
    static int counter = 0;
    std::string name = "unknown_Value_" + std::to_string(++counter);
    return named(name);
}