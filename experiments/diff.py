#! /usr/bin/env python3

import argparse

parser = argparse.ArgumentParser(description='Diff of basic block counts between instr and proxy')

parser.add_argument('instr', type=str, help='Path to instr.txt')
parser.add_argument('proxy', type=str, help='Path to proxy.txt')

args = parser.parse_args()

def get_instr_file_counts(file_name):

    block_counts = {}  # key: block address, value: count
    with open (file_name, 'r') as instr_file:
        texts = instr_file.read()
        lines = texts.split("\n")
        for line in lines:
            if line == "":
                continue
            block_name = line.split()[1]
            block_count_tk = line.split()[3]
            block_count = int(block_count_tk.split("=")[1]) 
            block_counts[block_name] = block_count
    return block_counts

def get_proxy_file_counts(file_name):

    block_counts = {}  # key: block address, value: count
    with open (file_name, 'r') as proxy_file:
        texts = proxy_file.read()
        lines = texts.split("\n")
        for line in lines:
            if line == "":
                continue
            block_name = line.split(" ")[1]
            block_count = int(line.split(" ")[2])
            block_counts[block_name] = block_count
    return block_counts

instr_counts = get_instr_file_counts(args.instr)
proxy_counts = get_proxy_file_counts(args.proxy)

for block in sorted(proxy_counts):
    if block not in instr_counts: continue
    if instr_counts[block] != proxy_counts[block]:
        print(f"BB: {block} has different counts: \ninstr:{instr_counts[block]} vs proxy:{proxy_counts[block]}")