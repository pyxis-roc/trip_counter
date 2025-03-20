import ctypes

# Load the shared library
lib = ctypes.CDLL('./libmatmul.so')

# Define the function prototype
lib.matmul_compute_.argtypes = [
    ctypes.c_int, ctypes.c_int, 
    ctypes.POINTER(ctypes.c_int), ctypes.c_int, ctypes.c_int, 
    ctypes.c_int, ctypes.POINTER(ctypes.c_int), ctypes.c_int, ctypes.c_int, 
    ctypes.POINTER(ctypes.c_int), ctypes.c_int, ctypes.c_int
]
lib.matmul_compute_.restype = None

# Example values for the arguments (use your actual data)
M = 10
N = 10
T_matmul = (ctypes.c_int * (M * N))()  # allocate a matrix of size MxN
stride = 10
stride1 = 10
K = 10
A = (ctypes.c_int * (M * K))()  # allocate a matrix A of size MxK
stride2 = 10
stride3 = 10
B = (ctypes.c_int * (K * N))()  # allocate a matrix B of size KxN
stride4 = 10
stride5 = 10

# Call the C function
lib.matmul_compute_(
    M, N, T_matmul, stride, stride1, K, A, stride2, stride3, B, stride4, stride5
)

# You can now use the result stored in `T_matmul`
