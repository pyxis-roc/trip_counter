import subprocess
import time
import sys
import os

# experiment different size of matrix
pool = [16, 32, 64, 128, 256, 512, 1024, 2048, 4096]

# run matmul kernel with M, N, K, return the time of instrumented and proxy
def experiment(M, N, K):
    generate_caller = "./caller %s %s %s 2> caller.ll" %(str(M), str(N), str(K))
    compile_plain = "clang++ -w -O2 caller.ll matmul_kernel.ll -o matmul_plain"
    compile_instr = "clang++ -w -O2 -fprofile-generate caller.ll matmul_kernel.ll -o matmul_instr"
    compile_proxy = "clang++ -w -O2 caller.ll matmul_kernel_simplified.ll print.ll -o matmul_proxy"
    generate_proxy = "./symCount matmul_kernel.ll"
    run_instr = "./matmul_instr"
    run_proxy = "./matmul_proxy"

    try:

        subprocess.check_call(generate_caller, stderr=subprocess.DEVNULL, stdout=subprocess.DEVNULL, shell=True)

        # measure analysis time
        get_plain_start = time.time()
        subprocess.check_call(compile_plain, stderr=subprocess.DEVNULL, stdout=subprocess.DEVNULL, shell=True)
        get_plain_end = time.time()

        get_proxy_start = time.time()
        subprocess.check_call(generate_proxy, stderr=subprocess.DEVNULL, stdout=subprocess.DEVNULL, shell=True)
        get_proxy_end = time.time()

        get_instr_start = time.time()
        subprocess.check_call(compile_instr, stderr=subprocess.DEVNULL, stdout=subprocess.DEVNULL, shell=True)
        get_instr_end = time.time()

        subprocess.check_call(compile_proxy, stderr=subprocess.DEVNULL, stdout=subprocess.DEVNULL, shell=True)

        run_instr_start = time.time()
        subprocess.check_call( run_instr, stderr=subprocess.DEVNULL, stdout=subprocess.DEVNULL, shell=True,)
        run_instr_end = time.time()

        run_proxy_start = time.time()
        subprocess.check_call( run_proxy, stderr=subprocess.DEVNULL, stdout=subprocess.DEVNULL, shell=True,)
        run_proxy_end = time.time()

    finally:
        # clean up
        to_remove = ["caller.ll", "matmul_plain", "matmul_instr", "matmul_proxy"]
        path = os.getcwd()
        for f in to_remove:
            os.remove(os.path.join(path, f))
            while os.path.exists(os.path.join(path, f)):
                pass
    
    get_plain_time = get_plain_end - get_plain_start
    get_proxy_time = get_proxy_end - get_proxy_start
    get_instr_time = get_instr_end - get_instr_start
    run_instr_time = run_instr_end - run_instr_start
    run_proxy_time = run_proxy_end - run_proxy_start

    instr_analysis_overhead = get_instr_time - get_plain_time
    proxy_analysis_overhead = get_proxy_time
    instr_run_overhead = run_instr_time 
    proxy_run_overhead = run_proxy_time

    return instr_analysis_overhead, proxy_analysis_overhead, instr_run_overhead, proxy_run_overhead

for size in pool:
    instr_analysis_overhead, proxy_analysis_overhead, instr_run_overhead, proxy_run_overhead = experiment(size, size, size)
    print("Size: %d" % size)
    print("Instrumented Analysis Overhead: %f" % instr_analysis_overhead)
    print("Proxy Analysis Overhead: %f" % proxy_analysis_overhead)
    print("Instrumented Run Overhead: %f" % instr_run_overhead)
    print("Proxy Run Overhead: %f" % proxy_run_overhead)
    print("")