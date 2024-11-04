from tvm.script import ir as I
from tvm.script import tir as T

@I.ir_module
class Module:
    @T.prim_func
    def main(X: T.handle, W: T.handle, conv2d_nchw: T.handle):
        T.func_attr({"from_legacy_te_schedule": T.bool(True), "tir.noalias": T.bool(True)})
        batch, in_channel, in_height, in_width = T.int32(), T.int32(), T.int32(), T.int32()
        X_1 = T.match_buffer(X, (batch, in_channel, in_height, in_width), strides=("stride", "stride", "stride", "stride"), buffer_type="auto")
        W_1 = T.match_buffer(W, (16, in_channel, 3, 3), strides=("stride", "stride", "stride", "stride"), buffer_type="auto")
        conv2d_nchw_1 = T.match_buffer(conv2d_nchw, (batch, 16, in_height, in_width), strides=("stride", "stride", "stride", "stride"), buffer_type="auto")
        pad_temp = T.allocate([batch * in_channel * (in_height + 2) * (in_width + 2)], "float32", "global")
        pad_temp_1 = T.Buffer((batch * in_channel * (in_height + 2) * (in_width + 2),), data=pad_temp)
        for i0, i1, i2, i3 in T.grid(batch, in_channel, in_height + 2, in_width + 2):
            X_2 = T.Buffer((X_1.strides[0] * batch,), data=X_1.data, buffer_type="auto")
            pad_temp_1[((i0 * in_channel + i1) * (in_height + 2) + i2) * (in_width + 2) + i3] = T.if_then_else(1 <= i2 and i2 <= in_height and 1 <= i3 and i3 <= in_width, X_2[i0 * X_1.strides[0] + i1 * X_1.strides[1] + (i2 - 1) * X_1.strides[2] + (i3 - 1) * X_1.strides[3]], T.float32(0.0))
        for nn, ff, yy, xx in T.grid(batch, 16, in_height, in_width):
            conv2d_nchw_2 = T.Buffer((conv2d_nchw_1.strides[0] * batch,), data=conv2d_nchw_1.data, buffer_type="auto")
            conv2d_nchw_2[nn * conv2d_nchw_1.strides[0] + ff * conv2d_nchw_1.strides[1] + yy * conv2d_nchw_1.strides[2] + xx * conv2d_nchw_1.strides[3]] = T.float32(0.0)
            for rc, ry, rx in T.grid(in_channel, 3, 3):
                W_2 = T.Buffer((W_1.strides[0] * 16,), data=W_1.data, buffer_type="auto")
                conv2d_nchw_2[nn * conv2d_nchw_1.strides[0] + ff * conv2d_nchw_1.strides[1] + yy * conv2d_nchw_1.strides[2] + xx * conv2d_nchw_1.strides[3]] = conv2d_nchw_2[nn * conv2d_nchw_1.strides[0] + ff * conv2d_nchw_1.strides[1] + yy * conv2d_nchw_1.strides[2] + xx * conv2d_nchw_1.strides[3]] + pad_temp_1[((nn * in_channel + rc) * (in_height + 2) + yy + ry) * (in_width + 2) + xx + rx] * W_2[ff * W_1.strides[0] + rc * W_1.strides[1] + ry * W_1.strides[2] + rx * W_1.strides[3]]