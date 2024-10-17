import json
import ast

class loop_tree:
    '''
    induction_variable: str - unique variable name for the induction variable e.g. i, j, k
    start: str - an expression for the start value of the induction variable e.g. 0, 1, 2
                 it can alse depend on other variables e.g. 2*i, 3*j
    end: str - an expression for the end value of the induction variable similar to start
    step: str - an expression for the step value of the induction variable similar to start
    basic_blocks: list - list of basic blocks names in current loop aka not including basic blocks in
                        inner loops
    inner_loops: list - list of loop_tree objects for inner
    '''
    def __init__(self, data):
        self.induction_variable = data['induction_variable']
        self.start = data['start']
        self.end = data['end']
        self.step = data['step']
        self.basic_blocks = data['basic_block']
        self.inner_loops = [loop_tree(i) for i in data['inner_loops']] if 'inner_loops' in data else []

    def show_block_trip_count(self, prefix = ''):
        for block in self.basic_blocks:
            print(f'{block} : {prefix}{self.loop_count_str()}')
        for inner_loop in self.inner_loops:
            prefix += f'∑({self.induction_variable},{self.start_str()},{self.end_str()},{self.step_str()}) '
            inner_loop.show_block_trip_count(prefix)
    

    def loop_count_str(self):
        return f'({self.end_str()} - {self.start_str()})/{self.step_str()} +1'

    def start_str(self):
        return self.start

    def end_str(self):
        return self.end

    def step_str(self):
        return self.step


if __name__ == '__main__':
    with open('loop_tree.json', 'r') as f:
        data = json.load(f)
        loop_tree(data).show_block_trip_count()
        
