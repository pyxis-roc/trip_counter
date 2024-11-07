import json
import sympy as sy
import ast
import argparse
import hashlib
from typing import Callable

class symSum(sy.Function):
    def doit(self, **hints):
        i, start, end, step, expr = self.args
        j = sy.Symbol('_j')

        return sy.Sum(
            expr.subs(i, start + j*step), 
            (j, 0, (end-start)//step)).doit()

    def __str__(self):
        i, start, end, step, expr = self.args
        return f'∑({i},{start},{end},{step}) {expr}'

class loop_tree:
    '''
    induction_variable: str - unique variable name for the induction variable e.g. i, j, k
    start: sympy.Expr - an expression for the start value of the induction variable e.g. 0, 1, 2
                 it can alse depend on other variables e.g. 2*i, 3*j
    end: sympy.Expr - an expression for the end value of the induction variable similar to start
    step: sympy.Expr - an expression for the step value of the induction variable similar to start
    basic_blocks: list - list of basic blocks names in current loop aka not including basic blocks in
                        inner loops
    inner_loops: list - list of loop_tree objects for inner
    '''
    def __init__(self, data):
        self.induction_variable = self.make_symbolic(data['induction_variable'])
        self.start = self.make_symbolic(data['start'])
        self.end = self.make_symbolic(data['end'])
        self.step = self.make_symbolic(data['step'])
        self.basic_blocks = data['basic_block']
        self.inner_loops = [loop_tree(i) for i in data['inner_loops']] if 'inner_loops' in data else []

    def show_all_trip_count(self, prefix = ''):
        for block in self.basic_blocks:
            print(f'{block} : {prefix}{self.loop_count_str()}')
        for inner_loop in self.inner_loops:
            prefix += f'∑({self.induction_variable},{self.start_str()},{self.end_str()},{self.step_str()}) '
            inner_loop.show_all_trip_count(prefix)
    
    def get_all_trip_count(self, wrapper:Callable[[sy.Expr], sy.Expr] = lambda x:x)  -> dict:
        trip_count = {}
        for block in self.basic_blocks:
            trip_count[block] = wrapper(self.get_trip_count())
        for inner_loop in self.inner_loops:
            new_wrapper = lambda expr: wrapper(self.sum_wrapper()(expr))
            trip_count.update(inner_loop.get_all_trip_count(new_wrapper))
        return trip_count

    def get_trip_count(self) -> sy.Expr:
        '''
        returns the trip count of current loop
        '''
        return self.sum_wrapper()(1)

    def sum_wrapper(self) -> sy.Expr:
        '''
        returns the sum of the expression from start to end with step
        '''
        def sum_expr(expr: sy.Expr) -> sy.Expr:
            i = self.induction_variable
            start = self.start
            end = self.end
            step = self.step
            return symSum(i, start, end, step, expr)
        
        return sum_expr

    def make_symbolic(self, expr:str) -> sy.Expr:
        var_names = self.extract_var_names(expr)
        symbolic_vars = {var: sy.Symbol(var) for var in var_names}
        return sy.parse_expr(expr, symbolic_vars)

    def extract_var_names(self, expr: str) -> list:
        '''
        returns a list of variables names in the string expression
        '''
        tree = ast.parse(expr, mode='eval')
        return [node.id for node in ast.walk(tree) if isinstance(node, ast.Name)]

    def loop_count_str(self):
        return f'({self.end_str()} - {self.start_str()})/{self.step_str()} +1'

    def start_str(self):
        return self.start

    def end_str(self):
        return self.end

    def step_str(self):
        return self.step


if __name__ == '__main__':
    parser = argparse.ArgumentParser()
    parser.add_argument('file', help='json file containing loop tree')
    parser.add_argument('--var', nargs='*', metavar='KEY=VALUE', help='Variables to substitute in the expression')

    args = parser.parse_args()
    with open(args.file, 'r') as f:
        data = json.load(f)
        trip_counts = loop_tree(data).get_all_trip_count()

    if args.var:
        pairs = [arg.split('=') for arg in args.var]
        vars = {sy.Symbol(key): value for key, value in pairs}
        for block in trip_counts:
            trip_counts[block] = trip_counts[block].subs(vars)
    
    for block in sorted(trip_counts):
        formula = f'{trip_counts[block]}'
        try:
            value = f'{trip_counts[block].doit()}'
        except :
            value = 'Not computable'
        print(f'{block} : {formula} : {value}')
