# Trip Counter
## Overview
This is a tool to enable symbolic profiling for LLVM IR. It takes in a LLVM IR file and the target function name. Output is the instrumented LLVM IR. Calls to the target function will print execution count of its internal basic blocks.

### Requirements
- **CMake**: Version 3.31.6 or higher.
- **Clang**: Version 19.1.0 or higher.
- **LLVM**: Version 19.1.0 or higher.

## Building and Running
Use CMake to build the target

```bash
$ cd src/llvm
$ mkdir build && cd build
$ cmake ..
$ cmake --build .
$ cmake --install .
```

There will be two programs **symCount** and **instr-count**. 

## symCount

This program is used to generate instrumented version of a llvm IR file. For example, assume the target program is example.cc

```cpp
// example.cc
int main() {
    int sum = 0;
    for (int i = 0; i < 10; i++) {
        sum += i;
    }
    return 0;
}
```

We first compile it to llvm IR.

```bash
$ clang++ -O0 -S -emit-llvm example.cc -o example.ll
```

Then we can use **symCount** to instrument the IR file by providing the llvm IR file and the target function name. 

```bash
$ ./symCount example.ll main > example_instrumented.ll
```

The output will be a new llvm IR file **example_instrumented.ll**. The target function name is the function that we want to get the the execution count, e.g. 'main' in our case. What this program does is to replace the target function with a new function that will only print the execution count of the internal basic blocks. The original function is destroyed, e.g. the new function does not have side effects the original one should perform or return values that should be computed.

Next, we can compile the instrumented llvm IR file to a native executable. 

```bash
$ clang++ example_instrumented.ll -o example_instrumented
```

Finally, we can run the instrumented executable. 

```bash
$ ./example_instrumented

9968501475174125120 entry 1
5746632034528552256 for.cond 11
12881587546266568719 for.body 10
17849245243161267553 for.inc 10
3198256872292226786 for.end 1
```

Each line of the output is basic block hash, basic block name and execution count. The hash is used to identify the basic block.

## instr-count

This program is used to count the instructions in a llvm IR file. For example, assume the target program is example.ll in previous section.

```bash
$ ./instr-count example.ll

9968501475174125120 entry
  alloca: 3
  br: 1
  store: 3
  Category Summary:
    control_flow: 1
    memory: 6
5746632034528552256 for.cond
  br: 1
  icmp: 1
  load: 1
  Category Summary:
    compare: 1
    control_flow: 1
    memory: 1
12881587546266568719 for.body
  add: 1
  br: 1
  load: 2
  store: 1
  Category Summary:
    arithmetic: 1
    control_flow: 1
    memory: 3
17849245243161267553 for.inc
  add: 1
  br: 1
  load: 1
  store: 1
  Category Summary:
    arithmetic: 1
    control_flow: 1
    memory: 2
3198256872292226786 for.end
  ret: 1
  Category Summary:
    other: 1

Category Summary:
arithmetic: 2
compare: 1
control_flow: 4
memory: 12
other: 1
```

Each block of the output is the basic block hash, basic block name and the instruction counts in the basic block grouped by the instruction category shown in the following table. The hash is the same as the one in the output of **symCount**. We can also create json output by using the **-o** option. For example:

```bash
$ ./instr-count example.ll main -o example.json
$ cat example.json

[
    {
        "block_ID": "9968501475174125120",
        "block_name": "entry",
        "category_counts": {
            "control_flow": 1,
            "memory": 6
        },
        "instruction_counts": {
            "alloca": 3,
            "br": 1,
            "store": 3
        }
    },
    {
        "block_ID": "5746632034528552256",
        "block_name": "for.cond",
        "category_counts": {
            "compare": 1,
            "control_flow": 1,
            "memory": 1
        },
        "instruction_counts": {
            "br": 1,
            "icmp": 1,
            "load": 1
        }
    },
    {
        "block_ID": "12881587546266568719",
        "block_name": "for.body",
        "category_counts": {
            "arithmetic": 1,
            "control_flow": 1,
            "memory": 3
        },
        "instruction_counts": {
            "add": 1,
            "br": 1,
            "load": 2,
            "store": 1
        }
    },
    {
        "block_ID": "17849245243161267553",
        "block_name": "for.inc",
        "category_counts": {
            "arithmetic": 1,
            "control_flow": 1,
            "memory": 2
        },
        "instruction_counts": {
            "add": 1,
            "br": 1,
            "load": 1,
            "store": 1
        }
    },
    {
        "block_ID": "3198256872292226786",
        "block_name": "for.end",
        "category_counts": {
            "other": 1
        },
        "instruction_counts": {
            "ret": 1
        }
    }
]⏎
```

### Instruction Categories
| **Category**     | **Instructions**                                                                                                                                                       |
|-------------------|-----------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| **arithmetic**    | `add`, `fadd`, `sub`, `fsub`, `mul`, `fmul`, `udiv`, `sdiv`, `fdiv`, `urem`, `srem`, `frem`                                                                           |
| **bitwise**       | `shl`, `lshr`, `ashr`, `and`, `or`, `xor`                                                                                                                             |
| **memory**        | `alloca`, `load`, `store`, `getelementptr`, `fence`, `cmpxchg`, `atomicrmw`                                                                                           |
| **conversion**    | `trunc`, `zext`, `sext`, `fptrunc`, `fpext`, `fptoui`, `fptosi`, `uitofp`, `sitofp`, `ptrtoint`, `inttoptr`, `bitcast`, `addrspacecast`                                |
| **compare**       | `icmp`, `fcmp`                                                                                                                                                        |
| **control_flow**  | `br`, `switch`, `indirectbr`, `invoke`, `resume`, `unreachable`, `callbr`                                                                                             |
| **vector**        | `extractelement`, `insertelement`, `shufflevector`, `extractvalue`, `insertvalue`                                                                                      |
| **other**         | `phi`, `select`, `call`, `va_arg`, `ret`, `landingpad`, `catchpad`, `cleanuppad`, `catchret`, `cleanupret`, `catchswitch`                                             |