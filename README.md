# Trip Counter

## Overview
`Trip Counter` is an LLVM-IR symbolic analysis toolchain. The primary supported CLI is **`symb-viewer`**, which analyzes a target function and can:

- Emit symbolic formulas / graph JSON
- Generate symbolic instance LLVM IR (`kernel` / `instance` modes)
- Run characterization metrics

> Note: `symCount` and `instr-count` are currently experimental utilities and are not the main documented workflow.

## Requirements

- **CMake**: 3.10+
- **Clang/LLVM**: compatible with your local build (project uses LLVM CMake config)
- **Z3**: 4.15.1+

## Build

From project root:

```bash
mkdir -p build
cmake -S . -B build
cmake --build build
```

Main executable:

- `build/symb-viewer`

## Project Layout

- `include/trip_counter/`: headers
- `src/core/`: shared implementation
- `src/tools/`: CLI entrypoints
- `src/IR_plugin/`: LLVM IR plugin helper artifacts

`symb-viewer` entrypoint source: `src/tools/symb_viewer_main.cc`

## symb-viewer CLI

From the code (`src/tools/symb_viewer_main.cc`), the command format is:

```bash
./build/symb-viewer <subcommand> <input.ll> <function_name> [options]
```

Subcommands:

- `formula` — show symbolic formulas (text or JSON)
- `kernel` — generate kernel-only symbolic instance (no generated `main`)
- `instance` — generate symbolic instance with generated `main`
- `characterize` — print structural/complexity metrics

Global option:

- `-h` — print help

### `formula` options

- `-json=<file>`: write symbolic graph JSON
- `-subs=<file>`: apply substitutions from a JSON file
- `-quiet`: suppress text output (useful with `-json`)
- `-time`: print timing breakdown

### `kernel` / `instance` options

- `--output-to-file`: generate output that writes results to file instead of stdout

## Examples

### 1) Print symbolic formula to stdout

```bash
./build/symb-viewer formula kernel_examples/example/example.ll main
```

### 2) Export symbolic graph JSON

```bash
./build/symb-viewer formula kernel_examples/example/example.ll main -json=example_formula.json
```

### 3) Apply substitutions + export JSON

```bash
./build/symb-viewer formula kernel_examples/example/example.ll main -subs=subs.json -json=example_substituted.json
```

### 4) Generate kernel-only symbolic instance IR

```bash
./build/symb-viewer kernel kernel_examples/example/example.ll main > kernel_instance.ll
```

### 5) Generate test instance IR (with generated main)

```bash
./build/symb-viewer instance kernel_examples/example/example.ll main > test_instance.ll
```

### 6) Characterization mode

```bash
./build/symb-viewer characterize kernel_examples/example/example.ll main -time
```

## Output Notes

- `formula` mode:
  - with `-json`: writes JSON to file
  - without `-quiet`: prints symbolic program/graphs to stdout
- `kernel` / `instance` modes:
  - print generated LLVM IR module to stdout
- `characterize` mode:
  - prints module/function metrics plus symbolic summary counts
