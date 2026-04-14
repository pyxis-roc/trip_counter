cmake_minimum_required(VERSION 3.10)

project(symCount VERSION 1.0)

option(
    TRIP_COUNTER_ENABLE_SYMB_FORM_TESTS
    "Enable optional symb_form_tests benchmark integration targets and tests."
    OFF
)

# get nlohmann/json
include(FetchContent)

# find llvm
find_package(LLVM REQUIRED CONFIG)

message(STATUS "Found LLVM ${LLVM_PACKAGE_VERSION}")
message(STATUS "LLVM Include Directory: ${LLVM_INCLUDE_DIRS}")
message(STATUS "LLVM Libraries: ${LLVM_LIBRARY_DIRS}")
message(STATUS "LLVM Targets: ${LLVM_TARGETS_TO_BUILD}")

execute_process(
    COMMAND llvm-config --includedir 
    OUTPUT_VARIABLE 
    LLVM_INCLUDE_DIRS
)
include_directories(${LLVM_INCLUDE_DIRS})

set(Z3_MIN_VERSION "4.15.1")
find_package(Z3 ${Z3_MIN_VERSION} REQUIRED CONFIG)

# Map LLVM components to library names
llvm_map_components_to_libnames(LLVM_LIBS core support irreader analysis passes instcombine)

FetchContent_Declare(json URL https://github.com/nlohmann/json/releases/download/v3.12.0/json.tar.xz)
FetchContent_MakeAvailable(json)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED True)
set(CMAKE_CXX_COMPILER clang++)
add_compile_options(-fno-rtti)
# add_compile_options(-g)
set(CMAKE_EXE_LINKER_FLAGS "-fuse-ld=lld")


# prepare utils llvm ir plugin using local compiler

add_custom_command(
    OUTPUT ${PROJECT_SOURCE_DIR}/src/IR_plugin/print.ll
    COMMAND ${CMAKE_CXX_COMPILER} -S -emit-llvm
                    ${PROJECT_SOURCE_DIR}/src/IR_plugin/print.cc
                    -o ${PROJECT_SOURCE_DIR}/src/IR_plugin/print.ll
    DEPENDS ${PROJECT_SOURCE_DIR}/src/IR_plugin/print.cc
    COMMENT "Generating LLVM IR from /src/IR_plugin/print.cc"
)

add_custom_target(
    GenerateIR ALL
    DEPENDS ${PROJECT_SOURCE_DIR}/src/IR_plugin/print.ll
)

add_executable(
    symCount 
    src/tools/symcount_main.cc 
    src/core/block_counting.cc
    src/core/control_variable.cc 
    src/core/loop_summary.cc
    src/core/utils.cc
    src/core/printer.cc
)

add_executable(
    symb-viewer
    src/tools/symb_viewer_main.cc
    src/core/instr_count_subcommand.cc
    src/core/symb_form.cc
    src/core/symb_form_analysis_flow.cc
    src/core/symb_form_analysis_affine.cc
    src/core/symb_form_analysis_expr.cc
    src/core/symb_form_symbol.cc
    src/core/symb_form_viewer.cc
    src/core/utils.cc
    src/core/symb_expr.cc
    src/core/characterize.cc
    src/core/symb_instance.cc
)

target_compile_definitions(symCount PRIVATE IR_PLUGIN_PATH="${PROJECT_SOURCE_DIR}/src/IR_plugin")
target_include_directories(symCount PUBLIC "${PROJECT_SOURCE_DIR}/include/trip_counter")
target_include_directories(symb-viewer PUBLIC "${PROJECT_SOURCE_DIR}/include/trip_counter")
target_link_libraries(symCount ${LLVM_LIBS} nlohmann_json::nlohmann_json)
target_link_libraries(symb-viewer ${LLVM_LIBS} nlohmann_json::nlohmann_json z3)
target_compile_options(symb-viewer PRIVATE -O3)
install(TARGETS symCount symb-viewer DESTINATION bin)

if(TRIP_COUNTER_ENABLE_SYMB_FORM_TESTS)
    set(TRIP_COUNTER_REQUIRED_SUBMODULES "")

    if(NOT EXISTS "${PROJECT_SOURCE_DIR}/third_party/tvm/CMakeLists.txt")
        string(APPEND TRIP_COUNTER_REQUIRED_SUBMODULES "\n  - third_party/tvm")
    endif()
    if(NOT EXISTS "${PROJECT_SOURCE_DIR}/third_party/instrGen/pyproject.toml")
        string(APPEND TRIP_COUNTER_REQUIRED_SUBMODULES "\n  - third_party/instrGen")
    endif()
    if(NOT EXISTS "${PROJECT_SOURCE_DIR}/third_party/getBBCount/pyproject.toml")
        string(APPEND TRIP_COUNTER_REQUIRED_SUBMODULES "\n  - third_party/getBBCount")
    endif()
    if(NOT EXISTS "${PROJECT_SOURCE_DIR}/external/symb_form_tests/tvm-ops/benchmark.py")
        string(APPEND TRIP_COUNTER_REQUIRED_SUBMODULES "\n  - external/symb_form_tests")
    endif()

    if(TRIP_COUNTER_REQUIRED_SUBMODULES)
        message(FATAL_ERROR
            "TRIP_COUNTER_ENABLE_SYMB_FORM_TESTS=ON requires these submodules:"
            "${TRIP_COUNTER_REQUIRED_SUBMODULES}\n"
            "Initialize them with:\n"
            "  git submodule update --init --recursive"
        )
    endif()

    set(TRIP_COUNTER_SYMB_FORM_VENV_DIR "${PROJECT_SOURCE_DIR}/.venv-symb-form-tests")
    set(TRIP_COUNTER_TVM_BUILD_DIR "${CMAKE_BINARY_DIR}/third_party/tvm")
    set(TRIP_COUNTER_BOOTSTRAP_SCRIPT "${PROJECT_SOURCE_DIR}/scripts/bootstrap_symb_form_tests.sh")
    set(TRIP_COUNTER_RUNNER_SCRIPT "${PROJECT_SOURCE_DIR}/scripts/run_symb_form_benchmark.sh")

    add_custom_target(
        symb_form_tests_bootstrap
        COMMAND "${TRIP_COUNTER_BOOTSTRAP_SCRIPT}"
                --venv-dir "${TRIP_COUNTER_SYMB_FORM_VENV_DIR}"
                --tvm-build-dir "${TRIP_COUNTER_TVM_BUILD_DIR}"
        WORKING_DIRECTORY "${PROJECT_SOURCE_DIR}"
        USES_TERMINAL
        COMMENT "Bootstrapping the optional symb_form_tests benchmark environment"
    )

    add_custom_target(
        symb_form_tests
        COMMAND "${TRIP_COUNTER_RUNNER_SCRIPT}"
                --build-dir "${CMAKE_BINARY_DIR}"
                --venv-dir "${TRIP_COUNTER_SYMB_FORM_VENV_DIR}"
        WORKING_DIRECTORY "${PROJECT_SOURCE_DIR}"
        USES_TERMINAL
        COMMENT "Running the optional symb_form_tests benchmark suite"
    )
    add_dependencies(symb_form_tests symb-viewer symb_form_tests_bootstrap)

    include(CTest)
    if(BUILD_TESTING)
        add_test(
            NAME symb_form_tests_full
            COMMAND "${TRIP_COUNTER_RUNNER_SCRIPT}"
                    --build-dir "${CMAKE_BINARY_DIR}"
                    --venv-dir "${TRIP_COUNTER_SYMB_FORM_VENV_DIR}"
        )
        set_tests_properties(symb_form_tests_full PROPERTIES
            LABELS "integration;slow"
            WORKING_DIRECTORY "${PROJECT_SOURCE_DIR}"
        )
    endif()
endif()
