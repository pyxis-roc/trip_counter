#!/usr/bin/env bash

set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
VENV_DIR="${ROOT_DIR}/.venv-symb-form-tests"
TVM_BUILD_DIR="${ROOT_DIR}/build/third_party/tvm"
REQUIREMENTS_FILE="${ROOT_DIR}/tests/symb_form_tests/requirements.txt"
TVM_SOURCE_DIR="${ROOT_DIR}/third_party/tvm"
INSTRGEN_DIR="${ROOT_DIR}/third_party/instrGen"
GETBBCOUNT_DIR="${ROOT_DIR}/third_party/getBBCount"
BENCHMARK_DIR="${ROOT_DIR}/external/symb_form_tests/tvm-ops"
BUILD_JOBS=""
LLVM_CONFIG_BIN="${LLVM_CONFIG:-}"
LLVM_USE_SPEC=""

usage() {
    cat <<'EOF'
Usage: bootstrap_symb_form_tests.sh [options]

Options:
  --venv-dir PATH       Override the repo-local virtualenv location.
  --tvm-build-dir PATH  Override the TVM build directory.
  --build-jobs N        Override the TVM build parallelism.
  --llvm-config PATH    Override the llvm-config binary used for TVM.
  -h, --help            Show this help message.
EOF
}

require_command() {
    local cmd="$1"
    if ! command -v "${cmd}" >/dev/null 2>&1; then
        echo "Missing required command: ${cmd}" >&2
        exit 1
    fi
}

require_path() {
    local path="$1"
    local description="$2"
    if [[ ! -e "${path}" ]]; then
        echo "Missing ${description}: ${path}" >&2
        echo "Initialize submodules first: git submodule update --init --recursive" >&2
        exit 1
    fi
}

require_positive_integer() {
    local value="$1"
    local description="$2"
    if [[ ! "${value}" =~ ^[1-9][0-9]*$ ]]; then
        echo "Expected ${description} to be a positive integer, got: ${value}" >&2
        exit 1
    fi
}

detect_cpu_count() {
    if command -v nproc >/dev/null 2>&1; then
        nproc
        return
    fi

    if command -v getconf >/dev/null 2>&1; then
        getconf _NPROCESSORS_ONLN
        return
    fi

    echo 1
}

detect_mem_available_kib() {
    awk '
        /MemAvailable:/ { print $2; found=1; exit }
        /MemTotal:/ { fallback=$2 }
        END {
            if (!found && fallback != "") {
                print fallback
            }
        }
    ' /proc/meminfo 2>/dev/null || true
}

resolve_command_path() {
    local cmd="$1"
    command -v "${cmd}" 2>/dev/null || true
}

choose_llvm_config() {
    local candidate candidate_path version major

    if [[ -n "${LLVM_CONFIG_BIN}" ]]; then
        printf '%s\n' "${LLVM_CONFIG_BIN}"
        return
    fi

    candidate_path="$(resolve_command_path llvm-config)"
    if [[ -n "${candidate_path}" ]]; then
        printf '%s\n' "${candidate_path}"
        return
    fi

    for candidate in llvm-config-20 llvm-config-19 llvm-config-18 llvm-config-17 llvm-config-16 llvm-config-15 llvm-config-14; do
        candidate_path="$(resolve_command_path "${candidate}")"
        if [[ -n "${candidate_path}" ]]; then
            printf '%s\n' "${candidate_path}"
            return
        fi
    done
}

choose_llvm_use_spec() {
    if "${LLVM_CONFIG_BIN}" --ignore-libllvm --link-static --libfiles >/dev/null 2>&1; then
        printf '%s --ignore-libllvm --link-static\n' "${LLVM_CONFIG_BIN}"
        return
    fi

    if "${LLVM_CONFIG_BIN}" --link-shared --libfiles >/dev/null 2>&1; then
        printf '%s --link-shared\n' "${LLVM_CONFIG_BIN}"
        return
    fi

    return 1
}

choose_build_jobs() {
    local cpu_count mem_available_kib jobs_by_mem jobs

    cpu_count="$(detect_cpu_count)"
    if [[ -z "${cpu_count}" || "${cpu_count}" -lt 1 ]]; then
        cpu_count=1
    fi

    mem_available_kib="$(detect_mem_available_kib)"
    jobs="${cpu_count}"

    # TVM's C++ compilation can be memory-heavy; keep the default conservative.
    if [[ -n "${mem_available_kib}" && "${mem_available_kib}" -gt 0 ]]; then
        jobs_by_mem=$(( mem_available_kib / (5 * 1024 * 1024) ))
        if [[ "${jobs_by_mem}" -lt 1 ]]; then
            jobs_by_mem=1
        fi
        if [[ "${jobs_by_mem}" -lt "${jobs}" ]]; then
            jobs="${jobs_by_mem}"
        fi
    fi

    if [[ "${jobs}" -gt 8 ]]; then
        jobs=8
    fi

    if [[ "${jobs}" -lt 1 ]]; then
        jobs=1
    fi

    printf '%s\n' "${jobs}"
}

while [[ $# -gt 0 ]]; do
    case "$1" in
        --venv-dir)
            VENV_DIR="$2"
            shift 2
            ;;
        --tvm-build-dir)
            TVM_BUILD_DIR="$2"
            shift 2
            ;;
        --build-jobs)
            BUILD_JOBS="$2"
            shift 2
            ;;
        --llvm-config)
            LLVM_CONFIG_BIN="$2"
            shift 2
            ;;
        -h|--help)
            usage
            exit 0
            ;;
        *)
            echo "Unknown argument: $1" >&2
            usage >&2
            exit 1
            ;;
    esac
done

require_command git
require_command python3
require_command cmake
require_command llvm-profdata
require_command clang++

require_path "${REQUIREMENTS_FILE}" "requirements file"
require_path "${TVM_SOURCE_DIR}/CMakeLists.txt" "TVM submodule"
require_path "${TVM_SOURCE_DIR}/python/pyproject.toml" "TVM python package"
require_path "${INSTRGEN_DIR}/pyproject.toml" "instrGen submodule"
require_path "${GETBBCOUNT_DIR}/pyproject.toml" "getBBCount submodule"
require_path "${BENCHMARK_DIR}/benchmark.py" "benchmark submodule"

if [[ -n "${BUILD_JOBS}" ]]; then
    require_positive_integer "${BUILD_JOBS}" "--build-jobs"
elif [[ -n "${CMAKE_BUILD_PARALLEL_LEVEL:-}" ]]; then
    require_positive_integer "${CMAKE_BUILD_PARALLEL_LEVEL}" "CMAKE_BUILD_PARALLEL_LEVEL"
    BUILD_JOBS="${CMAKE_BUILD_PARALLEL_LEVEL}"
else
    BUILD_JOBS="$(choose_build_jobs)"
fi

LLVM_CONFIG_BIN="$(choose_llvm_config)"
if [[ -z "${LLVM_CONFIG_BIN}" ]]; then
    echo "Missing required command: llvm-config" >&2
    exit 1
fi
if [[ ! -x "${LLVM_CONFIG_BIN}" ]]; then
    echo "Configured llvm-config is not executable: ${LLVM_CONFIG_BIN}" >&2
    exit 1
fi

LLVM_USE_SPEC="$(choose_llvm_use_spec)" || {
    echo "Unable to determine a working LLVM link mode for: ${LLVM_CONFIG_BIN}" >&2
    exit 1
}

echo "[symb_form_tests] Initializing nested TVM submodules..."
git -C "${TVM_SOURCE_DIR}" submodule update --init --recursive

echo "[symb_form_tests] Creating virtualenv at ${VENV_DIR}..."
python3 -m venv "${VENV_DIR}"

# shellcheck disable=SC1091
source "${VENV_DIR}/bin/activate"

echo "[symb_form_tests] Installing Python packaging tools..."
python3 -m pip install --upgrade pip setuptools wheel cython

echo "[symb_form_tests] Installing pinned Python dependencies..."
python3 -m pip install -r "${REQUIREMENTS_FILE}"

mkdir -p "${TVM_BUILD_DIR}"
cat > "${TVM_BUILD_DIR}/config.cmake" <<EOF
set(CMAKE_BUILD_TYPE RelWithDebInfo)
set(USE_LLVM "${LLVM_USE_SPEC}")
set(HIDE_PRIVATE_SYMBOLS ON)
EOF

echo "[symb_form_tests] Building vendored TVM in ${TVM_BUILD_DIR}..."
echo "[symb_form_tests] Using llvm-config: ${LLVM_CONFIG_BIN} ($("${LLVM_CONFIG_BIN}" --version))"
echo "[symb_form_tests] Using LLVM link mode: ${LLVM_USE_SPEC#${LLVM_CONFIG_BIN} }"
echo "[symb_form_tests] Using ${BUILD_JOBS} parallel build job(s) for TVM."
cmake -S "${TVM_SOURCE_DIR}" -B "${TVM_BUILD_DIR}" -DCMAKE_BUILD_TYPE=RelWithDebInfo
cmake --build "${TVM_BUILD_DIR}" --parallel "${BUILD_JOBS}"

export TVM_HOME="${TVM_SOURCE_DIR}"
export TVM_LIBRARY_PATH="${TVM_BUILD_DIR}"
export LD_LIBRARY_PATH="${TVM_BUILD_DIR}${LD_LIBRARY_PATH:+:${LD_LIBRARY_PATH}}"
export PYTHONNOUSERSITE=1

echo "[symb_form_tests] Installing editable benchmark tools..."
python3 -m pip install -e "${TVM_SOURCE_DIR}/python"
python3 -m pip install -e "${INSTRGEN_DIR}"
python3 -m pip install -e "${GETBBCOUNT_DIR}"

echo "[symb_form_tests] Validating the local TVM environment..."
python3 - "${TVM_SOURCE_DIR}" "${TVM_BUILD_DIR}" <<'EOF'
import pathlib
import sys

tvm_source = pathlib.Path(sys.argv[1]).resolve()
tvm_build = pathlib.Path(sys.argv[2]).resolve()

import tvm

version = getattr(tvm, "__version__", None)
if version != "0.21.0":
    raise SystemExit(f"Expected TVM 0.21.0, found {version!r}")

tvm_file = pathlib.Path(tvm.__file__).resolve()
if not tvm_file.is_relative_to((tvm_source / "python").resolve()):
    raise SystemExit(f"TVM imported from an unexpected location: {tvm_file}")

lib_path = pathlib.Path(tvm.base._LIB._name).resolve()
if not lib_path.is_relative_to(tvm_build):
    raise SystemExit(f"TVM loaded an unexpected shared library: {lib_path}")

print(f"Validated TVM {version} from {tvm_file}")
print(f"Loaded TVM shared library from {lib_path}")
EOF

echo "[symb_form_tests] Bootstrap complete."
