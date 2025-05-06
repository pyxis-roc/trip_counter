#! /usr/bin/env python3

import argparse
import sys
import subprocess

def parse_instr_raw_file(raw_file, ir_file):
    # get text output from llvm profraw file
    # llvm-profdata merge -output=instr.profdata instr.profraw

    try:
        prof_file = raw_file.replace(".profraw", ".profdata")
        subprocess.run(
            ["llvm-profdata", "merge", "-output=" + prof_file, raw_file],
            check=True
        )
        # get text output from llvm profdata file
        instr_file = prof_file.replace(".profdata", ".txt")
        subprocess.run(
            ["opt", "--passes=pgo-instr-use", "-pgo-test-profile-file=" + prof_file, "-pgo-view-raw-counts", "text", ir_file],
            check=True,
            stderr=open(instr_file, 'w')
        )
        return instr_file
    except subprocess.CalledProcessError as e:
        print(f"Error while running llvm-profdata: {e}")
        sys.exit(2)

def get_instr_file_counts(file_name):

    block_counts = {}  # key: block address, value: count
    with open (file_name, 'r') as instr_file:
        texts = instr_file.read()
        lines = texts.split("\n")
        for line in lines:
            if "BB:" not in line:
                continue
            if "FakeNode" in line:
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

def compare(instr_counts, proxy_counts):
    diff = 0

    for block in sorted(instr_counts):
        if block not in proxy_counts: continue
        if instr_counts[block] != proxy_counts[block]:
            diff += 1
            print(f"BB: {block} has different counts: \ninstr:{instr_counts[block]} vs proxy:{proxy_counts[block]}")

    print(f"Total different basic blocks: {diff}")
    return diff

if __name__ == "__main__":

    parser = argparse.ArgumentParser(description='Diff of basic block counts between instr and proxy')

    parser.add_argument('proxy', type=str, help='Path to proxy.txt')
    parser.add_argument('instrRaw', type=str, help='Path to default.profraw')
    parser.add_argument('irFile', type=str, help='Path to the IR file')

    args = parser.parse_args()

    instr_file = parse_instr_raw_file(args.instrRaw, args.irFile)
    instr_counts = get_instr_file_counts(instr_file)
    proxy_counts = get_proxy_file_counts(args.proxy)

    diff = compare(instr_counts, proxy_counts)
    if diff == 0:
        print("No differences in basic block counts")
        sys.exit(0)
    else:
        sys.exit(1)