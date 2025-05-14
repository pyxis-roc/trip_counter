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

Try this tool to generate instrumented IR

```bash
$ ./symCount example.ll main 2> example_instrumented.ll
```

Then when `example_instrumented.ll` is compiled and the `main` function is called. Execution counts of `main`'s internal basic blocks will be printed to stdout.