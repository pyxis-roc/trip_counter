cmake_minimum_required(VERSION 3.10)

project(symCount VERSION 1.0)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED True)
set(CMAKE_CXX_COMPILER clang++)

find_package(LLVM REQUIRED CONFIG)
execute_process(
    COMMAND llvm-config --includedir 
    OUTPUT_VARIABLE 
    LLVM_INCLUDE_DIRS
)
include_directories(${LLVM_INCLUDE_DIRS})

add_executable(
    symCount 
    main.cc 
    block_counting.cc
    control_variable.cc 
    loop_summary.cc
    printer.cc
)

add_executable(
    caller
    caller.cc
)

target_include_directories(symCount PUBLIC "${PROJECT_SOURCE_DIR}")
target_link_libraries(symCount LLVMPasses LLVMCore LLVMSupport LLVMIRReader LLVMAnalysis)
target_link_libraries(caller LLVMPasses LLVMCore LLVMSupport LLVMIRReader LLVMAnalysis)