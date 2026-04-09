# Trip Counter

## Overview
`Trip Counter` is an LLVM-IR symbolic analysis toolchain. The primary supported CLI is **`symb-viewer`**, which analyzes a target function and can:

- Emit symbolic formulas / graph JSON
- Generate symbolic instance LLVM IR (`kernel` / `instance` modes)
- Count per-block instruction/category statistics (`inst-count` mode)
- Run characterization metrics

> Note: `symCount` is currently experimental and not the main documented workflow.

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
- `inst-count` — count instructions in the target function
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

### `inst-count` options

- `-o=<file>`: write instruction-count result as JSON

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

### 7) Instruction count mode

```bash
./build/symb-viewer inst-count kernel_examples/example/example.ll main
```

### 8) Instruction count JSON output

```bash
./build/symb-viewer inst-count kernel_examples/example/example.ll main -o=counts.json
```

## Optional Benchmark Integration

This repo can vendor the in-development benchmark workflow so you can run the
current `symb_form_tests/tvm-ops` regression from the project root without
installing `symb-viewer` system-wide.

### Included Optional Submodules

- `third_party/tvm` pinned to fork commit `0d21b1e58` on branch `trip-counter-llvm22`
- `third_party/instrGen`
- `third_party/getBBCount`
- `external/symb_form_tests`

The TVM submodule now expects your fork at `git@github.com:SoftJing1/tvm.git`.
That fork commit is based on upstream TVM commit `68bb125ded265abf1ce46843979feae085fed03d`
with the repo-local LLVM 22 compatibility fixes recorded as a normal TVM commit.

If `SoftJing1/tvm` does not exist yet, create the fork once and push the pinned branch:

```bash
git -C third_party/tvm remote set-url origin git@github.com:SoftJing1/tvm.git
git -C third_party/tvm push -u origin trip-counter-llvm22
git submodule sync --recursive
```

Initialize them when you want the integration:

```bash
git submodule update --init --recursive
git -C third_party/tvm submodule update --init --recursive
```

### Bootstrap The Local Benchmark Environment

The bootstrap script creates a repo-local virtualenv, builds the vendored TVM
tree, installs editable Python packages for TVM, `instrGen`, and
`getBBCounts`, and validates that Python is importing TVM from this repo.

```bash
./scripts/bootstrap_symb_form_tests.sh
```

Useful overrides:

```bash
./scripts/bootstrap_symb_form_tests.sh \
  --venv-dir "$(pwd)/.venv-symb-form-tests" \
  --tvm-build-dir "$(pwd)/build/third_party/tvm" \
  --build-jobs 4
```

By default, the bootstrap script now picks a conservative TVM build
parallelism based on available memory and CPU count to avoid OOM-killing the
editor or shell session during the vendored TVM build. If you want to tune it
manually, pass `--build-jobs N` or set `CMAKE_BUILD_PARALLEL_LEVEL=N`.

### Run The Benchmark From This Repo

Build `symb-viewer` locally first:

```bash
cmake -S . -B build
cmake --build build
```

Then run the benchmark wrapper:

```bash
./scripts/run_symb_form_benchmark.sh
```

That wrapper reproduces the current external workflow by:

- activating the repo-local benchmark venv
- preferring the local `build/symb-viewer`
- running `python3 benchmark.py --no-debug` inside
  `external/symb_form_tests/tvm-ops`

Extra arguments are passed through to `benchmark.py`:

```bash
./scripts/run_symb_form_benchmark.sh --op conv
./scripts/run_symb_form_benchmark.sh --base_dir /tmp/symb-form-tests
```

### Optional CMake / CTest Hooks

Enable the integration hooks during configure time:

```bash
cmake -S . -B build -DTRIP_COUNTER_ENABLE_SYMB_FORM_TESTS=ON
```

This adds:

- `symb_form_tests_bootstrap` custom target
- `symb_form_tests` custom target
- `symb_form_tests_full` CTest entry labeled `integration` and `slow`

Examples:

```bash
cmake --build build --target symb_form_tests_bootstrap
cmake --build build --target symb_form_tests
ctest --test-dir build -L integration
```

### Troubleshooting

- `llvm-config` missing:
  TVM bootstrap needs LLVM available on `PATH`.
- `llvm-profdata` missing:
  `getBBCounts` depends on it during exact-count extraction.
- `clang++` missing:
  the benchmark uses it to compile generated `instance.ll`.
- TVM imports from the wrong location:
  rerun `./scripts/bootstrap_symb_form_tests.sh` and make sure the wrapper is
  using the repo-local venv instead of another active environment.

## Output Notes

- `formula` mode:
  - with `-json`: writes JSON to file
  - without `-quiet`: prints symbolic program/graphs to stdout
- `kernel` / `instance` modes:
  - print generated LLVM IR module to stdout
- `characterize` mode:
  - prints module/function metrics plus symbolic summary counts
- `inst-count` mode:
  - prints per-basic-block opcode counts and category summary
  - with `-o=<file>`, emits JSON output
