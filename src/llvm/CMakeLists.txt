cmake_minimum_required(VERSION 3.10)

project(symCount VERSION 1.0)

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
    OUTPUT ${PROJECT_SOURCE_DIR}/IR_plugin/print.ll
    COMMAND ${CMAKE_CXX_COMPILER} -S -emit-llvm
                    ${PROJECT_SOURCE_DIR}/IR_plugin/print.cc
                    -o ${PROJECT_SOURCE_DIR}/IR_plugin/print.ll
    DEPENDS ${PROJECT_SOURCE_DIR}/IR_plugin/print.cc
    COMMENT "Generating LLVM IR from /IR_plugin/print.cc"
)

add_custom_target(
    GenerateIR ALL
    DEPENDS ${PROJECT_SOURCE_DIR}/IR_plugin/print.ll
)

add_executable(
    symCount 
    main.cc 
    block_counting.cc
    control_variable.cc 
    loop_summary.cc
    utils.cc
    printer.cc
)

add_executable(
    instr-count
    instr_count.cc
    utils.cc
)

add_executable(
    symb-viewer
    symb_viewer.cc
    symb_form.cc
    utils.cc
    symb_expr.cc
    characterize.cc
    symb_instance.cc
)

target_compile_definitions(symCount PRIVATE IR_PLUGIN_PATH="${PROJECT_SOURCE_DIR}/IR_plugin")
target_include_directories(symCount PUBLIC "${PROJECT_SOURCE_DIR}")
target_link_libraries(symCount LLVMPasses LLVMCore LLVMSupport LLVMIRReader LLVMAnalysis nlohmann_json::nlohmann_json)
target_link_libraries(instr-count LLVMPasses LLVMCore LLVMSupport LLVMIRReader LLVMAnalysis nlohmann_json::nlohmann_json)
target_link_libraries(symb-viewer LLVMPasses LLVMCore LLVMSupport LLVMIRReader LLVMAnalysis nlohmann_json::nlohmann_json z3)
target_compile_options(symb-viewer PRIVATE -O3)
install(TARGETS symCount instr-count symb-viewer DESTINATION bin)
