import json
from scev2z3 import parse_symb_count
import sys
from collections import namedtuple
from z3 import Int, IntVal, Solver, is_const, simplify, substitute, Z3_OP_UNINTERPRETED, sat
import argparse
from itertools import product

'''
{
    "args": [
        "%M",
        "%N",
        "%T_add",
        "%A",
        "%B"
    ],
    "basic_graphs": [
        {
            "count": "1",
            "graph_type": "Branch",
            "id": "10892551719778344533",
            "name": "%entry"
        },
        {
            "count": "scMul((1 - TR_%for_begin_ax1.preheader.us), scMul(scAdd(-1, scZeroExt(%M)), scMul(TR_%entry, 1)))",
            "graph_type": "Loop",
            "id": "4803102904814766180",
            "name": "%vector.body"
        },
    ]
}
'''

BasicGraph = namedtuple('BasicGraph', ['count', 'z3_expr', 'graph_type', 'id', 'name'])
ArgsAndGraphs = namedtuple('ArgsAndGraphs', ['args', 'basic_graphs'])

def parse_basic_graphs(json_data:str) -> ArgsAndGraphs:
    """
    Parses the 'basic_graphs' list from the given JSON data and returns a list of
    four-element tuples: (count, graph_type, id, name).
    """
    data = json.loads(json_data)

    args = data.get("args", [])
    basic_graphs = []
    for item in data.get("basic_graphs", []):
        basic_graphs.append(BasicGraph(
            item.get("count"),
            parse_symb_count(item.get("count")),
            item.get("graph_type"),
            item.get("id"),
            item.get("name")
        ))
    return ArgsAndGraphs(args=args, basic_graphs=basic_graphs)


def guess_true_ratio(z3expr) -> list[tuple]:
    """
    Guess the True Ratio to be 0 or 1 such that the resulting counts are non-zero.
    Returns a list of guessed True Ratios for later substitution.
    """
    # Find all variables in z3expr with names starting with "TR_"
    tr_vars = []
    def collect_tr_vars(expr):
        if is_const(expr) and expr.decl().kind() == Z3_OP_UNINTERPRETED:
            if expr.decl().name().startswith("TR_"):
                tr_vars.append(expr)
        for child in expr.children():
            collect_tr_vars(child)
    collect_tr_vars(z3expr)
    tr_vars = list(set(tr_vars))

    # Try all combinations of 0/1 assignments to TR variables
    s = Solver()
    for values in product([0, 1], repeat=len(tr_vars)):
        s.push()
        for v, val in zip(tr_vars, values):
            s.add(v == val)
        s.add(z3expr != 0)
        if s.check() == sat:
            model = s.model()
            result = [(v, model[v]) for v in tr_vars]
            s.pop()
            return result
        s.pop()
    return []


EvaluatedGraph = namedtuple(
    'EvaluatedGraph', [
        'args',
        'name', 
        'id', 
        'original_expr', 
        'guessed_count',
        'guessed_TR', 
        'graph_type'
    ]
)

def symb_eval(args_map, basic_graphs) -> list[EvaluatedGraph]:
    """
    Evaluates the symbolic expressions in basic_graphs using the provided args_values.
    Returns a list of evaluated counts.
    """

    # Prepare substitution list for z3
    var_subs = []
    for arg_name, value in args_map.items():
        # parse_symb_count should have created z3 variables with the same names as in args
        sym = Int(arg_name)
        var_subs.append((sym, IntVal(value)))


    evaluated_graphs = []
    for graph in basic_graphs.basic_graphs:
        count_expr = graph.z3_expr

        # Substitute values
        tr_subs = guess_true_ratio(count_expr)
        subs = var_subs + tr_subs
        simplified = simplify(substitute(count_expr, *subs))
        evaluated_graphs.append(EvaluatedGraph(
            args=args_map,
            name=graph.name,
            id=graph.id,
            original_expr=graph.z3_expr,
            guessed_count=simplified,
            guessed_TR=tr_subs,
            graph_type=graph.graph_type
        ))
    return evaluated_graphs


def format_evaluated_graphs(evaluated_graphs):
    output = {
        "args": evaluated_graphs[0].args if evaluated_graphs else [],
        "basic_graphs": [
            {
                "original_expr": str(graph.original_expr).replace('\n', ''),
                "guessed_count": str(graph.guessed_count).replace('\n', ''),
                "guessed_TR": str(graph.guessed_TR).replace('\n', ''),
                "graph_type": graph.graph_type,
                "id": graph.id,
                "name": graph.name
            }
        for graph in evaluated_graphs
        ]
    }
    return output


def format_unevaluated_graphs(basic_graphs):
    output = {
        "args": basic_graphs.args,
        "basic_graphs": [
            {
                "count": graph.count,
                "graph_type": graph.graph_type,
                "id": graph.id,
                "name": graph.name
            }
            for graph in basic_graphs.basic_graphs
        ]
    }
    return output


if __name__ == "__main__":
    parser = argparse.ArgumentParser(description="Evaluate symbolic counts from a JSON input file.")
    parser.add_argument("input_file", help="Path to the JSON input file")
    parser.add_argument("--args", type=str, default=None,
                        help="Path to a JSON file mapping argument names to values, e.g. '{\"%M\": 10, \"%N\": 20}'")
    args = parser.parse_args()

    with open(args.input_file, "r") as f:
        input_data = f.read()

    basic_graphs = parse_basic_graphs(input_data)

    if args.args:
        # Parse the args JSON if provided
        with open(args.args, "r") as f:
            args_map = json.load(f)

        evaluated = symb_eval(args_map, basic_graphs)
        # Prepare output in the same format as input, but with original args names and a new field for concrete values
        print(json.dumps(format_evaluated_graphs(evaluated), indent=4))

    else:
        # Print the input format as before, but with symbolic args
        print(json.dumps(format_unevaluated_graphs(basic_graphs), indent=4))