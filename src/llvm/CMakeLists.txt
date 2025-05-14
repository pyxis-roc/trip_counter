cmake_minimum_required(VERSION 3.10)

project(symCount VERSION 1.0)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED True)
set(CMAKE_CXX_COMPILER clang++)
add_compile_options(-fno-rtti)

find_package(LLVM REQUIRED CONFIG)
execute_process(
    COMMAND llvm-config --includedir 
    OUTPUT_VARIABLE 
    LLVM_INCLUDE_DIRS
)
include_directories(${LLVM_INCLUDE_DIRS})

# Find nlohmann/json
find_package(nlohmann_json REQUIRED)

add_executable(
    symCount 
    main.cc 
    block_counting.cc
    control_variable.cc 
    loop_summary.cc
    printer.cc
    utils.cc
)

add_executable(
    instr-count
    instr_count.cc
    utils.cc
)

target_compile_definitions(symCount PRIVATE IR_PLUGIN_PATH="${PROJECT_SOURCE_DIR}/IR_plugin")
target_include_directories(symCount PUBLIC "${PROJECT_SOURCE_DIR}")
target_link_libraries(symCount LLVMPasses LLVMCore LLVMSupport LLVMIRReader LLVMAnalysis nlohmann_json::nlohmann_json)
target_link_libraries(instr-count LLVMPasses LLVMCore LLVMSupport LLVMIRReader LLVMAnalysis nlohmann_json::nlohmann_json)
install(TARGETS symCount instr-count DESTINATION bin)