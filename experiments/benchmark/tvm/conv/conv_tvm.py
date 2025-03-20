import tvm
from tvm import te, topi
import numpy as np
import time

# Define the filter parameters
# num_filter = 16           # Number of filters
# kernel_size = (3, 3)      # Kernel size
# stride = (1, 1)           # Stride
# padding = (1, 1)          # Padding


def get_conv_kernel(num_filter = 16, kernel_size = (3, 3), stride = (1, 1), padding = (1, 1)):

    # Define the convolution parameters (symbolic for flexibility)
    batch = te.var("batch")  # Batch size (symbolic)
    in_channel = te.var("in_channel")  # Input channels (symbolic)
    in_height = te.var("in_height")  # Input height (symbolic)
    in_width = te.var("in_width")  # Input width (symbolic)

    # Input tensor placeholder with symbolic dimensions
    X = te.placeholder((batch, in_channel, in_height, in_width), name="X")
    # Filter tensor placeholder
    W = te.placeholder((num_filter, in_channel, kernel_size[0], kernel_size[1]), name="W")

    # Use TVM's built-in conv2d function to define the convolution
    Y = topi.nn.conv2d(
        X,
        W,
        strides=stride,
        padding=padding,
        dilation=(1, 1),
        out_dtype="float32"
    )

    # Create a schedule for the computation
    s = te.create_schedule(Y.op)

    # Apply optimizations (optional)
    # For example, we can apply parallelization or tiling if needed.

    # Compile the function
    target = "llvm"
    f = tvm.build(s, [X, W, Y], target=target)

    return f


def run_conv_module(
        conv:tvm.runtime.module, 
        num_filter = 16, 
        kernel_size = (3, 3), 
        batch_size = 1,
        in_channels = 3,
        in_height_val = 10000,
        in_width_val = 10000
    ):

    input_data = np.random.uniform(-1, 1, (batch_size, in_channels, in_height_val, in_width_val)).astype("float32")
    filter_data = np.random.uniform(-1, 1, (num_filter, in_channels, kernel_size[0], kernel_size[1])).astype("float32")

    # Create TVM NDArray from numpy arrays
    tvm_input = tvm.nd.array(input_data)
    tvm_filter = tvm.nd.array(filter_data)
    tvm_output = tvm.nd.empty((batch_size, num_filter, in_height_val, in_width_val))

    # Run the function
    conv(tvm_input, tvm_filter, tvm_output)


def run_conv_lib(
        conv_ir:str,
        num_filter = 16,
        kernel_size = (3, 3),
        batch_size = 1,
        in_channels = 3,
        in_height_val = 10000,
        in_width_val = 10000
    ):
    # Load the LLVM IR into a TVM module
    conv = tvm.runtime.load_module(conv_ir)

    start_time = time.time()
    try:
        # Run the module
        run_conv_module(
            conv,
            num_filter,
            kernel_size,
            batch_size,
            in_channels,
            in_height_val,
            in_width_val
        )
    except:
        pass
    end_time = time.time()

    return end_time - start_time


def get_llvm_ir(conv:tvm.runtime.module, filename:str = "conv_tvm.ll"):
    with open(filename, "w") as f_out:
        f_out.write(conv.get_source())


# conv = get_conv_kernel()
# get_llvm_ir(conv, "tvm_conv2d_kernel.ll")

if __name__ == "__main__":
    run_conv_lib("./conv_tvm_proxy.so")