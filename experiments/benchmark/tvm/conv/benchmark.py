from conv_tvm import run_conv_lib
import csv
import time
import subprocess

def analysis(store = 'results/conv_init.csv'):
    compile_plain = 'clang++ -O0 conv_tvm.ll -shared -o conv_tvm_plain'
    compile_instr = 'clang++ -O0 -fprofile-generate=instr.prof conv_tvm.ll -shared -o conv_tvm_instr.so'
    compile_proxy = 'clang++ -O0 conv_tvm_proxy.ll -shared -o conv_tvm_proxy.so'

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


def run(store = 'results/conv.csv'):
    pool = [64,128,256,512,1024,2048,4096,8192]
    with open(store, mode='w') as file:
        writer = csv.writer(file)
        writer.writerow(['size', 'instr_exec_time', 'proxy_exec_time'])
        for size in pool:
            num_filter = 16
            kernel_size = (3, 3) 
            batch_size = 1
            in_channels = 3
            in_height_val = size
            in_width_val = size

            instr_time = run_conv_lib(
                "./conv_tvm_instr.so",
                num_filter,
                kernel_size,
                batch_size,
                in_channels,
                in_height_val,
                in_width_val
                )

            proxy_time = run_conv_lib(
                "./conv_tvm_proxy.so",
                num_filter,
                kernel_size,
                batch_size,
                in_channels,
                in_height_val,
                in_width_val
                )
            writer.writerow([size, instr_time, proxy_time])

analysis('results/conv_init1.csv')
# run('results/conv_exp1.csv')
# run('results/conv_exp2.csv')
# run('results/conv_exp3.csv')
