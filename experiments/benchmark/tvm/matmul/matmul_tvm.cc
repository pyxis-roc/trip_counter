// this file contains the function signatures of trioton matmul compute kernel
#include <cstdint>

extern "C"{ 
    void matmul_compute_(
        int32_t M, 
        int32_t N, 
        float* T_matmul, 
        int32_t stride, 
        int32_t stride1, 
        int32_t K, 
        const float* A, 
        int32_t stride2, 
        int32_t stride3, 
        const float* B, 
        int32_t stride4, 
        int32_t stride5
    );
}

#include <cstdlib>
#include <cstring>
#include <cstdint>
#include <cstdio>

using namespace std;

void* aligned_alloc(size_t alignment, size_t size) noexcept {
    void* ptr = nullptr;
    if (posix_memalign(&ptr, alignment, size) != 0) {
        return nullptr;
    }
    return ptr;
}

int main() {
    // Parameters
    int M = 10;
    int N = 10;
    int K = 10;

    // Strides (assuming contiguous layout for simplicity)
    int stride = N;
    int stride1 = 1;
    int stride2 = K;
    int stride3 = 1;
    int stride4 = N;
    int stride5 = 1;

    // Allocate memory for the input matrices
    float* A = (float*)aligned_alloc(64, M * K * sizeof(float));
    float* B = (float*)aligned_alloc(64, K * N * sizeof(float));
    float* T_matmul = (float*)aligned_alloc(64, M * N * sizeof(float));

    // Initialize input matrices
    for (int i = 0; i < M * K ; i++) {
        A[i] = 1;
    }
    for (int i = 0; i < K * N; i++) {
        B[i] = 1;
    }
    for(int i = 0; i < M * N; i++) {
        T_matmul[i] = 0;
    }

    // Compute matmul
    matmul_compute_(M, N, T_matmul, stride, stride1, K, A, stride2, stride3, B, stride4, stride5);

    // for (int i = 0; i < M * K; i++) {
    //     printf("%f", A[i]);
    // }
    // for (int i = 0; i < K * N; i++) {
    //     printf("%f", B[i]);
    // }
    // for(int i = 0; i < M * N; i++) {
    //     printf("%f ", T_matmul[i]);
    // }
    // Free memory
    free(A);
    free(B);
    free(T_matmul);

    return 0;
}
