import tvm
from tvm import te, topi
import numpy as np
import time

def run_matmul_module(
        matmul:tvm.runtime.module,
        M = 1000,
        K = 1000,
        N = 1000
    ):

    A = np.random.uniform(-1, 1, (M, K)).astype("float32")
    B = np.random.uniform(-1, 1, (K, N)).astype("float32")
    C = np.random.uniform(-1, 1, (M, N)).astype("float32")

    # Create TVM NDArray from numpy arrays
    tvm_A = tvm.nd.array(A)
    tvm_B = tvm.nd.array(B)
    tvm_C = tvm.nd.array(C)

    # Run the function
    matmul(tvm_A, tvm_B, tvm_C)

def run_matmul_lib(
        matmul_ir:str,
        M = 1000,
        K = 1000,
        N = 1000
    ):
    # Load the LLVM IR into a TVM module
    matmul = tvm.runtime.load_module(matmul_ir)

    start_time = time.time()
    try:
        # Run the module
        run_matmul_module(
            matmul,
            M,
            K,
            N
        )
    except:
        pass
    end_time = time.time()

    return end_time - start_time

if __name__ == "__main__":

    for size in range(100, 1100, 100):
        plain_time = run_matmul_lib("matmul_tvm_plain.so", size, size, size)
        print(f"Size {size}x{size}x{size} - Plain Execution time: {plain_time * 1000:.2f} ms")
        pgo_time = run_matmul_lib("matmul_tvm.so", size, size, size)
        print(f"Size {size}x{size}x{size} - PGO Execution time: {pgo_time * 1000:.2f} ms")