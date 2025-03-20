from matmul_tvm import run_matmul_lib
import csv
import time
import subprocess

def analysis(store = 'results/matmul_init.csv'):
    compile_plain = 'clang++ -O0 matmul_tvm.ll -shared -o matmul_tvm_plain.so'
    compile_instr = 'clang++ -O0 -fprofile-generate=instr.prof matmul_tvm.ll -shared -o matmul_tvm_instr.so'
    compile_proxy = 'clang++ -O0 matmul_tvm_proxy.ll -shared -o matmul_tvm_proxy.so'

    # collect time 
    get_plain_start = time.time()
    subprocess.check_call(compile_plain, stderr=subprocess.DEVNULL, stdout=subprocess.DEVNULL, shell=True)
    get_plain_end = time.time()

    get_instr_start = time.time()
    subprocess.check_call(compile_instr, stderr=subprocess.DEVNULL, stdout=subprocess.DEVNULL, shell=True)
    get_instr_end = time.time()

    get_proxy_start = time.time()
    subprocess.check_call(compile_proxy, stderr=subprocess.DEVNULL, stdout=subprocess.DEVNULL, shell=True)
    get_proxy_end = time.time()

    plain_time = get_plain_end - get_plain_start
    instr_time = get_instr_end - get_instr_start
    
    instr_analysis = instr_time - plain_time
    proxy_analysis = get_proxy_end - get_proxy_start

    with open(store, mode='w') as file:
        writer = csv.writer(file)
        writer.writerow(['plain_time', 'instr_analysis', 'proxy_analysis'])
        writer.writerow([plain_time, instr_analysis, proxy_analysis])


def run(store = 'results/matmul.csv'):
    pool = [64,128,256,512,1024,2048,4096]
    with open(store, mode='w') as file:
        writer = csv.writer(file)
        writer.writerow(['size', 'instr_exec_time', 'proxy_exec_time'])
        for size in pool:
            M = size
            K = size
            N = size

            instr_time = run_matmul_lib("./matmul_tvm_instr.so", M, K, N)
            proxy_time = run_matmul_lib( "./matmul_tvm_proxy.so", M, K, N)

            writer.writerow([size, instr_time, proxy_time])

# analysis('results/matmul_init1.csv')
run('results/matmul_exp1.csv')
run('results/matmul_exp2.csv')
run('results/matmul_exp3.csv')
