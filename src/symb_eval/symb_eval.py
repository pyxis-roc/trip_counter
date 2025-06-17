import json
from scev2z3 import parse_symb_count
import sys
from collections import namedtuple
from z3 import *
import argparse

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
def parse_basic_graphs(json_data):
    """
    Parses the 'basic_graphs' list from the given JSON data and returns a list of
    four-element tuples: (count, graph_type, id, name).
    """
    data = json.loads(json_data)
    BasicGraph = namedtuple('BasicGraph', ['count', 'z3_expr', 'graph_type', 'id', 'name'])
    ArgsAndGraphs = namedtuple('ArgsAndGraphs', ['args', 'basic_graphs'])

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


'''
    get concrete counts by filling in args_values, assuming True Ratio being 0 or 1
'''
def symb_eval(args_values, basic_graphs):
    """
    Evaluates the symbolic expressions in basic_graphs using the provided args_values.
    Returns a list of evaluated counts.
    """
    # Check if args_values matches the number of args
    args = basic_graphs.args
    if len(args_values) != len(args):
        raise ValueError(f"args_values length {len(args_values)} does not match args length {len(args)}")

    # Prepare substitution list for z3
    subs = []
    for arg_name, value in zip(args, args_values):
        # parse_symb_count should have created z3 variables with the same names as in args
        sym = Real(arg_name)
        subs.append((sym, RealVal(value)))

    EvaluatedGraph = namedtuple('EvaluatedGraph', ['name', 'id', 'simplified_count', 'original_count', 'graph_type'])

    evaluated_graphs = []
    for graph in basic_graphs.basic_graphs:
        count_expr = graph.z3_expr
        # Substitute values
        simplified = simplify(substitute(count_expr, *subs))
        evaluated_graphs.append(EvaluatedGraph(
            name=graph.name,
            id=graph.id,
            simplified_count=simplified,
            original_count=graph.z3_expr,
            graph_type=graph.graph_type
        ))
    return evaluated_graphs

if __name__ == "__main__":
    parser = argparse.ArgumentParser(description="Evaluate symbolic counts from a JSON input file.")
    parser.add_argument("input_file", help="Path to the JSON input file")
    parser.add_argument("--args", nargs='*', type=int, default=[], help="Values for the symbolic arguments, in order")
    args = parser.parse_args()

    with open(args.input_file, "r") as f:
        input_data = f.read()

    parsed = parse_basic_graphs(input_data)

    if args.args:
        evaluated = symb_eval(args.args, parsed)
        print("\nSubstitution Values:")
        for name, value in zip(parsed.args, args.args):
            print(f"  {name} = {value}")
        print("\nEvaluated Counts:")
        for graph in evaluated:
            print(f"  Name: {graph.name}")
            print(f"    Original Count: {graph.original_count}")
            print(f"    Evaluated Count: {graph.simplified_count}")
            print()
        
    else:
        print("Arguments:")
        for i, arg in enumerate(parsed.args):
            print(f"  [{i}] {arg}")
        print("\nBasic Graphs:")
        for graph in parsed.basic_graphs:
            print(f"  Name: {graph.name}")
            print(f"    ID: {graph.id}")
            print(f"    Type: {graph.graph_type}")
            print(f"    Count: {graph.count}")
            print(f"    Z3 Expr: {graph.z3_expr}")
            print()