#!/usr/bin/env bash

set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
BUILD_DIR="${ROOT_DIR}/build"
VENV_DIR="${ROOT_DIR}/.venv-symb-form-tests"
BENCHMARK_DIR="${ROOT_DIR}/external/symb_form_tests/tvm-ops"
EXTRA_ARGS=()
HAS_DEBUG_FLAG=0

usage() {
    cat <<'EOF'
Usage: run_symb_form_benchmark.sh [options] [benchmark.py args...]

Options:
  --build-dir PATH  Override the local trip_counter build directory.
  --venv-dir PATH   Override the benchmark virtualenv directory.
  -h, --help        Show this help message.
EOF
}

while [[ $# -gt 0 ]]; do
    case "$1" in
        --build-dir)
            BUILD_DIR="$2"
            shift 2
            ;;
        --venv-dir)
            VENV_DIR="$2"
            shift 2
            ;;
        -h|--help)
            usage
            exit 0
            ;;
        --debug|--no-debug)
            HAS_DEBUG_FLAG=1
            EXTRA_ARGS+=("$1")
            shift
            ;;
        *)
            EXTRA_ARGS+=("$1")
            shift
            ;;
    esac
done

if [[ ! -x "${BUILD_DIR}/symb-viewer" ]]; then
    echo "Expected a local symb-viewer at ${BUILD_DIR}/symb-viewer" >&2
    echo "Build it first with: cmake --build ${BUILD_DIR}" >&2
    exit 1
fi

if [[ ! -f "${VENV_DIR}/bin/activate" ]]; then
    echo "Expected a benchmark virtualenv at ${VENV_DIR}" >&2
    echo "Create it first with: ${ROOT_DIR}/scripts/bootstrap_symb_form_tests.sh" >&2
    exit 1
fi

if [[ ! -f "${BENCHMARK_DIR}/benchmark.py" ]]; then
    echo "Missing benchmark repo at ${BENCHMARK_DIR}" >&2
    echo "Initialize submodules first: git submodule update --init --recursive" >&2
    exit 1
fi

# shellcheck disable=SC1091
source "${VENV_DIR}/bin/activate"

export PATH="${BUILD_DIR}:${VENV_DIR}/bin:${PATH}"
export PYTHONNOUSERSITE=1
export TVM_LIBRARY_PATH="${BUILD_DIR}/third_party/tvm"

if [[ ${HAS_DEBUG_FLAG} -eq 0 ]]; then
    EXTRA_ARGS=("--no-debug" "${EXTRA_ARGS[@]}")
fi

cd "${BENCHMARK_DIR}"
echo "[symb_form_tests] Using symb-viewer: $(command -v symb-viewer)"
echo "[symb_form_tests] Running benchmark.py ${EXTRA_ARGS[*]}"
exec python3 benchmark.py "${EXTRA_ARGS[@]}"
