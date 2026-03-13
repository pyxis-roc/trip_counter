import re
from z3 import *
import unittest

# Helper: parse variable names and assign BitVecs
def get_int_var(varname, var_map):
    if varname not in var_map:
        var_map[varname] = Int(varname)
    return var_map[varname]

def get_real_var(varname, var_map):
    if varname not in var_map:
        var_map[varname] = Real(varname)
    return var_map[varname]

# Main parser
def parse_symb_count(expr, var_map=None):
    if var_map is None:
        var_map = {}

    expr = expr.strip()

    # Handle integer constants
    if re.fullmatch(r'-?\d+', expr):
        return IntVal(int(expr))

    # Handle parenthesis
    if expr.startswith('(') and expr.endswith(')'):
        return parse_symb_count(expr[1:-1], var_map)

    # scAdd(a, b, ...)
    m = re.match(r'scAdd\((.*)\)', expr)
    if m:
        args = split_args(m.group(1))
        z3_args = [parse_symb_count(a, var_map) for a in args]
        res = sum(z3_args)
        return res
    
    # scSub(a, b, ...)
    m = re.match(r'scSub\((.*)\)', expr)
    if m:
        args = split_args(m.group(1))
        assert len(args) == 2
        left = parse_symb_count(args[0], var_map)
        right = parse_symb_count(args[1], var_map)
        return left - right

    # scMul(a, b, ...)
    m = re.match(r'scMul\((.*)\)', expr)
    if m:
        args = split_args(m.group(1))
        z3_args = [parse_symb_count(a, var_map) for a in args]
        res = z3_args[0]
        for a in z3_args[1:]:
            # If either operand is a Real, cast both to Real for multiplication
            res = res * a
        return res

    # scUDiv(a, b)
    m = re.match(r'scUDiv\((.*)\)', expr)
    if m:
        args = split_args(m.group(1))
        assert len(args) == 2
        return parse_symb_count(args[0], var_map) / parse_symb_count(args[1], var_map)

    # scZeroExt(%M)
    m = re.match(r'scZeroExt\((.*)\)', expr)
    if m:
        arg = parse_symb_count(m.group(1), var_map)
        # ignore width for now
        return arg

    # scTrunc(expr)
    m = re.match(r'scTrunc\((.*)\)', expr)
    if m:
        arg = parse_symb_count(m.group(1), var_map)
        # ignore for now
        return arg

    # scSMax(a, b)
    m = re.match(r'scSMax\((.*)\)', expr)
    if m:
        args = split_args(m.group(1))
        assert len(args) == 2
        left = parse_symb_count(args[0], var_map)
        right = parse_symb_count(args[1], var_map)
        return If(left > right, left, right)

    # TR_num_%xxx / TR_den_%xxx
    m = re.match(r'TR_(num|den)_([%\w\.\= ]+)', expr)
    if m:
        kind = m.group(1)
        suffix = m.group(2).strip()
        return get_int_var(f'TR_{kind}_{suffix}', var_map)

    # TR_%xxx
    m = re.match(r'TR_([%\w\.\= ]+)', expr)
    if m:
        return get_real_var('TR_' + m.group(1).strip(), var_map)

    # %xxx or variable
    m = re.match(r'%[\w\.\= ]+', expr)
    if m:
        return get_int_var(expr.strip(), var_map)

    # Fallback: try to parse as arithmetic
    m = re.match(r'\((.*)\)', expr)
    if m:
        return parse_symb_count(m.group(1), var_map)

    # Arithmetic: (a - b)
    m = re.match(r'\(([^()]+)\)', expr)
    if m:
        inner = m.group(1)
        # Try to parse as arithmetic
        if '-' in inner:
            parts = inner.split('-')
            left = parse_symb_count(parts[0], var_map)
            right = parse_symb_count(parts[1], var_map)
            return left - right
        if '+' in inner:
            parts = inner.split('+')
            left = parse_symb_count(parts[0], var_map)
            right = parse_symb_count(parts[1], var_map)
            return left + right

    # If nothing matched, treat as variable
    return get_int_var(expr.strip(), var_map)

# Helper to split arguments at top-level commas
def split_args(s):
    args = []
    depth = 0
    last = 0
    for i, c in enumerate(s):
        if c == '(':
            depth += 1
        elif c == ')':
            depth -= 1
        elif c == ',' and depth == 0:
            args.append(s[last:i].strip())
            last = i + 1
    args.append(s[last:].strip())
    return args

class TestParseSymbCount(unittest.TestCase):
    def setUp(self):
        self.var_map = {}

    def test_counts(self):
        # List of all symb_count expressions from the text
        exprs = [
            # conv:
            "scMul(TR_%entry, 1)",
            "scAdd(-1, scZeroExt(%N))",
            "scAdd(-1, scZeroExt(%CO))",
            "scAdd(-1, scZeroExt(scAdd(3, scMul(-1, %KH), %H)))",
            "scAdd(-1, scZeroExt(scAdd(3, scMul(-1, %KW), %W)))",
            "scAdd(-1, scZeroExt(%CI))",
            "scAdd(-1, scZeroExt(%KH))",
            "scUDiv(scAdd(-2, scMul(2, scZeroExt(scTrunc(scUDiv(scZeroExt(%KW), 2))))), 2)",
            "scAdd(-1, scZeroExt(scSMax(1, scAdd(2, %H))))",
            "scUDiv(scAdd(-2, scMul(2, scUDiv(scAdd(-1, scZeroExt(scSMax(1, scAdd(2, %W)))), 2))), 2)",
            # gather:
            "scAdd(-1, scZeroExt(%K))",
            # matmul:
            "scAdd(-1, scZeroExt(%M))",
            "scAdd(-1, scZeroExt(scAdd(-1, scTrunc(%K))))",
            "scUDiv(scAdd(-4, scMul(4, scUDiv(scAdd(-1, scZeroExt(%K)), 4))), 4)",
            # unsqueeze:
            "scUDiv(scAdd(-4, scMul(4, scZeroExt(scTrunc(scUDiv(scZeroExt(%M), 4))))), 4)",
            "scAdd(-1, scZeroExt(scTrunc(%M)))",
        ]
        # Also test some nested expressions from the counts
        nested_exprs = [
            # conv:
            "scSub(1, TR_%entry)",
            "scSub(1, TR_%for_begin_ff.preheader.lr.ph)",
            "(TR_%for_begin_i1.preheader.lr.ph * (TR_%for_begin_i0.preheader * (scSub(1, TR_%entry) * 1)))",
            "(scSub(1, TR_%for_begin_ff.preheader.lr.ph) * (TR_%for_begin_i1.preheader.lr.ph * (TR_%for_begin_i0.preheader * (scSub(1, TR_%entry) * 1))))",
            "((scUDiv(scAdd(-2, scMul(2, scZeroExt(scTrunc(scUDiv(scZeroExt(%KW), 2))))), 2) + 1) * (scSub(1, TR_%for_begin_rx.preheader.us.us.us.us.us.us.us.us.us.us.us.us.us.us.us.us.us.us.us.us.us) * (scAdd(-1, scZeroExt(%KH)) * (scAdd(-1, scZeroExt(%CI)) * (scAdd(-1, scZeroExt(scAdd(3, scMul(-1, %KW), %W))) * (scAdd(-1, scZeroExt(scAdd(3, scMul(-1, %KH), %H))) * (scAdd(-1, scZeroExt(%CO)) * (scAdd(-1, scZeroExt(%N)) * (scSub(1, TR_%for_begin_ff.preheader.lr.ph) * (TR_%for_begin_i1.preheader.lr.ph * (TR_%for_begin_i0.preheader * (scSub(1, TR_%entry) * 1))))))))))))",
            # gather:
            "(TR_%for_begin_ax1.preheader.lr.ph * (TR_%entry * 1))",
            "((scAdd(-1, scZeroExt(%K)) + 1) * (TR_%for_begin_ax1.preheader.lr.ph * (TR_%entry * 1)))",
            # matmul:
            "(scAdd(-1, scZeroExt(%M)) * (TR_%entry * 1))",
            "((scAdd(-1, scZeroExt(%N)) * (scAdd(-1, scZeroExt(%M)) * (TR_%entry * 1))))",
            "((scUDiv(scAdd(-4, scMul(4, scUDiv(scAdd(-1, scZeroExt(%K)), 4))), 4) + 1) * (scSub(1, TR_%for_body_k.us.us.us.peel.next) * (scSub(1, TR_%if_end.us.us.us.peel) * (scAdd(-1, scZeroExt(%N)) * (scAdd(-1, scZeroExt(%M)) * (TR_%entry * 1))))))",
            "((scAdd(-1, scZeroExt(scAdd(-1, scTrunc(%K)))) + 1) * (scSub(1, TR_%for_begin_k.for_end_k_crit_edge.us.us.us.loopexit.unr-lcssa) * (scSub(1, TR_%if_end.us.us.us.peel) * (scAdd(-1, scZeroExt(%N)) * (scAdd(-1, scZeroExt(%M)) * (TR_%entry * 1))))))",
            # unsqueeze:
            "((scUDiv(scAdd(-4, scMul(4, scZeroExt(scTrunc(scUDiv(scZeroExt(%M), 4))))), 4) + 1) * (scSub(1, TR_%for_begin_ax2.preheader.us.preheader) * (TR_%entry * 1)))",
            "((scAdd(-1, scZeroExt(scTrunc(%M))) + 1) * (scSub(1, TR_%for_end_ax0.loopexit.unr-lcssa) * (TR_%entry * 1)))",
        ]
        for expr in exprs + nested_exprs:
            with self.subTest(expr=expr):
                z3_expr = parse_symb_count(expr, self.var_map)
                self.assertIsNotNone(z3_expr)

if __name__ == "__main__":

    # Example usage: parse and evaluate a specific expression
    # expr = "scAdd(-1, scZeroExt(scAdd(3, scMul(-1, %KH), %H)))"
    # var_map = {}
    # z3_expr = parse_symb_count(expr, var_map)
    # print("Z3 expression:", z3_expr)

    # # Assign concrete values to %KH and %H
    # s = Solver()
    # var_map['%KH'] = BitVecVal(5, 64)
    # var_map['%H'] = BitVecVal(10, 64)
    # z3_expr_concrete = parse_symb_count(expr, var_map)
    # print("Evaluated with %KH=5, %H=10:", simplify(z3_expr_concrete))

    unittest.main()