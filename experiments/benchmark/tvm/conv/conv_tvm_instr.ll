; ModuleID = 'tvm_conv2d_kernel.ll'
source_filename = "TVMMod"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-i128:128-f80:128-n8:16:32:64-S128"
target triple = "x86_64-unknown-linux-gnu"

$__llvm_profile_raw_version = comdat any

@__TVMAPISetLastError = linkonce dllexport local_unnamed_addr global ptr null, align 8
@.str = private constant [67 x i8] c"Assert fail: num_args == 3, default_function: num_args should be 3\00", align 1
@.str.1 = private constant [85 x i8] c"Assert fail: not T.isnullptr(args), default_function: TVMValue* arg pointer was NULL\00", align 1
@.str.2 = private constant [87 x i8] c"Assert fail: not T.isnullptr(arg_type_ids), default_function: int* type_codes was NULL\00", align 1
@.str.3 = private constant [118 x i8] c"Assert fail: X_code == 3 or X_code == 13 or X_code == 7 or X_code == 4, default_function: Expect arg[0] to be pointer\00", align 1
@.str.4 = private constant [118 x i8] c"Assert fail: W_code == 3 or W_code == 13 or W_code == 7 or W_code == 4, default_function: Expect arg[1] to be pointer\00", align 1
@.str.5 = private constant [158 x i8] c"Assert fail: conv2d_nchw_code == 3 or conv2d_nchw_code == 13 or conv2d_nchw_code == 7 or conv2d_nchw_code == 4, default_function: Expect arg[2] to be pointer\00", align 1
@.str.6 = private constant [99 x i8] c"Assert fail: not T.isnullptr(X), default_function.X is expected to have non-NULL DLTensor* pointer\00", align 1
@.str.7 = private constant [101 x i8] c"Assert fail: 4 == T.tvm_struct_get(X, 0, 4, \22int32\22), default_function.X.ndim is expected to equal 4\00", align 1
@.str.8 = private constant [99 x i8] c"Assert fail: not T.isnullptr(W), default_function.W is expected to have non-NULL DLTensor* pointer\00", align 1
@.str.9 = private constant [101 x i8] c"Assert fail: 4 == T.tvm_struct_get(W, 0, 4, \22int32\22), default_function.W.ndim is expected to equal 4\00", align 1
@.str.10 = private constant [119 x i8] c"Assert fail: not T.isnullptr(conv2d_nchw), default_function.conv2d_nchw is expected to have non-NULL DLTensor* pointer\00", align 1
@.str.11 = private constant [121 x i8] c"Assert fail: 4 == T.tvm_struct_get(conv2d_nchw, 0, 4, \22int32\22), default_function.conv2d_nchw.ndim is expected to equal 4\00", align 1
@.str.12 = private constant [223 x i8] c"Assert fail: T.tvm_struct_get(X, 0, 5, \22uint8\22) == T.uint8(2) and T.tvm_struct_get(X, 0, 6, \22uint8\22) == T.uint8(32) and T.tvm_struct_get(X, 0, 7, \22uint16\22) == T.uint16(1), default_function.X.dtype is expected to be float32\00", align 1
@.str.13 = private constant [187 x i8] c"Assert fail: T.uint64(0) == T.tvm_struct_get(X, 0, 8, \22uint64\22), Argument default_function.X.byte_offset has an unsatisfied constraint: T.uint64(0) == T.tvm_struct_get(X, 0, 8, \22uint64\22)\00", align 1
@.str.14 = private constant [167 x i8] c"Assert fail: T.tvm_struct_get(X, 0, 10, \22int32\22) == 1, Argument default_function.X.device_type has an unsatisfied constraint: 1 == T.tvm_struct_get(X, 0, 10, \22int32\22)\00", align 1
@.str.15 = private constant [144 x i8] c"Assert fail: batch * in_channel * in_height * in_width == 0 or not T.isnullptr(X), default_function.X is expected to have non-NULL data pointer\00", align 1
@.str.16 = private constant [223 x i8] c"Assert fail: T.tvm_struct_get(W, 0, 5, \22uint8\22) == T.uint8(2) and T.tvm_struct_get(W, 0, 6, \22uint8\22) == T.uint8(32) and T.tvm_struct_get(W, 0, 7, \22uint16\22) == T.uint16(1), default_function.W.dtype is expected to be float32\00", align 1
@.str.17 = private constant [184 x i8] c"Assert fail: T.Cast(\22int32\22, default_function_W_shape[0]) == 16, Argument default_function.W.shape[0] has an unsatisfied constraint: 16 == T.Cast(\22int32\22, default_function_W_shape[0])\00", align 1
@.str.18 = private constant [200 x i8] c"Assert fail: in_channel == T.Cast(\22int32\22, default_function_W_shape[1]), Argument default_function.W.shape[1] has an unsatisfied constraint: in_channel == T.Cast(\22int32\22, default_function_W_shape[1])\00", align 1
@.str.19 = private constant [182 x i8] c"Assert fail: T.Cast(\22int32\22, default_function_W_shape[2]) == 3, Argument default_function.W.shape[2] has an unsatisfied constraint: 3 == T.Cast(\22int32\22, default_function_W_shape[2])\00", align 1
@.str.20 = private constant [182 x i8] c"Assert fail: T.Cast(\22int32\22, default_function_W_shape[3]) == 3, Argument default_function.W.shape[3] has an unsatisfied constraint: 3 == T.Cast(\22int32\22, default_function_W_shape[3])\00", align 1
@.str.21 = private constant [187 x i8] c"Assert fail: T.uint64(0) == T.tvm_struct_get(W, 0, 8, \22uint64\22), Argument default_function.W.byte_offset has an unsatisfied constraint: T.uint64(0) == T.tvm_struct_get(W, 0, 8, \22uint64\22)\00", align 1
@.str.22 = private constant [167 x i8] c"Assert fail: T.tvm_struct_get(W, 0, 10, \22int32\22) == 1, Argument default_function.W.device_type has an unsatisfied constraint: 1 == T.tvm_struct_get(W, 0, 10, \22int32\22)\00", align 1
@.str.23 = private constant [173 x i8] c"Assert fail: dev_id == T.tvm_struct_get(W, 0, 9, \22int32\22), Argument default_function.W.device_id has an unsatisfied constraint: dev_id == T.tvm_struct_get(W, 0, 9, \22int32\22)\00", align 1
@.str.24 = private constant [126 x i8] c"Assert fail: 16 * in_channel * 3 * 3 == 0 or not T.isnullptr(W), default_function.W is expected to have non-NULL data pointer\00", align 1
@.str.25 = private constant [263 x i8] c"Assert fail: T.tvm_struct_get(conv2d_nchw, 0, 5, \22uint8\22) == T.uint8(2) and T.tvm_struct_get(conv2d_nchw, 0, 6, \22uint8\22) == T.uint8(32) and T.tvm_struct_get(conv2d_nchw, 0, 7, \22uint16\22) == T.uint16(1), default_function.conv2d_nchw.dtype is expected to be float32\00", align 1
@.str.26 = private constant [220 x i8] c"Assert fail: batch == T.Cast(\22int32\22, default_function_conv2d_nchw_shape[0]), Argument default_function.conv2d_nchw.shape[0] has an unsatisfied constraint: batch == T.Cast(\22int32\22, default_function_conv2d_nchw_shape[0])\00", align 1
@.str.27 = private constant [214 x i8] c"Assert fail: T.Cast(\22int32\22, default_function_conv2d_nchw_shape[1]) == 16, Argument default_function.conv2d_nchw.shape[1] has an unsatisfied constraint: 16 == T.Cast(\22int32\22, default_function_conv2d_nchw_shape[1])\00", align 1
@.str.28 = private constant [228 x i8] c"Assert fail: in_height == T.Cast(\22int32\22, default_function_conv2d_nchw_shape[2]), Argument default_function.conv2d_nchw.shape[2] has an unsatisfied constraint: in_height == T.Cast(\22int32\22, default_function_conv2d_nchw_shape[2])\00", align 1
@.str.29 = private constant [226 x i8] c"Assert fail: in_width == T.Cast(\22int32\22, default_function_conv2d_nchw_shape[3]), Argument default_function.conv2d_nchw.shape[3] has an unsatisfied constraint: in_width == T.Cast(\22int32\22, default_function_conv2d_nchw_shape[3])\00", align 1
@.str.30 = private constant [217 x i8] c"Assert fail: T.uint64(0) == T.tvm_struct_get(conv2d_nchw, 0, 8, \22uint64\22), Argument default_function.conv2d_nchw.byte_offset has an unsatisfied constraint: T.uint64(0) == T.tvm_struct_get(conv2d_nchw, 0, 8, \22uint64\22)\00", align 1
@.str.31 = private constant [197 x i8] c"Assert fail: T.tvm_struct_get(conv2d_nchw, 0, 10, \22int32\22) == 1, Argument default_function.conv2d_nchw.device_type has an unsatisfied constraint: 1 == T.tvm_struct_get(conv2d_nchw, 0, 10, \22int32\22)\00", align 1
@.str.32 = private constant [203 x i8] c"Assert fail: dev_id == T.tvm_struct_get(conv2d_nchw, 0, 9, \22int32\22), Argument default_function.conv2d_nchw.device_id has an unsatisfied constraint: dev_id == T.tvm_struct_get(conv2d_nchw, 0, 9, \22int32\22)\00", align 1
@.str.33 = private constant [156 x i8] c"Assert fail: batch * 16 * in_height * in_width == 0 or not T.isnullptr(conv2d_nchw), default_function.conv2d_nchw is expected to have non-NULL data pointer\00", align 1
@__TVMBackendAllocWorkspace = linkonce dllexport local_unnamed_addr global ptr null, align 8
@__TVMBackendFreeWorkspace = linkonce dllexport local_unnamed_addr global ptr null, align 8
@__tvm_main__ = weak dllexport local_unnamed_addr constant [17 x i8] c"default_function\00", align 1
@llvm.global_ctors = appending global [0 x { i32, ptr, ptr }] zeroinitializer
@__llvm_profile_raw_version = hidden constant i64 72057594037927946, comdat
@__profn_default_function = private constant [16 x i8] c"default_function"
@__profn_TVMMod_default_function_compute_ = private constant [32 x i8] c"TVMMod;default_function_compute_"
@__profn___truncsfhf2 = weak hidden constant [12 x i8] c"__truncsfhf2"
@__profn___extendhfsf2 = weak hidden constant [13 x i8] c"__extendhfsf2"

define dllexport range(i32 -1, 1) i32 @default_function(ptr noalias readonly %args, ptr noalias readonly %arg_type_ids, i32 %num_args, ptr noalias nocapture readnone %out_ret_value, ptr noalias nocapture readnone %out_ret_tcode, ptr noalias nocapture readnone %resource_handle) local_unnamed_addr #0 !dbg !5 {
entry:
    #dbg_value(ptr %args, !12, !DIExpression(), !18)
    #dbg_value(ptr %arg_type_ids, !13, !DIExpression(), !18)
    #dbg_value(i32 %num_args, !14, !DIExpression(), !18)
    #dbg_value(ptr %out_ret_value, !15, !DIExpression(), !18)
    #dbg_value(ptr %out_ret_tcode, !16, !DIExpression(), !18)
    #dbg_value(ptr %resource_handle, !17, !DIExpression(), !18)
  %0 = icmp eq i32 %num_args, 3, !dbg !18
  br i1 %0, label %assert_end, label %assert_fail, !dbg !18, !prof !19

common.ret:                                       ; preds = %assert_end151, %assert_fail150, %assert_fail148, %assert_fail146, %assert_fail144, %assert_fail142, %assert_fail140, %assert_fail138, %assert_fail136, %assert_fail134, %assert_fail132, %assert_fail130, %assert_fail128, %assert_fail126, %assert_fail124, %assert_fail122, %assert_fail120, %assert_fail118, %assert_fail116, %assert_fail114, %assert_fail112, %assert_fail110, %assert_fail108, %assert_fail75, %assert_fail73, %assert_fail46, %assert_fail44, %assert_fail13, %assert_fail11, %assert_fail9, %assert_fail7, %assert_fail5, %assert_fail3, %assert_fail1, %assert_fail
  %common.ret.op = phi i32 [ -1, %assert_fail ], [ -1, %assert_fail1 ], [ -1, %assert_fail3 ], [ -1, %assert_fail5 ], [ -1, %assert_fail7 ], [ -1, %assert_fail9 ], [ -1, %assert_fail11 ], [ -1, %assert_fail13 ], [ -1, %assert_fail44 ], [ -1, %assert_fail46 ], [ -1, %assert_fail73 ], [ -1, %assert_fail75 ], [ -1, %assert_fail108 ], [ -1, %assert_fail110 ], [ -1, %assert_fail112 ], [ -1, %assert_fail114 ], [ -1, %assert_fail116 ], [ -1, %assert_fail118 ], [ -1, %assert_fail120 ], [ -1, %assert_fail122 ], [ -1, %assert_fail124 ], [ -1, %assert_fail126 ], [ -1, %assert_fail128 ], [ -1, %assert_fail130 ], [ -1, %assert_fail132 ], [ -1, %assert_fail134 ], [ -1, %assert_fail136 ], [ -1, %assert_fail138 ], [ -1, %assert_fail140 ], [ -1, %assert_fail142 ], [ -1, %assert_fail144 ], [ -1, %assert_fail146 ], [ -1, %assert_fail148 ], [ -1, %assert_fail150 ], [ %255, %assert_end151 ]
  ret i32 %common.ret.op, !dbg !18

assert_fail:                                      ; preds = %entry
  call void @llvm.instrprof.increment(ptr @__profn_default_function, i64 1056841332866596056, i32 65, i32 31), !dbg !18
  %1 = load ptr, ptr @__TVMAPISetLastError, align 8, !dbg !18, !tbaa !20
  %2 = ptrtoint ptr %1 to i64, !dbg !18
  call void @llvm.instrprof.value.profile(ptr @__profn_default_function, i64 1056841332866596056, i64 %2, i32 0, i32 0), !dbg !18
  tail call void %1(ptr nonnull @.str), !dbg !18
  br label %common.ret, !dbg !18

assert_end:                                       ; preds = %entry
  %.not = icmp eq ptr %args, null, !dbg !18
  br i1 %.not, label %assert_fail1, label %assert_end2, !dbg !18, !prof !23

assert_fail1:                                     ; preds = %assert_end
  call void @llvm.instrprof.increment(ptr @__profn_default_function, i64 1056841332866596056, i32 65, i32 32), !dbg !18
  %3 = load ptr, ptr @__TVMAPISetLastError, align 8, !dbg !18, !tbaa !20
  %4 = ptrtoint ptr %3 to i64, !dbg !18
  call void @llvm.instrprof.value.profile(ptr @__profn_default_function, i64 1056841332866596056, i64 %4, i32 0, i32 1), !dbg !18
  tail call void %3(ptr nonnull @.str.1), !dbg !18
  br label %common.ret, !dbg !18

assert_end2:                                      ; preds = %assert_end
  %.not166 = icmp eq ptr %arg_type_ids, null, !dbg !18
  br i1 %.not166, label %assert_fail3, label %assert_end4, !dbg !18, !prof !23

assert_fail3:                                     ; preds = %assert_end2
  call void @llvm.instrprof.increment(ptr @__profn_default_function, i64 1056841332866596056, i32 65, i32 33), !dbg !18
  %5 = load ptr, ptr @__TVMAPISetLastError, align 8, !dbg !18, !tbaa !20
  %6 = ptrtoint ptr %5 to i64, !dbg !18
  call void @llvm.instrprof.value.profile(ptr @__profn_default_function, i64 1056841332866596056, i64 %6, i32 0, i32 2), !dbg !18
  tail call void %5(ptr nonnull @.str.2), !dbg !18
  br label %common.ret, !dbg !18

assert_end4:                                      ; preds = %assert_end2
  %X.code = load i32, ptr %arg_type_ids, align 4, !dbg !18, !tbaa !24
    #dbg_declare(i32 %X.code, !35, !DIExpression(), !18)
    #dbg_declare(i32 %X.code, !35, !DIExpression(), !18)
  switch i32 %X.code, label %assert_fail5 [
    i32 13, label %assert_end4.assert_end6_crit_edge
    i32 7, label %assert_end4.assert_end6_crit_edge1
    i32 4, label %assert_end4.assert_end6_crit_edge2
    i32 3, label %assert_end6
  ], !dbg !18

assert_end4.assert_end6_crit_edge2:               ; preds = %assert_end4
  call void @llvm.instrprof.increment(ptr @__profn_default_function, i64 1056841332866596056, i32 65, i32 2), !dbg !18
  br label %assert_end6, !dbg !18

assert_end4.assert_end6_crit_edge1:               ; preds = %assert_end4
  call void @llvm.instrprof.increment(ptr @__profn_default_function, i64 1056841332866596056, i32 65, i32 1), !dbg !18
  br label %assert_end6, !dbg !18

assert_end4.assert_end6_crit_edge:                ; preds = %assert_end4
  call void @llvm.instrprof.increment(ptr @__profn_default_function, i64 1056841332866596056, i32 65, i32 0), !dbg !18
  br label %assert_end6, !dbg !18

assert_fail5:                                     ; preds = %assert_end4
  call void @llvm.instrprof.increment(ptr @__profn_default_function, i64 1056841332866596056, i32 65, i32 13), !dbg !18
  %7 = load ptr, ptr @__TVMAPISetLastError, align 8, !dbg !18, !tbaa !20
  %8 = ptrtoint ptr %7 to i64, !dbg !18
  call void @llvm.instrprof.value.profile(ptr @__profn_default_function, i64 1056841332866596056, i64 %8, i32 0, i32 3), !dbg !18
  tail call void %7(ptr nonnull @.str.3), !dbg !18
  br label %common.ret, !dbg !18

assert_end6:                                      ; preds = %assert_end4.assert_end6_crit_edge2, %assert_end4.assert_end6_crit_edge1, %assert_end4.assert_end6_crit_edge, %assert_end4
  %9 = getelementptr inbounds i8, ptr %arg_type_ids, i64 4, !dbg !18
  %W.code = load i32, ptr %9, align 4, !dbg !18, !tbaa !36
    #dbg_declare(i32 %W.code, !38, !DIExpression(), !18)
    #dbg_declare(i32 %W.code, !38, !DIExpression(), !18)
  switch i32 %W.code, label %assert_fail7 [
    i32 13, label %assert_end6.assert_end8_crit_edge
    i32 7, label %assert_end6.assert_end8_crit_edge3
    i32 4, label %assert_end6.assert_end8_crit_edge4
    i32 3, label %assert_end8
  ], !dbg !18

assert_end6.assert_end8_crit_edge4:               ; preds = %assert_end6
  call void @llvm.instrprof.increment(ptr @__profn_default_function, i64 1056841332866596056, i32 65, i32 5), !dbg !18
  br label %assert_end8, !dbg !18

assert_end6.assert_end8_crit_edge3:               ; preds = %assert_end6
  call void @llvm.instrprof.increment(ptr @__profn_default_function, i64 1056841332866596056, i32 65, i32 4), !dbg !18
  br label %assert_end8, !dbg !18

assert_end6.assert_end8_crit_edge:                ; preds = %assert_end6
  call void @llvm.instrprof.increment(ptr @__profn_default_function, i64 1056841332866596056, i32 65, i32 3), !dbg !18
  br label %assert_end8, !dbg !18

assert_fail7:                                     ; preds = %assert_end6
  call void @llvm.instrprof.increment(ptr @__profn_default_function, i64 1056841332866596056, i32 65, i32 15), !dbg !18
  %10 = load ptr, ptr @__TVMAPISetLastError, align 8, !dbg !18, !tbaa !20
  %11 = ptrtoint ptr %10 to i64, !dbg !18
  call void @llvm.instrprof.value.profile(ptr @__profn_default_function, i64 1056841332866596056, i64 %11, i32 0, i32 4), !dbg !18
  tail call void %10(ptr nonnull @.str.4), !dbg !18
  br label %common.ret, !dbg !18

assert_end8:                                      ; preds = %assert_end6.assert_end8_crit_edge4, %assert_end6.assert_end8_crit_edge3, %assert_end6.assert_end8_crit_edge, %assert_end6
  %12 = getelementptr inbounds i8, ptr %arg_type_ids, i64 8, !dbg !18
  %conv2d_nchw.code = load i32, ptr %12, align 4, !dbg !18, !tbaa !39
    #dbg_declare(i32 %conv2d_nchw.code, !42, !DIExpression(), !18)
    #dbg_declare(i32 %conv2d_nchw.code, !42, !DIExpression(), !18)
  switch i32 %conv2d_nchw.code, label %assert_fail9 [
    i32 13, label %assert_end8.assert_end10_crit_edge
    i32 7, label %assert_end8.assert_end10_crit_edge5
    i32 4, label %assert_end8.assert_end10_crit_edge6
    i32 3, label %assert_end10
  ], !dbg !18

assert_end8.assert_end10_crit_edge6:              ; preds = %assert_end8
  call void @llvm.instrprof.increment(ptr @__profn_default_function, i64 1056841332866596056, i32 65, i32 8), !dbg !18
  br label %assert_end10, !dbg !18

assert_end8.assert_end10_crit_edge5:              ; preds = %assert_end8
  call void @llvm.instrprof.increment(ptr @__profn_default_function, i64 1056841332866596056, i32 65, i32 7), !dbg !18
  br label %assert_end10, !dbg !18

assert_end8.assert_end10_crit_edge:               ; preds = %assert_end8
  call void @llvm.instrprof.increment(ptr @__profn_default_function, i64 1056841332866596056, i32 65, i32 6), !dbg !18
  br label %assert_end10, !dbg !18

assert_fail9:                                     ; preds = %assert_end8
  call void @llvm.instrprof.increment(ptr @__profn_default_function, i64 1056841332866596056, i32 65, i32 24), !dbg !18
  %13 = load ptr, ptr @__TVMAPISetLastError, align 8, !dbg !18, !tbaa !20
  %14 = ptrtoint ptr %13 to i64, !dbg !18
  call void @llvm.instrprof.value.profile(ptr @__profn_default_function, i64 1056841332866596056, i64 %14, i32 0, i32 5), !dbg !18
  tail call void %13(ptr nonnull @.str.5), !dbg !18
  br label %common.ret, !dbg !18

assert_end10:                                     ; preds = %assert_end8.assert_end10_crit_edge6, %assert_end8.assert_end10_crit_edge5, %assert_end8.assert_end10_crit_edge, %assert_end8
  %X = load ptr, ptr %args, align 8, !dbg !18
    #dbg_declare(ptr %X, !43, !DIExpression(), !18)
    #dbg_declare(ptr %X, !43, !DIExpression(), !18)
  %15 = getelementptr inbounds i8, ptr %args, i64 8, !dbg !18
  %W = load ptr, ptr %15, align 8, !dbg !18
    #dbg_declare(ptr %W, !44, !DIExpression(), !18)
    #dbg_declare(ptr %W, !44, !DIExpression(), !18)
  %16 = getelementptr inbounds i8, ptr %args, i64 16, !dbg !18
  %conv2d_nchw = load ptr, ptr %16, align 8, !dbg !18
    #dbg_declare(ptr %conv2d_nchw, !45, !DIExpression(), !18)
    #dbg_declare(ptr %conv2d_nchw, !45, !DIExpression(), !18)
  %.not167 = icmp eq ptr %X, null, !dbg !18
  br i1 %.not167, label %assert_fail11, label %assert_end12, !dbg !18, !prof !23

assert_fail11:                                    ; preds = %assert_end10
  call void @llvm.instrprof.increment(ptr @__profn_default_function, i64 1056841332866596056, i32 65, i32 34), !dbg !18
  %17 = load ptr, ptr @__TVMAPISetLastError, align 8, !dbg !18, !tbaa !20
  %18 = ptrtoint ptr %17 to i64, !dbg !18
  call void @llvm.instrprof.value.profile(ptr @__profn_default_function, i64 1056841332866596056, i64 %18, i32 0, i32 6), !dbg !18
  tail call void %17(ptr nonnull @.str.6), !dbg !18
  br label %common.ret, !dbg !18

assert_end12:                                     ; preds = %assert_end10
  %19 = getelementptr inbounds i8, ptr %X, i64 16, !dbg !18
  %20 = load i32, ptr %19, align 4, !dbg !18
  %21 = icmp eq i32 %20, 4, !dbg !18
  br i1 %21, label %assert_end14, label %assert_fail13, !dbg !18, !prof !19

assert_fail13:                                    ; preds = %assert_end12
  call void @llvm.instrprof.increment(ptr @__profn_default_function, i64 1056841332866596056, i32 65, i32 35), !dbg !18
  %22 = load ptr, ptr @__TVMAPISetLastError, align 8, !dbg !18, !tbaa !20
  %23 = ptrtoint ptr %22 to i64, !dbg !18
  call void @llvm.instrprof.value.profile(ptr @__profn_default_function, i64 1056841332866596056, i64 %23, i32 0, i32 7), !dbg !18
  tail call void %22(ptr nonnull @.str.7), !dbg !18
  br label %common.ret, !dbg !18

assert_end14:                                     ; preds = %assert_end12
  %24 = getelementptr inbounds i8, ptr %X, i64 24, !dbg !18
  %default_function.X.shape = load ptr, ptr %24, align 8, !dbg !18
    #dbg_declare(ptr %default_function.X.shape, !46, !DIExpression(), !18)
    #dbg_declare(ptr %default_function.X.shape, !46, !DIExpression(), !18)
  %25 = load i64, ptr %default_function.X.shape, align 8, !dbg !18, !tbaa !49
  %batch = trunc i64 %25 to i32, !dbg !18
    #dbg_declare(i32 %batch, !59, !DIExpression(), !18)
    #dbg_declare(i32 %batch, !59, !DIExpression(), !18)
  %26 = getelementptr inbounds i8, ptr %default_function.X.shape, i64 8, !dbg !18
  %27 = load i64, ptr %26, align 8, !dbg !18, !tbaa !60
  %in_channel = trunc i64 %27 to i32, !dbg !18
    #dbg_declare(i32 %in_channel, !62, !DIExpression(), !18)
    #dbg_declare(i32 %in_channel, !62, !DIExpression(), !18)
  %28 = getelementptr inbounds i8, ptr %default_function.X.shape, i64 16, !dbg !18
  %29 = load i64, ptr %28, align 8, !dbg !18, !tbaa !63
  %in_height = trunc i64 %29 to i32, !dbg !18
    #dbg_declare(i32 %in_height, !66, !DIExpression(), !18)
    #dbg_declare(i32 %in_height, !66, !DIExpression(), !18)
  %30 = getelementptr inbounds i8, ptr %default_function.X.shape, i64 24, !dbg !18
  %31 = load i64, ptr %30, align 8, !dbg !18, !tbaa !67
  %in_width = trunc i64 %31 to i32, !dbg !18
    #dbg_declare(i32 %in_width, !69, !DIExpression(), !18)
    #dbg_declare(i32 %in_width, !69, !DIExpression(), !18)
  %32 = getelementptr inbounds i8, ptr %X, i64 32, !dbg !18
  %default_function.X.strides = load ptr, ptr %32, align 8, !dbg !18
    #dbg_declare(ptr %default_function.X.strides, !70, !DIExpression(), !18)
    #dbg_declare(ptr %default_function.X.strides, !70, !DIExpression(), !18)
  %33 = icmp eq i32 %in_width, 1, !dbg !18
  br i1 %33, label %if_end, label %if_else, !dbg !18

if_else:                                          ; preds = %assert_end14
  %34 = icmp eq ptr %default_function.X.strides, null, !dbg !18
  br i1 %34, label %if_end.thread, label %if_else16, !dbg !18

if_end:                                           ; preds = %if_else16, %assert_end14
  %stride = phi i32 [ 0, %assert_end14 ], [ %40, %if_else16 ], !dbg !18
    #dbg_declare(i32 %stride, !71, !DIExpression(), !18)
    #dbg_declare(i32 %stride, !71, !DIExpression(), !18)
  %35 = icmp eq i32 %in_height, 1, !dbg !18
  br i1 %35, label %if_end20, label %if_else19, !dbg !18

if_end.thread:                                    ; preds = %if_else
  call void @llvm.instrprof.increment(ptr @__profn_default_function, i64 1056841332866596056, i32 65, i32 27), !dbg !18
    #dbg_declare(i32 1, !71, !DIExpression(), !18)
    #dbg_declare(i32 1, !71, !DIExpression(), !18)
  %36 = icmp eq i32 %in_height, 1, !dbg !18
  %37 = zext i1 %36 to i64, !dbg !18
  call void @llvm.instrprof.increment.step(ptr @__profn_default_function, i64 1056841332866596056, i32 65, i32 62, i64 %37), !dbg !18
  %spec.select211 = select i1 %36, i32 0, i32 %in_width, !dbg !18
  br label %if_end20, !dbg !18

if_else16:                                        ; preds = %if_else
  call void @llvm.instrprof.increment(ptr @__profn_default_function, i64 1056841332866596056, i32 65, i32 16), !dbg !18
  %38 = getelementptr inbounds i8, ptr %default_function.X.strides, i64 24, !dbg !18
  %39 = load i64, ptr %38, align 8, !dbg !18, !tbaa !72
  %40 = trunc i64 %39 to i32, !dbg !18
  br label %if_end, !dbg !18

if_else19:                                        ; preds = %if_end
  call void @llvm.instrprof.increment(ptr @__profn_default_function, i64 1056841332866596056, i32 65, i32 10), !dbg !18
  %41 = icmp eq ptr %default_function.X.strides, null, !dbg !18
  br i1 %41, label %if_end20, label %if_else22, !dbg !18

if_end20:                                         ; preds = %if_else22, %if_else19, %if_end.thread, %if_end
  %42 = phi i1 [ true, %if_end ], [ false, %if_else22 ], [ false, %if_else19 ], [ %36, %if_end.thread ]
  %stride172 = phi i32 [ %stride, %if_end ], [ %stride, %if_else22 ], [ %stride, %if_else19 ], [ 1, %if_end.thread ]
  %stride155 = phi i32 [ 0, %if_end ], [ %46, %if_else22 ], [ %in_width, %if_else19 ], [ %spec.select211, %if_end.thread ], !dbg !18
    #dbg_declare(i32 %stride155, !71, !DIExpression(), !18)
    #dbg_declare(i32 %stride155, !71, !DIExpression(), !18)
  %43 = icmp eq i32 %in_channel, 1, !dbg !18
  br i1 %43, label %if_end28, label %if_else27, !dbg !18

if_else22:                                        ; preds = %if_else19
  call void @llvm.instrprof.increment(ptr @__profn_default_function, i64 1056841332866596056, i32 65, i32 20), !dbg !18
  %44 = getelementptr inbounds i8, ptr %default_function.X.strides, i64 16, !dbg !18
  %45 = load i64, ptr %44, align 8, !dbg !18, !tbaa !82
  %46 = trunc i64 %45 to i32, !dbg !18
  br label %if_end20, !dbg !18

if_else27:                                        ; preds = %if_end20
  %47 = icmp eq ptr %default_function.X.strides, null, !dbg !18
  br i1 %47, label %if_end28.thread, label %if_else30, !dbg !18

if_end28:                                         ; preds = %if_else30, %if_end20
  %stride154 = phi i32 [ 0, %if_end20 ], [ %53, %if_else30 ], !dbg !18
    #dbg_declare(i32 %stride154, !71, !DIExpression(), !18)
    #dbg_declare(i32 %stride154, !71, !DIExpression(), !18)
  %48 = icmp eq i32 %batch, 1, !dbg !18
  br i1 %48, label %if_end36, label %if_else35, !dbg !18

if_end28.thread:                                  ; preds = %if_else27
  call void @llvm.instrprof.increment(ptr @__profn_default_function, i64 1056841332866596056, i32 65, i32 28), !dbg !18
  %49 = mul nsw i32 %in_width, %in_height, !dbg !18
    #dbg_declare(i32 %49, !71, !DIExpression(), !18)
    #dbg_declare(i32 %49, !71, !DIExpression(), !18)
  %50 = icmp eq i32 %batch, 1, !dbg !18
  br i1 %50, label %if_end36, label %if_then37, !dbg !18

if_else30:                                        ; preds = %if_else27
  call void @llvm.instrprof.increment(ptr @__profn_default_function, i64 1056841332866596056, i32 65, i32 17), !dbg !18
  %51 = getelementptr inbounds i8, ptr %default_function.X.strides, i64 8, !dbg !18
  %52 = load i64, ptr %51, align 8, !dbg !18, !tbaa !84
  %53 = trunc i64 %52 to i32, !dbg !18
  br label %if_end28, !dbg !18

if_else35:                                        ; preds = %if_end28
  %54 = icmp eq ptr %default_function.X.strides, null, !dbg !18
  br i1 %54, label %if_else35.if_then37_crit_edge, label %if_else38, !dbg !18

if_else35.if_then37_crit_edge:                    ; preds = %if_else35
  call void @llvm.instrprof.increment(ptr @__profn_default_function, i64 1056841332866596056, i32 65, i32 30), !dbg !18
  %.pre = mul nsw i32 %in_width, %in_height, !dbg !18
  br label %if_then37, !dbg !18

if_end36:                                         ; preds = %if_else38, %if_then37, %if_end28.thread, %if_end28
  %55 = phi i1 [ true, %if_end28 ], [ false, %if_then37 ], [ false, %if_else38 ], [ true, %if_end28.thread ]
  %stride154176 = phi i32 [ %stride154, %if_end28 ], [ %stride154175178, %if_then37 ], [ %stride154, %if_else38 ], [ %49, %if_end28.thread ]
  %stride153 = phi i32 [ 0, %if_end28 ], [ %57, %if_then37 ], [ %59, %if_else38 ], [ 0, %if_end28.thread ], !dbg !18
    #dbg_declare(i32 %stride153, !71, !DIExpression(), !18)
    #dbg_declare(i32 %stride153, !71, !DIExpression(), !18)
  %56 = getelementptr inbounds i8, ptr %X, i64 12, !dbg !18
  %dev_id = load i32, ptr %56, align 4, !dbg !18
    #dbg_declare(i32 %dev_id, !87, !DIExpression(), !18)
    #dbg_declare(i32 %dev_id, !87, !DIExpression(), !18)
  %X152 = load ptr, ptr %X, align 8, !dbg !18
    #dbg_declare(ptr %X152, !88, !DIExpression(), !18)
    #dbg_declare(ptr %X152, !88, !DIExpression(), !18)
  call void @llvm.assume(i1 true) [ "align"(ptr %X152, i64 64) ], !dbg !18
  %.not168 = icmp eq ptr %W, null, !dbg !18
  br i1 %.not168, label %assert_fail44, label %assert_end45, !dbg !18, !prof !23

if_then37:                                        ; preds = %if_else35.if_then37_crit_edge, %if_end28.thread
  %.pre-phi = phi i32 [ %.pre, %if_else35.if_then37_crit_edge ], [ %49, %if_end28.thread ], !dbg !18
  %stride154175178 = phi i32 [ %stride154, %if_else35.if_then37_crit_edge ], [ %49, %if_end28.thread ]
  call void @llvm.instrprof.increment(ptr @__profn_default_function, i64 1056841332866596056, i32 65, i32 25), !dbg !18
  %57 = mul nsw i32 %.pre-phi, %in_channel, !dbg !18
  br label %if_end36, !dbg !18

if_else38:                                        ; preds = %if_else35
  call void @llvm.instrprof.increment(ptr @__profn_default_function, i64 1056841332866596056, i32 65, i32 21), !dbg !18
  %58 = load i64, ptr %default_function.X.strides, align 8, !dbg !18, !tbaa !91
  %59 = trunc i64 %58 to i32, !dbg !18
  br label %if_end36, !dbg !18

assert_fail44:                                    ; preds = %if_end36
  call void @llvm.instrprof.increment(ptr @__profn_default_function, i64 1056841332866596056, i32 65, i32 36), !dbg !18
  %60 = load ptr, ptr @__TVMAPISetLastError, align 8, !dbg !18, !tbaa !20
  %61 = ptrtoint ptr %60 to i64, !dbg !18
  call void @llvm.instrprof.value.profile(ptr @__profn_default_function, i64 1056841332866596056, i64 %61, i32 0, i32 8), !dbg !18
  tail call void %60(ptr nonnull @.str.8), !dbg !18
  br label %common.ret, !dbg !18

assert_end45:                                     ; preds = %if_end36
  %62 = getelementptr inbounds i8, ptr %W, i64 16, !dbg !18
  %63 = load i32, ptr %62, align 4, !dbg !18
  %64 = icmp eq i32 %63, 4, !dbg !18
  br i1 %64, label %assert_end47, label %assert_fail46, !dbg !18, !prof !19

assert_fail46:                                    ; preds = %assert_end45
  call void @llvm.instrprof.increment(ptr @__profn_default_function, i64 1056841332866596056, i32 65, i32 37), !dbg !18
  %65 = load ptr, ptr @__TVMAPISetLastError, align 8, !dbg !18, !tbaa !20
  %66 = ptrtoint ptr %65 to i64, !dbg !18
  call void @llvm.instrprof.value.profile(ptr @__profn_default_function, i64 1056841332866596056, i64 %66, i32 0, i32 9), !dbg !18
  tail call void %65(ptr nonnull @.str.9), !dbg !18
  br label %common.ret, !dbg !18

assert_end47:                                     ; preds = %assert_end45
  %67 = getelementptr inbounds i8, ptr %W, i64 24, !dbg !18
  %default_function.W.shape = load ptr, ptr %67, align 8, !dbg !18
    #dbg_declare(ptr %default_function.W.shape, !93, !DIExpression(), !18)
    #dbg_declare(ptr %default_function.W.shape, !93, !DIExpression(), !18)
  %68 = getelementptr inbounds i8, ptr %W, i64 32, !dbg !18
  %default_function.W.strides = load ptr, ptr %68, align 8, !dbg !18
    #dbg_declare(ptr %default_function.W.strides, !94, !DIExpression(), !18)
    #dbg_declare(ptr %default_function.W.strides, !94, !DIExpression(), !18)
  %69 = icmp eq ptr %default_function.W.strides, null, !dbg !18
  br i1 %69, label %if_then66, label %if_end55, !dbg !18

if_end55:                                         ; preds = %assert_end47
  %70 = getelementptr inbounds i8, ptr %default_function.W.strides, i64 24, !dbg !18
  %71 = load i64, ptr %70, align 8, !dbg !18, !tbaa !95
  %72 = trunc i64 %71 to i32, !dbg !18
    #dbg_declare(i32 %72, !71, !DIExpression(), !18)
    #dbg_declare(i32 %72, !71, !DIExpression(), !18)
  %73 = getelementptr inbounds i8, ptr %default_function.W.strides, i64 16, !dbg !18
  %74 = load i64, ptr %73, align 8, !dbg !18, !tbaa !105
  %75 = trunc i64 %74 to i32, !dbg !18
    #dbg_declare(i32 %75, !71, !DIExpression(), !18)
    #dbg_declare(i32 %75, !71, !DIExpression(), !18)
  br i1 %43, label %if_else67, label %if_else62, !dbg !18

if_else62:                                        ; preds = %if_end55
  call void @llvm.instrprof.increment(ptr @__profn_default_function, i64 1056841332866596056, i32 65, i32 18), !dbg !18
  %76 = getelementptr inbounds i8, ptr %default_function.W.strides, i64 8, !dbg !18
  %77 = load i64, ptr %76, align 8, !dbg !18, !tbaa !107
  %78 = trunc i64 %77 to i32, !dbg !18
  br label %if_else67, !dbg !18

if_then66:                                        ; preds = %assert_end47
  call void @llvm.instrprof.increment(ptr @__profn_default_function, i64 1056841332866596056, i32 65, i32 14), !dbg !18
    #dbg_declare(i32 1, !71, !DIExpression(), !18)
    #dbg_declare(i32 1, !71, !DIExpression(), !18)
    #dbg_declare(i32 3, !71, !DIExpression(), !18)
    #dbg_declare(i32 3, !71, !DIExpression(), !18)
  %79 = zext i1 %43 to i64, !dbg !18
  call void @llvm.instrprof.increment.step(ptr @__profn_default_function, i64 1056841332866596056, i32 65, i32 63, i64 %79), !dbg !18
  %.mux184 = select i1 %43, i32 0, i32 9, !dbg !18
    #dbg_declare(i32 %.mux184, !71, !DIExpression(), !18)
    #dbg_declare(i32 %.mux184, !71, !DIExpression(), !18)
  %80 = mul nsw i32 %in_channel, 9, !dbg !18
  br label %if_end68, !dbg !18

if_else67:                                        ; preds = %if_else62, %if_end55
  %stride163.ph = phi i32 [ %78, %if_else62 ], [ 0, %if_end55 ]
    #dbg_declare(i32 %stride163.ph, !71, !DIExpression(), !18)
    #dbg_declare(i32 %stride163.ph, !71, !DIExpression(), !18)
  %81 = load i64, ptr %default_function.W.strides, align 8, !dbg !18, !tbaa !110
  %82 = trunc i64 %81 to i32, !dbg !18
  br label %if_end68, !dbg !18

if_end68:                                         ; preds = %if_else67, %if_then66
  %stride163194 = phi i32 [ %.mux184, %if_then66 ], [ %stride163.ph, %if_else67 ]
  %stride165180185192 = phi i32 [ 1, %if_then66 ], [ %72, %if_else67 ]
  %stride164186190 = phi i32 [ 3, %if_then66 ], [ %75, %if_else67 ]
  %stride162 = phi i32 [ %80, %if_then66 ], [ %82, %if_else67 ], !dbg !18
    #dbg_declare(i32 %stride162, !71, !DIExpression(), !18)
    #dbg_declare(i32 %stride162, !71, !DIExpression(), !18)
  %W161 = load ptr, ptr %W, align 8, !dbg !18
    #dbg_declare(ptr %W161, !112, !DIExpression(), !18)
    #dbg_declare(ptr %W161, !112, !DIExpression(), !18)
  call void @llvm.assume(i1 true) [ "align"(ptr %W161, i64 64) ], !dbg !18
  %.not169 = icmp eq ptr %conv2d_nchw, null, !dbg !18
  br i1 %.not169, label %assert_fail73, label %assert_end74, !dbg !18, !prof !23

assert_fail73:                                    ; preds = %if_end68
  call void @llvm.instrprof.increment(ptr @__profn_default_function, i64 1056841332866596056, i32 65, i32 38), !dbg !18
  %83 = load ptr, ptr @__TVMAPISetLastError, align 8, !dbg !18, !tbaa !20
  %84 = ptrtoint ptr %83 to i64, !dbg !18
  call void @llvm.instrprof.value.profile(ptr @__profn_default_function, i64 1056841332866596056, i64 %84, i32 0, i32 10), !dbg !18
  tail call void %83(ptr nonnull @.str.10), !dbg !18
  br label %common.ret, !dbg !18

assert_end74:                                     ; preds = %if_end68
  %85 = getelementptr inbounds i8, ptr %conv2d_nchw, i64 16, !dbg !18
  %86 = load i32, ptr %85, align 4, !dbg !18
  %87 = icmp eq i32 %86, 4, !dbg !18
  br i1 %87, label %assert_end76, label %assert_fail75, !dbg !18, !prof !19

assert_fail75:                                    ; preds = %assert_end74
  call void @llvm.instrprof.increment(ptr @__profn_default_function, i64 1056841332866596056, i32 65, i32 39), !dbg !18
  %88 = load ptr, ptr @__TVMAPISetLastError, align 8, !dbg !18, !tbaa !20
  %89 = ptrtoint ptr %88 to i64, !dbg !18
  call void @llvm.instrprof.value.profile(ptr @__profn_default_function, i64 1056841332866596056, i64 %89, i32 0, i32 11), !dbg !18
  tail call void %88(ptr nonnull @.str.11), !dbg !18
  br label %common.ret, !dbg !18

assert_end76:                                     ; preds = %assert_end74
  %90 = getelementptr inbounds i8, ptr %conv2d_nchw, i64 24, !dbg !18
  %default_function.conv2d_nchw.shape = load ptr, ptr %90, align 8, !dbg !18
    #dbg_declare(ptr %default_function.conv2d_nchw.shape, !113, !DIExpression(), !18)
    #dbg_declare(ptr %default_function.conv2d_nchw.shape, !113, !DIExpression(), !18)
  %91 = getelementptr inbounds i8, ptr %conv2d_nchw, i64 32, !dbg !18
  %default_function.conv2d_nchw.strides = load ptr, ptr %91, align 8, !dbg !18
    #dbg_declare(ptr %default_function.conv2d_nchw.strides, !114, !DIExpression(), !18)
    #dbg_declare(ptr %default_function.conv2d_nchw.strides, !114, !DIExpression(), !18)
  br i1 %33, label %if_end79, label %if_else78, !dbg !18

if_else78:                                        ; preds = %assert_end76
  %92 = icmp eq ptr %default_function.conv2d_nchw.strides, null, !dbg !18
  br i1 %92, label %if_end79.thread, label %if_else81, !dbg !18

if_end79:                                         ; preds = %if_else81, %assert_end76
  %stride160 = phi i32 [ 0, %assert_end76 ], [ %97, %if_else81 ], !dbg !18
    #dbg_declare(i32 %stride160, !71, !DIExpression(), !18)
    #dbg_declare(i32 %stride160, !71, !DIExpression(), !18)
  %93 = icmp eq ptr %default_function.conv2d_nchw.strides, null, !dbg !18
  br i1 %42, label %if_end87, label %if_else86, !dbg !18

if_end79.thread:                                  ; preds = %if_else78
  call void @llvm.instrprof.increment(ptr @__profn_default_function, i64 1056841332866596056, i32 65, i32 29), !dbg !18
    #dbg_declare(i32 1, !71, !DIExpression(), !18)
    #dbg_declare(i32 1, !71, !DIExpression(), !18)
  %94 = zext i1 %42 to i64, !dbg !18
  call void @llvm.instrprof.increment.step(ptr @__profn_default_function, i64 1056841332866596056, i32 65, i32 64, i64 %94), !dbg !18
  %spec.select212 = select i1 %42, i32 0, i32 %in_width, !dbg !18
  br label %if_end95, !dbg !18

if_else81:                                        ; preds = %if_else78
  call void @llvm.instrprof.increment(ptr @__profn_default_function, i64 1056841332866596056, i32 65, i32 19), !dbg !18
  %95 = getelementptr inbounds i8, ptr %default_function.conv2d_nchw.strides, i64 24, !dbg !18
  %96 = load i64, ptr %95, align 8, !dbg !18, !tbaa !115
  %97 = trunc i64 %96 to i32, !dbg !18
  br label %if_end79, !dbg !18

if_else86:                                        ; preds = %if_end79
  call void @llvm.instrprof.increment(ptr @__profn_default_function, i64 1056841332866596056, i32 65, i32 12), !dbg !18
  br i1 %93, label %if_end95, label %if_end87.thread206, !dbg !18

if_end87:                                         ; preds = %if_end79
  call void @llvm.instrprof.increment(ptr @__profn_default_function, i64 1056841332866596056, i32 65, i32 11), !dbg !18
    #dbg_declare(i32 0, !71, !DIExpression(), !18)
    #dbg_declare(i32 0, !71, !DIExpression(), !18)
  br i1 %93, label %if_end87.if_end95_crit_edge, label %if_end95.thread, !dbg !18

if_end87.if_end95_crit_edge:                      ; preds = %if_end87
  call void @llvm.instrprof.increment(ptr @__profn_default_function, i64 1056841332866596056, i32 65, i32 9), !dbg !18
  br label %if_end95, !dbg !18

if_end87.thread206:                               ; preds = %if_else86
  call void @llvm.instrprof.increment(ptr @__profn_default_function, i64 1056841332866596056, i32 65, i32 22), !dbg !18
  %98 = getelementptr inbounds i8, ptr %default_function.conv2d_nchw.strides, i64 16, !dbg !18
  %99 = load i64, ptr %98, align 8, !dbg !18, !tbaa !125
  %100 = trunc i64 %99 to i32, !dbg !18
    #dbg_declare(i32 %100, !71, !DIExpression(), !18)
    #dbg_declare(i32 %100, !71, !DIExpression(), !18)
  br label %if_end95.thread, !dbg !18

if_end95:                                         ; preds = %if_end87.if_end95_crit_edge, %if_else86, %if_end79.thread
  %stride159205 = phi i32 [ 0, %if_end87.if_end95_crit_edge ], [ %in_width, %if_else86 ], [ %spec.select212, %if_end79.thread ]
  %stride160198203 = phi i32 [ %stride160, %if_end87.if_end95_crit_edge ], [ %stride160, %if_else86 ], [ 1, %if_end79.thread ]
  %101 = mul nsw i32 %in_width, %in_height, !dbg !18
    #dbg_declare(i32 %101, !71, !DIExpression(), !18)
    #dbg_declare(i32 %101, !71, !DIExpression(), !18)
  br i1 %55, label %if_end100, label %if_then101, !dbg !18

if_end95.thread:                                  ; preds = %if_end87.thread206, %if_end87
  %stride159210 = phi i32 [ %100, %if_end87.thread206 ], [ 0, %if_end87 ]
  %102 = getelementptr inbounds i8, ptr %default_function.conv2d_nchw.strides, i64 8, !dbg !18
  %103 = load i64, ptr %102, align 8, !dbg !18, !tbaa !127
  %104 = trunc i64 %103 to i32, !dbg !18
    #dbg_declare(i32 %104, !71, !DIExpression(), !18)
    #dbg_declare(i32 %104, !71, !DIExpression(), !18)
  br i1 %55, label %if_end100, label %if_else102, !dbg !18

if_end100:                                        ; preds = %if_else102, %if_then101, %if_end95.thread, %if_end95
  %stride158221 = phi i32 [ %101, %if_end95 ], [ %101, %if_then101 ], [ %104, %if_else102 ], [ %104, %if_end95.thread ]
  %stride160198202219 = phi i32 [ %stride160198203, %if_end95 ], [ %stride160198203, %if_then101 ], [ %stride160, %if_else102 ], [ %stride160, %if_end95.thread ]
  %stride159204217 = phi i32 [ %stride159205, %if_end95 ], [ %stride159205, %if_then101 ], [ %stride159210, %if_else102 ], [ %stride159210, %if_end95.thread ]
  %stride157 = phi i32 [ 0, %if_end95 ], [ %117, %if_then101 ], [ %119, %if_else102 ], [ 0, %if_end95.thread ], !dbg !18
    #dbg_declare(i32 %stride157, !71, !DIExpression(), !18)
    #dbg_declare(i32 %stride157, !71, !DIExpression(), !18)
  %conv2d_nchw156 = load ptr, ptr %conv2d_nchw, align 8, !dbg !18
    #dbg_declare(ptr %conv2d_nchw156, !130, !DIExpression(), !18)
    #dbg_declare(ptr %conv2d_nchw156, !130, !DIExpression(), !18)
  call void @llvm.assume(i1 true) [ "align"(ptr %conv2d_nchw156, i64 64) ], !dbg !18
  %105 = getelementptr inbounds i8, ptr %X, i64 22, !dbg !18
  %106 = load i16, ptr %105, align 2, !dbg !18
  %107 = icmp eq i16 %106, 1, !dbg !18
  %108 = getelementptr inbounds i8, ptr %X, i64 21, !dbg !18
  %109 = load i8, ptr %108, align 1, !dbg !18
  %110 = icmp eq i8 %109, 32, !dbg !18
  %111 = getelementptr inbounds i8, ptr %X, i64 20, !dbg !18
  %112 = load i8, ptr %111, align 1, !dbg !18
  %113 = icmp eq i8 %112, 2, !dbg !18
  %114 = and i1 %110, %113, !dbg !18
  %115 = and i1 %107, %114, !dbg !18
  br i1 %115, label %assert_end109, label %assert_fail108, !dbg !18, !prof !19

if_then101:                                       ; preds = %if_end95
  call void @llvm.instrprof.increment(ptr @__profn_default_function, i64 1056841332866596056, i32 65, i32 26), !dbg !18
  %116 = mul nsw i32 %in_width, %in_height, !dbg !18
  %117 = shl nsw i32 %116, 4, !dbg !18
  br label %if_end100, !dbg !18

if_else102:                                       ; preds = %if_end95.thread
  call void @llvm.instrprof.increment(ptr @__profn_default_function, i64 1056841332866596056, i32 65, i32 23), !dbg !18
  %118 = load i64, ptr %default_function.conv2d_nchw.strides, align 8, !dbg !18, !tbaa !131
  %119 = trunc i64 %118 to i32, !dbg !18
  br label %if_end100, !dbg !18

assert_fail108:                                   ; preds = %if_end100
  call void @llvm.instrprof.increment(ptr @__profn_default_function, i64 1056841332866596056, i32 65, i32 40), !dbg !18
  %120 = load ptr, ptr @__TVMAPISetLastError, align 8, !dbg !18, !tbaa !20
  %121 = ptrtoint ptr %120 to i64, !dbg !18
  call void @llvm.instrprof.value.profile(ptr @__profn_default_function, i64 1056841332866596056, i64 %121, i32 0, i32 12), !dbg !18
  tail call void %120(ptr nonnull @.str.12), !dbg !18
  br label %common.ret, !dbg !18

assert_end109:                                    ; preds = %if_end100
  %122 = getelementptr inbounds i8, ptr %X, i64 40, !dbg !18
  %123 = load i64, ptr %122, align 8, !dbg !18
  %124 = icmp eq i64 %123, 0, !dbg !18
  br i1 %124, label %assert_end111, label %assert_fail110, !dbg !18, !prof !19

assert_fail110:                                   ; preds = %assert_end109
  call void @llvm.instrprof.increment(ptr @__profn_default_function, i64 1056841332866596056, i32 65, i32 41), !dbg !18
  %125 = load ptr, ptr @__TVMAPISetLastError, align 8, !dbg !18, !tbaa !20
  %126 = ptrtoint ptr %125 to i64, !dbg !18
  call void @llvm.instrprof.value.profile(ptr @__profn_default_function, i64 1056841332866596056, i64 %126, i32 0, i32 13), !dbg !18
  tail call void %125(ptr nonnull @.str.13), !dbg !18
  br label %common.ret, !dbg !18

assert_end111:                                    ; preds = %assert_end109
  %127 = getelementptr inbounds i8, ptr %X, i64 8, !dbg !18
  %128 = load i32, ptr %127, align 4, !dbg !18
  %129 = icmp eq i32 %128, 1, !dbg !18
  br i1 %129, label %assert_end113, label %assert_fail112, !dbg !18, !prof !19

assert_fail112:                                   ; preds = %assert_end111
  call void @llvm.instrprof.increment(ptr @__profn_default_function, i64 1056841332866596056, i32 65, i32 42), !dbg !18
  %130 = load ptr, ptr @__TVMAPISetLastError, align 8, !dbg !18, !tbaa !20
  %131 = ptrtoint ptr %130 to i64, !dbg !18
  call void @llvm.instrprof.value.profile(ptr @__profn_default_function, i64 1056841332866596056, i64 %131, i32 0, i32 14), !dbg !18
  tail call void %130(ptr nonnull @.str.14), !dbg !18
  br label %common.ret, !dbg !18

assert_end113:                                    ; preds = %assert_end111
  %132 = icmp ne ptr %X152, null, !dbg !18
  %133 = mul i32 %in_width, %in_height, !dbg !18
  %134 = mul i32 %133, %batch, !dbg !18
  %135 = mul i32 %134, %in_channel, !dbg !18
  %136 = icmp eq i32 %135, 0, !dbg !18
  %137 = or i1 %136, %132, !dbg !18
  br i1 %137, label %assert_end115, label %assert_fail114, !dbg !18, !prof !19

assert_fail114:                                   ; preds = %assert_end113
  call void @llvm.instrprof.increment(ptr @__profn_default_function, i64 1056841332866596056, i32 65, i32 43), !dbg !18
  %138 = load ptr, ptr @__TVMAPISetLastError, align 8, !dbg !18, !tbaa !20
  %139 = ptrtoint ptr %138 to i64, !dbg !18
  call void @llvm.instrprof.value.profile(ptr @__profn_default_function, i64 1056841332866596056, i64 %139, i32 0, i32 15), !dbg !18
  tail call void %138(ptr nonnull @.str.15), !dbg !18
  br label %common.ret, !dbg !18

assert_end115:                                    ; preds = %assert_end113
  %140 = getelementptr inbounds i8, ptr %W, i64 22, !dbg !18
  %141 = load i16, ptr %140, align 2, !dbg !18
  %142 = icmp eq i16 %141, 1, !dbg !18
  %143 = getelementptr inbounds i8, ptr %W, i64 21, !dbg !18
  %144 = load i8, ptr %143, align 1, !dbg !18
  %145 = icmp eq i8 %144, 32, !dbg !18
  %146 = getelementptr inbounds i8, ptr %W, i64 20, !dbg !18
  %147 = load i8, ptr %146, align 1, !dbg !18
  %148 = icmp eq i8 %147, 2, !dbg !18
  %149 = and i1 %145, %148, !dbg !18
  %150 = and i1 %142, %149, !dbg !18
  br i1 %150, label %assert_end117, label %assert_fail116, !dbg !18, !prof !19

assert_fail116:                                   ; preds = %assert_end115
  call void @llvm.instrprof.increment(ptr @__profn_default_function, i64 1056841332866596056, i32 65, i32 44), !dbg !18
  %151 = load ptr, ptr @__TVMAPISetLastError, align 8, !dbg !18, !tbaa !20
  %152 = ptrtoint ptr %151 to i64, !dbg !18
  call void @llvm.instrprof.value.profile(ptr @__profn_default_function, i64 1056841332866596056, i64 %152, i32 0, i32 16), !dbg !18
  tail call void %151(ptr nonnull @.str.16), !dbg !18
  br label %common.ret, !dbg !18

assert_end117:                                    ; preds = %assert_end115
  %153 = load i64, ptr %default_function.W.shape, align 8, !dbg !18, !tbaa !133
  %154 = and i64 %153, 4294967295, !dbg !18
  %155 = icmp eq i64 %154, 16, !dbg !18
  br i1 %155, label %assert_end119, label %assert_fail118, !dbg !18, !prof !19

assert_fail118:                                   ; preds = %assert_end117
  call void @llvm.instrprof.increment(ptr @__profn_default_function, i64 1056841332866596056, i32 65, i32 45), !dbg !18
  %156 = load ptr, ptr @__TVMAPISetLastError, align 8, !dbg !18, !tbaa !20
  %157 = ptrtoint ptr %156 to i64, !dbg !18
  call void @llvm.instrprof.value.profile(ptr @__profn_default_function, i64 1056841332866596056, i64 %157, i32 0, i32 17), !dbg !18
  tail call void %156(ptr nonnull @.str.17), !dbg !18
  br label %common.ret, !dbg !18

assert_end119:                                    ; preds = %assert_end117
  %158 = getelementptr inbounds i8, ptr %default_function.W.shape, i64 8, !dbg !18
  %159 = load i64, ptr %158, align 8, !dbg !18, !tbaa !143
  %160 = trunc i64 %159 to i32, !dbg !18
  %161 = icmp eq i32 %in_channel, %160, !dbg !18
  br i1 %161, label %assert_end121, label %assert_fail120, !dbg !18, !prof !19

assert_fail120:                                   ; preds = %assert_end119
  call void @llvm.instrprof.increment(ptr @__profn_default_function, i64 1056841332866596056, i32 65, i32 46), !dbg !18
  %162 = load ptr, ptr @__TVMAPISetLastError, align 8, !dbg !18, !tbaa !20
  %163 = ptrtoint ptr %162 to i64, !dbg !18
  call void @llvm.instrprof.value.profile(ptr @__profn_default_function, i64 1056841332866596056, i64 %163, i32 0, i32 18), !dbg !18
  tail call void %162(ptr nonnull @.str.18), !dbg !18
  br label %common.ret, !dbg !18

assert_end121:                                    ; preds = %assert_end119
  %164 = getelementptr inbounds i8, ptr %default_function.W.shape, i64 16, !dbg !18
  %165 = load i64, ptr %164, align 8, !dbg !18, !tbaa !145
  %166 = and i64 %165, 4294967295, !dbg !18
  %167 = icmp eq i64 %166, 3, !dbg !18
  br i1 %167, label %assert_end123, label %assert_fail122, !dbg !18, !prof !19

assert_fail122:                                   ; preds = %assert_end121
  call void @llvm.instrprof.increment(ptr @__profn_default_function, i64 1056841332866596056, i32 65, i32 47), !dbg !18
  %168 = load ptr, ptr @__TVMAPISetLastError, align 8, !dbg !18, !tbaa !20
  %169 = ptrtoint ptr %168 to i64, !dbg !18
  call void @llvm.instrprof.value.profile(ptr @__profn_default_function, i64 1056841332866596056, i64 %169, i32 0, i32 19), !dbg !18
  tail call void %168(ptr nonnull @.str.19), !dbg !18
  br label %common.ret, !dbg !18

assert_end123:                                    ; preds = %assert_end121
  %170 = getelementptr inbounds i8, ptr %default_function.W.shape, i64 24, !dbg !18
  %171 = load i64, ptr %170, align 8, !dbg !18, !tbaa !148
  %172 = and i64 %171, 4294967295, !dbg !18
  %173 = icmp eq i64 %172, 3, !dbg !18
  br i1 %173, label %assert_end125, label %assert_fail124, !dbg !18, !prof !19

assert_fail124:                                   ; preds = %assert_end123
  call void @llvm.instrprof.increment(ptr @__profn_default_function, i64 1056841332866596056, i32 65, i32 48), !dbg !18
  %174 = load ptr, ptr @__TVMAPISetLastError, align 8, !dbg !18, !tbaa !20
  %175 = ptrtoint ptr %174 to i64, !dbg !18
  call void @llvm.instrprof.value.profile(ptr @__profn_default_function, i64 1056841332866596056, i64 %175, i32 0, i32 20), !dbg !18
  tail call void %174(ptr nonnull @.str.20), !dbg !18
  br label %common.ret, !dbg !18

assert_end125:                                    ; preds = %assert_end123
  %176 = getelementptr inbounds i8, ptr %W, i64 40, !dbg !18
  %177 = load i64, ptr %176, align 8, !dbg !18
  %178 = icmp eq i64 %177, 0, !dbg !18
  br i1 %178, label %assert_end127, label %assert_fail126, !dbg !18, !prof !19

assert_fail126:                                   ; preds = %assert_end125
  call void @llvm.instrprof.increment(ptr @__profn_default_function, i64 1056841332866596056, i32 65, i32 49), !dbg !18
  %179 = load ptr, ptr @__TVMAPISetLastError, align 8, !dbg !18, !tbaa !20
  %180 = ptrtoint ptr %179 to i64, !dbg !18
  call void @llvm.instrprof.value.profile(ptr @__profn_default_function, i64 1056841332866596056, i64 %180, i32 0, i32 21), !dbg !18
  tail call void %179(ptr nonnull @.str.21), !dbg !18
  br label %common.ret, !dbg !18

assert_end127:                                    ; preds = %assert_end125
  %181 = getelementptr inbounds i8, ptr %W, i64 8, !dbg !18
  %182 = load i32, ptr %181, align 4, !dbg !18
  %183 = icmp eq i32 %182, 1, !dbg !18
  br i1 %183, label %assert_end129, label %assert_fail128, !dbg !18, !prof !19

assert_fail128:                                   ; preds = %assert_end127
  call void @llvm.instrprof.increment(ptr @__profn_default_function, i64 1056841332866596056, i32 65, i32 50), !dbg !18
  %184 = load ptr, ptr @__TVMAPISetLastError, align 8, !dbg !18, !tbaa !20
  %185 = ptrtoint ptr %184 to i64, !dbg !18
  call void @llvm.instrprof.value.profile(ptr @__profn_default_function, i64 1056841332866596056, i64 %185, i32 0, i32 22), !dbg !18
  tail call void %184(ptr nonnull @.str.22), !dbg !18
  br label %common.ret, !dbg !18

assert_end129:                                    ; preds = %assert_end127
  %186 = getelementptr inbounds i8, ptr %W, i64 12, !dbg !18
  %187 = load i32, ptr %186, align 4, !dbg !18
  %188 = icmp eq i32 %dev_id, %187, !dbg !18
  br i1 %188, label %assert_end131, label %assert_fail130, !dbg !18, !prof !19

assert_fail130:                                   ; preds = %assert_end129
  call void @llvm.instrprof.increment(ptr @__profn_default_function, i64 1056841332866596056, i32 65, i32 51), !dbg !18
  %189 = load ptr, ptr @__TVMAPISetLastError, align 8, !dbg !18, !tbaa !20
  %190 = ptrtoint ptr %189 to i64, !dbg !18
  call void @llvm.instrprof.value.profile(ptr @__profn_default_function, i64 1056841332866596056, i64 %190, i32 0, i32 23), !dbg !18
  tail call void %189(ptr nonnull @.str.23), !dbg !18
  br label %common.ret, !dbg !18

assert_end131:                                    ; preds = %assert_end129
  %191 = icmp ne ptr %W161, null, !dbg !18
  %192 = mul i32 %in_channel, 144, !dbg !18
  %193 = icmp eq i32 %192, 0, !dbg !18
  %194 = or i1 %193, %191, !dbg !18
  br i1 %194, label %assert_end133, label %assert_fail132, !dbg !18, !prof !19

assert_fail132:                                   ; preds = %assert_end131
  call void @llvm.instrprof.increment(ptr @__profn_default_function, i64 1056841332866596056, i32 65, i32 52), !dbg !18
  %195 = load ptr, ptr @__TVMAPISetLastError, align 8, !dbg !18, !tbaa !20
  %196 = ptrtoint ptr %195 to i64, !dbg !18
  call void @llvm.instrprof.value.profile(ptr @__profn_default_function, i64 1056841332866596056, i64 %196, i32 0, i32 24), !dbg !18
  tail call void %195(ptr nonnull @.str.24), !dbg !18
  br label %common.ret, !dbg !18

assert_end133:                                    ; preds = %assert_end131
  %197 = getelementptr inbounds i8, ptr %conv2d_nchw, i64 22, !dbg !18
  %198 = load i16, ptr %197, align 2, !dbg !18
  %199 = icmp eq i16 %198, 1, !dbg !18
  %200 = getelementptr inbounds i8, ptr %conv2d_nchw, i64 21, !dbg !18
  %201 = load i8, ptr %200, align 1, !dbg !18
  %202 = icmp eq i8 %201, 32, !dbg !18
  %203 = getelementptr inbounds i8, ptr %conv2d_nchw, i64 20, !dbg !18
  %204 = load i8, ptr %203, align 1, !dbg !18
  %205 = icmp eq i8 %204, 2, !dbg !18
  %206 = and i1 %202, %205, !dbg !18
  %207 = and i1 %199, %206, !dbg !18
  br i1 %207, label %assert_end135, label %assert_fail134, !dbg !18, !prof !19

assert_fail134:                                   ; preds = %assert_end133
  call void @llvm.instrprof.increment(ptr @__profn_default_function, i64 1056841332866596056, i32 65, i32 53), !dbg !18
  %208 = load ptr, ptr @__TVMAPISetLastError, align 8, !dbg !18, !tbaa !20
  %209 = ptrtoint ptr %208 to i64, !dbg !18
  call void @llvm.instrprof.value.profile(ptr @__profn_default_function, i64 1056841332866596056, i64 %209, i32 0, i32 25), !dbg !18
  tail call void %208(ptr nonnull @.str.25), !dbg !18
  br label %common.ret, !dbg !18

assert_end135:                                    ; preds = %assert_end133
  %210 = load i64, ptr %default_function.conv2d_nchw.shape, align 8, !dbg !18, !tbaa !150
  %211 = trunc i64 %210 to i32, !dbg !18
  %212 = icmp eq i32 %batch, %211, !dbg !18
  br i1 %212, label %assert_end137, label %assert_fail136, !dbg !18, !prof !19

assert_fail136:                                   ; preds = %assert_end135
  call void @llvm.instrprof.increment(ptr @__profn_default_function, i64 1056841332866596056, i32 65, i32 54), !dbg !18
  %213 = load ptr, ptr @__TVMAPISetLastError, align 8, !dbg !18, !tbaa !20
  %214 = ptrtoint ptr %213 to i64, !dbg !18
  call void @llvm.instrprof.value.profile(ptr @__profn_default_function, i64 1056841332866596056, i64 %214, i32 0, i32 26), !dbg !18
  tail call void %213(ptr nonnull @.str.26), !dbg !18
  br label %common.ret, !dbg !18

assert_end137:                                    ; preds = %assert_end135
  %215 = getelementptr inbounds i8, ptr %default_function.conv2d_nchw.shape, i64 8, !dbg !18
  %216 = load i64, ptr %215, align 8, !dbg !18, !tbaa !160
  %217 = and i64 %216, 4294967295, !dbg !18
  %218 = icmp eq i64 %217, 16, !dbg !18
  br i1 %218, label %assert_end139, label %assert_fail138, !dbg !18, !prof !19

assert_fail138:                                   ; preds = %assert_end137
  call void @llvm.instrprof.increment(ptr @__profn_default_function, i64 1056841332866596056, i32 65, i32 55), !dbg !18
  %219 = load ptr, ptr @__TVMAPISetLastError, align 8, !dbg !18, !tbaa !20
  %220 = ptrtoint ptr %219 to i64, !dbg !18
  call void @llvm.instrprof.value.profile(ptr @__profn_default_function, i64 1056841332866596056, i64 %220, i32 0, i32 27), !dbg !18
  tail call void %219(ptr nonnull @.str.27), !dbg !18
  br label %common.ret, !dbg !18

assert_end139:                                    ; preds = %assert_end137
  %221 = getelementptr inbounds i8, ptr %default_function.conv2d_nchw.shape, i64 16, !dbg !18
  %222 = load i64, ptr %221, align 8, !dbg !18, !tbaa !162
  %223 = trunc i64 %222 to i32, !dbg !18
  %224 = icmp eq i32 %in_height, %223, !dbg !18
  br i1 %224, label %assert_end141, label %assert_fail140, !dbg !18, !prof !19

assert_fail140:                                   ; preds = %assert_end139
  call void @llvm.instrprof.increment(ptr @__profn_default_function, i64 1056841332866596056, i32 65, i32 56), !dbg !18
  %225 = load ptr, ptr @__TVMAPISetLastError, align 8, !dbg !18, !tbaa !20
  %226 = ptrtoint ptr %225 to i64, !dbg !18
  call void @llvm.instrprof.value.profile(ptr @__profn_default_function, i64 1056841332866596056, i64 %226, i32 0, i32 28), !dbg !18
  tail call void %225(ptr nonnull @.str.28), !dbg !18
  br label %common.ret, !dbg !18

assert_end141:                                    ; preds = %assert_end139
  %227 = getelementptr inbounds i8, ptr %default_function.conv2d_nchw.shape, i64 24, !dbg !18
  %228 = load i64, ptr %227, align 8, !dbg !18, !tbaa !165
  %229 = trunc i64 %228 to i32, !dbg !18
  %230 = icmp eq i32 %in_width, %229, !dbg !18
  br i1 %230, label %assert_end143, label %assert_fail142, !dbg !18, !prof !19

assert_fail142:                                   ; preds = %assert_end141
  call void @llvm.instrprof.increment(ptr @__profn_default_function, i64 1056841332866596056, i32 65, i32 57), !dbg !18
  %231 = load ptr, ptr @__TVMAPISetLastError, align 8, !dbg !18, !tbaa !20
  %232 = ptrtoint ptr %231 to i64, !dbg !18
  call void @llvm.instrprof.value.profile(ptr @__profn_default_function, i64 1056841332866596056, i64 %232, i32 0, i32 29), !dbg !18
  tail call void %231(ptr nonnull @.str.29), !dbg !18
  br label %common.ret, !dbg !18

assert_end143:                                    ; preds = %assert_end141
  %233 = getelementptr inbounds i8, ptr %conv2d_nchw, i64 40, !dbg !18
  %234 = load i64, ptr %233, align 8, !dbg !18
  %235 = icmp eq i64 %234, 0, !dbg !18
  br i1 %235, label %assert_end145, label %assert_fail144, !dbg !18, !prof !19

assert_fail144:                                   ; preds = %assert_end143
  call void @llvm.instrprof.increment(ptr @__profn_default_function, i64 1056841332866596056, i32 65, i32 58), !dbg !18
  %236 = load ptr, ptr @__TVMAPISetLastError, align 8, !dbg !18, !tbaa !20
  %237 = ptrtoint ptr %236 to i64, !dbg !18
  call void @llvm.instrprof.value.profile(ptr @__profn_default_function, i64 1056841332866596056, i64 %237, i32 0, i32 30), !dbg !18
  tail call void %236(ptr nonnull @.str.30), !dbg !18
  br label %common.ret, !dbg !18

assert_end145:                                    ; preds = %assert_end143
  %238 = getelementptr inbounds i8, ptr %conv2d_nchw, i64 8, !dbg !18
  %239 = load i32, ptr %238, align 4, !dbg !18
  %240 = icmp eq i32 %239, 1, !dbg !18
  br i1 %240, label %assert_end147, label %assert_fail146, !dbg !18, !prof !19

assert_fail146:                                   ; preds = %assert_end145
  call void @llvm.instrprof.increment(ptr @__profn_default_function, i64 1056841332866596056, i32 65, i32 59), !dbg !18
  %241 = load ptr, ptr @__TVMAPISetLastError, align 8, !dbg !18, !tbaa !20
  %242 = ptrtoint ptr %241 to i64, !dbg !18
  call void @llvm.instrprof.value.profile(ptr @__profn_default_function, i64 1056841332866596056, i64 %242, i32 0, i32 31), !dbg !18
  tail call void %241(ptr nonnull @.str.31), !dbg !18
  br label %common.ret, !dbg !18

assert_end147:                                    ; preds = %assert_end145
  %243 = getelementptr inbounds i8, ptr %conv2d_nchw, i64 12, !dbg !18
  %244 = load i32, ptr %243, align 4, !dbg !18
  %245 = icmp eq i32 %dev_id, %244, !dbg !18
  br i1 %245, label %assert_end149, label %assert_fail148, !dbg !18, !prof !19

assert_fail148:                                   ; preds = %assert_end147
  call void @llvm.instrprof.increment(ptr @__profn_default_function, i64 1056841332866596056, i32 65, i32 60), !dbg !18
  %246 = load ptr, ptr @__TVMAPISetLastError, align 8, !dbg !18, !tbaa !20
  %247 = ptrtoint ptr %246 to i64, !dbg !18
  call void @llvm.instrprof.value.profile(ptr @__profn_default_function, i64 1056841332866596056, i64 %247, i32 0, i32 32), !dbg !18
  tail call void %246(ptr nonnull @.str.32), !dbg !18
  br label %common.ret, !dbg !18

assert_end149:                                    ; preds = %assert_end147
  %248 = icmp ne ptr %conv2d_nchw156, null, !dbg !18
  %249 = shl i32 %133, 4, !dbg !18
  %250 = mul i32 %249, %batch, !dbg !18
  %251 = icmp eq i32 %250, 0, !dbg !18
  %252 = or i1 %251, %248, !dbg !18
  br i1 %252, label %assert_end151, label %assert_fail150, !dbg !18, !prof !19

assert_fail150:                                   ; preds = %assert_end149
  call void @llvm.instrprof.increment(ptr @__profn_default_function, i64 1056841332866596056, i32 65, i32 61), !dbg !18
  %253 = load ptr, ptr @__TVMAPISetLastError, align 8, !dbg !18, !tbaa !20
  %254 = ptrtoint ptr %253 to i64, !dbg !18
  call void @llvm.instrprof.value.profile(ptr @__profn_default_function, i64 1056841332866596056, i64 %254, i32 0, i32 33), !dbg !18
  tail call void %253(ptr nonnull @.str.33), !dbg !18
  br label %common.ret, !dbg !18

assert_end151:                                    ; preds = %assert_end149
  %255 = tail call fastcc i32 @default_function_compute_(i32 %dev_id, i32 %batch, i32 %in_channel, i32 %in_height, i32 %in_width, ptr %X152, i32 %stride153, i32 %stride154176, i32 %stride155, i32 %stride172, ptr %conv2d_nchw156, i32 %stride157, i32 %stride158221, i32 %stride159204217, i32 %stride160198202219, ptr %W161, i32 %stride162, i32 %stride163194, i32 %stride164186190, i32 %stride165180185192), !dbg !18
  br label %common.ret, !dbg !18
}

; Function Attrs: nocallback nofree nosync nounwind willreturn memory(inaccessiblemem: write)
declare void @llvm.assume(i1 noundef) #1

; Function Attrs: noinline
define internal fastcc range(i32 -1, 1) i32 @default_function_compute_(i32 %dev_id, i32 %batch, i32 %in_channel, i32 %in_height, i32 %in_width, ptr noalias nocapture readonly align 64 %X, i32 %stride, i32 %stride1, i32 %stride2, i32 %stride3, ptr noalias nocapture writeonly align 64 %conv2d_nchw, i32 %stride4, i32 %stride5, i32 %stride6, i32 %stride7, ptr noalias nocapture readonly align 64 %W, i32 %stride8, i32 %stride9, i32 %stride10, i32 %stride11) unnamed_addr #2 !dbg !167 {
entry:
  call void @llvm.instrprof.increment(ptr @__profn_TVMMod_default_function_compute_, i64 46134000452360265, i32 171, i32 125), !dbg !191
    #dbg_value(i32 %dev_id, !171, !DIExpression(), !191)
    #dbg_value(i32 %batch, !172, !DIExpression(), !191)
    #dbg_value(i32 %in_channel, !173, !DIExpression(), !191)
    #dbg_value(i32 %in_height, !174, !DIExpression(), !191)
    #dbg_value(i32 %in_width, !175, !DIExpression(), !191)
    #dbg_value(ptr %X, !176, !DIExpression(), !191)
    #dbg_value(i32 %stride, !177, !DIExpression(), !191)
    #dbg_value(i32 %stride1, !178, !DIExpression(), !191)
    #dbg_value(i32 %stride2, !179, !DIExpression(), !191)
    #dbg_value(i32 %stride3, !180, !DIExpression(), !191)
    #dbg_value(ptr %conv2d_nchw, !181, !DIExpression(), !191)
    #dbg_value(i32 %stride4, !182, !DIExpression(), !191)
    #dbg_value(i32 %stride5, !183, !DIExpression(), !191)
    #dbg_value(i32 %stride6, !184, !DIExpression(), !191)
    #dbg_value(i32 %stride7, !185, !DIExpression(), !191)
    #dbg_value(ptr %W, !186, !DIExpression(), !191)
    #dbg_value(i32 %stride8, !187, !DIExpression(), !191)
    #dbg_value(i32 %stride9, !188, !DIExpression(), !191)
    #dbg_value(i32 %stride10, !189, !DIExpression(), !191)
    #dbg_value(i32 %stride11, !190, !DIExpression(), !191)
  %0 = add i32 %in_width, 2, !dbg !191
  %1 = add i32 %in_height, 2, !dbg !191
  %2 = mul nsw i32 %in_channel, %batch, !dbg !191
  %3 = mul nsw i32 %2, %1, !dbg !191
  %4 = mul nsw i32 %3, %0, !dbg !191
  %5 = sext i32 %4 to i64, !dbg !191
  %6 = shl nuw nsw i64 %5, 2, !dbg !191
  %7 = load ptr, ptr @__TVMBackendAllocWorkspace, align 8, !dbg !191, !tbaa !20
  %8 = ptrtoint ptr %7 to i64, !dbg !191
  call void @llvm.instrprof.value.profile(ptr @__profn_TVMMod_default_function_compute_, i64 46134000452360265, i64 %8, i32 0, i32 0), !dbg !191
  %pad_temp = tail call ptr %7(i32 1, i32 %dev_id, i64 %6, i32 2, i32 32), !dbg !191
    #dbg_declare(ptr %pad_temp, !192, !DIExpression(), !191)
    #dbg_declare(ptr %pad_temp, !192, !DIExpression(), !191)
  call void @llvm.assume(i1 true) [ "align"(ptr %pad_temp, i64 64) ], !dbg !191
  %9 = icmp eq ptr %pad_temp, null, !dbg !191
  br i1 %9, label %common.ret, label %for_begin_i0.preheader, !dbg !191, !prof !19

for_begin_i0.preheader:                           ; preds = %entry
    #dbg_declare(i32 0, !193, !DIExpression(), !191)
  %10 = icmp sgt i32 %batch, 0, !dbg !191
  br i1 %10, label %for_begin_i1.preheader.lr.ph, label %for_end_nn, !dbg !191, !prof !194

for_begin_i1.preheader.lr.ph:                     ; preds = %for_begin_i0.preheader
  call void @llvm.instrprof.increment(ptr @__profn_TVMMod_default_function_compute_, i64 46134000452360265, i32 171, i32 126)
  %11 = icmp sgt i32 %in_channel, 0
  %12 = icmp sgt i32 %in_width, -2
  br i1 %11, label %for_begin_i1.preheader.lr.ph.split.us, label %for_begin_ff.preheader.lr.ph, !prof !194

for_begin_i1.preheader.lr.ph.split.us:            ; preds = %for_begin_i1.preheader.lr.ph
  call void @llvm.instrprof.increment(ptr @__profn_TVMMod_default_function_compute_, i64 46134000452360265, i32 171, i32 127)
  %13 = icmp sgt i32 %in_height, -2
  br i1 %13, label %for_begin_i1.preheader.lr.ph.split.us.split.us, label %for_end_nn, !prof !194

for_begin_i1.preheader.lr.ph.split.us.split.us:   ; preds = %for_begin_i1.preheader.lr.ph.split.us
  call void @llvm.instrprof.increment(ptr @__profn_TVMMod_default_function_compute_, i64 46134000452360265, i32 171, i32 128)
  br i1 %12, label %for_begin_i1.preheader.us.us.us.preheader, label %for_begin_ff.preheader.lr.ph, !prof !194

for_begin_i1.preheader.us.us.us.preheader:        ; preds = %for_begin_i1.preheader.lr.ph.split.us.split.us
  %14 = mul i32 %0, %in_channel
  %15 = mul i32 %14, %1
  %16 = mul i32 %0, %1
  %smax = tail call i32 @llvm.smax.i32(i32 %0, i32 1), !dbg !191
  %17 = zext nneg i32 %smax to i64, !dbg !191
  %18 = shl nuw nsw i64 %17, 2, !dbg !191
  %19 = sext i32 %in_width to i64, !dbg !191
  %20 = sext i32 %stride3 to i64, !dbg !191
  %21 = sext i32 %in_height to i64, !dbg !191
  %22 = sext i32 %stride2 to i64, !dbg !191
  %23 = sext i32 %0 to i64, !dbg !191
  %smax84 = tail call i32 @llvm.smax.i32(i32 %1, i32 1), !dbg !191
  %24 = sext i32 %stride1 to i64, !dbg !191
  %25 = sext i32 %1 to i64, !dbg !191
  %26 = sext i32 %stride to i64, !dbg !191
  %27 = zext nneg i32 %in_channel to i64, !dbg !191
  %wide.trip.count95 = zext nneg i32 %batch to i64, !dbg !191
  %wide.trip.count90 = zext nneg i32 %in_channel to i64
  %wide.trip.count85 = zext nneg i32 %smax84 to i64
  %exitcond.peel.not = icmp ugt i32 %in_width, 2147483645
  %28 = add nsw i64 %17, -1, !dbg !191
  %xtraiter = and i64 %28, 1
  %29 = icmp eq i32 %in_width, 0
  %unroll_iter = and i64 %28, -2
  %lcmp.mod.not = icmp eq i64 %xtraiter, 0
  br label %for_begin_i1.preheader.us.us.us, !dbg !191

for_begin_i1.preheader.us.us.us:                  ; preds = %for_begin_i1.for_end_i1_crit_edge.split.us.split.us.us.us.us, %for_begin_i1.preheader.us.us.us.preheader
  %indvars.iv92 = phi i64 [ 0, %for_begin_i1.preheader.us.us.us.preheader ], [ %indvars.iv.next93, %for_begin_i1.for_end_i1_crit_edge.split.us.split.us.us.us.us ]
  %30 = trunc nuw nsw i64 %indvars.iv92 to i32
  %31 = mul i32 %15, %30
    #dbg_declare(i64 %indvars.iv92, !193, !DIExpression(), !191)
    #dbg_declare(i32 0, !195, !DIExpression(), !191)
  %32 = mul nsw i64 %indvars.iv92, %26
  %33 = mul nuw nsw i64 %indvars.iv92, %27
  %invariant.gep164 = getelementptr float, ptr %X, i64 %32, !dbg !191
  br label %for_begin_i2.preheader.us.us.us.us.us, !dbg !191

for_begin_i2.preheader.us.us.us.us.us:            ; preds = %for_begin_i2.for_end_i2_crit_edge.split.us.us.us.us.us.us, %for_begin_i1.preheader.us.us.us
  %indvars.iv87 = phi i64 [ %indvars.iv.next88, %for_begin_i2.for_end_i2_crit_edge.split.us.us.us.us.us.us ], [ 0, %for_begin_i1.preheader.us.us.us ]
  %34 = trunc nuw nsw i64 %indvars.iv87 to i32
  %35 = mul i32 %16, %34
  %36 = add i32 %31, %35
    #dbg_declare(i64 %indvars.iv87, !195, !DIExpression(), !191)
    #dbg_declare(i32 0, !196, !DIExpression(), !191)
  %37 = mul nsw i64 %indvars.iv87, %24
  %38 = add nuw nsw i64 %indvars.iv87, %33
  %39 = mul nsw i64 %38, %25
  %gep165 = getelementptr float, ptr %invariant.gep164, i64 %37
  br label %for_begin_i3.preheader.us.us.us.us.us.us, !dbg !191

for_begin_i3.preheader.us.us.us.us.us.us:         ; preds = %for_begin_i3.for_end_i3_crit_edge.us.us.us.us.us.us, %for_begin_i2.preheader.us.us.us.us.us
  %indvars.iv81 = phi i64 [ %indvars.iv.next82, %for_begin_i3.for_end_i3_crit_edge.us.us.us.us.us.us ], [ 0, %for_begin_i2.preheader.us.us.us.us.us ]
    #dbg_declare(i64 %indvars.iv81, !196, !DIExpression(), !191)
    #dbg_declare(i32 0, !197, !DIExpression(), !191)
  %40 = icmp sle i64 %indvars.iv81, %21
  %41 = icmp ne i64 %indvars.iv81, 0
  %42 = and i1 %41, %40
  %43 = add nsw i64 %indvars.iv81, -1
  %44 = mul nsw i64 %43, %22
  %45 = add nsw i64 %indvars.iv81, %39
  %46 = mul nsw i64 %45, %23
  %.fr.us.us.us.us.us.us = freeze i1 %42
  br i1 %.fr.us.us.us.us.us.us, label %if_end13.us.us.us.us.us.us.peel, label %for_body_i3.us.us.us.us.us.us.us.preheader

for_body_i3.us.us.us.us.us.us.us.preheader:       ; preds = %for_begin_i3.preheader.us.us.us.us.us.us
  call void @llvm.instrprof.increment(ptr @__profn_TVMMod_default_function_compute_, i64 46134000452360265, i32 171, i32 5)
  %47 = trunc nuw nsw i64 %indvars.iv81 to i32
  %48 = mul i32 %0, %47
  %49 = add i32 %36, %48
  %50 = sext i32 %49 to i64
  %51 = shl nsw i64 %50, 2
  %scevgep = getelementptr i8, ptr %pad_temp, i64 %51
  call void @llvm.instrprof.value.profile(ptr @__profn_TVMMod_default_function_compute_, i64 46134000452360265, i64 %18, i32 1, i32 0), !dbg !191
  tail call void @llvm.memset.p0.i64(ptr noundef nonnull align 4 dereferenceable(1) %scevgep, i8 0, i64 %18, i1 false), !dbg !191, !tbaa !198
    #dbg_declare(i64 poison, !197, !DIExpression(), !191)
  br label %for_begin_i3.for_end_i3_crit_edge.us.us.us.us.us.us, !dbg !191

if_end13.us.us.us.us.us.us.peel:                  ; preds = %for_begin_i3.preheader.us.us.us.us.us.us
    #dbg_declare(i64 0, !197, !DIExpression(), !191)
  %52 = getelementptr inbounds float, ptr %pad_temp, i64 %46, !dbg !191
  store float 0.000000e+00, ptr %52, align 4, !dbg !191, !tbaa !198
    #dbg_declare(i64 1, !197, !DIExpression(), !191)
  br i1 %exitcond.peel.not, label %if_end13.us.us.us.us.us.us.peel.for_begin_i3.for_end_i3_crit_edge.us.us.us.us.us.us_crit_edge, label %for_body_i3.us20.us.us.us.us.us.peel.next, !dbg !191, !prof !200

if_end13.us.us.us.us.us.us.peel.for_begin_i3.for_end_i3_crit_edge.us.us.us.us.us.us_crit_edge: ; preds = %if_end13.us.us.us.us.us.us.peel
  call void @llvm.instrprof.increment(ptr @__profn_TVMMod_default_function_compute_, i64 46134000452360265, i32 171, i32 76), !dbg !191
  br label %for_begin_i3.for_end_i3_crit_edge.us.us.us.us.us.us, !dbg !191

for_body_i3.us20.us.us.us.us.us.peel.next:        ; preds = %if_end13.us.us.us.us.us.us.peel
  call void @llvm.instrprof.increment(ptr @__profn_TVMMod_default_function_compute_, i64 46134000452360265, i32 171, i32 6)
  %53 = getelementptr float, ptr %gep165, i64 %44
  %invariant.gep = getelementptr float, ptr %pad_temp, i64 %46, !dbg !191
  br i1 %29, label %for_begin_i3.for_end_i3_crit_edge.us.us.us.us.us.us.loopexit.unr-lcssa, label %for_body_i3.us20.us.us.us.us.us.peel.next.new, !dbg !191, !prof !201

for_body_i3.us20.us.us.us.us.us.peel.next.new:    ; preds = %for_body_i3.us20.us.us.us.us.us.peel.next
  call void @llvm.instrprof.increment(ptr @__profn_TVMMod_default_function_compute_, i64 46134000452360265, i32 171, i32 7), !dbg !191
  %invariant.gep463 = getelementptr i8, ptr %invariant.gep, i64 4, !dbg !191
  br label %for_body_i3.us20.us.us.us.us.us, !dbg !191

for_body_i3.us20.us.us.us.us.us:                  ; preds = %if_end13.us.us.us.us.us.us.1, %for_body_i3.us20.us.us.us.us.us.peel.next.new
  %indvars.iv = phi i64 [ 1, %for_body_i3.us20.us.us.us.us.us.peel.next.new ], [ %indvars.iv.next.1, %if_end13.us.us.us.us.us.us.1 ]
  %niter = phi i64 [ 0, %for_body_i3.us20.us.us.us.us.us.peel.next.new ], [ %niter.next.1, %if_end13.us.us.us.us.us.us.1 ]
    #dbg_declare(i64 %indvars.iv, !197, !DIExpression(), !191)
  %.not148 = icmp sgt i64 %indvars.iv, %19, !dbg !191
  br i1 %.not148, label %if_end13.us.us.us.us.us.us, label %if_then12.us.us.us.us.us.us, !dbg !191

if_then12.us.us.us.us.us.us:                      ; preds = %for_body_i3.us20.us.us.us.us.us
  call void @llvm.instrprof.increment(ptr @__profn_TVMMod_default_function_compute_, i64 46134000452360265, i32 171, i32 3), !dbg !191
  %54 = add nsw i64 %indvars.iv, -1, !dbg !191
  %55 = mul nsw i64 %54, %20, !dbg !191
  %56 = getelementptr float, ptr %53, i64 %55, !dbg !191
  %57 = load float, ptr %56, align 4, !dbg !191, !tbaa !202
  br label %if_end13.us.us.us.us.us.us, !dbg !191

if_end13.us.us.us.us.us.us:                       ; preds = %if_then12.us.us.us.us.us.us, %for_body_i3.us20.us.us.us.us.us
  %58 = phi float [ %57, %if_then12.us.us.us.us.us.us ], [ 0.000000e+00, %for_body_i3.us20.us.us.us.us.us ], !dbg !191
  %gep = getelementptr float, ptr %invariant.gep, i64 %indvars.iv, !dbg !191
  store float %58, ptr %gep, align 4, !dbg !191, !tbaa !198
    #dbg_declare(i64 %indvars.iv, !197, !DIExpression(DW_OP_plus_uconst, 1), !191)
    #dbg_declare(i64 %indvars.iv, !197, !DIExpression(DW_OP_plus_uconst, 1), !191)
  %.not148.1.not = icmp slt i64 %indvars.iv, %19, !dbg !191
  br i1 %.not148.1.not, label %if_then12.us.us.us.us.us.us.1, label %if_end13.us.us.us.us.us.us.if_end13.us.us.us.us.us.us.1_crit_edge, !dbg !191

if_end13.us.us.us.us.us.us.if_end13.us.us.us.us.us.us.1_crit_edge: ; preds = %if_end13.us.us.us.us.us.us
  call void @llvm.instrprof.increment(ptr @__profn_TVMMod_default_function_compute_, i64 46134000452360265, i32 171, i32 1), !dbg !191
  br label %if_end13.us.us.us.us.us.us.1, !dbg !191

if_then12.us.us.us.us.us.us.1:                    ; preds = %if_end13.us.us.us.us.us.us
  call void @llvm.instrprof.increment(ptr @__profn_TVMMod_default_function_compute_, i64 46134000452360265, i32 171, i32 4), !dbg !191
  %59 = mul nsw i64 %indvars.iv, %20, !dbg !191
  %60 = getelementptr float, ptr %53, i64 %59, !dbg !191
  %61 = load float, ptr %60, align 4, !dbg !191, !tbaa !202
  br label %if_end13.us.us.us.us.us.us.1, !dbg !191

if_end13.us.us.us.us.us.us.1:                     ; preds = %if_end13.us.us.us.us.us.us.if_end13.us.us.us.us.us.us.1_crit_edge, %if_then12.us.us.us.us.us.us.1
  %62 = phi float [ %61, %if_then12.us.us.us.us.us.us.1 ], [ 0.000000e+00, %if_end13.us.us.us.us.us.us.if_end13.us.us.us.us.us.us.1_crit_edge ], !dbg !191
  %gep464 = getelementptr float, ptr %invariant.gep463, i64 %indvars.iv, !dbg !191
  store float %62, ptr %gep464, align 4, !dbg !191, !tbaa !198
  %indvars.iv.next.1 = add nuw nsw i64 %indvars.iv, 2, !dbg !191
    #dbg_declare(i64 %indvars.iv.next.1, !197, !DIExpression(), !191)
  %niter.next.1 = add i64 %niter, 2, !dbg !191
  %niter.ncmp.1 = icmp eq i64 %niter.next.1, %unroll_iter, !dbg !191
  br i1 %niter.ncmp.1, label %for_begin_i3.for_end_i3_crit_edge.us.us.us.us.us.us.loopexit.unr-lcssa, label %for_body_i3.us20.us.us.us.us.us, !dbg !191, !prof !204, !llvm.loop !205

for_begin_i3.for_end_i3_crit_edge.us.us.us.us.us.us.loopexit.unr-lcssa: ; preds = %if_end13.us.us.us.us.us.us.1, %for_body_i3.us20.us.us.us.us.us.peel.next
  %indvars.iv.unr = phi i64 [ 1, %for_body_i3.us20.us.us.us.us.us.peel.next ], [ %indvars.iv.next.1, %if_end13.us.us.us.us.us.us.1 ]
  br i1 %lcmp.mod.not, label %for_begin_i3.for_end_i3_crit_edge.us.us.us.us.us.us, label %for_body_i3.us20.us.us.us.us.us.epil, !dbg !191, !prof !207

for_body_i3.us20.us.us.us.us.us.epil:             ; preds = %for_begin_i3.for_end_i3_crit_edge.us.us.us.us.us.us.loopexit.unr-lcssa
    #dbg_declare(i64 %indvars.iv.unr, !197, !DIExpression(), !191)
  %.not148.epil = icmp sgt i64 %indvars.iv.unr, %19, !dbg !191
  br i1 %.not148.epil, label %if_end13.us.us.us.us.us.us.epil, label %if_then12.us.us.us.us.us.us.epil, !dbg !191

if_then12.us.us.us.us.us.us.epil:                 ; preds = %for_body_i3.us20.us.us.us.us.us.epil
  call void @llvm.instrprof.increment(ptr @__profn_TVMMod_default_function_compute_, i64 46134000452360265, i32 171, i32 26), !dbg !191
  %63 = add nsw i64 %indvars.iv.unr, -1, !dbg !191
  %64 = mul nsw i64 %63, %20, !dbg !191
  %65 = getelementptr float, ptr %53, i64 %64, !dbg !191
  %66 = load float, ptr %65, align 4, !dbg !191, !tbaa !202
  br label %if_end13.us.us.us.us.us.us.epil, !dbg !191

if_end13.us.us.us.us.us.us.epil:                  ; preds = %if_then12.us.us.us.us.us.us.epil, %for_body_i3.us20.us.us.us.us.us.epil
  %67 = phi float [ %66, %if_then12.us.us.us.us.us.us.epil ], [ 0.000000e+00, %for_body_i3.us20.us.us.us.us.us.epil ], !dbg !191
  call void @llvm.instrprof.increment(ptr @__profn_TVMMod_default_function_compute_, i64 46134000452360265, i32 171, i32 9), !dbg !191
  %gep.epil = getelementptr float, ptr %invariant.gep, i64 %indvars.iv.unr, !dbg !191
  store float %67, ptr %gep.epil, align 4, !dbg !191, !tbaa !198
    #dbg_declare(i64 %indvars.iv.unr, !197, !DIExpression(DW_OP_plus_uconst, 1), !191)
  br label %for_begin_i3.for_end_i3_crit_edge.us.us.us.us.us.us, !dbg !191

for_begin_i3.for_end_i3_crit_edge.us.us.us.us.us.us: ; preds = %if_end13.us.us.us.us.us.us.peel.for_begin_i3.for_end_i3_crit_edge.us.us.us.us.us.us_crit_edge, %if_end13.us.us.us.us.us.us.epil, %for_begin_i3.for_end_i3_crit_edge.us.us.us.us.us.us.loopexit.unr-lcssa, %for_body_i3.us.us.us.us.us.us.us.preheader
  %indvars.iv.next82 = add nuw nsw i64 %indvars.iv81, 1, !dbg !191
    #dbg_declare(i64 %indvars.iv.next82, !196, !DIExpression(), !191)
  %exitcond86.not = icmp eq i64 %indvars.iv.next82, %wide.trip.count85, !dbg !191
  br i1 %exitcond86.not, label %for_begin_i2.for_end_i2_crit_edge.split.us.us.us.us.us.us, label %for_begin_i3.preheader.us.us.us.us.us.us, !dbg !191, !prof !200

for_begin_i2.for_end_i2_crit_edge.split.us.us.us.us.us.us: ; preds = %for_begin_i3.for_end_i3_crit_edge.us.us.us.us.us.us
  call void @llvm.instrprof.increment(ptr @__profn_TVMMod_default_function_compute_, i64 46134000452360265, i32 171, i32 129), !dbg !191
  %indvars.iv.next88 = add nuw nsw i64 %indvars.iv87, 1, !dbg !191
    #dbg_declare(i64 %indvars.iv.next88, !195, !DIExpression(), !191)
  %exitcond91.not = icmp eq i64 %indvars.iv.next88, %wide.trip.count90, !dbg !191
  br i1 %exitcond91.not, label %for_begin_i1.for_end_i1_crit_edge.split.us.split.us.us.us.us, label %for_begin_i2.preheader.us.us.us.us.us, !dbg !191, !prof !200

for_begin_i1.for_end_i1_crit_edge.split.us.split.us.us.us.us: ; preds = %for_begin_i2.for_end_i2_crit_edge.split.us.us.us.us.us.us
  call void @llvm.instrprof.increment(ptr @__profn_TVMMod_default_function_compute_, i64 46134000452360265, i32 171, i32 130), !dbg !191
  %indvars.iv.next93 = add nuw nsw i64 %indvars.iv92, 1, !dbg !191
    #dbg_declare(i64 %indvars.iv.next93, !193, !DIExpression(), !191)
  %exitcond96.not = icmp eq i64 %indvars.iv.next93, %wide.trip.count95, !dbg !191
  br i1 %exitcond96.not, label %for_begin_nn.preheader, label %for_begin_i1.preheader.us.us.us, !dbg !191, !prof !200

common.ret:                                       ; preds = %for_end_nn, %entry
  %common.ret.op = phi i32 [ -1, %entry ], [ %., %for_end_nn ]
  ret i32 %common.ret.op, !dbg !191

for_begin_nn.preheader:                           ; preds = %for_begin_i1.for_end_i1_crit_edge.split.us.split.us.us.us.us
  call void @llvm.instrprof.increment(ptr @__profn_TVMMod_default_function_compute_, i64 46134000452360265, i32 171, i32 131), !dbg !191
    #dbg_declare(i32 0, !208, !DIExpression(), !191)
  br i1 %10, label %for_begin_ff.preheader.lr.ph, label %for_begin_nn.preheader.for_end_nn_crit_edge, !dbg !191, !prof !209

for_begin_nn.preheader.for_end_nn_crit_edge:      ; preds = %for_begin_nn.preheader
  call void @llvm.instrprof.increment(ptr @__profn_TVMMod_default_function_compute_, i64 46134000452360265, i32 171, i32 27), !dbg !191
  br label %for_end_nn, !dbg !191

for_begin_ff.preheader.lr.ph:                     ; preds = %for_begin_nn.preheader, %for_begin_i1.preheader.lr.ph.split.us.split.us, %for_begin_i1.preheader.lr.ph
  %68 = icmp sgt i32 %in_height, 0
  %69 = icmp sgt i32 %in_width, 0
  %70 = zext i1 %68 to i64
  call void @llvm.instrprof.increment.step(ptr @__profn_TVMMod_default_function_compute_, i64 46134000452360265, i32 171, i32 154, i64 %70)
  %or.cond = select i1 %68, i1 %69, i1 false
  br i1 %or.cond, label %for_begin_ff.preheader.lr.ph.split.us.split.us, label %for_end_nn, !prof !210

for_begin_ff.preheader.lr.ph.split.us.split.us:   ; preds = %for_begin_ff.preheader.lr.ph
  %71 = icmp sgt i32 %in_channel, 0
  br i1 %71, label %for_begin_ff.preheader.us.us.us.preheader, label %for_begin_ff.preheader.us.us.preheader, !prof !194

for_begin_ff.preheader.us.us.preheader:           ; preds = %for_begin_ff.preheader.lr.ph.split.us.split.us
  %72 = sext i32 %stride7 to i64, !dbg !191
  %73 = sext i32 %stride6 to i64, !dbg !191
  %74 = sext i32 %stride5 to i64, !dbg !191
  %75 = sext i32 %stride4 to i64, !dbg !191
  %wide.trip.count114 = zext nneg i32 %batch to i64, !dbg !191
  %wide.trip.count105 = zext nneg i32 %in_height to i64
  %wide.trip.count100 = zext nneg i32 %in_width to i64
  %invariant.gep166 = getelementptr float, ptr %conv2d_nchw, i64 %74, !dbg !191
  %.idx = shl nsw i64 %74, 3
  %76 = getelementptr i8, ptr %conv2d_nchw, i64 %.idx
  %.idx149 = mul nsw i64 %74, 12
  %77 = getelementptr i8, ptr %conv2d_nchw, i64 %.idx149
  %.idx150 = shl nsw i64 %74, 4
  %78 = getelementptr i8, ptr %conv2d_nchw, i64 %.idx150
  %.idx151 = mul nsw i64 %74, 20
  %79 = getelementptr i8, ptr %conv2d_nchw, i64 %.idx151
  %.idx152 = mul nsw i64 %74, 24
  %80 = getelementptr i8, ptr %conv2d_nchw, i64 %.idx152
  %.idx153 = mul nsw i64 %74, 28
  %81 = getelementptr i8, ptr %conv2d_nchw, i64 %.idx153
  %.idx154 = shl nsw i64 %74, 5
  %82 = getelementptr i8, ptr %conv2d_nchw, i64 %.idx154
  %.idx155 = mul nsw i64 %74, 36
  %83 = getelementptr i8, ptr %conv2d_nchw, i64 %.idx155
  %.idx156 = mul nsw i64 %74, 40
  %84 = getelementptr i8, ptr %conv2d_nchw, i64 %.idx156
  %.idx157 = mul nsw i64 %74, 44
  %85 = getelementptr i8, ptr %conv2d_nchw, i64 %.idx157
  %.idx158 = mul nsw i64 %74, 48
  %86 = getelementptr i8, ptr %conv2d_nchw, i64 %.idx158
  %.idx159 = mul nsw i64 %74, 52
  %87 = getelementptr i8, ptr %conv2d_nchw, i64 %.idx159
  %.idx160 = mul nsw i64 %74, 56
  %88 = getelementptr i8, ptr %conv2d_nchw, i64 %.idx160
  %.idx161 = mul nsw i64 %74, 60
  %89 = getelementptr i8, ptr %conv2d_nchw, i64 %.idx161
  %min.iters.check381 = icmp ugt i32 %in_width, 7
  %ident.check378.not = icmp eq i32 %stride7, 1
  %90 = zext i1 %min.iters.check381 to i64
  call void @llvm.instrprof.increment.step(ptr @__profn_TVMMod_default_function_compute_, i64 46134000452360265, i32 171, i32 155, i64 %90)
  %or.cond390 = select i1 %min.iters.check381, i1 %ident.check378.not, i1 false
  %n.vec384 = and i64 %wide.trip.count100, 2147483640
  %cmp.n389 = icmp eq i64 %n.vec384, %wide.trip.count100
  %xtraiter407 = and i64 %wide.trip.count100, 3
  %lcmp.mod408.not = icmp eq i64 %xtraiter407, 0
  %min.iters.check368 = icmp ugt i32 %in_width, 7
  %ident.check365.not = icmp eq i32 %stride7, 1
  %91 = zext i1 %min.iters.check368 to i64
  call void @llvm.instrprof.increment.step(ptr @__profn_TVMMod_default_function_compute_, i64 46134000452360265, i32 171, i32 156, i64 %91)
  %or.cond391 = select i1 %min.iters.check368, i1 %ident.check365.not, i1 false
  %n.vec371 = and i64 %wide.trip.count100, 2147483640
  %cmp.n376 = icmp eq i64 %n.vec371, %wide.trip.count100
  %xtraiter418 = and i64 %wide.trip.count100, 3
  %lcmp.mod419.not = icmp eq i64 %xtraiter418, 0
  %min.iters.check355 = icmp ugt i32 %in_width, 7
  %ident.check352.not = icmp eq i32 %stride7, 1
  %92 = zext i1 %min.iters.check355 to i64
  call void @llvm.instrprof.increment.step(ptr @__profn_TVMMod_default_function_compute_, i64 46134000452360265, i32 171, i32 157, i64 %92)
  %or.cond392 = select i1 %min.iters.check355, i1 %ident.check352.not, i1 false
  %n.vec358 = and i64 %wide.trip.count100, 2147483640
  %cmp.n363 = icmp eq i64 %n.vec358, %wide.trip.count100
  %xtraiter421 = and i64 %wide.trip.count100, 3
  %lcmp.mod422.not = icmp eq i64 %xtraiter421, 0
  %min.iters.check342 = icmp ugt i32 %in_width, 7
  %ident.check339.not = icmp eq i32 %stride7, 1
  %93 = zext i1 %min.iters.check342 to i64
  call void @llvm.instrprof.increment.step(ptr @__profn_TVMMod_default_function_compute_, i64 46134000452360265, i32 171, i32 158, i64 %93)
  %or.cond393 = select i1 %min.iters.check342, i1 %ident.check339.not, i1 false
  %n.vec345 = and i64 %wide.trip.count100, 2147483640
  %cmp.n350 = icmp eq i64 %n.vec345, %wide.trip.count100
  %xtraiter424 = and i64 %wide.trip.count100, 3
  %lcmp.mod425.not = icmp eq i64 %xtraiter424, 0
  %min.iters.check329 = icmp ugt i32 %in_width, 7
  %ident.check326.not = icmp eq i32 %stride7, 1
  %94 = zext i1 %min.iters.check329 to i64
  call void @llvm.instrprof.increment.step(ptr @__profn_TVMMod_default_function_compute_, i64 46134000452360265, i32 171, i32 159, i64 %94)
  %or.cond394 = select i1 %min.iters.check329, i1 %ident.check326.not, i1 false
  %n.vec332 = and i64 %wide.trip.count100, 2147483640
  %cmp.n337 = icmp eq i64 %n.vec332, %wide.trip.count100
  %xtraiter427 = and i64 %wide.trip.count100, 3
  %lcmp.mod428.not = icmp eq i64 %xtraiter427, 0
  %min.iters.check316 = icmp ugt i32 %in_width, 7
  %ident.check313.not = icmp eq i32 %stride7, 1
  %95 = zext i1 %min.iters.check316 to i64
  call void @llvm.instrprof.increment.step(ptr @__profn_TVMMod_default_function_compute_, i64 46134000452360265, i32 171, i32 160, i64 %95)
  %or.cond395 = select i1 %min.iters.check316, i1 %ident.check313.not, i1 false
  %n.vec319 = and i64 %wide.trip.count100, 2147483640
  %cmp.n324 = icmp eq i64 %n.vec319, %wide.trip.count100
  %xtraiter430 = and i64 %wide.trip.count100, 3
  %lcmp.mod431.not = icmp eq i64 %xtraiter430, 0
  %min.iters.check303 = icmp ugt i32 %in_width, 7
  %ident.check300.not = icmp eq i32 %stride7, 1
  %96 = zext i1 %min.iters.check303 to i64
  call void @llvm.instrprof.increment.step(ptr @__profn_TVMMod_default_function_compute_, i64 46134000452360265, i32 171, i32 161, i64 %96)
  %or.cond396 = select i1 %min.iters.check303, i1 %ident.check300.not, i1 false
  %n.vec306 = and i64 %wide.trip.count100, 2147483640
  %cmp.n311 = icmp eq i64 %n.vec306, %wide.trip.count100
  %xtraiter433 = and i64 %wide.trip.count100, 3
  %lcmp.mod434.not = icmp eq i64 %xtraiter433, 0
  %min.iters.check290 = icmp ugt i32 %in_width, 7
  %ident.check287.not = icmp eq i32 %stride7, 1
  %97 = zext i1 %min.iters.check290 to i64
  call void @llvm.instrprof.increment.step(ptr @__profn_TVMMod_default_function_compute_, i64 46134000452360265, i32 171, i32 162, i64 %97)
  %or.cond397 = select i1 %min.iters.check290, i1 %ident.check287.not, i1 false
  %n.vec293 = and i64 %wide.trip.count100, 2147483640
  %cmp.n298 = icmp eq i64 %n.vec293, %wide.trip.count100
  %xtraiter436 = and i64 %wide.trip.count100, 3
  %lcmp.mod437.not = icmp eq i64 %xtraiter436, 0
  %min.iters.check277 = icmp ugt i32 %in_width, 7
  %ident.check274.not = icmp eq i32 %stride7, 1
  %98 = zext i1 %min.iters.check277 to i64
  call void @llvm.instrprof.increment.step(ptr @__profn_TVMMod_default_function_compute_, i64 46134000452360265, i32 171, i32 163, i64 %98)
  %or.cond398 = select i1 %min.iters.check277, i1 %ident.check274.not, i1 false
  %n.vec280 = and i64 %wide.trip.count100, 2147483640
  %cmp.n285 = icmp eq i64 %n.vec280, %wide.trip.count100
  %xtraiter439 = and i64 %wide.trip.count100, 3
  %lcmp.mod440.not = icmp eq i64 %xtraiter439, 0
  %min.iters.check264 = icmp ugt i32 %in_width, 7
  %ident.check261.not = icmp eq i32 %stride7, 1
  %99 = zext i1 %min.iters.check264 to i64
  call void @llvm.instrprof.increment.step(ptr @__profn_TVMMod_default_function_compute_, i64 46134000452360265, i32 171, i32 164, i64 %99)
  %or.cond399 = select i1 %min.iters.check264, i1 %ident.check261.not, i1 false
  %n.vec267 = and i64 %wide.trip.count100, 2147483640
  %cmp.n272 = icmp eq i64 %n.vec267, %wide.trip.count100
  %xtraiter442 = and i64 %wide.trip.count100, 3
  %lcmp.mod443.not = icmp eq i64 %xtraiter442, 0
  %min.iters.check251 = icmp ugt i32 %in_width, 7
  %ident.check248.not = icmp eq i32 %stride7, 1
  %100 = zext i1 %min.iters.check251 to i64
  call void @llvm.instrprof.increment.step(ptr @__profn_TVMMod_default_function_compute_, i64 46134000452360265, i32 171, i32 165, i64 %100)
  %or.cond400 = select i1 %min.iters.check251, i1 %ident.check248.not, i1 false
  %n.vec254 = and i64 %wide.trip.count100, 2147483640
  %cmp.n259 = icmp eq i64 %n.vec254, %wide.trip.count100
  %xtraiter445 = and i64 %wide.trip.count100, 3
  %lcmp.mod446.not = icmp eq i64 %xtraiter445, 0
  %min.iters.check238 = icmp ugt i32 %in_width, 7
  %ident.check235.not = icmp eq i32 %stride7, 1
  %101 = zext i1 %min.iters.check238 to i64
  call void @llvm.instrprof.increment.step(ptr @__profn_TVMMod_default_function_compute_, i64 46134000452360265, i32 171, i32 166, i64 %101)
  %or.cond401 = select i1 %min.iters.check238, i1 %ident.check235.not, i1 false
  %n.vec241 = and i64 %wide.trip.count100, 2147483640
  %cmp.n246 = icmp eq i64 %n.vec241, %wide.trip.count100
  %xtraiter448 = and i64 %wide.trip.count100, 3
  %lcmp.mod449.not = icmp eq i64 %xtraiter448, 0
  %min.iters.check225 = icmp ugt i32 %in_width, 7
  %ident.check222.not = icmp eq i32 %stride7, 1
  %102 = zext i1 %min.iters.check225 to i64
  call void @llvm.instrprof.increment.step(ptr @__profn_TVMMod_default_function_compute_, i64 46134000452360265, i32 171, i32 167, i64 %102)
  %or.cond402 = select i1 %min.iters.check225, i1 %ident.check222.not, i1 false
  %n.vec228 = and i64 %wide.trip.count100, 2147483640
  %cmp.n233 = icmp eq i64 %n.vec228, %wide.trip.count100
  %xtraiter451 = and i64 %wide.trip.count100, 3
  %lcmp.mod452.not = icmp eq i64 %xtraiter451, 0
  %min.iters.check212 = icmp ugt i32 %in_width, 7
  %ident.check209.not = icmp eq i32 %stride7, 1
  %103 = zext i1 %min.iters.check212 to i64
  call void @llvm.instrprof.increment.step(ptr @__profn_TVMMod_default_function_compute_, i64 46134000452360265, i32 171, i32 168, i64 %103)
  %or.cond403 = select i1 %min.iters.check212, i1 %ident.check209.not, i1 false
  %n.vec215 = and i64 %wide.trip.count100, 2147483640
  %cmp.n220 = icmp eq i64 %n.vec215, %wide.trip.count100
  %xtraiter454 = and i64 %wide.trip.count100, 3
  %lcmp.mod455.not = icmp eq i64 %xtraiter454, 0
  %min.iters.check199 = icmp ugt i32 %in_width, 7
  %ident.check196.not = icmp eq i32 %stride7, 1
  %104 = zext i1 %min.iters.check199 to i64
  call void @llvm.instrprof.increment.step(ptr @__profn_TVMMod_default_function_compute_, i64 46134000452360265, i32 171, i32 169, i64 %104)
  %or.cond404 = select i1 %min.iters.check199, i1 %ident.check196.not, i1 false
  %n.vec202 = and i64 %wide.trip.count100, 2147483640
  %cmp.n207 = icmp eq i64 %n.vec202, %wide.trip.count100
  %xtraiter457 = and i64 %wide.trip.count100, 3
  %lcmp.mod458.not = icmp eq i64 %xtraiter457, 0
  %min.iters.check = icmp ugt i32 %in_width, 7
  %ident.check.not = icmp eq i32 %stride7, 1
  %105 = zext i1 %min.iters.check to i64
  call void @llvm.instrprof.increment.step(ptr @__profn_TVMMod_default_function_compute_, i64 46134000452360265, i32 171, i32 170, i64 %105)
  %or.cond405 = select i1 %min.iters.check, i1 %ident.check.not, i1 false
  %n.vec = and i64 %wide.trip.count100, 2147483640
  %cmp.n = icmp eq i64 %n.vec, %wide.trip.count100
  %xtraiter460 = and i64 %wide.trip.count100, 3
  %lcmp.mod461.not = icmp eq i64 %xtraiter460, 0
  br label %for_begin_ff.preheader.us.us, !dbg !191

for_begin_ff.preheader.us.us.us.preheader:        ; preds = %for_begin_ff.preheader.lr.ph.split.us.split.us
  %106 = sext i32 %stride11 to i64, !dbg !191
  %107 = sext i32 %0 to i64, !dbg !191
  %108 = sext i32 %stride10 to i64, !dbg !191
  %109 = sext i32 %1 to i64, !dbg !191
  %110 = sext i32 %stride9 to i64, !dbg !191
  %111 = sext i32 %stride7 to i64, !dbg !191
  %112 = sext i32 %stride6 to i64, !dbg !191
  %113 = sext i32 %stride5 to i64, !dbg !191
  %114 = sext i32 %stride8 to i64, !dbg !191
  %115 = sext i32 %stride4 to i64, !dbg !191
  %116 = zext nneg i32 %in_channel to i64, !dbg !191
  %wide.trip.count146 = zext nneg i32 %batch to i64, !dbg !191
  %wide.trip.count137 = zext nneg i32 %in_height to i64
  %wide.trip.count132 = zext nneg i32 %in_width to i64
  %wide.trip.count127 = zext nneg i32 %in_channel to i64
  %invariant.gep168 = getelementptr i8, ptr %pad_temp, i64 4
  %invariant.gep170 = getelementptr float, ptr %W, i64 %106
  %invariant.gep172 = getelementptr i8, ptr %pad_temp, i64 8
  %117 = shl nsw i64 %106, 1
  %invariant.gep174 = getelementptr float, ptr %W, i64 %117
  %invariant.gep176 = getelementptr i8, ptr %pad_temp, i64 4
  %invariant.gep178 = getelementptr float, ptr %W, i64 %106
  %invariant.gep180 = getelementptr i8, ptr %pad_temp, i64 8
  %invariant.gep182 = getelementptr float, ptr %W, i64 %117
  %118 = shl nsw i64 %108, 1
  %invariant.gep184 = getelementptr i8, ptr %pad_temp, i64 4
  %invariant.gep186 = getelementptr float, ptr %W, i64 %106
  %invariant.gep188 = getelementptr i8, ptr %pad_temp, i64 8
  %invariant.gep190 = getelementptr float, ptr %W, i64 %117
  br label %for_begin_ff.preheader.us.us.us, !dbg !191

for_begin_ff.preheader.us.us.us:                  ; preds = %for_end_ff.split.us.split.us.split.us.us.us.us, %for_begin_ff.preheader.us.us.us.preheader
  %indvars.iv143 = phi i64 [ 0, %for_begin_ff.preheader.us.us.us.preheader ], [ %indvars.iv.next144, %for_end_ff.split.us.split.us.split.us.us.us.us ]
    #dbg_declare(i64 %indvars.iv143, !208, !DIExpression(), !191)
    #dbg_declare(i32 0, !211, !DIExpression(), !191)
  %119 = mul nsw i64 %indvars.iv143, %115
  %120 = mul nuw nsw i64 %indvars.iv143, %116
  %invariant.gep192 = getelementptr float, ptr %conv2d_nchw, i64 %119, !dbg !191
  br label %for_begin_yy.preheader.us.us.us.us.us.us, !dbg !191

for_begin_yy.preheader.us.us.us.us.us.us:         ; preds = %for_begin_yy.for_end_yy_crit_edge.split.us.split.us.us.us.us.us.us.us, %for_begin_ff.preheader.us.us.us
  %indvars.iv139 = phi i64 [ %indvars.iv.next140, %for_begin_yy.for_end_yy_crit_edge.split.us.split.us.us.us.us.us.us.us ], [ 0, %for_begin_ff.preheader.us.us.us ]
    #dbg_declare(i64 %indvars.iv139, !211, !DIExpression(), !191)
    #dbg_declare(i32 0, !212, !DIExpression(), !191)
  %121 = mul nsw i64 %indvars.iv139, %113
  %122 = mul nsw i64 %indvars.iv139, %114
  %gep193 = getelementptr float, ptr %invariant.gep192, i64 %121
  br label %for_begin_xx.preheader.us.us.us.us.us.us.us.us, !dbg !191

for_begin_xx.preheader.us.us.us.us.us.us.us.us:   ; preds = %for_begin_xx.for_end_xx_crit_edge.split.us.us.us.us.us.us.us.us.us, %for_begin_yy.preheader.us.us.us.us.us.us
  %indvars.iv134 = phi i64 [ %indvars.iv.next135, %for_begin_xx.for_end_xx_crit_edge.split.us.us.us.us.us.us.us.us.us ], [ 0, %for_begin_yy.preheader.us.us.us.us.us.us ]
    #dbg_declare(i64 %indvars.iv134, !212, !DIExpression(), !191)
    #dbg_declare(i32 0, !213, !DIExpression(), !191)
  %123 = mul nsw i64 %indvars.iv134, %112
  %124 = getelementptr float, ptr %gep193, i64 %123
  br label %for_body_xx.us.us.us.us.us.us.us.us.us, !dbg !191

for_body_xx.us.us.us.us.us.us.us.us.us:           ; preds = %for_begin_rc.for_end_rc_crit_edge.us.us.us.us.us.us.us.us.us, %for_begin_xx.preheader.us.us.us.us.us.us.us.us
  %indvars.iv129 = phi i64 [ %indvars.iv.next130, %for_begin_rc.for_end_rc_crit_edge.us.us.us.us.us.us.us.us.us ], [ 0, %for_begin_xx.preheader.us.us.us.us.us.us.us.us ]
    #dbg_declare(i64 %indvars.iv129, !213, !DIExpression(), !191)
  %125 = mul nsw i64 %indvars.iv129, %111, !dbg !191
  %126 = getelementptr float, ptr %124, i64 %125, !dbg !191
    #dbg_declare(i32 0, !214, !DIExpression(), !191)
  br label %for_begin_ry.preheader.us.us.us.us.us.us.us.us.us, !dbg !191

for_begin_ry.preheader.us.us.us.us.us.us.us.us.us: ; preds = %for_begin_ry.preheader.us.us.us.us.us.us.us.us.us.for_begin_ry.preheader.us.us.us.us.us.us.us.us.us_crit_edge, %for_body_xx.us.us.us.us.us.us.us.us.us
  %indvars.iv124 = phi i64 [ %indvars.iv.next125, %for_begin_ry.preheader.us.us.us.us.us.us.us.us.us.for_begin_ry.preheader.us.us.us.us.us.us.us.us.us_crit_edge ], [ 0, %for_body_xx.us.us.us.us.us.us.us.us.us ]
  %.lcssa40.lcssa44.us.us.us.us.us.us.us.us.us = phi float [ %174, %for_begin_ry.preheader.us.us.us.us.us.us.us.us.us.for_begin_ry.preheader.us.us.us.us.us.us.us.us.us_crit_edge ], [ 0.000000e+00, %for_body_xx.us.us.us.us.us.us.us.us.us ]
    #dbg_declare(i64 %indvars.iv124, !214, !DIExpression(), !191)
  %127 = add nuw nsw i64 %indvars.iv124, %120
  %128 = mul nuw nsw i64 %127, %109
  %129 = add nuw nsw i64 %128, %indvars.iv134
  %130 = mul nsw i64 %indvars.iv124, %110
  %131 = add nsw i64 %130, %122
    #dbg_declare(i32 0, !215, !DIExpression(), !191)
    #dbg_declare(i64 0, !215, !DIExpression(), !191)
  %132 = mul nuw nsw i64 %129, %107
  %133 = add nsw i64 %132, %indvars.iv129
    #dbg_declare(i32 0, !216, !DIExpression(), !191)
    #dbg_declare(i64 0, !216, !DIExpression(), !191)
  %134 = getelementptr inbounds float, ptr %pad_temp, i64 %133, !dbg !191
  %135 = load float, ptr %134, align 4, !dbg !191, !tbaa !198
  %136 = getelementptr inbounds float, ptr %W, i64 %131, !dbg !191
  %137 = load float, ptr %136, align 4, !dbg !191, !tbaa !217
  %138 = tail call float @llvm.fmuladd.f32(float %135, float %137, float %.lcssa40.lcssa44.us.us.us.us.us.us.us.us.us), !dbg !191
    #dbg_declare(i64 1, !216, !DIExpression(), !191)
    #dbg_declare(i64 1, !216, !DIExpression(), !191)
  %gep169 = getelementptr float, ptr %invariant.gep168, i64 %133, !dbg !191
  %139 = load float, ptr %gep169, align 4, !dbg !191, !tbaa !198
  %gep171 = getelementptr float, ptr %invariant.gep170, i64 %131, !dbg !191
  %140 = load float, ptr %gep171, align 4, !dbg !191, !tbaa !217
  %141 = tail call float @llvm.fmuladd.f32(float %139, float %140, float %138), !dbg !191
    #dbg_declare(i64 2, !216, !DIExpression(), !191)
    #dbg_declare(i64 2, !216, !DIExpression(), !191)
  %gep173 = getelementptr float, ptr %invariant.gep172, i64 %133, !dbg !191
  %142 = load float, ptr %gep173, align 4, !dbg !191, !tbaa !198
  %gep175 = getelementptr float, ptr %invariant.gep174, i64 %131, !dbg !191
  %143 = load float, ptr %gep175, align 4, !dbg !191, !tbaa !217
  %144 = tail call float @llvm.fmuladd.f32(float %142, float %143, float %141), !dbg !191
    #dbg_declare(i64 3, !216, !DIExpression(), !191)
    #dbg_declare(i64 1, !215, !DIExpression(), !191)
    #dbg_declare(i64 1, !215, !DIExpression(), !191)
  %145 = add nuw nsw i64 %129, 1
  %146 = mul nuw nsw i64 %145, %107
  %147 = add nsw i64 %146, %indvars.iv129
  %148 = add nsw i64 %131, %108
    #dbg_declare(i32 0, !216, !DIExpression(), !191)
    #dbg_declare(i64 0, !216, !DIExpression(), !191)
  %149 = getelementptr inbounds float, ptr %pad_temp, i64 %147, !dbg !191
  %150 = load float, ptr %149, align 4, !dbg !191, !tbaa !198
  %151 = getelementptr inbounds float, ptr %W, i64 %148, !dbg !191
  %152 = load float, ptr %151, align 4, !dbg !191, !tbaa !217
  %153 = tail call float @llvm.fmuladd.f32(float %150, float %152, float %144), !dbg !191
    #dbg_declare(i64 1, !216, !DIExpression(), !191)
    #dbg_declare(i64 1, !216, !DIExpression(), !191)
  %gep177 = getelementptr float, ptr %invariant.gep176, i64 %147, !dbg !191
  %154 = load float, ptr %gep177, align 4, !dbg !191, !tbaa !198
  %gep179 = getelementptr float, ptr %invariant.gep178, i64 %148, !dbg !191
  %155 = load float, ptr %gep179, align 4, !dbg !191, !tbaa !217
  %156 = tail call float @llvm.fmuladd.f32(float %154, float %155, float %153), !dbg !191
    #dbg_declare(i64 2, !216, !DIExpression(), !191)
    #dbg_declare(i64 2, !216, !DIExpression(), !191)
  %gep181 = getelementptr float, ptr %invariant.gep180, i64 %147, !dbg !191
  %157 = load float, ptr %gep181, align 4, !dbg !191, !tbaa !198
  %gep183 = getelementptr float, ptr %invariant.gep182, i64 %148, !dbg !191
  %158 = load float, ptr %gep183, align 4, !dbg !191, !tbaa !217
  %159 = tail call float @llvm.fmuladd.f32(float %157, float %158, float %156), !dbg !191
    #dbg_declare(i64 3, !216, !DIExpression(), !191)
    #dbg_declare(i64 2, !215, !DIExpression(), !191)
    #dbg_declare(i64 2, !215, !DIExpression(), !191)
  %160 = add nuw nsw i64 %129, 2
  %161 = mul nuw nsw i64 %160, %107
  %162 = add nsw i64 %161, %indvars.iv129
  %163 = add nsw i64 %131, %118
    #dbg_declare(i32 0, !216, !DIExpression(), !191)
    #dbg_declare(i64 0, !216, !DIExpression(), !191)
  %164 = getelementptr inbounds float, ptr %pad_temp, i64 %162, !dbg !191
  %165 = load float, ptr %164, align 4, !dbg !191, !tbaa !198
  %166 = getelementptr inbounds float, ptr %W, i64 %163, !dbg !191
  %167 = load float, ptr %166, align 4, !dbg !191, !tbaa !217
  %168 = tail call float @llvm.fmuladd.f32(float %165, float %167, float %159), !dbg !191
    #dbg_declare(i64 1, !216, !DIExpression(), !191)
    #dbg_declare(i64 1, !216, !DIExpression(), !191)
  %gep185 = getelementptr float, ptr %invariant.gep184, i64 %162, !dbg !191
  %169 = load float, ptr %gep185, align 4, !dbg !191, !tbaa !198
  %gep187 = getelementptr float, ptr %invariant.gep186, i64 %163, !dbg !191
  %170 = load float, ptr %gep187, align 4, !dbg !191, !tbaa !217
  %171 = tail call float @llvm.fmuladd.f32(float %169, float %170, float %168), !dbg !191
    #dbg_declare(i64 2, !216, !DIExpression(), !191)
    #dbg_declare(i64 2, !216, !DIExpression(), !191)
  %gep189 = getelementptr float, ptr %invariant.gep188, i64 %162, !dbg !191
  %172 = load float, ptr %gep189, align 4, !dbg !191, !tbaa !198
  %gep191 = getelementptr float, ptr %invariant.gep190, i64 %163, !dbg !191
  %173 = load float, ptr %gep191, align 4, !dbg !191, !tbaa !217
  %174 = tail call float @llvm.fmuladd.f32(float %172, float %173, float %171), !dbg !191
    #dbg_declare(i64 3, !216, !DIExpression(), !191)
    #dbg_declare(i64 3, !215, !DIExpression(), !191)
  %indvars.iv.next125 = add nuw nsw i64 %indvars.iv124, 1, !dbg !191
    #dbg_declare(i64 %indvars.iv.next125, !214, !DIExpression(), !191)
  %exitcond128.not = icmp eq i64 %indvars.iv.next125, %wide.trip.count127, !dbg !191
  br i1 %exitcond128.not, label %for_begin_rc.for_end_rc_crit_edge.us.us.us.us.us.us.us.us.us, label %for_begin_ry.preheader.us.us.us.us.us.us.us.us.us.for_begin_ry.preheader.us.us.us.us.us.us.us.us.us_crit_edge, !dbg !191, !prof !200

for_begin_ry.preheader.us.us.us.us.us.us.us.us.us.for_begin_ry.preheader.us.us.us.us.us.us.us.us.us_crit_edge: ; preds = %for_begin_ry.preheader.us.us.us.us.us.us.us.us.us
  call void @llvm.instrprof.increment(ptr @__profn_TVMMod_default_function_compute_, i64 46134000452360265, i32 171, i32 0), !dbg !191
  br label %for_begin_ry.preheader.us.us.us.us.us.us.us.us.us, !dbg !191

for_begin_rc.for_end_rc_crit_edge.us.us.us.us.us.us.us.us.us: ; preds = %for_begin_ry.preheader.us.us.us.us.us.us.us.us.us
  call void @llvm.instrprof.increment(ptr @__profn_TVMMod_default_function_compute_, i64 46134000452360265, i32 171, i32 2)
  store float %174, ptr %126, align 4, !tbaa !219
  %indvars.iv.next130 = add nuw nsw i64 %indvars.iv129, 1, !dbg !191
    #dbg_declare(i64 %indvars.iv.next130, !213, !DIExpression(), !191)
  %exitcond133.not = icmp eq i64 %indvars.iv.next130, %wide.trip.count132, !dbg !191
  br i1 %exitcond133.not, label %for_begin_xx.for_end_xx_crit_edge.split.us.us.us.us.us.us.us.us.us, label %for_body_xx.us.us.us.us.us.us.us.us.us, !dbg !191, !prof !200

for_begin_xx.for_end_xx_crit_edge.split.us.us.us.us.us.us.us.us.us: ; preds = %for_begin_rc.for_end_rc_crit_edge.us.us.us.us.us.us.us.us.us
  call void @llvm.instrprof.increment(ptr @__profn_TVMMod_default_function_compute_, i64 46134000452360265, i32 171, i32 8), !dbg !191
  %indvars.iv.next135 = add nuw nsw i64 %indvars.iv134, 1, !dbg !191
    #dbg_declare(i64 %indvars.iv.next135, !212, !DIExpression(), !191)
  %exitcond138.not = icmp eq i64 %indvars.iv.next135, %wide.trip.count137, !dbg !191
  br i1 %exitcond138.not, label %for_begin_yy.for_end_yy_crit_edge.split.us.split.us.us.us.us.us.us.us, label %for_begin_xx.preheader.us.us.us.us.us.us.us.us, !dbg !191, !prof !200

for_begin_yy.for_end_yy_crit_edge.split.us.split.us.us.us.us.us.us.us: ; preds = %for_begin_xx.for_end_xx_crit_edge.split.us.us.us.us.us.us.us.us.us
  call void @llvm.instrprof.increment(ptr @__profn_TVMMod_default_function_compute_, i64 46134000452360265, i32 171, i32 132), !dbg !191
  %indvars.iv.next140 = add nuw nsw i64 %indvars.iv139, 1, !dbg !191
    #dbg_declare(i64 %indvars.iv.next140, !211, !DIExpression(), !191)
  %exitcond142.not = icmp eq i64 %indvars.iv.next140, 16, !dbg !191
  br i1 %exitcond142.not, label %for_end_ff.split.us.split.us.split.us.us.us.us, label %for_begin_yy.preheader.us.us.us.us.us.us, !dbg !191, !prof !221

for_end_ff.split.us.split.us.split.us.us.us.us:   ; preds = %for_begin_yy.for_end_yy_crit_edge.split.us.split.us.us.us.us.us.us.us
  call void @llvm.instrprof.increment(ptr @__profn_TVMMod_default_function_compute_, i64 46134000452360265, i32 171, i32 133), !dbg !191
  %indvars.iv.next144 = add nuw nsw i64 %indvars.iv143, 1, !dbg !191
    #dbg_declare(i64 %indvars.iv.next144, !208, !DIExpression(), !191)
  %exitcond147.not = icmp eq i64 %indvars.iv.next144, %wide.trip.count146, !dbg !191
  br i1 %exitcond147.not, label %for_end_ff.split.us.split.us.split.us.us.us.us.for_end_nn_crit_edge, label %for_begin_ff.preheader.us.us.us, !dbg !191, !prof !200

for_end_ff.split.us.split.us.split.us.us.us.us.for_end_nn_crit_edge: ; preds = %for_end_ff.split.us.split.us.split.us.us.us.us
  call void @llvm.instrprof.increment(ptr @__profn_TVMMod_default_function_compute_, i64 46134000452360265, i32 171, i32 134), !dbg !191
  br label %for_end_nn, !dbg !191

for_begin_ff.preheader.us.us:                     ; preds = %for_begin_yy.for_end_yy_crit_edge.split.us.split.us59.us.us.us.15, %for_begin_ff.preheader.us.us.preheader
  %indvars.iv111 = phi i64 [ 0, %for_begin_ff.preheader.us.us.preheader ], [ %indvars.iv.next112, %for_begin_yy.for_end_yy_crit_edge.split.us.split.us59.us.us.us.15 ]
    #dbg_declare(i64 %indvars.iv111, !208, !DIExpression(), !191)
    #dbg_declare(i32 0, !211, !DIExpression(), !191)
  %175 = mul nsw i64 %indvars.iv111, %75
    #dbg_declare(i64 0, !211, !DIExpression(), !191)
    #dbg_declare(i32 0, !212, !DIExpression(), !191)
  %176 = getelementptr float, ptr %conv2d_nchw, i64 %175
  br label %for_begin_xx.preheader.us.us57.us.us.us, !dbg !191

for_begin_xx.preheader.us.us57.us.us.us:          ; preds = %for_begin_xx.for_end_xx_crit_edge.split.us50.us.us.us.us, %for_begin_ff.preheader.us.us
  %indvars.iv102 = phi i64 [ %indvars.iv.next103, %for_begin_xx.for_end_xx_crit_edge.split.us50.us.us.us.us ], [ 0, %for_begin_ff.preheader.us.us ]
    #dbg_declare(i64 %indvars.iv102, !212, !DIExpression(), !191)
    #dbg_declare(i32 0, !213, !DIExpression(), !191)
  %177 = mul nsw i64 %indvars.iv102, %73
  %178 = getelementptr float, ptr %176, i64 %177
  br i1 %or.cond390, label %vector.body386, label %for_begin_xx.preheader.us.us57.us.us.us.for_body_xx.us48.us.us.us.us.preheader_crit_edge, !dbg !191, !prof !222

for_begin_xx.preheader.us.us57.us.us.us.for_body_xx.us48.us.us.us.us.preheader_crit_edge: ; preds = %for_begin_xx.preheader.us.us57.us.us.us
  call void @llvm.instrprof.increment(ptr @__profn_TVMMod_default_function_compute_, i64 46134000452360265, i32 171, i32 77), !dbg !191
  br label %for_body_xx.us48.us.us.us.us.preheader, !dbg !191

vector.body386:                                   ; preds = %vector.body386.vector.body386_crit_edge, %for_begin_xx.preheader.us.us57.us.us.us
  %index387 = phi i64 [ %index.next388, %vector.body386.vector.body386_crit_edge ], [ 0, %for_begin_xx.preheader.us.us57.us.us.us ], !dbg !191
  %179 = getelementptr float, ptr %178, i64 %index387, !dbg !191
  %180 = getelementptr i8, ptr %179, i64 16, !dbg !191
  store <4 x float> zeroinitializer, ptr %179, align 4, !dbg !191, !tbaa !219
  store <4 x float> zeroinitializer, ptr %180, align 4, !dbg !191, !tbaa !219
  %index.next388 = add nuw i64 %index387, 8, !dbg !191
  %181 = icmp eq i64 %index.next388, %n.vec384, !dbg !191
  br i1 %181, label %middle.block379, label %vector.body386.vector.body386_crit_edge, !dbg !191, !prof !223, !llvm.loop !224

vector.body386.vector.body386_crit_edge:          ; preds = %vector.body386
  call void @llvm.instrprof.increment(ptr @__profn_TVMMod_default_function_compute_, i64 46134000452360265, i32 171, i32 10), !dbg !191
  br label %vector.body386, !dbg !191

middle.block379:                                  ; preds = %vector.body386
  call void @llvm.instrprof.increment(ptr @__profn_TVMMod_default_function_compute_, i64 46134000452360265, i32 171, i32 135), !dbg !191
  br i1 %cmp.n389, label %middle.block379.for_begin_xx.for_end_xx_crit_edge.split.us50.us.us.us.us_crit_edge, label %for_body_xx.us48.us.us.us.us.preheader, !dbg !191, !prof !227

middle.block379.for_begin_xx.for_end_xx_crit_edge.split.us50.us.us.us.us_crit_edge: ; preds = %middle.block379
  call void @llvm.instrprof.increment(ptr @__profn_TVMMod_default_function_compute_, i64 46134000452360265, i32 171, i32 60), !dbg !191
  br label %for_begin_xx.for_end_xx_crit_edge.split.us50.us.us.us.us, !dbg !191

for_body_xx.us48.us.us.us.us.preheader:           ; preds = %for_begin_xx.preheader.us.us57.us.us.us.for_body_xx.us48.us.us.us.us.preheader_crit_edge, %middle.block379
  %indvars.iv97.ph = phi i64 [ 0, %for_begin_xx.preheader.us.us57.us.us.us.for_body_xx.us48.us.us.us.us.preheader_crit_edge ], [ %n.vec384, %middle.block379 ]
  br i1 %lcmp.mod408.not, label %for_body_xx.us48.us.us.us.us.prol.loopexit, label %for_body_xx.us48.us.us.us.us.preheader.for_body_xx.us48.us.us.us.us.prol_crit_edge, !dbg !191, !prof !194

for_body_xx.us48.us.us.us.us.preheader.for_body_xx.us48.us.us.us.us.prol_crit_edge: ; preds = %for_body_xx.us48.us.us.us.us.preheader
  call void @llvm.instrprof.increment(ptr @__profn_TVMMod_default_function_compute_, i64 46134000452360265, i32 171, i32 93), !dbg !191
  br label %for_body_xx.us48.us.us.us.us.prol, !dbg !191

for_body_xx.us48.us.us.us.us.prol:                ; preds = %for_body_xx.us48.us.us.us.us.preheader.for_body_xx.us48.us.us.us.us.prol_crit_edge, %for_body_xx.us48.us.us.us.us.prol.for_body_xx.us48.us.us.us.us.prol_crit_edge
  %indvars.iv97.prol = phi i64 [ %indvars.iv.next98.prol, %for_body_xx.us48.us.us.us.us.prol.for_body_xx.us48.us.us.us.us.prol_crit_edge ], [ %indvars.iv97.ph, %for_body_xx.us48.us.us.us.us.preheader.for_body_xx.us48.us.us.us.us.prol_crit_edge ]
  %prol.iter = phi i64 [ %prol.iter.next, %for_body_xx.us48.us.us.us.us.prol.for_body_xx.us48.us.us.us.us.prol_crit_edge ], [ 0, %for_body_xx.us48.us.us.us.us.preheader.for_body_xx.us48.us.us.us.us.prol_crit_edge ]
    #dbg_declare(i64 %indvars.iv97.prol, !213, !DIExpression(), !191)
  %182 = mul nsw i64 %indvars.iv97.prol, %72, !dbg !191
  %183 = getelementptr float, ptr %178, i64 %182, !dbg !191
  store float 0.000000e+00, ptr %183, align 4, !dbg !191, !tbaa !219
    #dbg_declare(i32 0, !214, !DIExpression(), !191)
  %indvars.iv.next98.prol = add nuw nsw i64 %indvars.iv97.prol, 1, !dbg !191
    #dbg_declare(i64 %indvars.iv.next98.prol, !213, !DIExpression(), !191)
  %prol.iter.next = add i64 %prol.iter, 1, !dbg !191
  %prol.iter.cmp.not = icmp eq i64 %prol.iter.next, %xtraiter407, !dbg !191
  br i1 %prol.iter.cmp.not, label %for_body_xx.us48.us.us.us.us.prol.loopexit, label %for_body_xx.us48.us.us.us.us.prol.for_body_xx.us48.us.us.us.us.prol_crit_edge, !dbg !191, !prof !207, !llvm.loop !228

for_body_xx.us48.us.us.us.us.prol.for_body_xx.us48.us.us.us.us.prol_crit_edge: ; preds = %for_body_xx.us48.us.us.us.us.prol
  call void @llvm.instrprof.increment(ptr @__profn_TVMMod_default_function_compute_, i64 46134000452360265, i32 171, i32 28), !dbg !191
  br label %for_body_xx.us48.us.us.us.us.prol, !dbg !191

for_body_xx.us48.us.us.us.us.prol.loopexit:       ; preds = %for_body_xx.us48.us.us.us.us.prol, %for_body_xx.us48.us.us.us.us.preheader
  %indvars.iv97.unr = phi i64 [ %indvars.iv97.ph, %for_body_xx.us48.us.us.us.us.preheader ], [ %indvars.iv.next98.prol, %for_body_xx.us48.us.us.us.us.prol ]
  %184 = sub nsw i64 %indvars.iv97.ph, %wide.trip.count100, !dbg !191
  %185 = icmp ugt i64 %184, -4, !dbg !191
  br i1 %185, label %for_body_xx.us48.us.us.us.us.prol.loopexit.for_begin_xx.for_end_xx_crit_edge.split.us50.us.us.us.us_crit_edge, label %for_body_xx.us48.us.us.us.us, !dbg !191, !prof !201

for_body_xx.us48.us.us.us.us.prol.loopexit.for_begin_xx.for_end_xx_crit_edge.split.us50.us.us.us.us_crit_edge: ; preds = %for_body_xx.us48.us.us.us.us.prol.loopexit
  call void @llvm.instrprof.increment(ptr @__profn_TVMMod_default_function_compute_, i64 46134000452360265, i32 171, i32 94), !dbg !191
  br label %for_begin_xx.for_end_xx_crit_edge.split.us50.us.us.us.us, !dbg !191

for_body_xx.us48.us.us.us.us:                     ; preds = %for_body_xx.us48.us.us.us.us.for_body_xx.us48.us.us.us.us_crit_edge, %for_body_xx.us48.us.us.us.us.prol.loopexit
  %indvars.iv97 = phi i64 [ %indvars.iv.next98.3416, %for_body_xx.us48.us.us.us.us.for_body_xx.us48.us.us.us.us_crit_edge ], [ %indvars.iv97.unr, %for_body_xx.us48.us.us.us.us.prol.loopexit ]
    #dbg_declare(i64 %indvars.iv97, !213, !DIExpression(), !191)
  %186 = mul nsw i64 %indvars.iv97, %72, !dbg !191
  %187 = getelementptr float, ptr %178, i64 %186, !dbg !191
  store float 0.000000e+00, ptr %187, align 4, !dbg !191, !tbaa !219
    #dbg_declare(i32 0, !214, !DIExpression(), !191)
  %indvars.iv.next98 = add nuw nsw i64 %indvars.iv97, 1, !dbg !191
    #dbg_declare(i64 %indvars.iv.next98, !213, !DIExpression(), !191)
    #dbg_declare(i64 %indvars.iv.next98, !213, !DIExpression(), !191)
  %188 = mul nsw i64 %indvars.iv.next98, %72, !dbg !191
  %189 = getelementptr float, ptr %178, i64 %188, !dbg !191
  store float 0.000000e+00, ptr %189, align 4, !dbg !191, !tbaa !219
    #dbg_declare(i32 0, !214, !DIExpression(), !191)
  %indvars.iv.next98.1410 = add nuw nsw i64 %indvars.iv97, 2, !dbg !191
    #dbg_declare(i64 %indvars.iv.next98.1410, !213, !DIExpression(), !191)
    #dbg_declare(i64 %indvars.iv.next98.1410, !213, !DIExpression(), !191)
  %190 = mul nsw i64 %indvars.iv.next98.1410, %72, !dbg !191
  %191 = getelementptr float, ptr %178, i64 %190, !dbg !191
  store float 0.000000e+00, ptr %191, align 4, !dbg !191, !tbaa !219
    #dbg_declare(i32 0, !214, !DIExpression(), !191)
  %indvars.iv.next98.2413 = add nuw nsw i64 %indvars.iv97, 3, !dbg !191
    #dbg_declare(i64 %indvars.iv.next98.2413, !213, !DIExpression(), !191)
    #dbg_declare(i64 %indvars.iv.next98.2413, !213, !DIExpression(), !191)
  %192 = mul nsw i64 %indvars.iv.next98.2413, %72, !dbg !191
  %193 = getelementptr float, ptr %178, i64 %192, !dbg !191
  store float 0.000000e+00, ptr %193, align 4, !dbg !191, !tbaa !219
    #dbg_declare(i32 0, !214, !DIExpression(), !191)
  %indvars.iv.next98.3416 = add nuw nsw i64 %indvars.iv97, 4, !dbg !191
    #dbg_declare(i64 %indvars.iv.next98.3416, !213, !DIExpression(), !191)
  %exitcond101.not.3 = icmp eq i64 %indvars.iv.next98.3416, %wide.trip.count100, !dbg !191
  br i1 %exitcond101.not.3, label %for_begin_xx.for_end_xx_crit_edge.split.us50.us.us.us.us, label %for_body_xx.us48.us.us.us.us.for_body_xx.us48.us.us.us.us_crit_edge, !dbg !191, !prof !230, !llvm.loop !231

for_body_xx.us48.us.us.us.us.for_body_xx.us48.us.us.us.us_crit_edge: ; preds = %for_body_xx.us48.us.us.us.us
  call void @llvm.instrprof.increment(ptr @__profn_TVMMod_default_function_compute_, i64 46134000452360265, i32 171, i32 29), !dbg !191
  br label %for_body_xx.us48.us.us.us.us, !dbg !191

for_begin_xx.for_end_xx_crit_edge.split.us50.us.us.us.us: ; preds = %for_body_xx.us48.us.us.us.us.prol.loopexit.for_begin_xx.for_end_xx_crit_edge.split.us50.us.us.us.us_crit_edge, %middle.block379.for_begin_xx.for_end_xx_crit_edge.split.us50.us.us.us.us_crit_edge, %for_body_xx.us48.us.us.us.us
  %indvars.iv.next103 = add nuw nsw i64 %indvars.iv102, 1, !dbg !191
    #dbg_declare(i64 %indvars.iv.next103, !212, !DIExpression(), !191)
  %exitcond106.not = icmp eq i64 %indvars.iv.next103, %wide.trip.count105, !dbg !191
  br i1 %exitcond106.not, label %for_begin_yy.for_end_yy_crit_edge.split.us.split.us59.us.us.us, label %for_begin_xx.preheader.us.us57.us.us.us, !dbg !191, !prof !200

for_begin_yy.for_end_yy_crit_edge.split.us.split.us59.us.us.us: ; preds = %for_begin_xx.for_end_xx_crit_edge.split.us50.us.us.us.us
    #dbg_declare(i64 1, !211, !DIExpression(), !191)
    #dbg_declare(i64 1, !211, !DIExpression(), !191)
    #dbg_declare(i32 0, !212, !DIExpression(), !191)
  %gep167 = getelementptr float, ptr %invariant.gep166, i64 %175
  br label %for_begin_xx.preheader.us.us57.us.us.us.1, !dbg !191

for_begin_xx.preheader.us.us57.us.us.us.1:        ; preds = %for_begin_xx.for_end_xx_crit_edge.split.us50.us.us.us.us.1, %for_begin_yy.for_end_yy_crit_edge.split.us.split.us59.us.us.us
  %indvars.iv102.1 = phi i64 [ %indvars.iv.next103.1, %for_begin_xx.for_end_xx_crit_edge.split.us50.us.us.us.us.1 ], [ 0, %for_begin_yy.for_end_yy_crit_edge.split.us.split.us59.us.us.us ]
    #dbg_declare(i64 %indvars.iv102.1, !212, !DIExpression(), !191)
    #dbg_declare(i32 0, !213, !DIExpression(), !191)
  %194 = mul nsw i64 %indvars.iv102.1, %73
  %195 = getelementptr float, ptr %gep167, i64 %194
  br i1 %or.cond391, label %vector.body373, label %for_begin_xx.preheader.us.us57.us.us.us.1.for_body_xx.us48.us.us.us.us.1.preheader_crit_edge, !dbg !191, !prof !222

for_begin_xx.preheader.us.us57.us.us.us.1.for_body_xx.us48.us.us.us.us.1.preheader_crit_edge: ; preds = %for_begin_xx.preheader.us.us57.us.us.us.1
  call void @llvm.instrprof.increment(ptr @__profn_TVMMod_default_function_compute_, i64 46134000452360265, i32 171, i32 78), !dbg !191
  br label %for_body_xx.us48.us.us.us.us.1.preheader, !dbg !191

vector.body373:                                   ; preds = %vector.body373.vector.body373_crit_edge, %for_begin_xx.preheader.us.us57.us.us.us.1
  %index374 = phi i64 [ %index.next375, %vector.body373.vector.body373_crit_edge ], [ 0, %for_begin_xx.preheader.us.us57.us.us.us.1 ], !dbg !191
  %196 = getelementptr float, ptr %195, i64 %index374, !dbg !191
  %197 = getelementptr i8, ptr %196, i64 16, !dbg !191
  store <4 x float> zeroinitializer, ptr %196, align 4, !dbg !191, !tbaa !219
  store <4 x float> zeroinitializer, ptr %197, align 4, !dbg !191, !tbaa !219
  %index.next375 = add nuw i64 %index374, 8, !dbg !191
  %198 = icmp eq i64 %index.next375, %n.vec371, !dbg !191
  br i1 %198, label %middle.block366, label %vector.body373.vector.body373_crit_edge, !dbg !191, !prof !223, !llvm.loop !232

vector.body373.vector.body373_crit_edge:          ; preds = %vector.body373
  call void @llvm.instrprof.increment(ptr @__profn_TVMMod_default_function_compute_, i64 46134000452360265, i32 171, i32 11), !dbg !191
  br label %vector.body373, !dbg !191

middle.block366:                                  ; preds = %vector.body373
  call void @llvm.instrprof.increment(ptr @__profn_TVMMod_default_function_compute_, i64 46134000452360265, i32 171, i32 136), !dbg !191
  br i1 %cmp.n376, label %middle.block366.for_begin_xx.for_end_xx_crit_edge.split.us50.us.us.us.us.1_crit_edge, label %for_body_xx.us48.us.us.us.us.1.preheader, !dbg !191, !prof !227

middle.block366.for_begin_xx.for_end_xx_crit_edge.split.us50.us.us.us.us.1_crit_edge: ; preds = %middle.block366
  call void @llvm.instrprof.increment(ptr @__profn_TVMMod_default_function_compute_, i64 46134000452360265, i32 171, i32 61), !dbg !191
  br label %for_begin_xx.for_end_xx_crit_edge.split.us50.us.us.us.us.1, !dbg !191

for_body_xx.us48.us.us.us.us.1.preheader:         ; preds = %for_begin_xx.preheader.us.us57.us.us.us.1.for_body_xx.us48.us.us.us.us.1.preheader_crit_edge, %middle.block366
  %indvars.iv97.1.ph = phi i64 [ 0, %for_begin_xx.preheader.us.us57.us.us.us.1.for_body_xx.us48.us.us.us.us.1.preheader_crit_edge ], [ %n.vec371, %middle.block366 ]
  br i1 %lcmp.mod419.not, label %for_body_xx.us48.us.us.us.us.1.prol.loopexit, label %for_body_xx.us48.us.us.us.us.1.preheader.for_body_xx.us48.us.us.us.us.1.prol_crit_edge, !dbg !191, !prof !194

for_body_xx.us48.us.us.us.us.1.preheader.for_body_xx.us48.us.us.us.us.1.prol_crit_edge: ; preds = %for_body_xx.us48.us.us.us.us.1.preheader
  call void @llvm.instrprof.increment(ptr @__profn_TVMMod_default_function_compute_, i64 46134000452360265, i32 171, i32 95), !dbg !191
  br label %for_body_xx.us48.us.us.us.us.1.prol, !dbg !191

for_body_xx.us48.us.us.us.us.1.prol:              ; preds = %for_body_xx.us48.us.us.us.us.1.preheader.for_body_xx.us48.us.us.us.us.1.prol_crit_edge, %for_body_xx.us48.us.us.us.us.1.prol.for_body_xx.us48.us.us.us.us.1.prol_crit_edge
  %indvars.iv97.1.prol = phi i64 [ %indvars.iv.next98.1.prol, %for_body_xx.us48.us.us.us.us.1.prol.for_body_xx.us48.us.us.us.us.1.prol_crit_edge ], [ %indvars.iv97.1.ph, %for_body_xx.us48.us.us.us.us.1.preheader.for_body_xx.us48.us.us.us.us.1.prol_crit_edge ]
  %prol.iter420 = phi i64 [ %prol.iter420.next, %for_body_xx.us48.us.us.us.us.1.prol.for_body_xx.us48.us.us.us.us.1.prol_crit_edge ], [ 0, %for_body_xx.us48.us.us.us.us.1.preheader.for_body_xx.us48.us.us.us.us.1.prol_crit_edge ]
    #dbg_declare(i64 %indvars.iv97.1.prol, !213, !DIExpression(), !191)
  %199 = mul nsw i64 %indvars.iv97.1.prol, %72, !dbg !191
  %200 = getelementptr float, ptr %195, i64 %199, !dbg !191
  store float 0.000000e+00, ptr %200, align 4, !dbg !191, !tbaa !219
    #dbg_declare(i32 0, !214, !DIExpression(), !191)
  %indvars.iv.next98.1.prol = add nuw nsw i64 %indvars.iv97.1.prol, 1, !dbg !191
    #dbg_declare(i64 %indvars.iv.next98.1.prol, !213, !DIExpression(), !191)
  %prol.iter420.next = add i64 %prol.iter420, 1, !dbg !191
  %prol.iter420.cmp.not = icmp eq i64 %prol.iter420.next, %xtraiter418, !dbg !191
  br i1 %prol.iter420.cmp.not, label %for_body_xx.us48.us.us.us.us.1.prol.loopexit, label %for_body_xx.us48.us.us.us.us.1.prol.for_body_xx.us48.us.us.us.us.1.prol_crit_edge, !dbg !191, !prof !207, !llvm.loop !233

for_body_xx.us48.us.us.us.us.1.prol.for_body_xx.us48.us.us.us.us.1.prol_crit_edge: ; preds = %for_body_xx.us48.us.us.us.us.1.prol
  call void @llvm.instrprof.increment(ptr @__profn_TVMMod_default_function_compute_, i64 46134000452360265, i32 171, i32 30), !dbg !191
  br label %for_body_xx.us48.us.us.us.us.1.prol, !dbg !191

for_body_xx.us48.us.us.us.us.1.prol.loopexit:     ; preds = %for_body_xx.us48.us.us.us.us.1.prol, %for_body_xx.us48.us.us.us.us.1.preheader
  %indvars.iv97.1.unr = phi i64 [ %indvars.iv97.1.ph, %for_body_xx.us48.us.us.us.us.1.preheader ], [ %indvars.iv.next98.1.prol, %for_body_xx.us48.us.us.us.us.1.prol ]
  %201 = sub nsw i64 %indvars.iv97.1.ph, %wide.trip.count100, !dbg !191
  %202 = icmp ugt i64 %201, -4, !dbg !191
  br i1 %202, label %for_body_xx.us48.us.us.us.us.1.prol.loopexit.for_begin_xx.for_end_xx_crit_edge.split.us50.us.us.us.us.1_crit_edge, label %for_body_xx.us48.us.us.us.us.1, !dbg !191, !prof !201

for_body_xx.us48.us.us.us.us.1.prol.loopexit.for_begin_xx.for_end_xx_crit_edge.split.us50.us.us.us.us.1_crit_edge: ; preds = %for_body_xx.us48.us.us.us.us.1.prol.loopexit
  call void @llvm.instrprof.increment(ptr @__profn_TVMMod_default_function_compute_, i64 46134000452360265, i32 171, i32 96), !dbg !191
  br label %for_begin_xx.for_end_xx_crit_edge.split.us50.us.us.us.us.1, !dbg !191

for_body_xx.us48.us.us.us.us.1:                   ; preds = %for_body_xx.us48.us.us.us.us.1.for_body_xx.us48.us.us.us.us.1_crit_edge, %for_body_xx.us48.us.us.us.us.1.prol.loopexit
  %indvars.iv97.1 = phi i64 [ %indvars.iv.next98.1.3, %for_body_xx.us48.us.us.us.us.1.for_body_xx.us48.us.us.us.us.1_crit_edge ], [ %indvars.iv97.1.unr, %for_body_xx.us48.us.us.us.us.1.prol.loopexit ]
    #dbg_declare(i64 %indvars.iv97.1, !213, !DIExpression(), !191)
  %203 = mul nsw i64 %indvars.iv97.1, %72, !dbg !191
  %204 = getelementptr float, ptr %195, i64 %203, !dbg !191
  store float 0.000000e+00, ptr %204, align 4, !dbg !191, !tbaa !219
    #dbg_declare(i32 0, !214, !DIExpression(), !191)
  %indvars.iv.next98.1 = add nuw nsw i64 %indvars.iv97.1, 1, !dbg !191
    #dbg_declare(i64 %indvars.iv.next98.1, !213, !DIExpression(), !191)
    #dbg_declare(i64 %indvars.iv.next98.1, !213, !DIExpression(), !191)
  %205 = mul nsw i64 %indvars.iv.next98.1, %72, !dbg !191
  %206 = getelementptr float, ptr %195, i64 %205, !dbg !191
  store float 0.000000e+00, ptr %206, align 4, !dbg !191, !tbaa !219
    #dbg_declare(i32 0, !214, !DIExpression(), !191)
  %indvars.iv.next98.1.1 = add nuw nsw i64 %indvars.iv97.1, 2, !dbg !191
    #dbg_declare(i64 %indvars.iv.next98.1.1, !213, !DIExpression(), !191)
    #dbg_declare(i64 %indvars.iv.next98.1.1, !213, !DIExpression(), !191)
  %207 = mul nsw i64 %indvars.iv.next98.1.1, %72, !dbg !191
  %208 = getelementptr float, ptr %195, i64 %207, !dbg !191
  store float 0.000000e+00, ptr %208, align 4, !dbg !191, !tbaa !219
    #dbg_declare(i32 0, !214, !DIExpression(), !191)
  %indvars.iv.next98.1.2 = add nuw nsw i64 %indvars.iv97.1, 3, !dbg !191
    #dbg_declare(i64 %indvars.iv.next98.1.2, !213, !DIExpression(), !191)
    #dbg_declare(i64 %indvars.iv.next98.1.2, !213, !DIExpression(), !191)
  %209 = mul nsw i64 %indvars.iv.next98.1.2, %72, !dbg !191
  %210 = getelementptr float, ptr %195, i64 %209, !dbg !191
  store float 0.000000e+00, ptr %210, align 4, !dbg !191, !tbaa !219
    #dbg_declare(i32 0, !214, !DIExpression(), !191)
  %indvars.iv.next98.1.3 = add nuw nsw i64 %indvars.iv97.1, 4, !dbg !191
    #dbg_declare(i64 %indvars.iv.next98.1.3, !213, !DIExpression(), !191)
  %exitcond101.1.not.3 = icmp eq i64 %indvars.iv.next98.1.3, %wide.trip.count100, !dbg !191
  br i1 %exitcond101.1.not.3, label %for_begin_xx.for_end_xx_crit_edge.split.us50.us.us.us.us.1, label %for_body_xx.us48.us.us.us.us.1.for_body_xx.us48.us.us.us.us.1_crit_edge, !dbg !191, !prof !230, !llvm.loop !234

for_body_xx.us48.us.us.us.us.1.for_body_xx.us48.us.us.us.us.1_crit_edge: ; preds = %for_body_xx.us48.us.us.us.us.1
  call void @llvm.instrprof.increment(ptr @__profn_TVMMod_default_function_compute_, i64 46134000452360265, i32 171, i32 31), !dbg !191
  br label %for_body_xx.us48.us.us.us.us.1, !dbg !191

for_begin_xx.for_end_xx_crit_edge.split.us50.us.us.us.us.1: ; preds = %for_body_xx.us48.us.us.us.us.1.prol.loopexit.for_begin_xx.for_end_xx_crit_edge.split.us50.us.us.us.us.1_crit_edge, %middle.block366.for_begin_xx.for_end_xx_crit_edge.split.us50.us.us.us.us.1_crit_edge, %for_body_xx.us48.us.us.us.us.1
  %indvars.iv.next103.1 = add nuw nsw i64 %indvars.iv102.1, 1, !dbg !191
    #dbg_declare(i64 %indvars.iv.next103.1, !212, !DIExpression(), !191)
  %exitcond106.1.not = icmp eq i64 %indvars.iv.next103.1, %wide.trip.count105, !dbg !191
  br i1 %exitcond106.1.not, label %for_begin_yy.for_end_yy_crit_edge.split.us.split.us59.us.us.us.1, label %for_begin_xx.preheader.us.us57.us.us.us.1, !dbg !191, !prof !200

for_begin_yy.for_end_yy_crit_edge.split.us.split.us59.us.us.us.1: ; preds = %for_begin_xx.for_end_xx_crit_edge.split.us50.us.us.us.us.1
    #dbg_declare(i64 2, !211, !DIExpression(), !191)
    #dbg_declare(i64 2, !211, !DIExpression(), !191)
    #dbg_declare(i32 0, !212, !DIExpression(), !191)
  %211 = getelementptr float, ptr %76, i64 %175
  br label %for_begin_xx.preheader.us.us57.us.us.us.2, !dbg !191

for_begin_xx.preheader.us.us57.us.us.us.2:        ; preds = %for_begin_xx.for_end_xx_crit_edge.split.us50.us.us.us.us.2, %for_begin_yy.for_end_yy_crit_edge.split.us.split.us59.us.us.us.1
  %indvars.iv102.2 = phi i64 [ %indvars.iv.next103.2, %for_begin_xx.for_end_xx_crit_edge.split.us50.us.us.us.us.2 ], [ 0, %for_begin_yy.for_end_yy_crit_edge.split.us.split.us59.us.us.us.1 ]
    #dbg_declare(i64 %indvars.iv102.2, !212, !DIExpression(), !191)
    #dbg_declare(i32 0, !213, !DIExpression(), !191)
  %212 = mul nsw i64 %indvars.iv102.2, %73
  %213 = getelementptr float, ptr %211, i64 %212
  br i1 %or.cond392, label %vector.body360, label %for_begin_xx.preheader.us.us57.us.us.us.2.for_body_xx.us48.us.us.us.us.2.preheader_crit_edge, !dbg !191, !prof !222

for_begin_xx.preheader.us.us57.us.us.us.2.for_body_xx.us48.us.us.us.us.2.preheader_crit_edge: ; preds = %for_begin_xx.preheader.us.us57.us.us.us.2
  call void @llvm.instrprof.increment(ptr @__profn_TVMMod_default_function_compute_, i64 46134000452360265, i32 171, i32 79), !dbg !191
  br label %for_body_xx.us48.us.us.us.us.2.preheader, !dbg !191

vector.body360:                                   ; preds = %vector.body360.vector.body360_crit_edge, %for_begin_xx.preheader.us.us57.us.us.us.2
  %index361 = phi i64 [ %index.next362, %vector.body360.vector.body360_crit_edge ], [ 0, %for_begin_xx.preheader.us.us57.us.us.us.2 ], !dbg !191
  %214 = getelementptr float, ptr %213, i64 %index361, !dbg !191
  %215 = getelementptr i8, ptr %214, i64 16, !dbg !191
  store <4 x float> zeroinitializer, ptr %214, align 4, !dbg !191, !tbaa !219
  store <4 x float> zeroinitializer, ptr %215, align 4, !dbg !191, !tbaa !219
  %index.next362 = add nuw i64 %index361, 8, !dbg !191
  %216 = icmp eq i64 %index.next362, %n.vec358, !dbg !191
  br i1 %216, label %middle.block353, label %vector.body360.vector.body360_crit_edge, !dbg !191, !prof !223, !llvm.loop !235

vector.body360.vector.body360_crit_edge:          ; preds = %vector.body360
  call void @llvm.instrprof.increment(ptr @__profn_TVMMod_default_function_compute_, i64 46134000452360265, i32 171, i32 12), !dbg !191
  br label %vector.body360, !dbg !191

middle.block353:                                  ; preds = %vector.body360
  call void @llvm.instrprof.increment(ptr @__profn_TVMMod_default_function_compute_, i64 46134000452360265, i32 171, i32 137), !dbg !191
  br i1 %cmp.n363, label %middle.block353.for_begin_xx.for_end_xx_crit_edge.split.us50.us.us.us.us.2_crit_edge, label %for_body_xx.us48.us.us.us.us.2.preheader, !dbg !191, !prof !227

middle.block353.for_begin_xx.for_end_xx_crit_edge.split.us50.us.us.us.us.2_crit_edge: ; preds = %middle.block353
  call void @llvm.instrprof.increment(ptr @__profn_TVMMod_default_function_compute_, i64 46134000452360265, i32 171, i32 62), !dbg !191
  br label %for_begin_xx.for_end_xx_crit_edge.split.us50.us.us.us.us.2, !dbg !191

for_body_xx.us48.us.us.us.us.2.preheader:         ; preds = %for_begin_xx.preheader.us.us57.us.us.us.2.for_body_xx.us48.us.us.us.us.2.preheader_crit_edge, %middle.block353
  %indvars.iv97.2.ph = phi i64 [ 0, %for_begin_xx.preheader.us.us57.us.us.us.2.for_body_xx.us48.us.us.us.us.2.preheader_crit_edge ], [ %n.vec358, %middle.block353 ]
  br i1 %lcmp.mod422.not, label %for_body_xx.us48.us.us.us.us.2.prol.loopexit, label %for_body_xx.us48.us.us.us.us.2.preheader.for_body_xx.us48.us.us.us.us.2.prol_crit_edge, !dbg !191, !prof !194

for_body_xx.us48.us.us.us.us.2.preheader.for_body_xx.us48.us.us.us.us.2.prol_crit_edge: ; preds = %for_body_xx.us48.us.us.us.us.2.preheader
  call void @llvm.instrprof.increment(ptr @__profn_TVMMod_default_function_compute_, i64 46134000452360265, i32 171, i32 97), !dbg !191
  br label %for_body_xx.us48.us.us.us.us.2.prol, !dbg !191

for_body_xx.us48.us.us.us.us.2.prol:              ; preds = %for_body_xx.us48.us.us.us.us.2.preheader.for_body_xx.us48.us.us.us.us.2.prol_crit_edge, %for_body_xx.us48.us.us.us.us.2.prol.for_body_xx.us48.us.us.us.us.2.prol_crit_edge
  %indvars.iv97.2.prol = phi i64 [ %indvars.iv.next98.2.prol, %for_body_xx.us48.us.us.us.us.2.prol.for_body_xx.us48.us.us.us.us.2.prol_crit_edge ], [ %indvars.iv97.2.ph, %for_body_xx.us48.us.us.us.us.2.preheader.for_body_xx.us48.us.us.us.us.2.prol_crit_edge ]
  %prol.iter423 = phi i64 [ %prol.iter423.next, %for_body_xx.us48.us.us.us.us.2.prol.for_body_xx.us48.us.us.us.us.2.prol_crit_edge ], [ 0, %for_body_xx.us48.us.us.us.us.2.preheader.for_body_xx.us48.us.us.us.us.2.prol_crit_edge ]
    #dbg_declare(i64 %indvars.iv97.2.prol, !213, !DIExpression(), !191)
  %217 = mul nsw i64 %indvars.iv97.2.prol, %72, !dbg !191
  %218 = getelementptr float, ptr %213, i64 %217, !dbg !191
  store float 0.000000e+00, ptr %218, align 4, !dbg !191, !tbaa !219
    #dbg_declare(i32 0, !214, !DIExpression(), !191)
  %indvars.iv.next98.2.prol = add nuw nsw i64 %indvars.iv97.2.prol, 1, !dbg !191
    #dbg_declare(i64 %indvars.iv.next98.2.prol, !213, !DIExpression(), !191)
  %prol.iter423.next = add i64 %prol.iter423, 1, !dbg !191
  %prol.iter423.cmp.not = icmp eq i64 %prol.iter423.next, %xtraiter421, !dbg !191
  br i1 %prol.iter423.cmp.not, label %for_body_xx.us48.us.us.us.us.2.prol.loopexit, label %for_body_xx.us48.us.us.us.us.2.prol.for_body_xx.us48.us.us.us.us.2.prol_crit_edge, !dbg !191, !prof !207, !llvm.loop !236

for_body_xx.us48.us.us.us.us.2.prol.for_body_xx.us48.us.us.us.us.2.prol_crit_edge: ; preds = %for_body_xx.us48.us.us.us.us.2.prol
  call void @llvm.instrprof.increment(ptr @__profn_TVMMod_default_function_compute_, i64 46134000452360265, i32 171, i32 32), !dbg !191
  br label %for_body_xx.us48.us.us.us.us.2.prol, !dbg !191

for_body_xx.us48.us.us.us.us.2.prol.loopexit:     ; preds = %for_body_xx.us48.us.us.us.us.2.prol, %for_body_xx.us48.us.us.us.us.2.preheader
  %indvars.iv97.2.unr = phi i64 [ %indvars.iv97.2.ph, %for_body_xx.us48.us.us.us.us.2.preheader ], [ %indvars.iv.next98.2.prol, %for_body_xx.us48.us.us.us.us.2.prol ]
  %219 = sub nsw i64 %indvars.iv97.2.ph, %wide.trip.count100, !dbg !191
  %220 = icmp ugt i64 %219, -4, !dbg !191
  br i1 %220, label %for_body_xx.us48.us.us.us.us.2.prol.loopexit.for_begin_xx.for_end_xx_crit_edge.split.us50.us.us.us.us.2_crit_edge, label %for_body_xx.us48.us.us.us.us.2, !dbg !191, !prof !201

for_body_xx.us48.us.us.us.us.2.prol.loopexit.for_begin_xx.for_end_xx_crit_edge.split.us50.us.us.us.us.2_crit_edge: ; preds = %for_body_xx.us48.us.us.us.us.2.prol.loopexit
  call void @llvm.instrprof.increment(ptr @__profn_TVMMod_default_function_compute_, i64 46134000452360265, i32 171, i32 98), !dbg !191
  br label %for_begin_xx.for_end_xx_crit_edge.split.us50.us.us.us.us.2, !dbg !191

for_body_xx.us48.us.us.us.us.2:                   ; preds = %for_body_xx.us48.us.us.us.us.2.for_body_xx.us48.us.us.us.us.2_crit_edge, %for_body_xx.us48.us.us.us.us.2.prol.loopexit
  %indvars.iv97.2 = phi i64 [ %indvars.iv.next98.2.3, %for_body_xx.us48.us.us.us.us.2.for_body_xx.us48.us.us.us.us.2_crit_edge ], [ %indvars.iv97.2.unr, %for_body_xx.us48.us.us.us.us.2.prol.loopexit ]
    #dbg_declare(i64 %indvars.iv97.2, !213, !DIExpression(), !191)
  %221 = mul nsw i64 %indvars.iv97.2, %72, !dbg !191
  %222 = getelementptr float, ptr %213, i64 %221, !dbg !191
  store float 0.000000e+00, ptr %222, align 4, !dbg !191, !tbaa !219
    #dbg_declare(i32 0, !214, !DIExpression(), !191)
  %indvars.iv.next98.2 = add nuw nsw i64 %indvars.iv97.2, 1, !dbg !191
    #dbg_declare(i64 %indvars.iv.next98.2, !213, !DIExpression(), !191)
    #dbg_declare(i64 %indvars.iv.next98.2, !213, !DIExpression(), !191)
  %223 = mul nsw i64 %indvars.iv.next98.2, %72, !dbg !191
  %224 = getelementptr float, ptr %213, i64 %223, !dbg !191
  store float 0.000000e+00, ptr %224, align 4, !dbg !191, !tbaa !219
    #dbg_declare(i32 0, !214, !DIExpression(), !191)
  %indvars.iv.next98.2.1 = add nuw nsw i64 %indvars.iv97.2, 2, !dbg !191
    #dbg_declare(i64 %indvars.iv.next98.2.1, !213, !DIExpression(), !191)
    #dbg_declare(i64 %indvars.iv.next98.2.1, !213, !DIExpression(), !191)
  %225 = mul nsw i64 %indvars.iv.next98.2.1, %72, !dbg !191
  %226 = getelementptr float, ptr %213, i64 %225, !dbg !191
  store float 0.000000e+00, ptr %226, align 4, !dbg !191, !tbaa !219
    #dbg_declare(i32 0, !214, !DIExpression(), !191)
  %indvars.iv.next98.2.2 = add nuw nsw i64 %indvars.iv97.2, 3, !dbg !191
    #dbg_declare(i64 %indvars.iv.next98.2.2, !213, !DIExpression(), !191)
    #dbg_declare(i64 %indvars.iv.next98.2.2, !213, !DIExpression(), !191)
  %227 = mul nsw i64 %indvars.iv.next98.2.2, %72, !dbg !191
  %228 = getelementptr float, ptr %213, i64 %227, !dbg !191
  store float 0.000000e+00, ptr %228, align 4, !dbg !191, !tbaa !219
    #dbg_declare(i32 0, !214, !DIExpression(), !191)
  %indvars.iv.next98.2.3 = add nuw nsw i64 %indvars.iv97.2, 4, !dbg !191
    #dbg_declare(i64 %indvars.iv.next98.2.3, !213, !DIExpression(), !191)
  %exitcond101.2.not.3 = icmp eq i64 %indvars.iv.next98.2.3, %wide.trip.count100, !dbg !191
  br i1 %exitcond101.2.not.3, label %for_begin_xx.for_end_xx_crit_edge.split.us50.us.us.us.us.2, label %for_body_xx.us48.us.us.us.us.2.for_body_xx.us48.us.us.us.us.2_crit_edge, !dbg !191, !prof !230, !llvm.loop !237

for_body_xx.us48.us.us.us.us.2.for_body_xx.us48.us.us.us.us.2_crit_edge: ; preds = %for_body_xx.us48.us.us.us.us.2
  call void @llvm.instrprof.increment(ptr @__profn_TVMMod_default_function_compute_, i64 46134000452360265, i32 171, i32 33), !dbg !191
  br label %for_body_xx.us48.us.us.us.us.2, !dbg !191

for_begin_xx.for_end_xx_crit_edge.split.us50.us.us.us.us.2: ; preds = %for_body_xx.us48.us.us.us.us.2.prol.loopexit.for_begin_xx.for_end_xx_crit_edge.split.us50.us.us.us.us.2_crit_edge, %middle.block353.for_begin_xx.for_end_xx_crit_edge.split.us50.us.us.us.us.2_crit_edge, %for_body_xx.us48.us.us.us.us.2
  %indvars.iv.next103.2 = add nuw nsw i64 %indvars.iv102.2, 1, !dbg !191
    #dbg_declare(i64 %indvars.iv.next103.2, !212, !DIExpression(), !191)
  %exitcond106.2.not = icmp eq i64 %indvars.iv.next103.2, %wide.trip.count105, !dbg !191
  br i1 %exitcond106.2.not, label %for_begin_yy.for_end_yy_crit_edge.split.us.split.us59.us.us.us.2, label %for_begin_xx.preheader.us.us57.us.us.us.2, !dbg !191, !prof !200

for_begin_yy.for_end_yy_crit_edge.split.us.split.us59.us.us.us.2: ; preds = %for_begin_xx.for_end_xx_crit_edge.split.us50.us.us.us.us.2
    #dbg_declare(i64 3, !211, !DIExpression(), !191)
    #dbg_declare(i64 3, !211, !DIExpression(), !191)
    #dbg_declare(i32 0, !212, !DIExpression(), !191)
  %229 = getelementptr float, ptr %77, i64 %175
  br label %for_begin_xx.preheader.us.us57.us.us.us.3, !dbg !191

for_begin_xx.preheader.us.us57.us.us.us.3:        ; preds = %for_begin_xx.for_end_xx_crit_edge.split.us50.us.us.us.us.3, %for_begin_yy.for_end_yy_crit_edge.split.us.split.us59.us.us.us.2
  %indvars.iv102.3 = phi i64 [ %indvars.iv.next103.3, %for_begin_xx.for_end_xx_crit_edge.split.us50.us.us.us.us.3 ], [ 0, %for_begin_yy.for_end_yy_crit_edge.split.us.split.us59.us.us.us.2 ]
    #dbg_declare(i64 %indvars.iv102.3, !212, !DIExpression(), !191)
    #dbg_declare(i32 0, !213, !DIExpression(), !191)
  %230 = mul nsw i64 %indvars.iv102.3, %73
  %231 = getelementptr float, ptr %229, i64 %230
  br i1 %or.cond393, label %vector.body347, label %for_begin_xx.preheader.us.us57.us.us.us.3.for_body_xx.us48.us.us.us.us.3.preheader_crit_edge, !dbg !191, !prof !222

for_begin_xx.preheader.us.us57.us.us.us.3.for_body_xx.us48.us.us.us.us.3.preheader_crit_edge: ; preds = %for_begin_xx.preheader.us.us57.us.us.us.3
  call void @llvm.instrprof.increment(ptr @__profn_TVMMod_default_function_compute_, i64 46134000452360265, i32 171, i32 80), !dbg !191
  br label %for_body_xx.us48.us.us.us.us.3.preheader, !dbg !191

vector.body347:                                   ; preds = %vector.body347.vector.body347_crit_edge, %for_begin_xx.preheader.us.us57.us.us.us.3
  %index348 = phi i64 [ %index.next349, %vector.body347.vector.body347_crit_edge ], [ 0, %for_begin_xx.preheader.us.us57.us.us.us.3 ], !dbg !191
  %232 = getelementptr float, ptr %231, i64 %index348, !dbg !191
  %233 = getelementptr i8, ptr %232, i64 16, !dbg !191
  store <4 x float> zeroinitializer, ptr %232, align 4, !dbg !191, !tbaa !219
  store <4 x float> zeroinitializer, ptr %233, align 4, !dbg !191, !tbaa !219
  %index.next349 = add nuw i64 %index348, 8, !dbg !191
  %234 = icmp eq i64 %index.next349, %n.vec345, !dbg !191
  br i1 %234, label %middle.block340, label %vector.body347.vector.body347_crit_edge, !dbg !191, !prof !223, !llvm.loop !238

vector.body347.vector.body347_crit_edge:          ; preds = %vector.body347
  call void @llvm.instrprof.increment(ptr @__profn_TVMMod_default_function_compute_, i64 46134000452360265, i32 171, i32 13), !dbg !191
  br label %vector.body347, !dbg !191

middle.block340:                                  ; preds = %vector.body347
  call void @llvm.instrprof.increment(ptr @__profn_TVMMod_default_function_compute_, i64 46134000452360265, i32 171, i32 138), !dbg !191
  br i1 %cmp.n350, label %middle.block340.for_begin_xx.for_end_xx_crit_edge.split.us50.us.us.us.us.3_crit_edge, label %for_body_xx.us48.us.us.us.us.3.preheader, !dbg !191, !prof !227

middle.block340.for_begin_xx.for_end_xx_crit_edge.split.us50.us.us.us.us.3_crit_edge: ; preds = %middle.block340
  call void @llvm.instrprof.increment(ptr @__profn_TVMMod_default_function_compute_, i64 46134000452360265, i32 171, i32 63), !dbg !191
  br label %for_begin_xx.for_end_xx_crit_edge.split.us50.us.us.us.us.3, !dbg !191

for_body_xx.us48.us.us.us.us.3.preheader:         ; preds = %for_begin_xx.preheader.us.us57.us.us.us.3.for_body_xx.us48.us.us.us.us.3.preheader_crit_edge, %middle.block340
  %indvars.iv97.3.ph = phi i64 [ 0, %for_begin_xx.preheader.us.us57.us.us.us.3.for_body_xx.us48.us.us.us.us.3.preheader_crit_edge ], [ %n.vec345, %middle.block340 ]
  br i1 %lcmp.mod425.not, label %for_body_xx.us48.us.us.us.us.3.prol.loopexit, label %for_body_xx.us48.us.us.us.us.3.preheader.for_body_xx.us48.us.us.us.us.3.prol_crit_edge, !dbg !191, !prof !194

for_body_xx.us48.us.us.us.us.3.preheader.for_body_xx.us48.us.us.us.us.3.prol_crit_edge: ; preds = %for_body_xx.us48.us.us.us.us.3.preheader
  call void @llvm.instrprof.increment(ptr @__profn_TVMMod_default_function_compute_, i64 46134000452360265, i32 171, i32 99), !dbg !191
  br label %for_body_xx.us48.us.us.us.us.3.prol, !dbg !191

for_body_xx.us48.us.us.us.us.3.prol:              ; preds = %for_body_xx.us48.us.us.us.us.3.preheader.for_body_xx.us48.us.us.us.us.3.prol_crit_edge, %for_body_xx.us48.us.us.us.us.3.prol.for_body_xx.us48.us.us.us.us.3.prol_crit_edge
  %indvars.iv97.3.prol = phi i64 [ %indvars.iv.next98.3.prol, %for_body_xx.us48.us.us.us.us.3.prol.for_body_xx.us48.us.us.us.us.3.prol_crit_edge ], [ %indvars.iv97.3.ph, %for_body_xx.us48.us.us.us.us.3.preheader.for_body_xx.us48.us.us.us.us.3.prol_crit_edge ]
  %prol.iter426 = phi i64 [ %prol.iter426.next, %for_body_xx.us48.us.us.us.us.3.prol.for_body_xx.us48.us.us.us.us.3.prol_crit_edge ], [ 0, %for_body_xx.us48.us.us.us.us.3.preheader.for_body_xx.us48.us.us.us.us.3.prol_crit_edge ]
    #dbg_declare(i64 %indvars.iv97.3.prol, !213, !DIExpression(), !191)
  %235 = mul nsw i64 %indvars.iv97.3.prol, %72, !dbg !191
  %236 = getelementptr float, ptr %231, i64 %235, !dbg !191
  store float 0.000000e+00, ptr %236, align 4, !dbg !191, !tbaa !219
    #dbg_declare(i32 0, !214, !DIExpression(), !191)
  %indvars.iv.next98.3.prol = add nuw nsw i64 %indvars.iv97.3.prol, 1, !dbg !191
    #dbg_declare(i64 %indvars.iv.next98.3.prol, !213, !DIExpression(), !191)
  %prol.iter426.next = add i64 %prol.iter426, 1, !dbg !191
  %prol.iter426.cmp.not = icmp eq i64 %prol.iter426.next, %xtraiter424, !dbg !191
  br i1 %prol.iter426.cmp.not, label %for_body_xx.us48.us.us.us.us.3.prol.loopexit, label %for_body_xx.us48.us.us.us.us.3.prol.for_body_xx.us48.us.us.us.us.3.prol_crit_edge, !dbg !191, !prof !207, !llvm.loop !239

for_body_xx.us48.us.us.us.us.3.prol.for_body_xx.us48.us.us.us.us.3.prol_crit_edge: ; preds = %for_body_xx.us48.us.us.us.us.3.prol
  call void @llvm.instrprof.increment(ptr @__profn_TVMMod_default_function_compute_, i64 46134000452360265, i32 171, i32 34), !dbg !191
  br label %for_body_xx.us48.us.us.us.us.3.prol, !dbg !191

for_body_xx.us48.us.us.us.us.3.prol.loopexit:     ; preds = %for_body_xx.us48.us.us.us.us.3.prol, %for_body_xx.us48.us.us.us.us.3.preheader
  %indvars.iv97.3.unr = phi i64 [ %indvars.iv97.3.ph, %for_body_xx.us48.us.us.us.us.3.preheader ], [ %indvars.iv.next98.3.prol, %for_body_xx.us48.us.us.us.us.3.prol ]
  %237 = sub nsw i64 %indvars.iv97.3.ph, %wide.trip.count100, !dbg !191
  %238 = icmp ugt i64 %237, -4, !dbg !191
  br i1 %238, label %for_body_xx.us48.us.us.us.us.3.prol.loopexit.for_begin_xx.for_end_xx_crit_edge.split.us50.us.us.us.us.3_crit_edge, label %for_body_xx.us48.us.us.us.us.3, !dbg !191, !prof !201

for_body_xx.us48.us.us.us.us.3.prol.loopexit.for_begin_xx.for_end_xx_crit_edge.split.us50.us.us.us.us.3_crit_edge: ; preds = %for_body_xx.us48.us.us.us.us.3.prol.loopexit
  call void @llvm.instrprof.increment(ptr @__profn_TVMMod_default_function_compute_, i64 46134000452360265, i32 171, i32 100), !dbg !191
  br label %for_begin_xx.for_end_xx_crit_edge.split.us50.us.us.us.us.3, !dbg !191

for_body_xx.us48.us.us.us.us.3:                   ; preds = %for_body_xx.us48.us.us.us.us.3.for_body_xx.us48.us.us.us.us.3_crit_edge, %for_body_xx.us48.us.us.us.us.3.prol.loopexit
  %indvars.iv97.3 = phi i64 [ %indvars.iv.next98.3.3, %for_body_xx.us48.us.us.us.us.3.for_body_xx.us48.us.us.us.us.3_crit_edge ], [ %indvars.iv97.3.unr, %for_body_xx.us48.us.us.us.us.3.prol.loopexit ]
    #dbg_declare(i64 %indvars.iv97.3, !213, !DIExpression(), !191)
  %239 = mul nsw i64 %indvars.iv97.3, %72, !dbg !191
  %240 = getelementptr float, ptr %231, i64 %239, !dbg !191
  store float 0.000000e+00, ptr %240, align 4, !dbg !191, !tbaa !219
    #dbg_declare(i32 0, !214, !DIExpression(), !191)
  %indvars.iv.next98.3 = add nuw nsw i64 %indvars.iv97.3, 1, !dbg !191
    #dbg_declare(i64 %indvars.iv.next98.3, !213, !DIExpression(), !191)
    #dbg_declare(i64 %indvars.iv.next98.3, !213, !DIExpression(), !191)
  %241 = mul nsw i64 %indvars.iv.next98.3, %72, !dbg !191
  %242 = getelementptr float, ptr %231, i64 %241, !dbg !191
  store float 0.000000e+00, ptr %242, align 4, !dbg !191, !tbaa !219
    #dbg_declare(i32 0, !214, !DIExpression(), !191)
  %indvars.iv.next98.3.1 = add nuw nsw i64 %indvars.iv97.3, 2, !dbg !191
    #dbg_declare(i64 %indvars.iv.next98.3.1, !213, !DIExpression(), !191)
    #dbg_declare(i64 %indvars.iv.next98.3.1, !213, !DIExpression(), !191)
  %243 = mul nsw i64 %indvars.iv.next98.3.1, %72, !dbg !191
  %244 = getelementptr float, ptr %231, i64 %243, !dbg !191
  store float 0.000000e+00, ptr %244, align 4, !dbg !191, !tbaa !219
    #dbg_declare(i32 0, !214, !DIExpression(), !191)
  %indvars.iv.next98.3.2 = add nuw nsw i64 %indvars.iv97.3, 3, !dbg !191
    #dbg_declare(i64 %indvars.iv.next98.3.2, !213, !DIExpression(), !191)
    #dbg_declare(i64 %indvars.iv.next98.3.2, !213, !DIExpression(), !191)
  %245 = mul nsw i64 %indvars.iv.next98.3.2, %72, !dbg !191
  %246 = getelementptr float, ptr %231, i64 %245, !dbg !191
  store float 0.000000e+00, ptr %246, align 4, !dbg !191, !tbaa !219
    #dbg_declare(i32 0, !214, !DIExpression(), !191)
  %indvars.iv.next98.3.3 = add nuw nsw i64 %indvars.iv97.3, 4, !dbg !191
    #dbg_declare(i64 %indvars.iv.next98.3.3, !213, !DIExpression(), !191)
  %exitcond101.3.not.3 = icmp eq i64 %indvars.iv.next98.3.3, %wide.trip.count100, !dbg !191
  br i1 %exitcond101.3.not.3, label %for_begin_xx.for_end_xx_crit_edge.split.us50.us.us.us.us.3, label %for_body_xx.us48.us.us.us.us.3.for_body_xx.us48.us.us.us.us.3_crit_edge, !dbg !191, !prof !230, !llvm.loop !240

for_body_xx.us48.us.us.us.us.3.for_body_xx.us48.us.us.us.us.3_crit_edge: ; preds = %for_body_xx.us48.us.us.us.us.3
  call void @llvm.instrprof.increment(ptr @__profn_TVMMod_default_function_compute_, i64 46134000452360265, i32 171, i32 35), !dbg !191
  br label %for_body_xx.us48.us.us.us.us.3, !dbg !191

for_begin_xx.for_end_xx_crit_edge.split.us50.us.us.us.us.3: ; preds = %for_body_xx.us48.us.us.us.us.3.prol.loopexit.for_begin_xx.for_end_xx_crit_edge.split.us50.us.us.us.us.3_crit_edge, %middle.block340.for_begin_xx.for_end_xx_crit_edge.split.us50.us.us.us.us.3_crit_edge, %for_body_xx.us48.us.us.us.us.3
  %indvars.iv.next103.3 = add nuw nsw i64 %indvars.iv102.3, 1, !dbg !191
    #dbg_declare(i64 %indvars.iv.next103.3, !212, !DIExpression(), !191)
  %exitcond106.3.not = icmp eq i64 %indvars.iv.next103.3, %wide.trip.count105, !dbg !191
  br i1 %exitcond106.3.not, label %for_begin_yy.for_end_yy_crit_edge.split.us.split.us59.us.us.us.3, label %for_begin_xx.preheader.us.us57.us.us.us.3, !dbg !191, !prof !200

for_begin_yy.for_end_yy_crit_edge.split.us.split.us59.us.us.us.3: ; preds = %for_begin_xx.for_end_xx_crit_edge.split.us50.us.us.us.us.3
    #dbg_declare(i64 4, !211, !DIExpression(), !191)
    #dbg_declare(i64 4, !211, !DIExpression(), !191)
    #dbg_declare(i32 0, !212, !DIExpression(), !191)
  %247 = getelementptr float, ptr %78, i64 %175
  br label %for_begin_xx.preheader.us.us57.us.us.us.4, !dbg !191

for_begin_xx.preheader.us.us57.us.us.us.4:        ; preds = %for_begin_xx.for_end_xx_crit_edge.split.us50.us.us.us.us.4, %for_begin_yy.for_end_yy_crit_edge.split.us.split.us59.us.us.us.3
  %indvars.iv102.4 = phi i64 [ %indvars.iv.next103.4, %for_begin_xx.for_end_xx_crit_edge.split.us50.us.us.us.us.4 ], [ 0, %for_begin_yy.for_end_yy_crit_edge.split.us.split.us59.us.us.us.3 ]
    #dbg_declare(i64 %indvars.iv102.4, !212, !DIExpression(), !191)
    #dbg_declare(i32 0, !213, !DIExpression(), !191)
  %248 = mul nsw i64 %indvars.iv102.4, %73
  %249 = getelementptr float, ptr %247, i64 %248
  br i1 %or.cond394, label %vector.body334, label %for_begin_xx.preheader.us.us57.us.us.us.4.for_body_xx.us48.us.us.us.us.4.preheader_crit_edge, !dbg !191, !prof !222

for_begin_xx.preheader.us.us57.us.us.us.4.for_body_xx.us48.us.us.us.us.4.preheader_crit_edge: ; preds = %for_begin_xx.preheader.us.us57.us.us.us.4
  call void @llvm.instrprof.increment(ptr @__profn_TVMMod_default_function_compute_, i64 46134000452360265, i32 171, i32 81), !dbg !191
  br label %for_body_xx.us48.us.us.us.us.4.preheader, !dbg !191

vector.body334:                                   ; preds = %vector.body334.vector.body334_crit_edge, %for_begin_xx.preheader.us.us57.us.us.us.4
  %index335 = phi i64 [ %index.next336, %vector.body334.vector.body334_crit_edge ], [ 0, %for_begin_xx.preheader.us.us57.us.us.us.4 ], !dbg !191
  %250 = getelementptr float, ptr %249, i64 %index335, !dbg !191
  %251 = getelementptr i8, ptr %250, i64 16, !dbg !191
  store <4 x float> zeroinitializer, ptr %250, align 4, !dbg !191, !tbaa !219
  store <4 x float> zeroinitializer, ptr %251, align 4, !dbg !191, !tbaa !219
  %index.next336 = add nuw i64 %index335, 8, !dbg !191
  %252 = icmp eq i64 %index.next336, %n.vec332, !dbg !191
  br i1 %252, label %middle.block327, label %vector.body334.vector.body334_crit_edge, !dbg !191, !prof !223, !llvm.loop !241

vector.body334.vector.body334_crit_edge:          ; preds = %vector.body334
  call void @llvm.instrprof.increment(ptr @__profn_TVMMod_default_function_compute_, i64 46134000452360265, i32 171, i32 14), !dbg !191
  br label %vector.body334, !dbg !191

middle.block327:                                  ; preds = %vector.body334
  call void @llvm.instrprof.increment(ptr @__profn_TVMMod_default_function_compute_, i64 46134000452360265, i32 171, i32 139), !dbg !191
  br i1 %cmp.n337, label %middle.block327.for_begin_xx.for_end_xx_crit_edge.split.us50.us.us.us.us.4_crit_edge, label %for_body_xx.us48.us.us.us.us.4.preheader, !dbg !191, !prof !227

middle.block327.for_begin_xx.for_end_xx_crit_edge.split.us50.us.us.us.us.4_crit_edge: ; preds = %middle.block327
  call void @llvm.instrprof.increment(ptr @__profn_TVMMod_default_function_compute_, i64 46134000452360265, i32 171, i32 64), !dbg !191
  br label %for_begin_xx.for_end_xx_crit_edge.split.us50.us.us.us.us.4, !dbg !191

for_body_xx.us48.us.us.us.us.4.preheader:         ; preds = %for_begin_xx.preheader.us.us57.us.us.us.4.for_body_xx.us48.us.us.us.us.4.preheader_crit_edge, %middle.block327
  %indvars.iv97.4.ph = phi i64 [ 0, %for_begin_xx.preheader.us.us57.us.us.us.4.for_body_xx.us48.us.us.us.us.4.preheader_crit_edge ], [ %n.vec332, %middle.block327 ]
  br i1 %lcmp.mod428.not, label %for_body_xx.us48.us.us.us.us.4.prol.loopexit, label %for_body_xx.us48.us.us.us.us.4.preheader.for_body_xx.us48.us.us.us.us.4.prol_crit_edge, !dbg !191, !prof !194

for_body_xx.us48.us.us.us.us.4.preheader.for_body_xx.us48.us.us.us.us.4.prol_crit_edge: ; preds = %for_body_xx.us48.us.us.us.us.4.preheader
  call void @llvm.instrprof.increment(ptr @__profn_TVMMod_default_function_compute_, i64 46134000452360265, i32 171, i32 101), !dbg !191
  br label %for_body_xx.us48.us.us.us.us.4.prol, !dbg !191

for_body_xx.us48.us.us.us.us.4.prol:              ; preds = %for_body_xx.us48.us.us.us.us.4.preheader.for_body_xx.us48.us.us.us.us.4.prol_crit_edge, %for_body_xx.us48.us.us.us.us.4.prol.for_body_xx.us48.us.us.us.us.4.prol_crit_edge
  %indvars.iv97.4.prol = phi i64 [ %indvars.iv.next98.4.prol, %for_body_xx.us48.us.us.us.us.4.prol.for_body_xx.us48.us.us.us.us.4.prol_crit_edge ], [ %indvars.iv97.4.ph, %for_body_xx.us48.us.us.us.us.4.preheader.for_body_xx.us48.us.us.us.us.4.prol_crit_edge ]
  %prol.iter429 = phi i64 [ %prol.iter429.next, %for_body_xx.us48.us.us.us.us.4.prol.for_body_xx.us48.us.us.us.us.4.prol_crit_edge ], [ 0, %for_body_xx.us48.us.us.us.us.4.preheader.for_body_xx.us48.us.us.us.us.4.prol_crit_edge ]
    #dbg_declare(i64 %indvars.iv97.4.prol, !213, !DIExpression(), !191)
  %253 = mul nsw i64 %indvars.iv97.4.prol, %72, !dbg !191
  %254 = getelementptr float, ptr %249, i64 %253, !dbg !191
  store float 0.000000e+00, ptr %254, align 4, !dbg !191, !tbaa !219
    #dbg_declare(i32 0, !214, !DIExpression(), !191)
  %indvars.iv.next98.4.prol = add nuw nsw i64 %indvars.iv97.4.prol, 1, !dbg !191
    #dbg_declare(i64 %indvars.iv.next98.4.prol, !213, !DIExpression(), !191)
  %prol.iter429.next = add i64 %prol.iter429, 1, !dbg !191
  %prol.iter429.cmp.not = icmp eq i64 %prol.iter429.next, %xtraiter427, !dbg !191
  br i1 %prol.iter429.cmp.not, label %for_body_xx.us48.us.us.us.us.4.prol.loopexit, label %for_body_xx.us48.us.us.us.us.4.prol.for_body_xx.us48.us.us.us.us.4.prol_crit_edge, !dbg !191, !prof !207, !llvm.loop !242

for_body_xx.us48.us.us.us.us.4.prol.for_body_xx.us48.us.us.us.us.4.prol_crit_edge: ; preds = %for_body_xx.us48.us.us.us.us.4.prol
  call void @llvm.instrprof.increment(ptr @__profn_TVMMod_default_function_compute_, i64 46134000452360265, i32 171, i32 36), !dbg !191
  br label %for_body_xx.us48.us.us.us.us.4.prol, !dbg !191

for_body_xx.us48.us.us.us.us.4.prol.loopexit:     ; preds = %for_body_xx.us48.us.us.us.us.4.prol, %for_body_xx.us48.us.us.us.us.4.preheader
  %indvars.iv97.4.unr = phi i64 [ %indvars.iv97.4.ph, %for_body_xx.us48.us.us.us.us.4.preheader ], [ %indvars.iv.next98.4.prol, %for_body_xx.us48.us.us.us.us.4.prol ]
  %255 = sub nsw i64 %indvars.iv97.4.ph, %wide.trip.count100, !dbg !191
  %256 = icmp ugt i64 %255, -4, !dbg !191
  br i1 %256, label %for_body_xx.us48.us.us.us.us.4.prol.loopexit.for_begin_xx.for_end_xx_crit_edge.split.us50.us.us.us.us.4_crit_edge, label %for_body_xx.us48.us.us.us.us.4, !dbg !191, !prof !201

for_body_xx.us48.us.us.us.us.4.prol.loopexit.for_begin_xx.for_end_xx_crit_edge.split.us50.us.us.us.us.4_crit_edge: ; preds = %for_body_xx.us48.us.us.us.us.4.prol.loopexit
  call void @llvm.instrprof.increment(ptr @__profn_TVMMod_default_function_compute_, i64 46134000452360265, i32 171, i32 102), !dbg !191
  br label %for_begin_xx.for_end_xx_crit_edge.split.us50.us.us.us.us.4, !dbg !191

for_body_xx.us48.us.us.us.us.4:                   ; preds = %for_body_xx.us48.us.us.us.us.4.for_body_xx.us48.us.us.us.us.4_crit_edge, %for_body_xx.us48.us.us.us.us.4.prol.loopexit
  %indvars.iv97.4 = phi i64 [ %indvars.iv.next98.4.3, %for_body_xx.us48.us.us.us.us.4.for_body_xx.us48.us.us.us.us.4_crit_edge ], [ %indvars.iv97.4.unr, %for_body_xx.us48.us.us.us.us.4.prol.loopexit ]
    #dbg_declare(i64 %indvars.iv97.4, !213, !DIExpression(), !191)
  %257 = mul nsw i64 %indvars.iv97.4, %72, !dbg !191
  %258 = getelementptr float, ptr %249, i64 %257, !dbg !191
  store float 0.000000e+00, ptr %258, align 4, !dbg !191, !tbaa !219
    #dbg_declare(i32 0, !214, !DIExpression(), !191)
  %indvars.iv.next98.4 = add nuw nsw i64 %indvars.iv97.4, 1, !dbg !191
    #dbg_declare(i64 %indvars.iv.next98.4, !213, !DIExpression(), !191)
    #dbg_declare(i64 %indvars.iv.next98.4, !213, !DIExpression(), !191)
  %259 = mul nsw i64 %indvars.iv.next98.4, %72, !dbg !191
  %260 = getelementptr float, ptr %249, i64 %259, !dbg !191
  store float 0.000000e+00, ptr %260, align 4, !dbg !191, !tbaa !219
    #dbg_declare(i32 0, !214, !DIExpression(), !191)
  %indvars.iv.next98.4.1 = add nuw nsw i64 %indvars.iv97.4, 2, !dbg !191
    #dbg_declare(i64 %indvars.iv.next98.4.1, !213, !DIExpression(), !191)
    #dbg_declare(i64 %indvars.iv.next98.4.1, !213, !DIExpression(), !191)
  %261 = mul nsw i64 %indvars.iv.next98.4.1, %72, !dbg !191
  %262 = getelementptr float, ptr %249, i64 %261, !dbg !191
  store float 0.000000e+00, ptr %262, align 4, !dbg !191, !tbaa !219
    #dbg_declare(i32 0, !214, !DIExpression(), !191)
  %indvars.iv.next98.4.2 = add nuw nsw i64 %indvars.iv97.4, 3, !dbg !191
    #dbg_declare(i64 %indvars.iv.next98.4.2, !213, !DIExpression(), !191)
    #dbg_declare(i64 %indvars.iv.next98.4.2, !213, !DIExpression(), !191)
  %263 = mul nsw i64 %indvars.iv.next98.4.2, %72, !dbg !191
  %264 = getelementptr float, ptr %249, i64 %263, !dbg !191
  store float 0.000000e+00, ptr %264, align 4, !dbg !191, !tbaa !219
    #dbg_declare(i32 0, !214, !DIExpression(), !191)
  %indvars.iv.next98.4.3 = add nuw nsw i64 %indvars.iv97.4, 4, !dbg !191
    #dbg_declare(i64 %indvars.iv.next98.4.3, !213, !DIExpression(), !191)
  %exitcond101.4.not.3 = icmp eq i64 %indvars.iv.next98.4.3, %wide.trip.count100, !dbg !191
  br i1 %exitcond101.4.not.3, label %for_begin_xx.for_end_xx_crit_edge.split.us50.us.us.us.us.4, label %for_body_xx.us48.us.us.us.us.4.for_body_xx.us48.us.us.us.us.4_crit_edge, !dbg !191, !prof !230, !llvm.loop !243

for_body_xx.us48.us.us.us.us.4.for_body_xx.us48.us.us.us.us.4_crit_edge: ; preds = %for_body_xx.us48.us.us.us.us.4
  call void @llvm.instrprof.increment(ptr @__profn_TVMMod_default_function_compute_, i64 46134000452360265, i32 171, i32 37), !dbg !191
  br label %for_body_xx.us48.us.us.us.us.4, !dbg !191

for_begin_xx.for_end_xx_crit_edge.split.us50.us.us.us.us.4: ; preds = %for_body_xx.us48.us.us.us.us.4.prol.loopexit.for_begin_xx.for_end_xx_crit_edge.split.us50.us.us.us.us.4_crit_edge, %middle.block327.for_begin_xx.for_end_xx_crit_edge.split.us50.us.us.us.us.4_crit_edge, %for_body_xx.us48.us.us.us.us.4
  %indvars.iv.next103.4 = add nuw nsw i64 %indvars.iv102.4, 1, !dbg !191
    #dbg_declare(i64 %indvars.iv.next103.4, !212, !DIExpression(), !191)
  %exitcond106.4.not = icmp eq i64 %indvars.iv.next103.4, %wide.trip.count105, !dbg !191
  br i1 %exitcond106.4.not, label %for_begin_yy.for_end_yy_crit_edge.split.us.split.us59.us.us.us.4, label %for_begin_xx.preheader.us.us57.us.us.us.4, !dbg !191, !prof !200

for_begin_yy.for_end_yy_crit_edge.split.us.split.us59.us.us.us.4: ; preds = %for_begin_xx.for_end_xx_crit_edge.split.us50.us.us.us.us.4
    #dbg_declare(i64 5, !211, !DIExpression(), !191)
    #dbg_declare(i64 5, !211, !DIExpression(), !191)
    #dbg_declare(i32 0, !212, !DIExpression(), !191)
  %265 = getelementptr float, ptr %79, i64 %175
  br label %for_begin_xx.preheader.us.us57.us.us.us.5, !dbg !191

for_begin_xx.preheader.us.us57.us.us.us.5:        ; preds = %for_begin_xx.for_end_xx_crit_edge.split.us50.us.us.us.us.5, %for_begin_yy.for_end_yy_crit_edge.split.us.split.us59.us.us.us.4
  %indvars.iv102.5 = phi i64 [ %indvars.iv.next103.5, %for_begin_xx.for_end_xx_crit_edge.split.us50.us.us.us.us.5 ], [ 0, %for_begin_yy.for_end_yy_crit_edge.split.us.split.us59.us.us.us.4 ]
    #dbg_declare(i64 %indvars.iv102.5, !212, !DIExpression(), !191)
    #dbg_declare(i32 0, !213, !DIExpression(), !191)
  %266 = mul nsw i64 %indvars.iv102.5, %73
  %267 = getelementptr float, ptr %265, i64 %266
  br i1 %or.cond395, label %vector.body321, label %for_begin_xx.preheader.us.us57.us.us.us.5.for_body_xx.us48.us.us.us.us.5.preheader_crit_edge, !dbg !191, !prof !222

for_begin_xx.preheader.us.us57.us.us.us.5.for_body_xx.us48.us.us.us.us.5.preheader_crit_edge: ; preds = %for_begin_xx.preheader.us.us57.us.us.us.5
  call void @llvm.instrprof.increment(ptr @__profn_TVMMod_default_function_compute_, i64 46134000452360265, i32 171, i32 82), !dbg !191
  br label %for_body_xx.us48.us.us.us.us.5.preheader, !dbg !191

vector.body321:                                   ; preds = %vector.body321.vector.body321_crit_edge, %for_begin_xx.preheader.us.us57.us.us.us.5
  %index322 = phi i64 [ %index.next323, %vector.body321.vector.body321_crit_edge ], [ 0, %for_begin_xx.preheader.us.us57.us.us.us.5 ], !dbg !191
  %268 = getelementptr float, ptr %267, i64 %index322, !dbg !191
  %269 = getelementptr i8, ptr %268, i64 16, !dbg !191
  store <4 x float> zeroinitializer, ptr %268, align 4, !dbg !191, !tbaa !219
  store <4 x float> zeroinitializer, ptr %269, align 4, !dbg !191, !tbaa !219
  %index.next323 = add nuw i64 %index322, 8, !dbg !191
  %270 = icmp eq i64 %index.next323, %n.vec319, !dbg !191
  br i1 %270, label %middle.block314, label %vector.body321.vector.body321_crit_edge, !dbg !191, !prof !223, !llvm.loop !244

vector.body321.vector.body321_crit_edge:          ; preds = %vector.body321
  call void @llvm.instrprof.increment(ptr @__profn_TVMMod_default_function_compute_, i64 46134000452360265, i32 171, i32 15), !dbg !191
  br label %vector.body321, !dbg !191

middle.block314:                                  ; preds = %vector.body321
  call void @llvm.instrprof.increment(ptr @__profn_TVMMod_default_function_compute_, i64 46134000452360265, i32 171, i32 140), !dbg !191
  br i1 %cmp.n324, label %middle.block314.for_begin_xx.for_end_xx_crit_edge.split.us50.us.us.us.us.5_crit_edge, label %for_body_xx.us48.us.us.us.us.5.preheader, !dbg !191, !prof !227

middle.block314.for_begin_xx.for_end_xx_crit_edge.split.us50.us.us.us.us.5_crit_edge: ; preds = %middle.block314
  call void @llvm.instrprof.increment(ptr @__profn_TVMMod_default_function_compute_, i64 46134000452360265, i32 171, i32 65), !dbg !191
  br label %for_begin_xx.for_end_xx_crit_edge.split.us50.us.us.us.us.5, !dbg !191

for_body_xx.us48.us.us.us.us.5.preheader:         ; preds = %for_begin_xx.preheader.us.us57.us.us.us.5.for_body_xx.us48.us.us.us.us.5.preheader_crit_edge, %middle.block314
  %indvars.iv97.5.ph = phi i64 [ 0, %for_begin_xx.preheader.us.us57.us.us.us.5.for_body_xx.us48.us.us.us.us.5.preheader_crit_edge ], [ %n.vec319, %middle.block314 ]
  br i1 %lcmp.mod431.not, label %for_body_xx.us48.us.us.us.us.5.prol.loopexit, label %for_body_xx.us48.us.us.us.us.5.preheader.for_body_xx.us48.us.us.us.us.5.prol_crit_edge, !dbg !191, !prof !194

for_body_xx.us48.us.us.us.us.5.preheader.for_body_xx.us48.us.us.us.us.5.prol_crit_edge: ; preds = %for_body_xx.us48.us.us.us.us.5.preheader
  call void @llvm.instrprof.increment(ptr @__profn_TVMMod_default_function_compute_, i64 46134000452360265, i32 171, i32 103), !dbg !191
  br label %for_body_xx.us48.us.us.us.us.5.prol, !dbg !191

for_body_xx.us48.us.us.us.us.5.prol:              ; preds = %for_body_xx.us48.us.us.us.us.5.preheader.for_body_xx.us48.us.us.us.us.5.prol_crit_edge, %for_body_xx.us48.us.us.us.us.5.prol.for_body_xx.us48.us.us.us.us.5.prol_crit_edge
  %indvars.iv97.5.prol = phi i64 [ %indvars.iv.next98.5.prol, %for_body_xx.us48.us.us.us.us.5.prol.for_body_xx.us48.us.us.us.us.5.prol_crit_edge ], [ %indvars.iv97.5.ph, %for_body_xx.us48.us.us.us.us.5.preheader.for_body_xx.us48.us.us.us.us.5.prol_crit_edge ]
  %prol.iter432 = phi i64 [ %prol.iter432.next, %for_body_xx.us48.us.us.us.us.5.prol.for_body_xx.us48.us.us.us.us.5.prol_crit_edge ], [ 0, %for_body_xx.us48.us.us.us.us.5.preheader.for_body_xx.us48.us.us.us.us.5.prol_crit_edge ]
    #dbg_declare(i64 %indvars.iv97.5.prol, !213, !DIExpression(), !191)
  %271 = mul nsw i64 %indvars.iv97.5.prol, %72, !dbg !191
  %272 = getelementptr float, ptr %267, i64 %271, !dbg !191
  store float 0.000000e+00, ptr %272, align 4, !dbg !191, !tbaa !219
    #dbg_declare(i32 0, !214, !DIExpression(), !191)
  %indvars.iv.next98.5.prol = add nuw nsw i64 %indvars.iv97.5.prol, 1, !dbg !191
    #dbg_declare(i64 %indvars.iv.next98.5.prol, !213, !DIExpression(), !191)
  %prol.iter432.next = add i64 %prol.iter432, 1, !dbg !191
  %prol.iter432.cmp.not = icmp eq i64 %prol.iter432.next, %xtraiter430, !dbg !191
  br i1 %prol.iter432.cmp.not, label %for_body_xx.us48.us.us.us.us.5.prol.loopexit, label %for_body_xx.us48.us.us.us.us.5.prol.for_body_xx.us48.us.us.us.us.5.prol_crit_edge, !dbg !191, !prof !207, !llvm.loop !245

for_body_xx.us48.us.us.us.us.5.prol.for_body_xx.us48.us.us.us.us.5.prol_crit_edge: ; preds = %for_body_xx.us48.us.us.us.us.5.prol
  call void @llvm.instrprof.increment(ptr @__profn_TVMMod_default_function_compute_, i64 46134000452360265, i32 171, i32 38), !dbg !191
  br label %for_body_xx.us48.us.us.us.us.5.prol, !dbg !191

for_body_xx.us48.us.us.us.us.5.prol.loopexit:     ; preds = %for_body_xx.us48.us.us.us.us.5.prol, %for_body_xx.us48.us.us.us.us.5.preheader
  %indvars.iv97.5.unr = phi i64 [ %indvars.iv97.5.ph, %for_body_xx.us48.us.us.us.us.5.preheader ], [ %indvars.iv.next98.5.prol, %for_body_xx.us48.us.us.us.us.5.prol ]
  %273 = sub nsw i64 %indvars.iv97.5.ph, %wide.trip.count100, !dbg !191
  %274 = icmp ugt i64 %273, -4, !dbg !191
  br i1 %274, label %for_body_xx.us48.us.us.us.us.5.prol.loopexit.for_begin_xx.for_end_xx_crit_edge.split.us50.us.us.us.us.5_crit_edge, label %for_body_xx.us48.us.us.us.us.5, !dbg !191, !prof !201

for_body_xx.us48.us.us.us.us.5.prol.loopexit.for_begin_xx.for_end_xx_crit_edge.split.us50.us.us.us.us.5_crit_edge: ; preds = %for_body_xx.us48.us.us.us.us.5.prol.loopexit
  call void @llvm.instrprof.increment(ptr @__profn_TVMMod_default_function_compute_, i64 46134000452360265, i32 171, i32 104), !dbg !191
  br label %for_begin_xx.for_end_xx_crit_edge.split.us50.us.us.us.us.5, !dbg !191

for_body_xx.us48.us.us.us.us.5:                   ; preds = %for_body_xx.us48.us.us.us.us.5.for_body_xx.us48.us.us.us.us.5_crit_edge, %for_body_xx.us48.us.us.us.us.5.prol.loopexit
  %indvars.iv97.5 = phi i64 [ %indvars.iv.next98.5.3, %for_body_xx.us48.us.us.us.us.5.for_body_xx.us48.us.us.us.us.5_crit_edge ], [ %indvars.iv97.5.unr, %for_body_xx.us48.us.us.us.us.5.prol.loopexit ]
    #dbg_declare(i64 %indvars.iv97.5, !213, !DIExpression(), !191)
  %275 = mul nsw i64 %indvars.iv97.5, %72, !dbg !191
  %276 = getelementptr float, ptr %267, i64 %275, !dbg !191
  store float 0.000000e+00, ptr %276, align 4, !dbg !191, !tbaa !219
    #dbg_declare(i32 0, !214, !DIExpression(), !191)
  %indvars.iv.next98.5 = add nuw nsw i64 %indvars.iv97.5, 1, !dbg !191
    #dbg_declare(i64 %indvars.iv.next98.5, !213, !DIExpression(), !191)
    #dbg_declare(i64 %indvars.iv.next98.5, !213, !DIExpression(), !191)
  %277 = mul nsw i64 %indvars.iv.next98.5, %72, !dbg !191
  %278 = getelementptr float, ptr %267, i64 %277, !dbg !191
  store float 0.000000e+00, ptr %278, align 4, !dbg !191, !tbaa !219
    #dbg_declare(i32 0, !214, !DIExpression(), !191)
  %indvars.iv.next98.5.1 = add nuw nsw i64 %indvars.iv97.5, 2, !dbg !191
    #dbg_declare(i64 %indvars.iv.next98.5.1, !213, !DIExpression(), !191)
    #dbg_declare(i64 %indvars.iv.next98.5.1, !213, !DIExpression(), !191)
  %279 = mul nsw i64 %indvars.iv.next98.5.1, %72, !dbg !191
  %280 = getelementptr float, ptr %267, i64 %279, !dbg !191
  store float 0.000000e+00, ptr %280, align 4, !dbg !191, !tbaa !219
    #dbg_declare(i32 0, !214, !DIExpression(), !191)
  %indvars.iv.next98.5.2 = add nuw nsw i64 %indvars.iv97.5, 3, !dbg !191
    #dbg_declare(i64 %indvars.iv.next98.5.2, !213, !DIExpression(), !191)
    #dbg_declare(i64 %indvars.iv.next98.5.2, !213, !DIExpression(), !191)
  %281 = mul nsw i64 %indvars.iv.next98.5.2, %72, !dbg !191
  %282 = getelementptr float, ptr %267, i64 %281, !dbg !191
  store float 0.000000e+00, ptr %282, align 4, !dbg !191, !tbaa !219
    #dbg_declare(i32 0, !214, !DIExpression(), !191)
  %indvars.iv.next98.5.3 = add nuw nsw i64 %indvars.iv97.5, 4, !dbg !191
    #dbg_declare(i64 %indvars.iv.next98.5.3, !213, !DIExpression(), !191)
  %exitcond101.5.not.3 = icmp eq i64 %indvars.iv.next98.5.3, %wide.trip.count100, !dbg !191
  br i1 %exitcond101.5.not.3, label %for_begin_xx.for_end_xx_crit_edge.split.us50.us.us.us.us.5, label %for_body_xx.us48.us.us.us.us.5.for_body_xx.us48.us.us.us.us.5_crit_edge, !dbg !191, !prof !230, !llvm.loop !246

for_body_xx.us48.us.us.us.us.5.for_body_xx.us48.us.us.us.us.5_crit_edge: ; preds = %for_body_xx.us48.us.us.us.us.5
  call void @llvm.instrprof.increment(ptr @__profn_TVMMod_default_function_compute_, i64 46134000452360265, i32 171, i32 39), !dbg !191
  br label %for_body_xx.us48.us.us.us.us.5, !dbg !191

for_begin_xx.for_end_xx_crit_edge.split.us50.us.us.us.us.5: ; preds = %for_body_xx.us48.us.us.us.us.5.prol.loopexit.for_begin_xx.for_end_xx_crit_edge.split.us50.us.us.us.us.5_crit_edge, %middle.block314.for_begin_xx.for_end_xx_crit_edge.split.us50.us.us.us.us.5_crit_edge, %for_body_xx.us48.us.us.us.us.5
  %indvars.iv.next103.5 = add nuw nsw i64 %indvars.iv102.5, 1, !dbg !191
    #dbg_declare(i64 %indvars.iv.next103.5, !212, !DIExpression(), !191)
  %exitcond106.5.not = icmp eq i64 %indvars.iv.next103.5, %wide.trip.count105, !dbg !191
  br i1 %exitcond106.5.not, label %for_begin_yy.for_end_yy_crit_edge.split.us.split.us59.us.us.us.5, label %for_begin_xx.preheader.us.us57.us.us.us.5, !dbg !191, !prof !200

for_begin_yy.for_end_yy_crit_edge.split.us.split.us59.us.us.us.5: ; preds = %for_begin_xx.for_end_xx_crit_edge.split.us50.us.us.us.us.5
    #dbg_declare(i64 6, !211, !DIExpression(), !191)
    #dbg_declare(i64 6, !211, !DIExpression(), !191)
    #dbg_declare(i32 0, !212, !DIExpression(), !191)
  %283 = getelementptr float, ptr %80, i64 %175
  br label %for_begin_xx.preheader.us.us57.us.us.us.6, !dbg !191

for_begin_xx.preheader.us.us57.us.us.us.6:        ; preds = %for_begin_xx.for_end_xx_crit_edge.split.us50.us.us.us.us.6, %for_begin_yy.for_end_yy_crit_edge.split.us.split.us59.us.us.us.5
  %indvars.iv102.6 = phi i64 [ %indvars.iv.next103.6, %for_begin_xx.for_end_xx_crit_edge.split.us50.us.us.us.us.6 ], [ 0, %for_begin_yy.for_end_yy_crit_edge.split.us.split.us59.us.us.us.5 ]
    #dbg_declare(i64 %indvars.iv102.6, !212, !DIExpression(), !191)
    #dbg_declare(i32 0, !213, !DIExpression(), !191)
  %284 = mul nsw i64 %indvars.iv102.6, %73
  %285 = getelementptr float, ptr %283, i64 %284
  br i1 %or.cond396, label %vector.body308, label %for_begin_xx.preheader.us.us57.us.us.us.6.for_body_xx.us48.us.us.us.us.6.preheader_crit_edge, !dbg !191, !prof !222

for_begin_xx.preheader.us.us57.us.us.us.6.for_body_xx.us48.us.us.us.us.6.preheader_crit_edge: ; preds = %for_begin_xx.preheader.us.us57.us.us.us.6
  call void @llvm.instrprof.increment(ptr @__profn_TVMMod_default_function_compute_, i64 46134000452360265, i32 171, i32 83), !dbg !191
  br label %for_body_xx.us48.us.us.us.us.6.preheader, !dbg !191

vector.body308:                                   ; preds = %vector.body308.vector.body308_crit_edge, %for_begin_xx.preheader.us.us57.us.us.us.6
  %index309 = phi i64 [ %index.next310, %vector.body308.vector.body308_crit_edge ], [ 0, %for_begin_xx.preheader.us.us57.us.us.us.6 ], !dbg !191
  %286 = getelementptr float, ptr %285, i64 %index309, !dbg !191
  %287 = getelementptr i8, ptr %286, i64 16, !dbg !191
  store <4 x float> zeroinitializer, ptr %286, align 4, !dbg !191, !tbaa !219
  store <4 x float> zeroinitializer, ptr %287, align 4, !dbg !191, !tbaa !219
  %index.next310 = add nuw i64 %index309, 8, !dbg !191
  %288 = icmp eq i64 %index.next310, %n.vec306, !dbg !191
  br i1 %288, label %middle.block301, label %vector.body308.vector.body308_crit_edge, !dbg !191, !prof !223, !llvm.loop !247

vector.body308.vector.body308_crit_edge:          ; preds = %vector.body308
  call void @llvm.instrprof.increment(ptr @__profn_TVMMod_default_function_compute_, i64 46134000452360265, i32 171, i32 16), !dbg !191
  br label %vector.body308, !dbg !191

middle.block301:                                  ; preds = %vector.body308
  call void @llvm.instrprof.increment(ptr @__profn_TVMMod_default_function_compute_, i64 46134000452360265, i32 171, i32 141), !dbg !191
  br i1 %cmp.n311, label %middle.block301.for_begin_xx.for_end_xx_crit_edge.split.us50.us.us.us.us.6_crit_edge, label %for_body_xx.us48.us.us.us.us.6.preheader, !dbg !191, !prof !227

middle.block301.for_begin_xx.for_end_xx_crit_edge.split.us50.us.us.us.us.6_crit_edge: ; preds = %middle.block301
  call void @llvm.instrprof.increment(ptr @__profn_TVMMod_default_function_compute_, i64 46134000452360265, i32 171, i32 66), !dbg !191
  br label %for_begin_xx.for_end_xx_crit_edge.split.us50.us.us.us.us.6, !dbg !191

for_body_xx.us48.us.us.us.us.6.preheader:         ; preds = %for_begin_xx.preheader.us.us57.us.us.us.6.for_body_xx.us48.us.us.us.us.6.preheader_crit_edge, %middle.block301
  %indvars.iv97.6.ph = phi i64 [ 0, %for_begin_xx.preheader.us.us57.us.us.us.6.for_body_xx.us48.us.us.us.us.6.preheader_crit_edge ], [ %n.vec306, %middle.block301 ]
  br i1 %lcmp.mod434.not, label %for_body_xx.us48.us.us.us.us.6.prol.loopexit, label %for_body_xx.us48.us.us.us.us.6.preheader.for_body_xx.us48.us.us.us.us.6.prol_crit_edge, !dbg !191, !prof !194

for_body_xx.us48.us.us.us.us.6.preheader.for_body_xx.us48.us.us.us.us.6.prol_crit_edge: ; preds = %for_body_xx.us48.us.us.us.us.6.preheader
  call void @llvm.instrprof.increment(ptr @__profn_TVMMod_default_function_compute_, i64 46134000452360265, i32 171, i32 105), !dbg !191
  br label %for_body_xx.us48.us.us.us.us.6.prol, !dbg !191

for_body_xx.us48.us.us.us.us.6.prol:              ; preds = %for_body_xx.us48.us.us.us.us.6.preheader.for_body_xx.us48.us.us.us.us.6.prol_crit_edge, %for_body_xx.us48.us.us.us.us.6.prol.for_body_xx.us48.us.us.us.us.6.prol_crit_edge
  %indvars.iv97.6.prol = phi i64 [ %indvars.iv.next98.6.prol, %for_body_xx.us48.us.us.us.us.6.prol.for_body_xx.us48.us.us.us.us.6.prol_crit_edge ], [ %indvars.iv97.6.ph, %for_body_xx.us48.us.us.us.us.6.preheader.for_body_xx.us48.us.us.us.us.6.prol_crit_edge ]
  %prol.iter435 = phi i64 [ %prol.iter435.next, %for_body_xx.us48.us.us.us.us.6.prol.for_body_xx.us48.us.us.us.us.6.prol_crit_edge ], [ 0, %for_body_xx.us48.us.us.us.us.6.preheader.for_body_xx.us48.us.us.us.us.6.prol_crit_edge ]
    #dbg_declare(i64 %indvars.iv97.6.prol, !213, !DIExpression(), !191)
  %289 = mul nsw i64 %indvars.iv97.6.prol, %72, !dbg !191
  %290 = getelementptr float, ptr %285, i64 %289, !dbg !191
  store float 0.000000e+00, ptr %290, align 4, !dbg !191, !tbaa !219
    #dbg_declare(i32 0, !214, !DIExpression(), !191)
  %indvars.iv.next98.6.prol = add nuw nsw i64 %indvars.iv97.6.prol, 1, !dbg !191
    #dbg_declare(i64 %indvars.iv.next98.6.prol, !213, !DIExpression(), !191)
  %prol.iter435.next = add i64 %prol.iter435, 1, !dbg !191
  %prol.iter435.cmp.not = icmp eq i64 %prol.iter435.next, %xtraiter433, !dbg !191
  br i1 %prol.iter435.cmp.not, label %for_body_xx.us48.us.us.us.us.6.prol.loopexit, label %for_body_xx.us48.us.us.us.us.6.prol.for_body_xx.us48.us.us.us.us.6.prol_crit_edge, !dbg !191, !prof !207, !llvm.loop !248

for_body_xx.us48.us.us.us.us.6.prol.for_body_xx.us48.us.us.us.us.6.prol_crit_edge: ; preds = %for_body_xx.us48.us.us.us.us.6.prol
  call void @llvm.instrprof.increment(ptr @__profn_TVMMod_default_function_compute_, i64 46134000452360265, i32 171, i32 40), !dbg !191
  br label %for_body_xx.us48.us.us.us.us.6.prol, !dbg !191

for_body_xx.us48.us.us.us.us.6.prol.loopexit:     ; preds = %for_body_xx.us48.us.us.us.us.6.prol, %for_body_xx.us48.us.us.us.us.6.preheader
  %indvars.iv97.6.unr = phi i64 [ %indvars.iv97.6.ph, %for_body_xx.us48.us.us.us.us.6.preheader ], [ %indvars.iv.next98.6.prol, %for_body_xx.us48.us.us.us.us.6.prol ]
  %291 = sub nsw i64 %indvars.iv97.6.ph, %wide.trip.count100, !dbg !191
  %292 = icmp ugt i64 %291, -4, !dbg !191
  br i1 %292, label %for_body_xx.us48.us.us.us.us.6.prol.loopexit.for_begin_xx.for_end_xx_crit_edge.split.us50.us.us.us.us.6_crit_edge, label %for_body_xx.us48.us.us.us.us.6, !dbg !191, !prof !201

for_body_xx.us48.us.us.us.us.6.prol.loopexit.for_begin_xx.for_end_xx_crit_edge.split.us50.us.us.us.us.6_crit_edge: ; preds = %for_body_xx.us48.us.us.us.us.6.prol.loopexit
  call void @llvm.instrprof.increment(ptr @__profn_TVMMod_default_function_compute_, i64 46134000452360265, i32 171, i32 106), !dbg !191
  br label %for_begin_xx.for_end_xx_crit_edge.split.us50.us.us.us.us.6, !dbg !191

for_body_xx.us48.us.us.us.us.6:                   ; preds = %for_body_xx.us48.us.us.us.us.6.for_body_xx.us48.us.us.us.us.6_crit_edge, %for_body_xx.us48.us.us.us.us.6.prol.loopexit
  %indvars.iv97.6 = phi i64 [ %indvars.iv.next98.6.3, %for_body_xx.us48.us.us.us.us.6.for_body_xx.us48.us.us.us.us.6_crit_edge ], [ %indvars.iv97.6.unr, %for_body_xx.us48.us.us.us.us.6.prol.loopexit ]
    #dbg_declare(i64 %indvars.iv97.6, !213, !DIExpression(), !191)
  %293 = mul nsw i64 %indvars.iv97.6, %72, !dbg !191
  %294 = getelementptr float, ptr %285, i64 %293, !dbg !191
  store float 0.000000e+00, ptr %294, align 4, !dbg !191, !tbaa !219
    #dbg_declare(i32 0, !214, !DIExpression(), !191)
  %indvars.iv.next98.6 = add nuw nsw i64 %indvars.iv97.6, 1, !dbg !191
    #dbg_declare(i64 %indvars.iv.next98.6, !213, !DIExpression(), !191)
    #dbg_declare(i64 %indvars.iv.next98.6, !213, !DIExpression(), !191)
  %295 = mul nsw i64 %indvars.iv.next98.6, %72, !dbg !191
  %296 = getelementptr float, ptr %285, i64 %295, !dbg !191
  store float 0.000000e+00, ptr %296, align 4, !dbg !191, !tbaa !219
    #dbg_declare(i32 0, !214, !DIExpression(), !191)
  %indvars.iv.next98.6.1 = add nuw nsw i64 %indvars.iv97.6, 2, !dbg !191
    #dbg_declare(i64 %indvars.iv.next98.6.1, !213, !DIExpression(), !191)
    #dbg_declare(i64 %indvars.iv.next98.6.1, !213, !DIExpression(), !191)
  %297 = mul nsw i64 %indvars.iv.next98.6.1, %72, !dbg !191
  %298 = getelementptr float, ptr %285, i64 %297, !dbg !191
  store float 0.000000e+00, ptr %298, align 4, !dbg !191, !tbaa !219
    #dbg_declare(i32 0, !214, !DIExpression(), !191)
  %indvars.iv.next98.6.2 = add nuw nsw i64 %indvars.iv97.6, 3, !dbg !191
    #dbg_declare(i64 %indvars.iv.next98.6.2, !213, !DIExpression(), !191)
    #dbg_declare(i64 %indvars.iv.next98.6.2, !213, !DIExpression(), !191)
  %299 = mul nsw i64 %indvars.iv.next98.6.2, %72, !dbg !191
  %300 = getelementptr float, ptr %285, i64 %299, !dbg !191
  store float 0.000000e+00, ptr %300, align 4, !dbg !191, !tbaa !219
    #dbg_declare(i32 0, !214, !DIExpression(), !191)
  %indvars.iv.next98.6.3 = add nuw nsw i64 %indvars.iv97.6, 4, !dbg !191
    #dbg_declare(i64 %indvars.iv.next98.6.3, !213, !DIExpression(), !191)
  %exitcond101.6.not.3 = icmp eq i64 %indvars.iv.next98.6.3, %wide.trip.count100, !dbg !191
  br i1 %exitcond101.6.not.3, label %for_begin_xx.for_end_xx_crit_edge.split.us50.us.us.us.us.6, label %for_body_xx.us48.us.us.us.us.6.for_body_xx.us48.us.us.us.us.6_crit_edge, !dbg !191, !prof !230, !llvm.loop !249

for_body_xx.us48.us.us.us.us.6.for_body_xx.us48.us.us.us.us.6_crit_edge: ; preds = %for_body_xx.us48.us.us.us.us.6
  call void @llvm.instrprof.increment(ptr @__profn_TVMMod_default_function_compute_, i64 46134000452360265, i32 171, i32 41), !dbg !191
  br label %for_body_xx.us48.us.us.us.us.6, !dbg !191

for_begin_xx.for_end_xx_crit_edge.split.us50.us.us.us.us.6: ; preds = %for_body_xx.us48.us.us.us.us.6.prol.loopexit.for_begin_xx.for_end_xx_crit_edge.split.us50.us.us.us.us.6_crit_edge, %middle.block301.for_begin_xx.for_end_xx_crit_edge.split.us50.us.us.us.us.6_crit_edge, %for_body_xx.us48.us.us.us.us.6
  %indvars.iv.next103.6 = add nuw nsw i64 %indvars.iv102.6, 1, !dbg !191
    #dbg_declare(i64 %indvars.iv.next103.6, !212, !DIExpression(), !191)
  %exitcond106.6.not = icmp eq i64 %indvars.iv.next103.6, %wide.trip.count105, !dbg !191
  br i1 %exitcond106.6.not, label %for_begin_yy.for_end_yy_crit_edge.split.us.split.us59.us.us.us.6, label %for_begin_xx.preheader.us.us57.us.us.us.6, !dbg !191, !prof !200

for_begin_yy.for_end_yy_crit_edge.split.us.split.us59.us.us.us.6: ; preds = %for_begin_xx.for_end_xx_crit_edge.split.us50.us.us.us.us.6
    #dbg_declare(i64 7, !211, !DIExpression(), !191)
    #dbg_declare(i64 7, !211, !DIExpression(), !191)
    #dbg_declare(i32 0, !212, !DIExpression(), !191)
  %301 = getelementptr float, ptr %81, i64 %175
  br label %for_begin_xx.preheader.us.us57.us.us.us.7, !dbg !191

for_begin_xx.preheader.us.us57.us.us.us.7:        ; preds = %for_begin_xx.for_end_xx_crit_edge.split.us50.us.us.us.us.7, %for_begin_yy.for_end_yy_crit_edge.split.us.split.us59.us.us.us.6
  %indvars.iv102.7 = phi i64 [ %indvars.iv.next103.7, %for_begin_xx.for_end_xx_crit_edge.split.us50.us.us.us.us.7 ], [ 0, %for_begin_yy.for_end_yy_crit_edge.split.us.split.us59.us.us.us.6 ]
    #dbg_declare(i64 %indvars.iv102.7, !212, !DIExpression(), !191)
    #dbg_declare(i32 0, !213, !DIExpression(), !191)
  %302 = mul nsw i64 %indvars.iv102.7, %73
  %303 = getelementptr float, ptr %301, i64 %302
  br i1 %or.cond397, label %vector.body295, label %for_begin_xx.preheader.us.us57.us.us.us.7.for_body_xx.us48.us.us.us.us.7.preheader_crit_edge, !dbg !191, !prof !222

for_begin_xx.preheader.us.us57.us.us.us.7.for_body_xx.us48.us.us.us.us.7.preheader_crit_edge: ; preds = %for_begin_xx.preheader.us.us57.us.us.us.7
  call void @llvm.instrprof.increment(ptr @__profn_TVMMod_default_function_compute_, i64 46134000452360265, i32 171, i32 84), !dbg !191
  br label %for_body_xx.us48.us.us.us.us.7.preheader, !dbg !191

vector.body295:                                   ; preds = %vector.body295.vector.body295_crit_edge, %for_begin_xx.preheader.us.us57.us.us.us.7
  %index296 = phi i64 [ %index.next297, %vector.body295.vector.body295_crit_edge ], [ 0, %for_begin_xx.preheader.us.us57.us.us.us.7 ], !dbg !191
  %304 = getelementptr float, ptr %303, i64 %index296, !dbg !191
  %305 = getelementptr i8, ptr %304, i64 16, !dbg !191
  store <4 x float> zeroinitializer, ptr %304, align 4, !dbg !191, !tbaa !219
  store <4 x float> zeroinitializer, ptr %305, align 4, !dbg !191, !tbaa !219
  %index.next297 = add nuw i64 %index296, 8, !dbg !191
  %306 = icmp eq i64 %index.next297, %n.vec293, !dbg !191
  br i1 %306, label %middle.block288, label %vector.body295.vector.body295_crit_edge, !dbg !191, !prof !223, !llvm.loop !250

vector.body295.vector.body295_crit_edge:          ; preds = %vector.body295
  call void @llvm.instrprof.increment(ptr @__profn_TVMMod_default_function_compute_, i64 46134000452360265, i32 171, i32 17), !dbg !191
  br label %vector.body295, !dbg !191

middle.block288:                                  ; preds = %vector.body295
  call void @llvm.instrprof.increment(ptr @__profn_TVMMod_default_function_compute_, i64 46134000452360265, i32 171, i32 142), !dbg !191
  br i1 %cmp.n298, label %middle.block288.for_begin_xx.for_end_xx_crit_edge.split.us50.us.us.us.us.7_crit_edge, label %for_body_xx.us48.us.us.us.us.7.preheader, !dbg !191, !prof !227

middle.block288.for_begin_xx.for_end_xx_crit_edge.split.us50.us.us.us.us.7_crit_edge: ; preds = %middle.block288
  call void @llvm.instrprof.increment(ptr @__profn_TVMMod_default_function_compute_, i64 46134000452360265, i32 171, i32 67), !dbg !191
  br label %for_begin_xx.for_end_xx_crit_edge.split.us50.us.us.us.us.7, !dbg !191

for_body_xx.us48.us.us.us.us.7.preheader:         ; preds = %for_begin_xx.preheader.us.us57.us.us.us.7.for_body_xx.us48.us.us.us.us.7.preheader_crit_edge, %middle.block288
  %indvars.iv97.7.ph = phi i64 [ 0, %for_begin_xx.preheader.us.us57.us.us.us.7.for_body_xx.us48.us.us.us.us.7.preheader_crit_edge ], [ %n.vec293, %middle.block288 ]
  br i1 %lcmp.mod437.not, label %for_body_xx.us48.us.us.us.us.7.prol.loopexit, label %for_body_xx.us48.us.us.us.us.7.preheader.for_body_xx.us48.us.us.us.us.7.prol_crit_edge, !dbg !191, !prof !194

for_body_xx.us48.us.us.us.us.7.preheader.for_body_xx.us48.us.us.us.us.7.prol_crit_edge: ; preds = %for_body_xx.us48.us.us.us.us.7.preheader
  call void @llvm.instrprof.increment(ptr @__profn_TVMMod_default_function_compute_, i64 46134000452360265, i32 171, i32 107), !dbg !191
  br label %for_body_xx.us48.us.us.us.us.7.prol, !dbg !191

for_body_xx.us48.us.us.us.us.7.prol:              ; preds = %for_body_xx.us48.us.us.us.us.7.preheader.for_body_xx.us48.us.us.us.us.7.prol_crit_edge, %for_body_xx.us48.us.us.us.us.7.prol.for_body_xx.us48.us.us.us.us.7.prol_crit_edge
  %indvars.iv97.7.prol = phi i64 [ %indvars.iv.next98.7.prol, %for_body_xx.us48.us.us.us.us.7.prol.for_body_xx.us48.us.us.us.us.7.prol_crit_edge ], [ %indvars.iv97.7.ph, %for_body_xx.us48.us.us.us.us.7.preheader.for_body_xx.us48.us.us.us.us.7.prol_crit_edge ]
  %prol.iter438 = phi i64 [ %prol.iter438.next, %for_body_xx.us48.us.us.us.us.7.prol.for_body_xx.us48.us.us.us.us.7.prol_crit_edge ], [ 0, %for_body_xx.us48.us.us.us.us.7.preheader.for_body_xx.us48.us.us.us.us.7.prol_crit_edge ]
    #dbg_declare(i64 %indvars.iv97.7.prol, !213, !DIExpression(), !191)
  %307 = mul nsw i64 %indvars.iv97.7.prol, %72, !dbg !191
  %308 = getelementptr float, ptr %303, i64 %307, !dbg !191
  store float 0.000000e+00, ptr %308, align 4, !dbg !191, !tbaa !219
    #dbg_declare(i32 0, !214, !DIExpression(), !191)
  %indvars.iv.next98.7.prol = add nuw nsw i64 %indvars.iv97.7.prol, 1, !dbg !191
    #dbg_declare(i64 %indvars.iv.next98.7.prol, !213, !DIExpression(), !191)
  %prol.iter438.next = add i64 %prol.iter438, 1, !dbg !191
  %prol.iter438.cmp.not = icmp eq i64 %prol.iter438.next, %xtraiter436, !dbg !191
  br i1 %prol.iter438.cmp.not, label %for_body_xx.us48.us.us.us.us.7.prol.loopexit, label %for_body_xx.us48.us.us.us.us.7.prol.for_body_xx.us48.us.us.us.us.7.prol_crit_edge, !dbg !191, !prof !207, !llvm.loop !251

for_body_xx.us48.us.us.us.us.7.prol.for_body_xx.us48.us.us.us.us.7.prol_crit_edge: ; preds = %for_body_xx.us48.us.us.us.us.7.prol
  call void @llvm.instrprof.increment(ptr @__profn_TVMMod_default_function_compute_, i64 46134000452360265, i32 171, i32 42), !dbg !191
  br label %for_body_xx.us48.us.us.us.us.7.prol, !dbg !191

for_body_xx.us48.us.us.us.us.7.prol.loopexit:     ; preds = %for_body_xx.us48.us.us.us.us.7.prol, %for_body_xx.us48.us.us.us.us.7.preheader
  %indvars.iv97.7.unr = phi i64 [ %indvars.iv97.7.ph, %for_body_xx.us48.us.us.us.us.7.preheader ], [ %indvars.iv.next98.7.prol, %for_body_xx.us48.us.us.us.us.7.prol ]
  %309 = sub nsw i64 %indvars.iv97.7.ph, %wide.trip.count100, !dbg !191
  %310 = icmp ugt i64 %309, -4, !dbg !191
  br i1 %310, label %for_body_xx.us48.us.us.us.us.7.prol.loopexit.for_begin_xx.for_end_xx_crit_edge.split.us50.us.us.us.us.7_crit_edge, label %for_body_xx.us48.us.us.us.us.7, !dbg !191, !prof !201

for_body_xx.us48.us.us.us.us.7.prol.loopexit.for_begin_xx.for_end_xx_crit_edge.split.us50.us.us.us.us.7_crit_edge: ; preds = %for_body_xx.us48.us.us.us.us.7.prol.loopexit
  call void @llvm.instrprof.increment(ptr @__profn_TVMMod_default_function_compute_, i64 46134000452360265, i32 171, i32 108), !dbg !191
  br label %for_begin_xx.for_end_xx_crit_edge.split.us50.us.us.us.us.7, !dbg !191

for_body_xx.us48.us.us.us.us.7:                   ; preds = %for_body_xx.us48.us.us.us.us.7.for_body_xx.us48.us.us.us.us.7_crit_edge, %for_body_xx.us48.us.us.us.us.7.prol.loopexit
  %indvars.iv97.7 = phi i64 [ %indvars.iv.next98.7.3, %for_body_xx.us48.us.us.us.us.7.for_body_xx.us48.us.us.us.us.7_crit_edge ], [ %indvars.iv97.7.unr, %for_body_xx.us48.us.us.us.us.7.prol.loopexit ]
    #dbg_declare(i64 %indvars.iv97.7, !213, !DIExpression(), !191)
  %311 = mul nsw i64 %indvars.iv97.7, %72, !dbg !191
  %312 = getelementptr float, ptr %303, i64 %311, !dbg !191
  store float 0.000000e+00, ptr %312, align 4, !dbg !191, !tbaa !219
    #dbg_declare(i32 0, !214, !DIExpression(), !191)
  %indvars.iv.next98.7 = add nuw nsw i64 %indvars.iv97.7, 1, !dbg !191
    #dbg_declare(i64 %indvars.iv.next98.7, !213, !DIExpression(), !191)
    #dbg_declare(i64 %indvars.iv.next98.7, !213, !DIExpression(), !191)
  %313 = mul nsw i64 %indvars.iv.next98.7, %72, !dbg !191
  %314 = getelementptr float, ptr %303, i64 %313, !dbg !191
  store float 0.000000e+00, ptr %314, align 4, !dbg !191, !tbaa !219
    #dbg_declare(i32 0, !214, !DIExpression(), !191)
  %indvars.iv.next98.7.1 = add nuw nsw i64 %indvars.iv97.7, 2, !dbg !191
    #dbg_declare(i64 %indvars.iv.next98.7.1, !213, !DIExpression(), !191)
    #dbg_declare(i64 %indvars.iv.next98.7.1, !213, !DIExpression(), !191)
  %315 = mul nsw i64 %indvars.iv.next98.7.1, %72, !dbg !191
  %316 = getelementptr float, ptr %303, i64 %315, !dbg !191
  store float 0.000000e+00, ptr %316, align 4, !dbg !191, !tbaa !219
    #dbg_declare(i32 0, !214, !DIExpression(), !191)
  %indvars.iv.next98.7.2 = add nuw nsw i64 %indvars.iv97.7, 3, !dbg !191
    #dbg_declare(i64 %indvars.iv.next98.7.2, !213, !DIExpression(), !191)
    #dbg_declare(i64 %indvars.iv.next98.7.2, !213, !DIExpression(), !191)
  %317 = mul nsw i64 %indvars.iv.next98.7.2, %72, !dbg !191
  %318 = getelementptr float, ptr %303, i64 %317, !dbg !191
  store float 0.000000e+00, ptr %318, align 4, !dbg !191, !tbaa !219
    #dbg_declare(i32 0, !214, !DIExpression(), !191)
  %indvars.iv.next98.7.3 = add nuw nsw i64 %indvars.iv97.7, 4, !dbg !191
    #dbg_declare(i64 %indvars.iv.next98.7.3, !213, !DIExpression(), !191)
  %exitcond101.7.not.3 = icmp eq i64 %indvars.iv.next98.7.3, %wide.trip.count100, !dbg !191
  br i1 %exitcond101.7.not.3, label %for_begin_xx.for_end_xx_crit_edge.split.us50.us.us.us.us.7, label %for_body_xx.us48.us.us.us.us.7.for_body_xx.us48.us.us.us.us.7_crit_edge, !dbg !191, !prof !230, !llvm.loop !252

for_body_xx.us48.us.us.us.us.7.for_body_xx.us48.us.us.us.us.7_crit_edge: ; preds = %for_body_xx.us48.us.us.us.us.7
  call void @llvm.instrprof.increment(ptr @__profn_TVMMod_default_function_compute_, i64 46134000452360265, i32 171, i32 43), !dbg !191
  br label %for_body_xx.us48.us.us.us.us.7, !dbg !191

for_begin_xx.for_end_xx_crit_edge.split.us50.us.us.us.us.7: ; preds = %for_body_xx.us48.us.us.us.us.7.prol.loopexit.for_begin_xx.for_end_xx_crit_edge.split.us50.us.us.us.us.7_crit_edge, %middle.block288.for_begin_xx.for_end_xx_crit_edge.split.us50.us.us.us.us.7_crit_edge, %for_body_xx.us48.us.us.us.us.7
  %indvars.iv.next103.7 = add nuw nsw i64 %indvars.iv102.7, 1, !dbg !191
    #dbg_declare(i64 %indvars.iv.next103.7, !212, !DIExpression(), !191)
  %exitcond106.7.not = icmp eq i64 %indvars.iv.next103.7, %wide.trip.count105, !dbg !191
  br i1 %exitcond106.7.not, label %for_begin_yy.for_end_yy_crit_edge.split.us.split.us59.us.us.us.7, label %for_begin_xx.preheader.us.us57.us.us.us.7, !dbg !191, !prof !200

for_begin_yy.for_end_yy_crit_edge.split.us.split.us59.us.us.us.7: ; preds = %for_begin_xx.for_end_xx_crit_edge.split.us50.us.us.us.us.7
    #dbg_declare(i64 8, !211, !DIExpression(), !191)
    #dbg_declare(i64 8, !211, !DIExpression(), !191)
    #dbg_declare(i32 0, !212, !DIExpression(), !191)
  %319 = getelementptr float, ptr %82, i64 %175
  br label %for_begin_xx.preheader.us.us57.us.us.us.8, !dbg !191

for_begin_xx.preheader.us.us57.us.us.us.8:        ; preds = %for_begin_xx.for_end_xx_crit_edge.split.us50.us.us.us.us.8, %for_begin_yy.for_end_yy_crit_edge.split.us.split.us59.us.us.us.7
  %indvars.iv102.8 = phi i64 [ %indvars.iv.next103.8, %for_begin_xx.for_end_xx_crit_edge.split.us50.us.us.us.us.8 ], [ 0, %for_begin_yy.for_end_yy_crit_edge.split.us.split.us59.us.us.us.7 ]
    #dbg_declare(i64 %indvars.iv102.8, !212, !DIExpression(), !191)
    #dbg_declare(i32 0, !213, !DIExpression(), !191)
  %320 = mul nsw i64 %indvars.iv102.8, %73
  %321 = getelementptr float, ptr %319, i64 %320
  br i1 %or.cond398, label %vector.body282, label %for_begin_xx.preheader.us.us57.us.us.us.8.for_body_xx.us48.us.us.us.us.8.preheader_crit_edge, !dbg !191, !prof !222

for_begin_xx.preheader.us.us57.us.us.us.8.for_body_xx.us48.us.us.us.us.8.preheader_crit_edge: ; preds = %for_begin_xx.preheader.us.us57.us.us.us.8
  call void @llvm.instrprof.increment(ptr @__profn_TVMMod_default_function_compute_, i64 46134000452360265, i32 171, i32 85), !dbg !191
  br label %for_body_xx.us48.us.us.us.us.8.preheader, !dbg !191

vector.body282:                                   ; preds = %vector.body282.vector.body282_crit_edge, %for_begin_xx.preheader.us.us57.us.us.us.8
  %index283 = phi i64 [ %index.next284, %vector.body282.vector.body282_crit_edge ], [ 0, %for_begin_xx.preheader.us.us57.us.us.us.8 ], !dbg !191
  %322 = getelementptr float, ptr %321, i64 %index283, !dbg !191
  %323 = getelementptr i8, ptr %322, i64 16, !dbg !191
  store <4 x float> zeroinitializer, ptr %322, align 4, !dbg !191, !tbaa !219
  store <4 x float> zeroinitializer, ptr %323, align 4, !dbg !191, !tbaa !219
  %index.next284 = add nuw i64 %index283, 8, !dbg !191
  %324 = icmp eq i64 %index.next284, %n.vec280, !dbg !191
  br i1 %324, label %middle.block275, label %vector.body282.vector.body282_crit_edge, !dbg !191, !prof !223, !llvm.loop !253

vector.body282.vector.body282_crit_edge:          ; preds = %vector.body282
  call void @llvm.instrprof.increment(ptr @__profn_TVMMod_default_function_compute_, i64 46134000452360265, i32 171, i32 18), !dbg !191
  br label %vector.body282, !dbg !191

middle.block275:                                  ; preds = %vector.body282
  call void @llvm.instrprof.increment(ptr @__profn_TVMMod_default_function_compute_, i64 46134000452360265, i32 171, i32 143), !dbg !191
  br i1 %cmp.n285, label %middle.block275.for_begin_xx.for_end_xx_crit_edge.split.us50.us.us.us.us.8_crit_edge, label %for_body_xx.us48.us.us.us.us.8.preheader, !dbg !191, !prof !227

middle.block275.for_begin_xx.for_end_xx_crit_edge.split.us50.us.us.us.us.8_crit_edge: ; preds = %middle.block275
  call void @llvm.instrprof.increment(ptr @__profn_TVMMod_default_function_compute_, i64 46134000452360265, i32 171, i32 68), !dbg !191
  br label %for_begin_xx.for_end_xx_crit_edge.split.us50.us.us.us.us.8, !dbg !191

for_body_xx.us48.us.us.us.us.8.preheader:         ; preds = %for_begin_xx.preheader.us.us57.us.us.us.8.for_body_xx.us48.us.us.us.us.8.preheader_crit_edge, %middle.block275
  %indvars.iv97.8.ph = phi i64 [ 0, %for_begin_xx.preheader.us.us57.us.us.us.8.for_body_xx.us48.us.us.us.us.8.preheader_crit_edge ], [ %n.vec280, %middle.block275 ]
  br i1 %lcmp.mod440.not, label %for_body_xx.us48.us.us.us.us.8.prol.loopexit, label %for_body_xx.us48.us.us.us.us.8.preheader.for_body_xx.us48.us.us.us.us.8.prol_crit_edge, !dbg !191, !prof !194

for_body_xx.us48.us.us.us.us.8.preheader.for_body_xx.us48.us.us.us.us.8.prol_crit_edge: ; preds = %for_body_xx.us48.us.us.us.us.8.preheader
  call void @llvm.instrprof.increment(ptr @__profn_TVMMod_default_function_compute_, i64 46134000452360265, i32 171, i32 109), !dbg !191
  br label %for_body_xx.us48.us.us.us.us.8.prol, !dbg !191

for_body_xx.us48.us.us.us.us.8.prol:              ; preds = %for_body_xx.us48.us.us.us.us.8.preheader.for_body_xx.us48.us.us.us.us.8.prol_crit_edge, %for_body_xx.us48.us.us.us.us.8.prol.for_body_xx.us48.us.us.us.us.8.prol_crit_edge
  %indvars.iv97.8.prol = phi i64 [ %indvars.iv.next98.8.prol, %for_body_xx.us48.us.us.us.us.8.prol.for_body_xx.us48.us.us.us.us.8.prol_crit_edge ], [ %indvars.iv97.8.ph, %for_body_xx.us48.us.us.us.us.8.preheader.for_body_xx.us48.us.us.us.us.8.prol_crit_edge ]
  %prol.iter441 = phi i64 [ %prol.iter441.next, %for_body_xx.us48.us.us.us.us.8.prol.for_body_xx.us48.us.us.us.us.8.prol_crit_edge ], [ 0, %for_body_xx.us48.us.us.us.us.8.preheader.for_body_xx.us48.us.us.us.us.8.prol_crit_edge ]
    #dbg_declare(i64 %indvars.iv97.8.prol, !213, !DIExpression(), !191)
  %325 = mul nsw i64 %indvars.iv97.8.prol, %72, !dbg !191
  %326 = getelementptr float, ptr %321, i64 %325, !dbg !191
  store float 0.000000e+00, ptr %326, align 4, !dbg !191, !tbaa !219
    #dbg_declare(i32 0, !214, !DIExpression(), !191)
  %indvars.iv.next98.8.prol = add nuw nsw i64 %indvars.iv97.8.prol, 1, !dbg !191
    #dbg_declare(i64 %indvars.iv.next98.8.prol, !213, !DIExpression(), !191)
  %prol.iter441.next = add i64 %prol.iter441, 1, !dbg !191
  %prol.iter441.cmp.not = icmp eq i64 %prol.iter441.next, %xtraiter439, !dbg !191
  br i1 %prol.iter441.cmp.not, label %for_body_xx.us48.us.us.us.us.8.prol.loopexit, label %for_body_xx.us48.us.us.us.us.8.prol.for_body_xx.us48.us.us.us.us.8.prol_crit_edge, !dbg !191, !prof !207, !llvm.loop !254

for_body_xx.us48.us.us.us.us.8.prol.for_body_xx.us48.us.us.us.us.8.prol_crit_edge: ; preds = %for_body_xx.us48.us.us.us.us.8.prol
  call void @llvm.instrprof.increment(ptr @__profn_TVMMod_default_function_compute_, i64 46134000452360265, i32 171, i32 44), !dbg !191
  br label %for_body_xx.us48.us.us.us.us.8.prol, !dbg !191

for_body_xx.us48.us.us.us.us.8.prol.loopexit:     ; preds = %for_body_xx.us48.us.us.us.us.8.prol, %for_body_xx.us48.us.us.us.us.8.preheader
  %indvars.iv97.8.unr = phi i64 [ %indvars.iv97.8.ph, %for_body_xx.us48.us.us.us.us.8.preheader ], [ %indvars.iv.next98.8.prol, %for_body_xx.us48.us.us.us.us.8.prol ]
  %327 = sub nsw i64 %indvars.iv97.8.ph, %wide.trip.count100, !dbg !191
  %328 = icmp ugt i64 %327, -4, !dbg !191
  br i1 %328, label %for_body_xx.us48.us.us.us.us.8.prol.loopexit.for_begin_xx.for_end_xx_crit_edge.split.us50.us.us.us.us.8_crit_edge, label %for_body_xx.us48.us.us.us.us.8, !dbg !191, !prof !201

for_body_xx.us48.us.us.us.us.8.prol.loopexit.for_begin_xx.for_end_xx_crit_edge.split.us50.us.us.us.us.8_crit_edge: ; preds = %for_body_xx.us48.us.us.us.us.8.prol.loopexit
  call void @llvm.instrprof.increment(ptr @__profn_TVMMod_default_function_compute_, i64 46134000452360265, i32 171, i32 110), !dbg !191
  br label %for_begin_xx.for_end_xx_crit_edge.split.us50.us.us.us.us.8, !dbg !191

for_body_xx.us48.us.us.us.us.8:                   ; preds = %for_body_xx.us48.us.us.us.us.8.for_body_xx.us48.us.us.us.us.8_crit_edge, %for_body_xx.us48.us.us.us.us.8.prol.loopexit
  %indvars.iv97.8 = phi i64 [ %indvars.iv.next98.8.3, %for_body_xx.us48.us.us.us.us.8.for_body_xx.us48.us.us.us.us.8_crit_edge ], [ %indvars.iv97.8.unr, %for_body_xx.us48.us.us.us.us.8.prol.loopexit ]
    #dbg_declare(i64 %indvars.iv97.8, !213, !DIExpression(), !191)
  %329 = mul nsw i64 %indvars.iv97.8, %72, !dbg !191
  %330 = getelementptr float, ptr %321, i64 %329, !dbg !191
  store float 0.000000e+00, ptr %330, align 4, !dbg !191, !tbaa !219
    #dbg_declare(i32 0, !214, !DIExpression(), !191)
  %indvars.iv.next98.8 = add nuw nsw i64 %indvars.iv97.8, 1, !dbg !191
    #dbg_declare(i64 %indvars.iv.next98.8, !213, !DIExpression(), !191)
    #dbg_declare(i64 %indvars.iv.next98.8, !213, !DIExpression(), !191)
  %331 = mul nsw i64 %indvars.iv.next98.8, %72, !dbg !191
  %332 = getelementptr float, ptr %321, i64 %331, !dbg !191
  store float 0.000000e+00, ptr %332, align 4, !dbg !191, !tbaa !219
    #dbg_declare(i32 0, !214, !DIExpression(), !191)
  %indvars.iv.next98.8.1 = add nuw nsw i64 %indvars.iv97.8, 2, !dbg !191
    #dbg_declare(i64 %indvars.iv.next98.8.1, !213, !DIExpression(), !191)
    #dbg_declare(i64 %indvars.iv.next98.8.1, !213, !DIExpression(), !191)
  %333 = mul nsw i64 %indvars.iv.next98.8.1, %72, !dbg !191
  %334 = getelementptr float, ptr %321, i64 %333, !dbg !191
  store float 0.000000e+00, ptr %334, align 4, !dbg !191, !tbaa !219
    #dbg_declare(i32 0, !214, !DIExpression(), !191)
  %indvars.iv.next98.8.2 = add nuw nsw i64 %indvars.iv97.8, 3, !dbg !191
    #dbg_declare(i64 %indvars.iv.next98.8.2, !213, !DIExpression(), !191)
    #dbg_declare(i64 %indvars.iv.next98.8.2, !213, !DIExpression(), !191)
  %335 = mul nsw i64 %indvars.iv.next98.8.2, %72, !dbg !191
  %336 = getelementptr float, ptr %321, i64 %335, !dbg !191
  store float 0.000000e+00, ptr %336, align 4, !dbg !191, !tbaa !219
    #dbg_declare(i32 0, !214, !DIExpression(), !191)
  %indvars.iv.next98.8.3 = add nuw nsw i64 %indvars.iv97.8, 4, !dbg !191
    #dbg_declare(i64 %indvars.iv.next98.8.3, !213, !DIExpression(), !191)
  %exitcond101.8.not.3 = icmp eq i64 %indvars.iv.next98.8.3, %wide.trip.count100, !dbg !191
  br i1 %exitcond101.8.not.3, label %for_begin_xx.for_end_xx_crit_edge.split.us50.us.us.us.us.8, label %for_body_xx.us48.us.us.us.us.8.for_body_xx.us48.us.us.us.us.8_crit_edge, !dbg !191, !prof !230, !llvm.loop !255

for_body_xx.us48.us.us.us.us.8.for_body_xx.us48.us.us.us.us.8_crit_edge: ; preds = %for_body_xx.us48.us.us.us.us.8
  call void @llvm.instrprof.increment(ptr @__profn_TVMMod_default_function_compute_, i64 46134000452360265, i32 171, i32 45), !dbg !191
  br label %for_body_xx.us48.us.us.us.us.8, !dbg !191

for_begin_xx.for_end_xx_crit_edge.split.us50.us.us.us.us.8: ; preds = %for_body_xx.us48.us.us.us.us.8.prol.loopexit.for_begin_xx.for_end_xx_crit_edge.split.us50.us.us.us.us.8_crit_edge, %middle.block275.for_begin_xx.for_end_xx_crit_edge.split.us50.us.us.us.us.8_crit_edge, %for_body_xx.us48.us.us.us.us.8
  %indvars.iv.next103.8 = add nuw nsw i64 %indvars.iv102.8, 1, !dbg !191
    #dbg_declare(i64 %indvars.iv.next103.8, !212, !DIExpression(), !191)
  %exitcond106.8.not = icmp eq i64 %indvars.iv.next103.8, %wide.trip.count105, !dbg !191
  br i1 %exitcond106.8.not, label %for_begin_yy.for_end_yy_crit_edge.split.us.split.us59.us.us.us.8, label %for_begin_xx.preheader.us.us57.us.us.us.8, !dbg !191, !prof !200

for_begin_yy.for_end_yy_crit_edge.split.us.split.us59.us.us.us.8: ; preds = %for_begin_xx.for_end_xx_crit_edge.split.us50.us.us.us.us.8
    #dbg_declare(i64 9, !211, !DIExpression(), !191)
    #dbg_declare(i64 9, !211, !DIExpression(), !191)
    #dbg_declare(i32 0, !212, !DIExpression(), !191)
  %337 = getelementptr float, ptr %83, i64 %175
  br label %for_begin_xx.preheader.us.us57.us.us.us.9, !dbg !191

for_begin_xx.preheader.us.us57.us.us.us.9:        ; preds = %for_begin_xx.for_end_xx_crit_edge.split.us50.us.us.us.us.9, %for_begin_yy.for_end_yy_crit_edge.split.us.split.us59.us.us.us.8
  %indvars.iv102.9 = phi i64 [ %indvars.iv.next103.9, %for_begin_xx.for_end_xx_crit_edge.split.us50.us.us.us.us.9 ], [ 0, %for_begin_yy.for_end_yy_crit_edge.split.us.split.us59.us.us.us.8 ]
    #dbg_declare(i64 %indvars.iv102.9, !212, !DIExpression(), !191)
    #dbg_declare(i32 0, !213, !DIExpression(), !191)
  %338 = mul nsw i64 %indvars.iv102.9, %73
  %339 = getelementptr float, ptr %337, i64 %338
  br i1 %or.cond399, label %vector.body269, label %for_begin_xx.preheader.us.us57.us.us.us.9.for_body_xx.us48.us.us.us.us.9.preheader_crit_edge, !dbg !191, !prof !222

for_begin_xx.preheader.us.us57.us.us.us.9.for_body_xx.us48.us.us.us.us.9.preheader_crit_edge: ; preds = %for_begin_xx.preheader.us.us57.us.us.us.9
  call void @llvm.instrprof.increment(ptr @__profn_TVMMod_default_function_compute_, i64 46134000452360265, i32 171, i32 86), !dbg !191
  br label %for_body_xx.us48.us.us.us.us.9.preheader, !dbg !191

vector.body269:                                   ; preds = %vector.body269.vector.body269_crit_edge, %for_begin_xx.preheader.us.us57.us.us.us.9
  %index270 = phi i64 [ %index.next271, %vector.body269.vector.body269_crit_edge ], [ 0, %for_begin_xx.preheader.us.us57.us.us.us.9 ], !dbg !191
  %340 = getelementptr float, ptr %339, i64 %index270, !dbg !191
  %341 = getelementptr i8, ptr %340, i64 16, !dbg !191
  store <4 x float> zeroinitializer, ptr %340, align 4, !dbg !191, !tbaa !219
  store <4 x float> zeroinitializer, ptr %341, align 4, !dbg !191, !tbaa !219
  %index.next271 = add nuw i64 %index270, 8, !dbg !191
  %342 = icmp eq i64 %index.next271, %n.vec267, !dbg !191
  br i1 %342, label %middle.block262, label %vector.body269.vector.body269_crit_edge, !dbg !191, !prof !223, !llvm.loop !256

vector.body269.vector.body269_crit_edge:          ; preds = %vector.body269
  call void @llvm.instrprof.increment(ptr @__profn_TVMMod_default_function_compute_, i64 46134000452360265, i32 171, i32 19), !dbg !191
  br label %vector.body269, !dbg !191

middle.block262:                                  ; preds = %vector.body269
  call void @llvm.instrprof.increment(ptr @__profn_TVMMod_default_function_compute_, i64 46134000452360265, i32 171, i32 144), !dbg !191
  br i1 %cmp.n272, label %middle.block262.for_begin_xx.for_end_xx_crit_edge.split.us50.us.us.us.us.9_crit_edge, label %for_body_xx.us48.us.us.us.us.9.preheader, !dbg !191, !prof !227

middle.block262.for_begin_xx.for_end_xx_crit_edge.split.us50.us.us.us.us.9_crit_edge: ; preds = %middle.block262
  call void @llvm.instrprof.increment(ptr @__profn_TVMMod_default_function_compute_, i64 46134000452360265, i32 171, i32 69), !dbg !191
  br label %for_begin_xx.for_end_xx_crit_edge.split.us50.us.us.us.us.9, !dbg !191

for_body_xx.us48.us.us.us.us.9.preheader:         ; preds = %for_begin_xx.preheader.us.us57.us.us.us.9.for_body_xx.us48.us.us.us.us.9.preheader_crit_edge, %middle.block262
  %indvars.iv97.9.ph = phi i64 [ 0, %for_begin_xx.preheader.us.us57.us.us.us.9.for_body_xx.us48.us.us.us.us.9.preheader_crit_edge ], [ %n.vec267, %middle.block262 ]
  br i1 %lcmp.mod443.not, label %for_body_xx.us48.us.us.us.us.9.prol.loopexit, label %for_body_xx.us48.us.us.us.us.9.preheader.for_body_xx.us48.us.us.us.us.9.prol_crit_edge, !dbg !191, !prof !194

for_body_xx.us48.us.us.us.us.9.preheader.for_body_xx.us48.us.us.us.us.9.prol_crit_edge: ; preds = %for_body_xx.us48.us.us.us.us.9.preheader
  call void @llvm.instrprof.increment(ptr @__profn_TVMMod_default_function_compute_, i64 46134000452360265, i32 171, i32 111), !dbg !191
  br label %for_body_xx.us48.us.us.us.us.9.prol, !dbg !191

for_body_xx.us48.us.us.us.us.9.prol:              ; preds = %for_body_xx.us48.us.us.us.us.9.preheader.for_body_xx.us48.us.us.us.us.9.prol_crit_edge, %for_body_xx.us48.us.us.us.us.9.prol.for_body_xx.us48.us.us.us.us.9.prol_crit_edge
  %indvars.iv97.9.prol = phi i64 [ %indvars.iv.next98.9.prol, %for_body_xx.us48.us.us.us.us.9.prol.for_body_xx.us48.us.us.us.us.9.prol_crit_edge ], [ %indvars.iv97.9.ph, %for_body_xx.us48.us.us.us.us.9.preheader.for_body_xx.us48.us.us.us.us.9.prol_crit_edge ]
  %prol.iter444 = phi i64 [ %prol.iter444.next, %for_body_xx.us48.us.us.us.us.9.prol.for_body_xx.us48.us.us.us.us.9.prol_crit_edge ], [ 0, %for_body_xx.us48.us.us.us.us.9.preheader.for_body_xx.us48.us.us.us.us.9.prol_crit_edge ]
    #dbg_declare(i64 %indvars.iv97.9.prol, !213, !DIExpression(), !191)
  %343 = mul nsw i64 %indvars.iv97.9.prol, %72, !dbg !191
  %344 = getelementptr float, ptr %339, i64 %343, !dbg !191
  store float 0.000000e+00, ptr %344, align 4, !dbg !191, !tbaa !219
    #dbg_declare(i32 0, !214, !DIExpression(), !191)
  %indvars.iv.next98.9.prol = add nuw nsw i64 %indvars.iv97.9.prol, 1, !dbg !191
    #dbg_declare(i64 %indvars.iv.next98.9.prol, !213, !DIExpression(), !191)
  %prol.iter444.next = add i64 %prol.iter444, 1, !dbg !191
  %prol.iter444.cmp.not = icmp eq i64 %prol.iter444.next, %xtraiter442, !dbg !191
  br i1 %prol.iter444.cmp.not, label %for_body_xx.us48.us.us.us.us.9.prol.loopexit, label %for_body_xx.us48.us.us.us.us.9.prol.for_body_xx.us48.us.us.us.us.9.prol_crit_edge, !dbg !191, !prof !207, !llvm.loop !257

for_body_xx.us48.us.us.us.us.9.prol.for_body_xx.us48.us.us.us.us.9.prol_crit_edge: ; preds = %for_body_xx.us48.us.us.us.us.9.prol
  call void @llvm.instrprof.increment(ptr @__profn_TVMMod_default_function_compute_, i64 46134000452360265, i32 171, i32 46), !dbg !191
  br label %for_body_xx.us48.us.us.us.us.9.prol, !dbg !191

for_body_xx.us48.us.us.us.us.9.prol.loopexit:     ; preds = %for_body_xx.us48.us.us.us.us.9.prol, %for_body_xx.us48.us.us.us.us.9.preheader
  %indvars.iv97.9.unr = phi i64 [ %indvars.iv97.9.ph, %for_body_xx.us48.us.us.us.us.9.preheader ], [ %indvars.iv.next98.9.prol, %for_body_xx.us48.us.us.us.us.9.prol ]
  %345 = sub nsw i64 %indvars.iv97.9.ph, %wide.trip.count100, !dbg !191
  %346 = icmp ugt i64 %345, -4, !dbg !191
  br i1 %346, label %for_body_xx.us48.us.us.us.us.9.prol.loopexit.for_begin_xx.for_end_xx_crit_edge.split.us50.us.us.us.us.9_crit_edge, label %for_body_xx.us48.us.us.us.us.9, !dbg !191, !prof !201

for_body_xx.us48.us.us.us.us.9.prol.loopexit.for_begin_xx.for_end_xx_crit_edge.split.us50.us.us.us.us.9_crit_edge: ; preds = %for_body_xx.us48.us.us.us.us.9.prol.loopexit
  call void @llvm.instrprof.increment(ptr @__profn_TVMMod_default_function_compute_, i64 46134000452360265, i32 171, i32 112), !dbg !191
  br label %for_begin_xx.for_end_xx_crit_edge.split.us50.us.us.us.us.9, !dbg !191

for_body_xx.us48.us.us.us.us.9:                   ; preds = %for_body_xx.us48.us.us.us.us.9.for_body_xx.us48.us.us.us.us.9_crit_edge, %for_body_xx.us48.us.us.us.us.9.prol.loopexit
  %indvars.iv97.9 = phi i64 [ %indvars.iv.next98.9.3, %for_body_xx.us48.us.us.us.us.9.for_body_xx.us48.us.us.us.us.9_crit_edge ], [ %indvars.iv97.9.unr, %for_body_xx.us48.us.us.us.us.9.prol.loopexit ]
    #dbg_declare(i64 %indvars.iv97.9, !213, !DIExpression(), !191)
  %347 = mul nsw i64 %indvars.iv97.9, %72, !dbg !191
  %348 = getelementptr float, ptr %339, i64 %347, !dbg !191
  store float 0.000000e+00, ptr %348, align 4, !dbg !191, !tbaa !219
    #dbg_declare(i32 0, !214, !DIExpression(), !191)
  %indvars.iv.next98.9 = add nuw nsw i64 %indvars.iv97.9, 1, !dbg !191
    #dbg_declare(i64 %indvars.iv.next98.9, !213, !DIExpression(), !191)
    #dbg_declare(i64 %indvars.iv.next98.9, !213, !DIExpression(), !191)
  %349 = mul nsw i64 %indvars.iv.next98.9, %72, !dbg !191
  %350 = getelementptr float, ptr %339, i64 %349, !dbg !191
  store float 0.000000e+00, ptr %350, align 4, !dbg !191, !tbaa !219
    #dbg_declare(i32 0, !214, !DIExpression(), !191)
  %indvars.iv.next98.9.1 = add nuw nsw i64 %indvars.iv97.9, 2, !dbg !191
    #dbg_declare(i64 %indvars.iv.next98.9.1, !213, !DIExpression(), !191)
    #dbg_declare(i64 %indvars.iv.next98.9.1, !213, !DIExpression(), !191)
  %351 = mul nsw i64 %indvars.iv.next98.9.1, %72, !dbg !191
  %352 = getelementptr float, ptr %339, i64 %351, !dbg !191
  store float 0.000000e+00, ptr %352, align 4, !dbg !191, !tbaa !219
    #dbg_declare(i32 0, !214, !DIExpression(), !191)
  %indvars.iv.next98.9.2 = add nuw nsw i64 %indvars.iv97.9, 3, !dbg !191
    #dbg_declare(i64 %indvars.iv.next98.9.2, !213, !DIExpression(), !191)
    #dbg_declare(i64 %indvars.iv.next98.9.2, !213, !DIExpression(), !191)
  %353 = mul nsw i64 %indvars.iv.next98.9.2, %72, !dbg !191
  %354 = getelementptr float, ptr %339, i64 %353, !dbg !191
  store float 0.000000e+00, ptr %354, align 4, !dbg !191, !tbaa !219
    #dbg_declare(i32 0, !214, !DIExpression(), !191)
  %indvars.iv.next98.9.3 = add nuw nsw i64 %indvars.iv97.9, 4, !dbg !191
    #dbg_declare(i64 %indvars.iv.next98.9.3, !213, !DIExpression(), !191)
  %exitcond101.9.not.3 = icmp eq i64 %indvars.iv.next98.9.3, %wide.trip.count100, !dbg !191
  br i1 %exitcond101.9.not.3, label %for_begin_xx.for_end_xx_crit_edge.split.us50.us.us.us.us.9, label %for_body_xx.us48.us.us.us.us.9.for_body_xx.us48.us.us.us.us.9_crit_edge, !dbg !191, !prof !230, !llvm.loop !258

for_body_xx.us48.us.us.us.us.9.for_body_xx.us48.us.us.us.us.9_crit_edge: ; preds = %for_body_xx.us48.us.us.us.us.9
  call void @llvm.instrprof.increment(ptr @__profn_TVMMod_default_function_compute_, i64 46134000452360265, i32 171, i32 47), !dbg !191
  br label %for_body_xx.us48.us.us.us.us.9, !dbg !191

for_begin_xx.for_end_xx_crit_edge.split.us50.us.us.us.us.9: ; preds = %for_body_xx.us48.us.us.us.us.9.prol.loopexit.for_begin_xx.for_end_xx_crit_edge.split.us50.us.us.us.us.9_crit_edge, %middle.block262.for_begin_xx.for_end_xx_crit_edge.split.us50.us.us.us.us.9_crit_edge, %for_body_xx.us48.us.us.us.us.9
  %indvars.iv.next103.9 = add nuw nsw i64 %indvars.iv102.9, 1, !dbg !191
    #dbg_declare(i64 %indvars.iv.next103.9, !212, !DIExpression(), !191)
  %exitcond106.9.not = icmp eq i64 %indvars.iv.next103.9, %wide.trip.count105, !dbg !191
  br i1 %exitcond106.9.not, label %for_begin_yy.for_end_yy_crit_edge.split.us.split.us59.us.us.us.9, label %for_begin_xx.preheader.us.us57.us.us.us.9, !dbg !191, !prof !200

for_begin_yy.for_end_yy_crit_edge.split.us.split.us59.us.us.us.9: ; preds = %for_begin_xx.for_end_xx_crit_edge.split.us50.us.us.us.us.9
    #dbg_declare(i64 10, !211, !DIExpression(), !191)
    #dbg_declare(i64 10, !211, !DIExpression(), !191)
    #dbg_declare(i32 0, !212, !DIExpression(), !191)
  %355 = getelementptr float, ptr %84, i64 %175
  br label %for_begin_xx.preheader.us.us57.us.us.us.10, !dbg !191

for_begin_xx.preheader.us.us57.us.us.us.10:       ; preds = %for_begin_xx.for_end_xx_crit_edge.split.us50.us.us.us.us.10, %for_begin_yy.for_end_yy_crit_edge.split.us.split.us59.us.us.us.9
  %indvars.iv102.10 = phi i64 [ %indvars.iv.next103.10, %for_begin_xx.for_end_xx_crit_edge.split.us50.us.us.us.us.10 ], [ 0, %for_begin_yy.for_end_yy_crit_edge.split.us.split.us59.us.us.us.9 ]
    #dbg_declare(i64 %indvars.iv102.10, !212, !DIExpression(), !191)
    #dbg_declare(i32 0, !213, !DIExpression(), !191)
  %356 = mul nsw i64 %indvars.iv102.10, %73
  %357 = getelementptr float, ptr %355, i64 %356
  br i1 %or.cond400, label %vector.body256, label %for_begin_xx.preheader.us.us57.us.us.us.10.for_body_xx.us48.us.us.us.us.10.preheader_crit_edge, !dbg !191, !prof !222

for_begin_xx.preheader.us.us57.us.us.us.10.for_body_xx.us48.us.us.us.us.10.preheader_crit_edge: ; preds = %for_begin_xx.preheader.us.us57.us.us.us.10
  call void @llvm.instrprof.increment(ptr @__profn_TVMMod_default_function_compute_, i64 46134000452360265, i32 171, i32 87), !dbg !191
  br label %for_body_xx.us48.us.us.us.us.10.preheader, !dbg !191

vector.body256:                                   ; preds = %vector.body256.vector.body256_crit_edge, %for_begin_xx.preheader.us.us57.us.us.us.10
  %index257 = phi i64 [ %index.next258, %vector.body256.vector.body256_crit_edge ], [ 0, %for_begin_xx.preheader.us.us57.us.us.us.10 ], !dbg !191
  %358 = getelementptr float, ptr %357, i64 %index257, !dbg !191
  %359 = getelementptr i8, ptr %358, i64 16, !dbg !191
  store <4 x float> zeroinitializer, ptr %358, align 4, !dbg !191, !tbaa !219
  store <4 x float> zeroinitializer, ptr %359, align 4, !dbg !191, !tbaa !219
  %index.next258 = add nuw i64 %index257, 8, !dbg !191
  %360 = icmp eq i64 %index.next258, %n.vec254, !dbg !191
  br i1 %360, label %middle.block249, label %vector.body256.vector.body256_crit_edge, !dbg !191, !prof !223, !llvm.loop !259

vector.body256.vector.body256_crit_edge:          ; preds = %vector.body256
  call void @llvm.instrprof.increment(ptr @__profn_TVMMod_default_function_compute_, i64 46134000452360265, i32 171, i32 20), !dbg !191
  br label %vector.body256, !dbg !191

middle.block249:                                  ; preds = %vector.body256
  call void @llvm.instrprof.increment(ptr @__profn_TVMMod_default_function_compute_, i64 46134000452360265, i32 171, i32 145), !dbg !191
  br i1 %cmp.n259, label %middle.block249.for_begin_xx.for_end_xx_crit_edge.split.us50.us.us.us.us.10_crit_edge, label %for_body_xx.us48.us.us.us.us.10.preheader, !dbg !191, !prof !227

middle.block249.for_begin_xx.for_end_xx_crit_edge.split.us50.us.us.us.us.10_crit_edge: ; preds = %middle.block249
  call void @llvm.instrprof.increment(ptr @__profn_TVMMod_default_function_compute_, i64 46134000452360265, i32 171, i32 70), !dbg !191
  br label %for_begin_xx.for_end_xx_crit_edge.split.us50.us.us.us.us.10, !dbg !191

for_body_xx.us48.us.us.us.us.10.preheader:        ; preds = %for_begin_xx.preheader.us.us57.us.us.us.10.for_body_xx.us48.us.us.us.us.10.preheader_crit_edge, %middle.block249
  %indvars.iv97.10.ph = phi i64 [ 0, %for_begin_xx.preheader.us.us57.us.us.us.10.for_body_xx.us48.us.us.us.us.10.preheader_crit_edge ], [ %n.vec254, %middle.block249 ]
  br i1 %lcmp.mod446.not, label %for_body_xx.us48.us.us.us.us.10.prol.loopexit, label %for_body_xx.us48.us.us.us.us.10.preheader.for_body_xx.us48.us.us.us.us.10.prol_crit_edge, !dbg !191, !prof !194

for_body_xx.us48.us.us.us.us.10.preheader.for_body_xx.us48.us.us.us.us.10.prol_crit_edge: ; preds = %for_body_xx.us48.us.us.us.us.10.preheader
  call void @llvm.instrprof.increment(ptr @__profn_TVMMod_default_function_compute_, i64 46134000452360265, i32 171, i32 113), !dbg !191
  br label %for_body_xx.us48.us.us.us.us.10.prol, !dbg !191

for_body_xx.us48.us.us.us.us.10.prol:             ; preds = %for_body_xx.us48.us.us.us.us.10.preheader.for_body_xx.us48.us.us.us.us.10.prol_crit_edge, %for_body_xx.us48.us.us.us.us.10.prol.for_body_xx.us48.us.us.us.us.10.prol_crit_edge
  %indvars.iv97.10.prol = phi i64 [ %indvars.iv.next98.10.prol, %for_body_xx.us48.us.us.us.us.10.prol.for_body_xx.us48.us.us.us.us.10.prol_crit_edge ], [ %indvars.iv97.10.ph, %for_body_xx.us48.us.us.us.us.10.preheader.for_body_xx.us48.us.us.us.us.10.prol_crit_edge ]
  %prol.iter447 = phi i64 [ %prol.iter447.next, %for_body_xx.us48.us.us.us.us.10.prol.for_body_xx.us48.us.us.us.us.10.prol_crit_edge ], [ 0, %for_body_xx.us48.us.us.us.us.10.preheader.for_body_xx.us48.us.us.us.us.10.prol_crit_edge ]
    #dbg_declare(i64 %indvars.iv97.10.prol, !213, !DIExpression(), !191)
  %361 = mul nsw i64 %indvars.iv97.10.prol, %72, !dbg !191
  %362 = getelementptr float, ptr %357, i64 %361, !dbg !191
  store float 0.000000e+00, ptr %362, align 4, !dbg !191, !tbaa !219
    #dbg_declare(i32 0, !214, !DIExpression(), !191)
  %indvars.iv.next98.10.prol = add nuw nsw i64 %indvars.iv97.10.prol, 1, !dbg !191
    #dbg_declare(i64 %indvars.iv.next98.10.prol, !213, !DIExpression(), !191)
  %prol.iter447.next = add i64 %prol.iter447, 1, !dbg !191
  %prol.iter447.cmp.not = icmp eq i64 %prol.iter447.next, %xtraiter445, !dbg !191
  br i1 %prol.iter447.cmp.not, label %for_body_xx.us48.us.us.us.us.10.prol.loopexit, label %for_body_xx.us48.us.us.us.us.10.prol.for_body_xx.us48.us.us.us.us.10.prol_crit_edge, !dbg !191, !prof !207, !llvm.loop !260

for_body_xx.us48.us.us.us.us.10.prol.for_body_xx.us48.us.us.us.us.10.prol_crit_edge: ; preds = %for_body_xx.us48.us.us.us.us.10.prol
  call void @llvm.instrprof.increment(ptr @__profn_TVMMod_default_function_compute_, i64 46134000452360265, i32 171, i32 48), !dbg !191
  br label %for_body_xx.us48.us.us.us.us.10.prol, !dbg !191

for_body_xx.us48.us.us.us.us.10.prol.loopexit:    ; preds = %for_body_xx.us48.us.us.us.us.10.prol, %for_body_xx.us48.us.us.us.us.10.preheader
  %indvars.iv97.10.unr = phi i64 [ %indvars.iv97.10.ph, %for_body_xx.us48.us.us.us.us.10.preheader ], [ %indvars.iv.next98.10.prol, %for_body_xx.us48.us.us.us.us.10.prol ]
  %363 = sub nsw i64 %indvars.iv97.10.ph, %wide.trip.count100, !dbg !191
  %364 = icmp ugt i64 %363, -4, !dbg !191
  br i1 %364, label %for_body_xx.us48.us.us.us.us.10.prol.loopexit.for_begin_xx.for_end_xx_crit_edge.split.us50.us.us.us.us.10_crit_edge, label %for_body_xx.us48.us.us.us.us.10, !dbg !191, !prof !201

for_body_xx.us48.us.us.us.us.10.prol.loopexit.for_begin_xx.for_end_xx_crit_edge.split.us50.us.us.us.us.10_crit_edge: ; preds = %for_body_xx.us48.us.us.us.us.10.prol.loopexit
  call void @llvm.instrprof.increment(ptr @__profn_TVMMod_default_function_compute_, i64 46134000452360265, i32 171, i32 114), !dbg !191
  br label %for_begin_xx.for_end_xx_crit_edge.split.us50.us.us.us.us.10, !dbg !191

for_body_xx.us48.us.us.us.us.10:                  ; preds = %for_body_xx.us48.us.us.us.us.10.for_body_xx.us48.us.us.us.us.10_crit_edge, %for_body_xx.us48.us.us.us.us.10.prol.loopexit
  %indvars.iv97.10 = phi i64 [ %indvars.iv.next98.10.3, %for_body_xx.us48.us.us.us.us.10.for_body_xx.us48.us.us.us.us.10_crit_edge ], [ %indvars.iv97.10.unr, %for_body_xx.us48.us.us.us.us.10.prol.loopexit ]
    #dbg_declare(i64 %indvars.iv97.10, !213, !DIExpression(), !191)
  %365 = mul nsw i64 %indvars.iv97.10, %72, !dbg !191
  %366 = getelementptr float, ptr %357, i64 %365, !dbg !191
  store float 0.000000e+00, ptr %366, align 4, !dbg !191, !tbaa !219
    #dbg_declare(i32 0, !214, !DIExpression(), !191)
  %indvars.iv.next98.10 = add nuw nsw i64 %indvars.iv97.10, 1, !dbg !191
    #dbg_declare(i64 %indvars.iv.next98.10, !213, !DIExpression(), !191)
    #dbg_declare(i64 %indvars.iv.next98.10, !213, !DIExpression(), !191)
  %367 = mul nsw i64 %indvars.iv.next98.10, %72, !dbg !191
  %368 = getelementptr float, ptr %357, i64 %367, !dbg !191
  store float 0.000000e+00, ptr %368, align 4, !dbg !191, !tbaa !219
    #dbg_declare(i32 0, !214, !DIExpression(), !191)
  %indvars.iv.next98.10.1 = add nuw nsw i64 %indvars.iv97.10, 2, !dbg !191
    #dbg_declare(i64 %indvars.iv.next98.10.1, !213, !DIExpression(), !191)
    #dbg_declare(i64 %indvars.iv.next98.10.1, !213, !DIExpression(), !191)
  %369 = mul nsw i64 %indvars.iv.next98.10.1, %72, !dbg !191
  %370 = getelementptr float, ptr %357, i64 %369, !dbg !191
  store float 0.000000e+00, ptr %370, align 4, !dbg !191, !tbaa !219
    #dbg_declare(i32 0, !214, !DIExpression(), !191)
  %indvars.iv.next98.10.2 = add nuw nsw i64 %indvars.iv97.10, 3, !dbg !191
    #dbg_declare(i64 %indvars.iv.next98.10.2, !213, !DIExpression(), !191)
    #dbg_declare(i64 %indvars.iv.next98.10.2, !213, !DIExpression(), !191)
  %371 = mul nsw i64 %indvars.iv.next98.10.2, %72, !dbg !191
  %372 = getelementptr float, ptr %357, i64 %371, !dbg !191
  store float 0.000000e+00, ptr %372, align 4, !dbg !191, !tbaa !219
    #dbg_declare(i32 0, !214, !DIExpression(), !191)
  %indvars.iv.next98.10.3 = add nuw nsw i64 %indvars.iv97.10, 4, !dbg !191
    #dbg_declare(i64 %indvars.iv.next98.10.3, !213, !DIExpression(), !191)
  %exitcond101.10.not.3 = icmp eq i64 %indvars.iv.next98.10.3, %wide.trip.count100, !dbg !191
  br i1 %exitcond101.10.not.3, label %for_begin_xx.for_end_xx_crit_edge.split.us50.us.us.us.us.10, label %for_body_xx.us48.us.us.us.us.10.for_body_xx.us48.us.us.us.us.10_crit_edge, !dbg !191, !prof !230, !llvm.loop !261

for_body_xx.us48.us.us.us.us.10.for_body_xx.us48.us.us.us.us.10_crit_edge: ; preds = %for_body_xx.us48.us.us.us.us.10
  call void @llvm.instrprof.increment(ptr @__profn_TVMMod_default_function_compute_, i64 46134000452360265, i32 171, i32 49), !dbg !191
  br label %for_body_xx.us48.us.us.us.us.10, !dbg !191

for_begin_xx.for_end_xx_crit_edge.split.us50.us.us.us.us.10: ; preds = %for_body_xx.us48.us.us.us.us.10.prol.loopexit.for_begin_xx.for_end_xx_crit_edge.split.us50.us.us.us.us.10_crit_edge, %middle.block249.for_begin_xx.for_end_xx_crit_edge.split.us50.us.us.us.us.10_crit_edge, %for_body_xx.us48.us.us.us.us.10
  %indvars.iv.next103.10 = add nuw nsw i64 %indvars.iv102.10, 1, !dbg !191
    #dbg_declare(i64 %indvars.iv.next103.10, !212, !DIExpression(), !191)
  %exitcond106.10.not = icmp eq i64 %indvars.iv.next103.10, %wide.trip.count105, !dbg !191
  br i1 %exitcond106.10.not, label %for_begin_yy.for_end_yy_crit_edge.split.us.split.us59.us.us.us.10, label %for_begin_xx.preheader.us.us57.us.us.us.10, !dbg !191, !prof !200

for_begin_yy.for_end_yy_crit_edge.split.us.split.us59.us.us.us.10: ; preds = %for_begin_xx.for_end_xx_crit_edge.split.us50.us.us.us.us.10
    #dbg_declare(i64 11, !211, !DIExpression(), !191)
    #dbg_declare(i64 11, !211, !DIExpression(), !191)
    #dbg_declare(i32 0, !212, !DIExpression(), !191)
  %373 = getelementptr float, ptr %85, i64 %175
  br label %for_begin_xx.preheader.us.us57.us.us.us.11, !dbg !191

for_begin_xx.preheader.us.us57.us.us.us.11:       ; preds = %for_begin_xx.for_end_xx_crit_edge.split.us50.us.us.us.us.11, %for_begin_yy.for_end_yy_crit_edge.split.us.split.us59.us.us.us.10
  %indvars.iv102.11 = phi i64 [ %indvars.iv.next103.11, %for_begin_xx.for_end_xx_crit_edge.split.us50.us.us.us.us.11 ], [ 0, %for_begin_yy.for_end_yy_crit_edge.split.us.split.us59.us.us.us.10 ]
    #dbg_declare(i64 %indvars.iv102.11, !212, !DIExpression(), !191)
    #dbg_declare(i32 0, !213, !DIExpression(), !191)
  %374 = mul nsw i64 %indvars.iv102.11, %73
  %375 = getelementptr float, ptr %373, i64 %374
  br i1 %or.cond401, label %vector.body243, label %for_begin_xx.preheader.us.us57.us.us.us.11.for_body_xx.us48.us.us.us.us.11.preheader_crit_edge, !dbg !191, !prof !222

for_begin_xx.preheader.us.us57.us.us.us.11.for_body_xx.us48.us.us.us.us.11.preheader_crit_edge: ; preds = %for_begin_xx.preheader.us.us57.us.us.us.11
  call void @llvm.instrprof.increment(ptr @__profn_TVMMod_default_function_compute_, i64 46134000452360265, i32 171, i32 88), !dbg !191
  br label %for_body_xx.us48.us.us.us.us.11.preheader, !dbg !191

vector.body243:                                   ; preds = %vector.body243.vector.body243_crit_edge, %for_begin_xx.preheader.us.us57.us.us.us.11
  %index244 = phi i64 [ %index.next245, %vector.body243.vector.body243_crit_edge ], [ 0, %for_begin_xx.preheader.us.us57.us.us.us.11 ], !dbg !191
  %376 = getelementptr float, ptr %375, i64 %index244, !dbg !191
  %377 = getelementptr i8, ptr %376, i64 16, !dbg !191
  store <4 x float> zeroinitializer, ptr %376, align 4, !dbg !191, !tbaa !219
  store <4 x float> zeroinitializer, ptr %377, align 4, !dbg !191, !tbaa !219
  %index.next245 = add nuw i64 %index244, 8, !dbg !191
  %378 = icmp eq i64 %index.next245, %n.vec241, !dbg !191
  br i1 %378, label %middle.block236, label %vector.body243.vector.body243_crit_edge, !dbg !191, !prof !223, !llvm.loop !262

vector.body243.vector.body243_crit_edge:          ; preds = %vector.body243
  call void @llvm.instrprof.increment(ptr @__profn_TVMMod_default_function_compute_, i64 46134000452360265, i32 171, i32 21), !dbg !191
  br label %vector.body243, !dbg !191

middle.block236:                                  ; preds = %vector.body243
  call void @llvm.instrprof.increment(ptr @__profn_TVMMod_default_function_compute_, i64 46134000452360265, i32 171, i32 146), !dbg !191
  br i1 %cmp.n246, label %middle.block236.for_begin_xx.for_end_xx_crit_edge.split.us50.us.us.us.us.11_crit_edge, label %for_body_xx.us48.us.us.us.us.11.preheader, !dbg !191, !prof !227

middle.block236.for_begin_xx.for_end_xx_crit_edge.split.us50.us.us.us.us.11_crit_edge: ; preds = %middle.block236
  call void @llvm.instrprof.increment(ptr @__profn_TVMMod_default_function_compute_, i64 46134000452360265, i32 171, i32 71), !dbg !191
  br label %for_begin_xx.for_end_xx_crit_edge.split.us50.us.us.us.us.11, !dbg !191

for_body_xx.us48.us.us.us.us.11.preheader:        ; preds = %for_begin_xx.preheader.us.us57.us.us.us.11.for_body_xx.us48.us.us.us.us.11.preheader_crit_edge, %middle.block236
  %indvars.iv97.11.ph = phi i64 [ 0, %for_begin_xx.preheader.us.us57.us.us.us.11.for_body_xx.us48.us.us.us.us.11.preheader_crit_edge ], [ %n.vec241, %middle.block236 ]
  br i1 %lcmp.mod449.not, label %for_body_xx.us48.us.us.us.us.11.prol.loopexit, label %for_body_xx.us48.us.us.us.us.11.preheader.for_body_xx.us48.us.us.us.us.11.prol_crit_edge, !dbg !191, !prof !194

for_body_xx.us48.us.us.us.us.11.preheader.for_body_xx.us48.us.us.us.us.11.prol_crit_edge: ; preds = %for_body_xx.us48.us.us.us.us.11.preheader
  call void @llvm.instrprof.increment(ptr @__profn_TVMMod_default_function_compute_, i64 46134000452360265, i32 171, i32 115), !dbg !191
  br label %for_body_xx.us48.us.us.us.us.11.prol, !dbg !191

for_body_xx.us48.us.us.us.us.11.prol:             ; preds = %for_body_xx.us48.us.us.us.us.11.preheader.for_body_xx.us48.us.us.us.us.11.prol_crit_edge, %for_body_xx.us48.us.us.us.us.11.prol.for_body_xx.us48.us.us.us.us.11.prol_crit_edge
  %indvars.iv97.11.prol = phi i64 [ %indvars.iv.next98.11.prol, %for_body_xx.us48.us.us.us.us.11.prol.for_body_xx.us48.us.us.us.us.11.prol_crit_edge ], [ %indvars.iv97.11.ph, %for_body_xx.us48.us.us.us.us.11.preheader.for_body_xx.us48.us.us.us.us.11.prol_crit_edge ]
  %prol.iter450 = phi i64 [ %prol.iter450.next, %for_body_xx.us48.us.us.us.us.11.prol.for_body_xx.us48.us.us.us.us.11.prol_crit_edge ], [ 0, %for_body_xx.us48.us.us.us.us.11.preheader.for_body_xx.us48.us.us.us.us.11.prol_crit_edge ]
    #dbg_declare(i64 %indvars.iv97.11.prol, !213, !DIExpression(), !191)
  %379 = mul nsw i64 %indvars.iv97.11.prol, %72, !dbg !191
  %380 = getelementptr float, ptr %375, i64 %379, !dbg !191
  store float 0.000000e+00, ptr %380, align 4, !dbg !191, !tbaa !219
    #dbg_declare(i32 0, !214, !DIExpression(), !191)
  %indvars.iv.next98.11.prol = add nuw nsw i64 %indvars.iv97.11.prol, 1, !dbg !191
    #dbg_declare(i64 %indvars.iv.next98.11.prol, !213, !DIExpression(), !191)
  %prol.iter450.next = add i64 %prol.iter450, 1, !dbg !191
  %prol.iter450.cmp.not = icmp eq i64 %prol.iter450.next, %xtraiter448, !dbg !191
  br i1 %prol.iter450.cmp.not, label %for_body_xx.us48.us.us.us.us.11.prol.loopexit, label %for_body_xx.us48.us.us.us.us.11.prol.for_body_xx.us48.us.us.us.us.11.prol_crit_edge, !dbg !191, !prof !207, !llvm.loop !263

for_body_xx.us48.us.us.us.us.11.prol.for_body_xx.us48.us.us.us.us.11.prol_crit_edge: ; preds = %for_body_xx.us48.us.us.us.us.11.prol
  call void @llvm.instrprof.increment(ptr @__profn_TVMMod_default_function_compute_, i64 46134000452360265, i32 171, i32 50), !dbg !191
  br label %for_body_xx.us48.us.us.us.us.11.prol, !dbg !191

for_body_xx.us48.us.us.us.us.11.prol.loopexit:    ; preds = %for_body_xx.us48.us.us.us.us.11.prol, %for_body_xx.us48.us.us.us.us.11.preheader
  %indvars.iv97.11.unr = phi i64 [ %indvars.iv97.11.ph, %for_body_xx.us48.us.us.us.us.11.preheader ], [ %indvars.iv.next98.11.prol, %for_body_xx.us48.us.us.us.us.11.prol ]
  %381 = sub nsw i64 %indvars.iv97.11.ph, %wide.trip.count100, !dbg !191
  %382 = icmp ugt i64 %381, -4, !dbg !191
  br i1 %382, label %for_body_xx.us48.us.us.us.us.11.prol.loopexit.for_begin_xx.for_end_xx_crit_edge.split.us50.us.us.us.us.11_crit_edge, label %for_body_xx.us48.us.us.us.us.11, !dbg !191, !prof !201

for_body_xx.us48.us.us.us.us.11.prol.loopexit.for_begin_xx.for_end_xx_crit_edge.split.us50.us.us.us.us.11_crit_edge: ; preds = %for_body_xx.us48.us.us.us.us.11.prol.loopexit
  call void @llvm.instrprof.increment(ptr @__profn_TVMMod_default_function_compute_, i64 46134000452360265, i32 171, i32 116), !dbg !191
  br label %for_begin_xx.for_end_xx_crit_edge.split.us50.us.us.us.us.11, !dbg !191

for_body_xx.us48.us.us.us.us.11:                  ; preds = %for_body_xx.us48.us.us.us.us.11.for_body_xx.us48.us.us.us.us.11_crit_edge, %for_body_xx.us48.us.us.us.us.11.prol.loopexit
  %indvars.iv97.11 = phi i64 [ %indvars.iv.next98.11.3, %for_body_xx.us48.us.us.us.us.11.for_body_xx.us48.us.us.us.us.11_crit_edge ], [ %indvars.iv97.11.unr, %for_body_xx.us48.us.us.us.us.11.prol.loopexit ]
    #dbg_declare(i64 %indvars.iv97.11, !213, !DIExpression(), !191)
  %383 = mul nsw i64 %indvars.iv97.11, %72, !dbg !191
  %384 = getelementptr float, ptr %375, i64 %383, !dbg !191
  store float 0.000000e+00, ptr %384, align 4, !dbg !191, !tbaa !219
    #dbg_declare(i32 0, !214, !DIExpression(), !191)
  %indvars.iv.next98.11 = add nuw nsw i64 %indvars.iv97.11, 1, !dbg !191
    #dbg_declare(i64 %indvars.iv.next98.11, !213, !DIExpression(), !191)
    #dbg_declare(i64 %indvars.iv.next98.11, !213, !DIExpression(), !191)
  %385 = mul nsw i64 %indvars.iv.next98.11, %72, !dbg !191
  %386 = getelementptr float, ptr %375, i64 %385, !dbg !191
  store float 0.000000e+00, ptr %386, align 4, !dbg !191, !tbaa !219
    #dbg_declare(i32 0, !214, !DIExpression(), !191)
  %indvars.iv.next98.11.1 = add nuw nsw i64 %indvars.iv97.11, 2, !dbg !191
    #dbg_declare(i64 %indvars.iv.next98.11.1, !213, !DIExpression(), !191)
    #dbg_declare(i64 %indvars.iv.next98.11.1, !213, !DIExpression(), !191)
  %387 = mul nsw i64 %indvars.iv.next98.11.1, %72, !dbg !191
  %388 = getelementptr float, ptr %375, i64 %387, !dbg !191
  store float 0.000000e+00, ptr %388, align 4, !dbg !191, !tbaa !219
    #dbg_declare(i32 0, !214, !DIExpression(), !191)
  %indvars.iv.next98.11.2 = add nuw nsw i64 %indvars.iv97.11, 3, !dbg !191
    #dbg_declare(i64 %indvars.iv.next98.11.2, !213, !DIExpression(), !191)
    #dbg_declare(i64 %indvars.iv.next98.11.2, !213, !DIExpression(), !191)
  %389 = mul nsw i64 %indvars.iv.next98.11.2, %72, !dbg !191
  %390 = getelementptr float, ptr %375, i64 %389, !dbg !191
  store float 0.000000e+00, ptr %390, align 4, !dbg !191, !tbaa !219
    #dbg_declare(i32 0, !214, !DIExpression(), !191)
  %indvars.iv.next98.11.3 = add nuw nsw i64 %indvars.iv97.11, 4, !dbg !191
    #dbg_declare(i64 %indvars.iv.next98.11.3, !213, !DIExpression(), !191)
  %exitcond101.11.not.3 = icmp eq i64 %indvars.iv.next98.11.3, %wide.trip.count100, !dbg !191
  br i1 %exitcond101.11.not.3, label %for_begin_xx.for_end_xx_crit_edge.split.us50.us.us.us.us.11, label %for_body_xx.us48.us.us.us.us.11.for_body_xx.us48.us.us.us.us.11_crit_edge, !dbg !191, !prof !230, !llvm.loop !264

for_body_xx.us48.us.us.us.us.11.for_body_xx.us48.us.us.us.us.11_crit_edge: ; preds = %for_body_xx.us48.us.us.us.us.11
  call void @llvm.instrprof.increment(ptr @__profn_TVMMod_default_function_compute_, i64 46134000452360265, i32 171, i32 51), !dbg !191
  br label %for_body_xx.us48.us.us.us.us.11, !dbg !191

for_begin_xx.for_end_xx_crit_edge.split.us50.us.us.us.us.11: ; preds = %for_body_xx.us48.us.us.us.us.11.prol.loopexit.for_begin_xx.for_end_xx_crit_edge.split.us50.us.us.us.us.11_crit_edge, %middle.block236.for_begin_xx.for_end_xx_crit_edge.split.us50.us.us.us.us.11_crit_edge, %for_body_xx.us48.us.us.us.us.11
  %indvars.iv.next103.11 = add nuw nsw i64 %indvars.iv102.11, 1, !dbg !191
    #dbg_declare(i64 %indvars.iv.next103.11, !212, !DIExpression(), !191)
  %exitcond106.11.not = icmp eq i64 %indvars.iv.next103.11, %wide.trip.count105, !dbg !191
  br i1 %exitcond106.11.not, label %for_begin_yy.for_end_yy_crit_edge.split.us.split.us59.us.us.us.11, label %for_begin_xx.preheader.us.us57.us.us.us.11, !dbg !191, !prof !200

for_begin_yy.for_end_yy_crit_edge.split.us.split.us59.us.us.us.11: ; preds = %for_begin_xx.for_end_xx_crit_edge.split.us50.us.us.us.us.11
    #dbg_declare(i64 12, !211, !DIExpression(), !191)
    #dbg_declare(i64 12, !211, !DIExpression(), !191)
    #dbg_declare(i32 0, !212, !DIExpression(), !191)
  %391 = getelementptr float, ptr %86, i64 %175
  br label %for_begin_xx.preheader.us.us57.us.us.us.12, !dbg !191

for_begin_xx.preheader.us.us57.us.us.us.12:       ; preds = %for_begin_xx.for_end_xx_crit_edge.split.us50.us.us.us.us.12, %for_begin_yy.for_end_yy_crit_edge.split.us.split.us59.us.us.us.11
  %indvars.iv102.12 = phi i64 [ %indvars.iv.next103.12, %for_begin_xx.for_end_xx_crit_edge.split.us50.us.us.us.us.12 ], [ 0, %for_begin_yy.for_end_yy_crit_edge.split.us.split.us59.us.us.us.11 ]
    #dbg_declare(i64 %indvars.iv102.12, !212, !DIExpression(), !191)
    #dbg_declare(i32 0, !213, !DIExpression(), !191)
  %392 = mul nsw i64 %indvars.iv102.12, %73
  %393 = getelementptr float, ptr %391, i64 %392
  br i1 %or.cond402, label %vector.body230, label %for_begin_xx.preheader.us.us57.us.us.us.12.for_body_xx.us48.us.us.us.us.12.preheader_crit_edge, !dbg !191, !prof !222

for_begin_xx.preheader.us.us57.us.us.us.12.for_body_xx.us48.us.us.us.us.12.preheader_crit_edge: ; preds = %for_begin_xx.preheader.us.us57.us.us.us.12
  call void @llvm.instrprof.increment(ptr @__profn_TVMMod_default_function_compute_, i64 46134000452360265, i32 171, i32 89), !dbg !191
  br label %for_body_xx.us48.us.us.us.us.12.preheader, !dbg !191

vector.body230:                                   ; preds = %vector.body230.vector.body230_crit_edge, %for_begin_xx.preheader.us.us57.us.us.us.12
  %index231 = phi i64 [ %index.next232, %vector.body230.vector.body230_crit_edge ], [ 0, %for_begin_xx.preheader.us.us57.us.us.us.12 ], !dbg !191
  %394 = getelementptr float, ptr %393, i64 %index231, !dbg !191
  %395 = getelementptr i8, ptr %394, i64 16, !dbg !191
  store <4 x float> zeroinitializer, ptr %394, align 4, !dbg !191, !tbaa !219
  store <4 x float> zeroinitializer, ptr %395, align 4, !dbg !191, !tbaa !219
  %index.next232 = add nuw i64 %index231, 8, !dbg !191
  %396 = icmp eq i64 %index.next232, %n.vec228, !dbg !191
  br i1 %396, label %middle.block223, label %vector.body230.vector.body230_crit_edge, !dbg !191, !prof !223, !llvm.loop !265

vector.body230.vector.body230_crit_edge:          ; preds = %vector.body230
  call void @llvm.instrprof.increment(ptr @__profn_TVMMod_default_function_compute_, i64 46134000452360265, i32 171, i32 22), !dbg !191
  br label %vector.body230, !dbg !191

middle.block223:                                  ; preds = %vector.body230
  call void @llvm.instrprof.increment(ptr @__profn_TVMMod_default_function_compute_, i64 46134000452360265, i32 171, i32 147), !dbg !191
  br i1 %cmp.n233, label %middle.block223.for_begin_xx.for_end_xx_crit_edge.split.us50.us.us.us.us.12_crit_edge, label %for_body_xx.us48.us.us.us.us.12.preheader, !dbg !191, !prof !227

middle.block223.for_begin_xx.for_end_xx_crit_edge.split.us50.us.us.us.us.12_crit_edge: ; preds = %middle.block223
  call void @llvm.instrprof.increment(ptr @__profn_TVMMod_default_function_compute_, i64 46134000452360265, i32 171, i32 72), !dbg !191
  br label %for_begin_xx.for_end_xx_crit_edge.split.us50.us.us.us.us.12, !dbg !191

for_body_xx.us48.us.us.us.us.12.preheader:        ; preds = %for_begin_xx.preheader.us.us57.us.us.us.12.for_body_xx.us48.us.us.us.us.12.preheader_crit_edge, %middle.block223
  %indvars.iv97.12.ph = phi i64 [ 0, %for_begin_xx.preheader.us.us57.us.us.us.12.for_body_xx.us48.us.us.us.us.12.preheader_crit_edge ], [ %n.vec228, %middle.block223 ]
  br i1 %lcmp.mod452.not, label %for_body_xx.us48.us.us.us.us.12.prol.loopexit, label %for_body_xx.us48.us.us.us.us.12.preheader.for_body_xx.us48.us.us.us.us.12.prol_crit_edge, !dbg !191, !prof !194

for_body_xx.us48.us.us.us.us.12.preheader.for_body_xx.us48.us.us.us.us.12.prol_crit_edge: ; preds = %for_body_xx.us48.us.us.us.us.12.preheader
  call void @llvm.instrprof.increment(ptr @__profn_TVMMod_default_function_compute_, i64 46134000452360265, i32 171, i32 117), !dbg !191
  br label %for_body_xx.us48.us.us.us.us.12.prol, !dbg !191

for_body_xx.us48.us.us.us.us.12.prol:             ; preds = %for_body_xx.us48.us.us.us.us.12.preheader.for_body_xx.us48.us.us.us.us.12.prol_crit_edge, %for_body_xx.us48.us.us.us.us.12.prol.for_body_xx.us48.us.us.us.us.12.prol_crit_edge
  %indvars.iv97.12.prol = phi i64 [ %indvars.iv.next98.12.prol, %for_body_xx.us48.us.us.us.us.12.prol.for_body_xx.us48.us.us.us.us.12.prol_crit_edge ], [ %indvars.iv97.12.ph, %for_body_xx.us48.us.us.us.us.12.preheader.for_body_xx.us48.us.us.us.us.12.prol_crit_edge ]
  %prol.iter453 = phi i64 [ %prol.iter453.next, %for_body_xx.us48.us.us.us.us.12.prol.for_body_xx.us48.us.us.us.us.12.prol_crit_edge ], [ 0, %for_body_xx.us48.us.us.us.us.12.preheader.for_body_xx.us48.us.us.us.us.12.prol_crit_edge ]
    #dbg_declare(i64 %indvars.iv97.12.prol, !213, !DIExpression(), !191)
  %397 = mul nsw i64 %indvars.iv97.12.prol, %72, !dbg !191
  %398 = getelementptr float, ptr %393, i64 %397, !dbg !191
  store float 0.000000e+00, ptr %398, align 4, !dbg !191, !tbaa !219
    #dbg_declare(i32 0, !214, !DIExpression(), !191)
  %indvars.iv.next98.12.prol = add nuw nsw i64 %indvars.iv97.12.prol, 1, !dbg !191
    #dbg_declare(i64 %indvars.iv.next98.12.prol, !213, !DIExpression(), !191)
  %prol.iter453.next = add i64 %prol.iter453, 1, !dbg !191
  %prol.iter453.cmp.not = icmp eq i64 %prol.iter453.next, %xtraiter451, !dbg !191
  br i1 %prol.iter453.cmp.not, label %for_body_xx.us48.us.us.us.us.12.prol.loopexit, label %for_body_xx.us48.us.us.us.us.12.prol.for_body_xx.us48.us.us.us.us.12.prol_crit_edge, !dbg !191, !prof !207, !llvm.loop !266

for_body_xx.us48.us.us.us.us.12.prol.for_body_xx.us48.us.us.us.us.12.prol_crit_edge: ; preds = %for_body_xx.us48.us.us.us.us.12.prol
  call void @llvm.instrprof.increment(ptr @__profn_TVMMod_default_function_compute_, i64 46134000452360265, i32 171, i32 52), !dbg !191
  br label %for_body_xx.us48.us.us.us.us.12.prol, !dbg !191

for_body_xx.us48.us.us.us.us.12.prol.loopexit:    ; preds = %for_body_xx.us48.us.us.us.us.12.prol, %for_body_xx.us48.us.us.us.us.12.preheader
  %indvars.iv97.12.unr = phi i64 [ %indvars.iv97.12.ph, %for_body_xx.us48.us.us.us.us.12.preheader ], [ %indvars.iv.next98.12.prol, %for_body_xx.us48.us.us.us.us.12.prol ]
  %399 = sub nsw i64 %indvars.iv97.12.ph, %wide.trip.count100, !dbg !191
  %400 = icmp ugt i64 %399, -4, !dbg !191
  br i1 %400, label %for_body_xx.us48.us.us.us.us.12.prol.loopexit.for_begin_xx.for_end_xx_crit_edge.split.us50.us.us.us.us.12_crit_edge, label %for_body_xx.us48.us.us.us.us.12, !dbg !191, !prof !201

for_body_xx.us48.us.us.us.us.12.prol.loopexit.for_begin_xx.for_end_xx_crit_edge.split.us50.us.us.us.us.12_crit_edge: ; preds = %for_body_xx.us48.us.us.us.us.12.prol.loopexit
  call void @llvm.instrprof.increment(ptr @__profn_TVMMod_default_function_compute_, i64 46134000452360265, i32 171, i32 118), !dbg !191
  br label %for_begin_xx.for_end_xx_crit_edge.split.us50.us.us.us.us.12, !dbg !191

for_body_xx.us48.us.us.us.us.12:                  ; preds = %for_body_xx.us48.us.us.us.us.12.for_body_xx.us48.us.us.us.us.12_crit_edge, %for_body_xx.us48.us.us.us.us.12.prol.loopexit
  %indvars.iv97.12 = phi i64 [ %indvars.iv.next98.12.3, %for_body_xx.us48.us.us.us.us.12.for_body_xx.us48.us.us.us.us.12_crit_edge ], [ %indvars.iv97.12.unr, %for_body_xx.us48.us.us.us.us.12.prol.loopexit ]
    #dbg_declare(i64 %indvars.iv97.12, !213, !DIExpression(), !191)
  %401 = mul nsw i64 %indvars.iv97.12, %72, !dbg !191
  %402 = getelementptr float, ptr %393, i64 %401, !dbg !191
  store float 0.000000e+00, ptr %402, align 4, !dbg !191, !tbaa !219
    #dbg_declare(i32 0, !214, !DIExpression(), !191)
  %indvars.iv.next98.12 = add nuw nsw i64 %indvars.iv97.12, 1, !dbg !191
    #dbg_declare(i64 %indvars.iv.next98.12, !213, !DIExpression(), !191)
    #dbg_declare(i64 %indvars.iv.next98.12, !213, !DIExpression(), !191)
  %403 = mul nsw i64 %indvars.iv.next98.12, %72, !dbg !191
  %404 = getelementptr float, ptr %393, i64 %403, !dbg !191
  store float 0.000000e+00, ptr %404, align 4, !dbg !191, !tbaa !219
    #dbg_declare(i32 0, !214, !DIExpression(), !191)
  %indvars.iv.next98.12.1 = add nuw nsw i64 %indvars.iv97.12, 2, !dbg !191
    #dbg_declare(i64 %indvars.iv.next98.12.1, !213, !DIExpression(), !191)
    #dbg_declare(i64 %indvars.iv.next98.12.1, !213, !DIExpression(), !191)
  %405 = mul nsw i64 %indvars.iv.next98.12.1, %72, !dbg !191
  %406 = getelementptr float, ptr %393, i64 %405, !dbg !191
  store float 0.000000e+00, ptr %406, align 4, !dbg !191, !tbaa !219
    #dbg_declare(i32 0, !214, !DIExpression(), !191)
  %indvars.iv.next98.12.2 = add nuw nsw i64 %indvars.iv97.12, 3, !dbg !191
    #dbg_declare(i64 %indvars.iv.next98.12.2, !213, !DIExpression(), !191)
    #dbg_declare(i64 %indvars.iv.next98.12.2, !213, !DIExpression(), !191)
  %407 = mul nsw i64 %indvars.iv.next98.12.2, %72, !dbg !191
  %408 = getelementptr float, ptr %393, i64 %407, !dbg !191
  store float 0.000000e+00, ptr %408, align 4, !dbg !191, !tbaa !219
    #dbg_declare(i32 0, !214, !DIExpression(), !191)
  %indvars.iv.next98.12.3 = add nuw nsw i64 %indvars.iv97.12, 4, !dbg !191
    #dbg_declare(i64 %indvars.iv.next98.12.3, !213, !DIExpression(), !191)
  %exitcond101.12.not.3 = icmp eq i64 %indvars.iv.next98.12.3, %wide.trip.count100, !dbg !191
  br i1 %exitcond101.12.not.3, label %for_begin_xx.for_end_xx_crit_edge.split.us50.us.us.us.us.12, label %for_body_xx.us48.us.us.us.us.12.for_body_xx.us48.us.us.us.us.12_crit_edge, !dbg !191, !prof !230, !llvm.loop !267

for_body_xx.us48.us.us.us.us.12.for_body_xx.us48.us.us.us.us.12_crit_edge: ; preds = %for_body_xx.us48.us.us.us.us.12
  call void @llvm.instrprof.increment(ptr @__profn_TVMMod_default_function_compute_, i64 46134000452360265, i32 171, i32 53), !dbg !191
  br label %for_body_xx.us48.us.us.us.us.12, !dbg !191

for_begin_xx.for_end_xx_crit_edge.split.us50.us.us.us.us.12: ; preds = %for_body_xx.us48.us.us.us.us.12.prol.loopexit.for_begin_xx.for_end_xx_crit_edge.split.us50.us.us.us.us.12_crit_edge, %middle.block223.for_begin_xx.for_end_xx_crit_edge.split.us50.us.us.us.us.12_crit_edge, %for_body_xx.us48.us.us.us.us.12
  %indvars.iv.next103.12 = add nuw nsw i64 %indvars.iv102.12, 1, !dbg !191
    #dbg_declare(i64 %indvars.iv.next103.12, !212, !DIExpression(), !191)
  %exitcond106.12.not = icmp eq i64 %indvars.iv.next103.12, %wide.trip.count105, !dbg !191
  br i1 %exitcond106.12.not, label %for_begin_yy.for_end_yy_crit_edge.split.us.split.us59.us.us.us.12, label %for_begin_xx.preheader.us.us57.us.us.us.12, !dbg !191, !prof !200

for_begin_yy.for_end_yy_crit_edge.split.us.split.us59.us.us.us.12: ; preds = %for_begin_xx.for_end_xx_crit_edge.split.us50.us.us.us.us.12
    #dbg_declare(i64 13, !211, !DIExpression(), !191)
    #dbg_declare(i64 13, !211, !DIExpression(), !191)
    #dbg_declare(i32 0, !212, !DIExpression(), !191)
  %409 = getelementptr float, ptr %87, i64 %175
  br label %for_begin_xx.preheader.us.us57.us.us.us.13, !dbg !191

for_begin_xx.preheader.us.us57.us.us.us.13:       ; preds = %for_begin_xx.for_end_xx_crit_edge.split.us50.us.us.us.us.13, %for_begin_yy.for_end_yy_crit_edge.split.us.split.us59.us.us.us.12
  %indvars.iv102.13 = phi i64 [ %indvars.iv.next103.13, %for_begin_xx.for_end_xx_crit_edge.split.us50.us.us.us.us.13 ], [ 0, %for_begin_yy.for_end_yy_crit_edge.split.us.split.us59.us.us.us.12 ]
    #dbg_declare(i64 %indvars.iv102.13, !212, !DIExpression(), !191)
    #dbg_declare(i32 0, !213, !DIExpression(), !191)
  %410 = mul nsw i64 %indvars.iv102.13, %73
  %411 = getelementptr float, ptr %409, i64 %410
  br i1 %or.cond403, label %vector.body217, label %for_begin_xx.preheader.us.us57.us.us.us.13.for_body_xx.us48.us.us.us.us.13.preheader_crit_edge, !dbg !191, !prof !222

for_begin_xx.preheader.us.us57.us.us.us.13.for_body_xx.us48.us.us.us.us.13.preheader_crit_edge: ; preds = %for_begin_xx.preheader.us.us57.us.us.us.13
  call void @llvm.instrprof.increment(ptr @__profn_TVMMod_default_function_compute_, i64 46134000452360265, i32 171, i32 90), !dbg !191
  br label %for_body_xx.us48.us.us.us.us.13.preheader, !dbg !191

vector.body217:                                   ; preds = %vector.body217.vector.body217_crit_edge, %for_begin_xx.preheader.us.us57.us.us.us.13
  %index218 = phi i64 [ %index.next219, %vector.body217.vector.body217_crit_edge ], [ 0, %for_begin_xx.preheader.us.us57.us.us.us.13 ], !dbg !191
  %412 = getelementptr float, ptr %411, i64 %index218, !dbg !191
  %413 = getelementptr i8, ptr %412, i64 16, !dbg !191
  store <4 x float> zeroinitializer, ptr %412, align 4, !dbg !191, !tbaa !219
  store <4 x float> zeroinitializer, ptr %413, align 4, !dbg !191, !tbaa !219
  %index.next219 = add nuw i64 %index218, 8, !dbg !191
  %414 = icmp eq i64 %index.next219, %n.vec215, !dbg !191
  br i1 %414, label %middle.block210, label %vector.body217.vector.body217_crit_edge, !dbg !191, !prof !223, !llvm.loop !268

vector.body217.vector.body217_crit_edge:          ; preds = %vector.body217
  call void @llvm.instrprof.increment(ptr @__profn_TVMMod_default_function_compute_, i64 46134000452360265, i32 171, i32 23), !dbg !191
  br label %vector.body217, !dbg !191

middle.block210:                                  ; preds = %vector.body217
  call void @llvm.instrprof.increment(ptr @__profn_TVMMod_default_function_compute_, i64 46134000452360265, i32 171, i32 148), !dbg !191
  br i1 %cmp.n220, label %middle.block210.for_begin_xx.for_end_xx_crit_edge.split.us50.us.us.us.us.13_crit_edge, label %for_body_xx.us48.us.us.us.us.13.preheader, !dbg !191, !prof !227

middle.block210.for_begin_xx.for_end_xx_crit_edge.split.us50.us.us.us.us.13_crit_edge: ; preds = %middle.block210
  call void @llvm.instrprof.increment(ptr @__profn_TVMMod_default_function_compute_, i64 46134000452360265, i32 171, i32 73), !dbg !191
  br label %for_begin_xx.for_end_xx_crit_edge.split.us50.us.us.us.us.13, !dbg !191

for_body_xx.us48.us.us.us.us.13.preheader:        ; preds = %for_begin_xx.preheader.us.us57.us.us.us.13.for_body_xx.us48.us.us.us.us.13.preheader_crit_edge, %middle.block210
  %indvars.iv97.13.ph = phi i64 [ 0, %for_begin_xx.preheader.us.us57.us.us.us.13.for_body_xx.us48.us.us.us.us.13.preheader_crit_edge ], [ %n.vec215, %middle.block210 ]
  br i1 %lcmp.mod455.not, label %for_body_xx.us48.us.us.us.us.13.prol.loopexit, label %for_body_xx.us48.us.us.us.us.13.preheader.for_body_xx.us48.us.us.us.us.13.prol_crit_edge, !dbg !191, !prof !194

for_body_xx.us48.us.us.us.us.13.preheader.for_body_xx.us48.us.us.us.us.13.prol_crit_edge: ; preds = %for_body_xx.us48.us.us.us.us.13.preheader
  call void @llvm.instrprof.increment(ptr @__profn_TVMMod_default_function_compute_, i64 46134000452360265, i32 171, i32 119), !dbg !191
  br label %for_body_xx.us48.us.us.us.us.13.prol, !dbg !191

for_body_xx.us48.us.us.us.us.13.prol:             ; preds = %for_body_xx.us48.us.us.us.us.13.preheader.for_body_xx.us48.us.us.us.us.13.prol_crit_edge, %for_body_xx.us48.us.us.us.us.13.prol.for_body_xx.us48.us.us.us.us.13.prol_crit_edge
  %indvars.iv97.13.prol = phi i64 [ %indvars.iv.next98.13.prol, %for_body_xx.us48.us.us.us.us.13.prol.for_body_xx.us48.us.us.us.us.13.prol_crit_edge ], [ %indvars.iv97.13.ph, %for_body_xx.us48.us.us.us.us.13.preheader.for_body_xx.us48.us.us.us.us.13.prol_crit_edge ]
  %prol.iter456 = phi i64 [ %prol.iter456.next, %for_body_xx.us48.us.us.us.us.13.prol.for_body_xx.us48.us.us.us.us.13.prol_crit_edge ], [ 0, %for_body_xx.us48.us.us.us.us.13.preheader.for_body_xx.us48.us.us.us.us.13.prol_crit_edge ]
    #dbg_declare(i64 %indvars.iv97.13.prol, !213, !DIExpression(), !191)
  %415 = mul nsw i64 %indvars.iv97.13.prol, %72, !dbg !191
  %416 = getelementptr float, ptr %411, i64 %415, !dbg !191
  store float 0.000000e+00, ptr %416, align 4, !dbg !191, !tbaa !219
    #dbg_declare(i32 0, !214, !DIExpression(), !191)
  %indvars.iv.next98.13.prol = add nuw nsw i64 %indvars.iv97.13.prol, 1, !dbg !191
    #dbg_declare(i64 %indvars.iv.next98.13.prol, !213, !DIExpression(), !191)
  %prol.iter456.next = add i64 %prol.iter456, 1, !dbg !191
  %prol.iter456.cmp.not = icmp eq i64 %prol.iter456.next, %xtraiter454, !dbg !191
  br i1 %prol.iter456.cmp.not, label %for_body_xx.us48.us.us.us.us.13.prol.loopexit, label %for_body_xx.us48.us.us.us.us.13.prol.for_body_xx.us48.us.us.us.us.13.prol_crit_edge, !dbg !191, !prof !207, !llvm.loop !269

for_body_xx.us48.us.us.us.us.13.prol.for_body_xx.us48.us.us.us.us.13.prol_crit_edge: ; preds = %for_body_xx.us48.us.us.us.us.13.prol
  call void @llvm.instrprof.increment(ptr @__profn_TVMMod_default_function_compute_, i64 46134000452360265, i32 171, i32 54), !dbg !191
  br label %for_body_xx.us48.us.us.us.us.13.prol, !dbg !191

for_body_xx.us48.us.us.us.us.13.prol.loopexit:    ; preds = %for_body_xx.us48.us.us.us.us.13.prol, %for_body_xx.us48.us.us.us.us.13.preheader
  %indvars.iv97.13.unr = phi i64 [ %indvars.iv97.13.ph, %for_body_xx.us48.us.us.us.us.13.preheader ], [ %indvars.iv.next98.13.prol, %for_body_xx.us48.us.us.us.us.13.prol ]
  %417 = sub nsw i64 %indvars.iv97.13.ph, %wide.trip.count100, !dbg !191
  %418 = icmp ugt i64 %417, -4, !dbg !191
  br i1 %418, label %for_body_xx.us48.us.us.us.us.13.prol.loopexit.for_begin_xx.for_end_xx_crit_edge.split.us50.us.us.us.us.13_crit_edge, label %for_body_xx.us48.us.us.us.us.13, !dbg !191, !prof !201

for_body_xx.us48.us.us.us.us.13.prol.loopexit.for_begin_xx.for_end_xx_crit_edge.split.us50.us.us.us.us.13_crit_edge: ; preds = %for_body_xx.us48.us.us.us.us.13.prol.loopexit
  call void @llvm.instrprof.increment(ptr @__profn_TVMMod_default_function_compute_, i64 46134000452360265, i32 171, i32 120), !dbg !191
  br label %for_begin_xx.for_end_xx_crit_edge.split.us50.us.us.us.us.13, !dbg !191

for_body_xx.us48.us.us.us.us.13:                  ; preds = %for_body_xx.us48.us.us.us.us.13.for_body_xx.us48.us.us.us.us.13_crit_edge, %for_body_xx.us48.us.us.us.us.13.prol.loopexit
  %indvars.iv97.13 = phi i64 [ %indvars.iv.next98.13.3, %for_body_xx.us48.us.us.us.us.13.for_body_xx.us48.us.us.us.us.13_crit_edge ], [ %indvars.iv97.13.unr, %for_body_xx.us48.us.us.us.us.13.prol.loopexit ]
    #dbg_declare(i64 %indvars.iv97.13, !213, !DIExpression(), !191)
  %419 = mul nsw i64 %indvars.iv97.13, %72, !dbg !191
  %420 = getelementptr float, ptr %411, i64 %419, !dbg !191
  store float 0.000000e+00, ptr %420, align 4, !dbg !191, !tbaa !219
    #dbg_declare(i32 0, !214, !DIExpression(), !191)
  %indvars.iv.next98.13 = add nuw nsw i64 %indvars.iv97.13, 1, !dbg !191
    #dbg_declare(i64 %indvars.iv.next98.13, !213, !DIExpression(), !191)
    #dbg_declare(i64 %indvars.iv.next98.13, !213, !DIExpression(), !191)
  %421 = mul nsw i64 %indvars.iv.next98.13, %72, !dbg !191
  %422 = getelementptr float, ptr %411, i64 %421, !dbg !191
  store float 0.000000e+00, ptr %422, align 4, !dbg !191, !tbaa !219
    #dbg_declare(i32 0, !214, !DIExpression(), !191)
  %indvars.iv.next98.13.1 = add nuw nsw i64 %indvars.iv97.13, 2, !dbg !191
    #dbg_declare(i64 %indvars.iv.next98.13.1, !213, !DIExpression(), !191)
    #dbg_declare(i64 %indvars.iv.next98.13.1, !213, !DIExpression(), !191)
  %423 = mul nsw i64 %indvars.iv.next98.13.1, %72, !dbg !191
  %424 = getelementptr float, ptr %411, i64 %423, !dbg !191
  store float 0.000000e+00, ptr %424, align 4, !dbg !191, !tbaa !219
    #dbg_declare(i32 0, !214, !DIExpression(), !191)
  %indvars.iv.next98.13.2 = add nuw nsw i64 %indvars.iv97.13, 3, !dbg !191
    #dbg_declare(i64 %indvars.iv.next98.13.2, !213, !DIExpression(), !191)
    #dbg_declare(i64 %indvars.iv.next98.13.2, !213, !DIExpression(), !191)
  %425 = mul nsw i64 %indvars.iv.next98.13.2, %72, !dbg !191
  %426 = getelementptr float, ptr %411, i64 %425, !dbg !191
  store float 0.000000e+00, ptr %426, align 4, !dbg !191, !tbaa !219
    #dbg_declare(i32 0, !214, !DIExpression(), !191)
  %indvars.iv.next98.13.3 = add nuw nsw i64 %indvars.iv97.13, 4, !dbg !191
    #dbg_declare(i64 %indvars.iv.next98.13.3, !213, !DIExpression(), !191)
  %exitcond101.13.not.3 = icmp eq i64 %indvars.iv.next98.13.3, %wide.trip.count100, !dbg !191
  br i1 %exitcond101.13.not.3, label %for_begin_xx.for_end_xx_crit_edge.split.us50.us.us.us.us.13, label %for_body_xx.us48.us.us.us.us.13.for_body_xx.us48.us.us.us.us.13_crit_edge, !dbg !191, !prof !230, !llvm.loop !270

for_body_xx.us48.us.us.us.us.13.for_body_xx.us48.us.us.us.us.13_crit_edge: ; preds = %for_body_xx.us48.us.us.us.us.13
  call void @llvm.instrprof.increment(ptr @__profn_TVMMod_default_function_compute_, i64 46134000452360265, i32 171, i32 55), !dbg !191
  br label %for_body_xx.us48.us.us.us.us.13, !dbg !191

for_begin_xx.for_end_xx_crit_edge.split.us50.us.us.us.us.13: ; preds = %for_body_xx.us48.us.us.us.us.13.prol.loopexit.for_begin_xx.for_end_xx_crit_edge.split.us50.us.us.us.us.13_crit_edge, %middle.block210.for_begin_xx.for_end_xx_crit_edge.split.us50.us.us.us.us.13_crit_edge, %for_body_xx.us48.us.us.us.us.13
  %indvars.iv.next103.13 = add nuw nsw i64 %indvars.iv102.13, 1, !dbg !191
    #dbg_declare(i64 %indvars.iv.next103.13, !212, !DIExpression(), !191)
  %exitcond106.13.not = icmp eq i64 %indvars.iv.next103.13, %wide.trip.count105, !dbg !191
  br i1 %exitcond106.13.not, label %for_begin_yy.for_end_yy_crit_edge.split.us.split.us59.us.us.us.13, label %for_begin_xx.preheader.us.us57.us.us.us.13, !dbg !191, !prof !200

for_begin_yy.for_end_yy_crit_edge.split.us.split.us59.us.us.us.13: ; preds = %for_begin_xx.for_end_xx_crit_edge.split.us50.us.us.us.us.13
    #dbg_declare(i64 14, !211, !DIExpression(), !191)
    #dbg_declare(i64 14, !211, !DIExpression(), !191)
    #dbg_declare(i32 0, !212, !DIExpression(), !191)
  %427 = getelementptr float, ptr %88, i64 %175
  br label %for_begin_xx.preheader.us.us57.us.us.us.14, !dbg !191

for_begin_xx.preheader.us.us57.us.us.us.14:       ; preds = %for_begin_xx.for_end_xx_crit_edge.split.us50.us.us.us.us.14, %for_begin_yy.for_end_yy_crit_edge.split.us.split.us59.us.us.us.13
  %indvars.iv102.14 = phi i64 [ %indvars.iv.next103.14, %for_begin_xx.for_end_xx_crit_edge.split.us50.us.us.us.us.14 ], [ 0, %for_begin_yy.for_end_yy_crit_edge.split.us.split.us59.us.us.us.13 ]
    #dbg_declare(i64 %indvars.iv102.14, !212, !DIExpression(), !191)
    #dbg_declare(i32 0, !213, !DIExpression(), !191)
  %428 = mul nsw i64 %indvars.iv102.14, %73
  %429 = getelementptr float, ptr %427, i64 %428
  br i1 %or.cond404, label %vector.body204, label %for_begin_xx.preheader.us.us57.us.us.us.14.for_body_xx.us48.us.us.us.us.14.preheader_crit_edge, !dbg !191, !prof !222

for_begin_xx.preheader.us.us57.us.us.us.14.for_body_xx.us48.us.us.us.us.14.preheader_crit_edge: ; preds = %for_begin_xx.preheader.us.us57.us.us.us.14
  call void @llvm.instrprof.increment(ptr @__profn_TVMMod_default_function_compute_, i64 46134000452360265, i32 171, i32 91), !dbg !191
  br label %for_body_xx.us48.us.us.us.us.14.preheader, !dbg !191

vector.body204:                                   ; preds = %vector.body204.vector.body204_crit_edge, %for_begin_xx.preheader.us.us57.us.us.us.14
  %index205 = phi i64 [ %index.next206, %vector.body204.vector.body204_crit_edge ], [ 0, %for_begin_xx.preheader.us.us57.us.us.us.14 ], !dbg !191
  %430 = getelementptr float, ptr %429, i64 %index205, !dbg !191
  %431 = getelementptr i8, ptr %430, i64 16, !dbg !191
  store <4 x float> zeroinitializer, ptr %430, align 4, !dbg !191, !tbaa !219
  store <4 x float> zeroinitializer, ptr %431, align 4, !dbg !191, !tbaa !219
  %index.next206 = add nuw i64 %index205, 8, !dbg !191
  %432 = icmp eq i64 %index.next206, %n.vec202, !dbg !191
  br i1 %432, label %middle.block197, label %vector.body204.vector.body204_crit_edge, !dbg !191, !prof !223, !llvm.loop !271

vector.body204.vector.body204_crit_edge:          ; preds = %vector.body204
  call void @llvm.instrprof.increment(ptr @__profn_TVMMod_default_function_compute_, i64 46134000452360265, i32 171, i32 24), !dbg !191
  br label %vector.body204, !dbg !191

middle.block197:                                  ; preds = %vector.body204
  call void @llvm.instrprof.increment(ptr @__profn_TVMMod_default_function_compute_, i64 46134000452360265, i32 171, i32 149), !dbg !191
  br i1 %cmp.n207, label %middle.block197.for_begin_xx.for_end_xx_crit_edge.split.us50.us.us.us.us.14_crit_edge, label %for_body_xx.us48.us.us.us.us.14.preheader, !dbg !191, !prof !227

middle.block197.for_begin_xx.for_end_xx_crit_edge.split.us50.us.us.us.us.14_crit_edge: ; preds = %middle.block197
  call void @llvm.instrprof.increment(ptr @__profn_TVMMod_default_function_compute_, i64 46134000452360265, i32 171, i32 74), !dbg !191
  br label %for_begin_xx.for_end_xx_crit_edge.split.us50.us.us.us.us.14, !dbg !191

for_body_xx.us48.us.us.us.us.14.preheader:        ; preds = %for_begin_xx.preheader.us.us57.us.us.us.14.for_body_xx.us48.us.us.us.us.14.preheader_crit_edge, %middle.block197
  %indvars.iv97.14.ph = phi i64 [ 0, %for_begin_xx.preheader.us.us57.us.us.us.14.for_body_xx.us48.us.us.us.us.14.preheader_crit_edge ], [ %n.vec202, %middle.block197 ]
  br i1 %lcmp.mod458.not, label %for_body_xx.us48.us.us.us.us.14.prol.loopexit, label %for_body_xx.us48.us.us.us.us.14.preheader.for_body_xx.us48.us.us.us.us.14.prol_crit_edge, !dbg !191, !prof !194

for_body_xx.us48.us.us.us.us.14.preheader.for_body_xx.us48.us.us.us.us.14.prol_crit_edge: ; preds = %for_body_xx.us48.us.us.us.us.14.preheader
  call void @llvm.instrprof.increment(ptr @__profn_TVMMod_default_function_compute_, i64 46134000452360265, i32 171, i32 121), !dbg !191
  br label %for_body_xx.us48.us.us.us.us.14.prol, !dbg !191

for_body_xx.us48.us.us.us.us.14.prol:             ; preds = %for_body_xx.us48.us.us.us.us.14.preheader.for_body_xx.us48.us.us.us.us.14.prol_crit_edge, %for_body_xx.us48.us.us.us.us.14.prol.for_body_xx.us48.us.us.us.us.14.prol_crit_edge
  %indvars.iv97.14.prol = phi i64 [ %indvars.iv.next98.14.prol, %for_body_xx.us48.us.us.us.us.14.prol.for_body_xx.us48.us.us.us.us.14.prol_crit_edge ], [ %indvars.iv97.14.ph, %for_body_xx.us48.us.us.us.us.14.preheader.for_body_xx.us48.us.us.us.us.14.prol_crit_edge ]
  %prol.iter459 = phi i64 [ %prol.iter459.next, %for_body_xx.us48.us.us.us.us.14.prol.for_body_xx.us48.us.us.us.us.14.prol_crit_edge ], [ 0, %for_body_xx.us48.us.us.us.us.14.preheader.for_body_xx.us48.us.us.us.us.14.prol_crit_edge ]
    #dbg_declare(i64 %indvars.iv97.14.prol, !213, !DIExpression(), !191)
  %433 = mul nsw i64 %indvars.iv97.14.prol, %72, !dbg !191
  %434 = getelementptr float, ptr %429, i64 %433, !dbg !191
  store float 0.000000e+00, ptr %434, align 4, !dbg !191, !tbaa !219
    #dbg_declare(i32 0, !214, !DIExpression(), !191)
  %indvars.iv.next98.14.prol = add nuw nsw i64 %indvars.iv97.14.prol, 1, !dbg !191
    #dbg_declare(i64 %indvars.iv.next98.14.prol, !213, !DIExpression(), !191)
  %prol.iter459.next = add i64 %prol.iter459, 1, !dbg !191
  %prol.iter459.cmp.not = icmp eq i64 %prol.iter459.next, %xtraiter457, !dbg !191
  br i1 %prol.iter459.cmp.not, label %for_body_xx.us48.us.us.us.us.14.prol.loopexit, label %for_body_xx.us48.us.us.us.us.14.prol.for_body_xx.us48.us.us.us.us.14.prol_crit_edge, !dbg !191, !prof !207, !llvm.loop !272

for_body_xx.us48.us.us.us.us.14.prol.for_body_xx.us48.us.us.us.us.14.prol_crit_edge: ; preds = %for_body_xx.us48.us.us.us.us.14.prol
  call void @llvm.instrprof.increment(ptr @__profn_TVMMod_default_function_compute_, i64 46134000452360265, i32 171, i32 56), !dbg !191
  br label %for_body_xx.us48.us.us.us.us.14.prol, !dbg !191

for_body_xx.us48.us.us.us.us.14.prol.loopexit:    ; preds = %for_body_xx.us48.us.us.us.us.14.prol, %for_body_xx.us48.us.us.us.us.14.preheader
  %indvars.iv97.14.unr = phi i64 [ %indvars.iv97.14.ph, %for_body_xx.us48.us.us.us.us.14.preheader ], [ %indvars.iv.next98.14.prol, %for_body_xx.us48.us.us.us.us.14.prol ]
  %435 = sub nsw i64 %indvars.iv97.14.ph, %wide.trip.count100, !dbg !191
  %436 = icmp ugt i64 %435, -4, !dbg !191
  br i1 %436, label %for_body_xx.us48.us.us.us.us.14.prol.loopexit.for_begin_xx.for_end_xx_crit_edge.split.us50.us.us.us.us.14_crit_edge, label %for_body_xx.us48.us.us.us.us.14, !dbg !191, !prof !201

for_body_xx.us48.us.us.us.us.14.prol.loopexit.for_begin_xx.for_end_xx_crit_edge.split.us50.us.us.us.us.14_crit_edge: ; preds = %for_body_xx.us48.us.us.us.us.14.prol.loopexit
  call void @llvm.instrprof.increment(ptr @__profn_TVMMod_default_function_compute_, i64 46134000452360265, i32 171, i32 122), !dbg !191
  br label %for_begin_xx.for_end_xx_crit_edge.split.us50.us.us.us.us.14, !dbg !191

for_body_xx.us48.us.us.us.us.14:                  ; preds = %for_body_xx.us48.us.us.us.us.14.for_body_xx.us48.us.us.us.us.14_crit_edge, %for_body_xx.us48.us.us.us.us.14.prol.loopexit
  %indvars.iv97.14 = phi i64 [ %indvars.iv.next98.14.3, %for_body_xx.us48.us.us.us.us.14.for_body_xx.us48.us.us.us.us.14_crit_edge ], [ %indvars.iv97.14.unr, %for_body_xx.us48.us.us.us.us.14.prol.loopexit ]
    #dbg_declare(i64 %indvars.iv97.14, !213, !DIExpression(), !191)
  %437 = mul nsw i64 %indvars.iv97.14, %72, !dbg !191
  %438 = getelementptr float, ptr %429, i64 %437, !dbg !191
  store float 0.000000e+00, ptr %438, align 4, !dbg !191, !tbaa !219
    #dbg_declare(i32 0, !214, !DIExpression(), !191)
  %indvars.iv.next98.14 = add nuw nsw i64 %indvars.iv97.14, 1, !dbg !191
    #dbg_declare(i64 %indvars.iv.next98.14, !213, !DIExpression(), !191)
    #dbg_declare(i64 %indvars.iv.next98.14, !213, !DIExpression(), !191)
  %439 = mul nsw i64 %indvars.iv.next98.14, %72, !dbg !191
  %440 = getelementptr float, ptr %429, i64 %439, !dbg !191
  store float 0.000000e+00, ptr %440, align 4, !dbg !191, !tbaa !219
    #dbg_declare(i32 0, !214, !DIExpression(), !191)
  %indvars.iv.next98.14.1 = add nuw nsw i64 %indvars.iv97.14, 2, !dbg !191
    #dbg_declare(i64 %indvars.iv.next98.14.1, !213, !DIExpression(), !191)
    #dbg_declare(i64 %indvars.iv.next98.14.1, !213, !DIExpression(), !191)
  %441 = mul nsw i64 %indvars.iv.next98.14.1, %72, !dbg !191
  %442 = getelementptr float, ptr %429, i64 %441, !dbg !191
  store float 0.000000e+00, ptr %442, align 4, !dbg !191, !tbaa !219
    #dbg_declare(i32 0, !214, !DIExpression(), !191)
  %indvars.iv.next98.14.2 = add nuw nsw i64 %indvars.iv97.14, 3, !dbg !191
    #dbg_declare(i64 %indvars.iv.next98.14.2, !213, !DIExpression(), !191)
    #dbg_declare(i64 %indvars.iv.next98.14.2, !213, !DIExpression(), !191)
  %443 = mul nsw i64 %indvars.iv.next98.14.2, %72, !dbg !191
  %444 = getelementptr float, ptr %429, i64 %443, !dbg !191
  store float 0.000000e+00, ptr %444, align 4, !dbg !191, !tbaa !219
    #dbg_declare(i32 0, !214, !DIExpression(), !191)
  %indvars.iv.next98.14.3 = add nuw nsw i64 %indvars.iv97.14, 4, !dbg !191
    #dbg_declare(i64 %indvars.iv.next98.14.3, !213, !DIExpression(), !191)
  %exitcond101.14.not.3 = icmp eq i64 %indvars.iv.next98.14.3, %wide.trip.count100, !dbg !191
  br i1 %exitcond101.14.not.3, label %for_begin_xx.for_end_xx_crit_edge.split.us50.us.us.us.us.14, label %for_body_xx.us48.us.us.us.us.14.for_body_xx.us48.us.us.us.us.14_crit_edge, !dbg !191, !prof !230, !llvm.loop !273

for_body_xx.us48.us.us.us.us.14.for_body_xx.us48.us.us.us.us.14_crit_edge: ; preds = %for_body_xx.us48.us.us.us.us.14
  call void @llvm.instrprof.increment(ptr @__profn_TVMMod_default_function_compute_, i64 46134000452360265, i32 171, i32 57), !dbg !191
  br label %for_body_xx.us48.us.us.us.us.14, !dbg !191

for_begin_xx.for_end_xx_crit_edge.split.us50.us.us.us.us.14: ; preds = %for_body_xx.us48.us.us.us.us.14.prol.loopexit.for_begin_xx.for_end_xx_crit_edge.split.us50.us.us.us.us.14_crit_edge, %middle.block197.for_begin_xx.for_end_xx_crit_edge.split.us50.us.us.us.us.14_crit_edge, %for_body_xx.us48.us.us.us.us.14
  %indvars.iv.next103.14 = add nuw nsw i64 %indvars.iv102.14, 1, !dbg !191
    #dbg_declare(i64 %indvars.iv.next103.14, !212, !DIExpression(), !191)
  %exitcond106.14.not = icmp eq i64 %indvars.iv.next103.14, %wide.trip.count105, !dbg !191
  br i1 %exitcond106.14.not, label %for_begin_yy.for_end_yy_crit_edge.split.us.split.us59.us.us.us.14, label %for_begin_xx.preheader.us.us57.us.us.us.14, !dbg !191, !prof !200

for_begin_yy.for_end_yy_crit_edge.split.us.split.us59.us.us.us.14: ; preds = %for_begin_xx.for_end_xx_crit_edge.split.us50.us.us.us.us.14
    #dbg_declare(i64 15, !211, !DIExpression(), !191)
    #dbg_declare(i64 15, !211, !DIExpression(), !191)
    #dbg_declare(i32 0, !212, !DIExpression(), !191)
  %445 = getelementptr float, ptr %89, i64 %175
  br label %for_begin_xx.preheader.us.us57.us.us.us.15, !dbg !191

for_begin_xx.preheader.us.us57.us.us.us.15:       ; preds = %for_begin_xx.for_end_xx_crit_edge.split.us50.us.us.us.us.15, %for_begin_yy.for_end_yy_crit_edge.split.us.split.us59.us.us.us.14
  %indvars.iv102.15 = phi i64 [ %indvars.iv.next103.15, %for_begin_xx.for_end_xx_crit_edge.split.us50.us.us.us.us.15 ], [ 0, %for_begin_yy.for_end_yy_crit_edge.split.us.split.us59.us.us.us.14 ]
    #dbg_declare(i64 %indvars.iv102.15, !212, !DIExpression(), !191)
    #dbg_declare(i32 0, !213, !DIExpression(), !191)
  %446 = mul nsw i64 %indvars.iv102.15, %73
  %447 = getelementptr float, ptr %445, i64 %446
  br i1 %or.cond405, label %vector.body, label %for_begin_xx.preheader.us.us57.us.us.us.15.for_body_xx.us48.us.us.us.us.15.preheader_crit_edge, !dbg !191, !prof !222

for_begin_xx.preheader.us.us57.us.us.us.15.for_body_xx.us48.us.us.us.us.15.preheader_crit_edge: ; preds = %for_begin_xx.preheader.us.us57.us.us.us.15
  call void @llvm.instrprof.increment(ptr @__profn_TVMMod_default_function_compute_, i64 46134000452360265, i32 171, i32 92), !dbg !191
  br label %for_body_xx.us48.us.us.us.us.15.preheader, !dbg !191

vector.body:                                      ; preds = %vector.body.vector.body_crit_edge, %for_begin_xx.preheader.us.us57.us.us.us.15
  %index = phi i64 [ %index.next, %vector.body.vector.body_crit_edge ], [ 0, %for_begin_xx.preheader.us.us57.us.us.us.15 ], !dbg !191
  %448 = getelementptr float, ptr %447, i64 %index, !dbg !191
  %449 = getelementptr i8, ptr %448, i64 16, !dbg !191
  store <4 x float> zeroinitializer, ptr %448, align 4, !dbg !191, !tbaa !219
  store <4 x float> zeroinitializer, ptr %449, align 4, !dbg !191, !tbaa !219
  %index.next = add nuw i64 %index, 8, !dbg !191
  %450 = icmp eq i64 %index.next, %n.vec, !dbg !191
  br i1 %450, label %middle.block, label %vector.body.vector.body_crit_edge, !dbg !191, !prof !223, !llvm.loop !274

vector.body.vector.body_crit_edge:                ; preds = %vector.body
  call void @llvm.instrprof.increment(ptr @__profn_TVMMod_default_function_compute_, i64 46134000452360265, i32 171, i32 25), !dbg !191
  br label %vector.body, !dbg !191

middle.block:                                     ; preds = %vector.body
  call void @llvm.instrprof.increment(ptr @__profn_TVMMod_default_function_compute_, i64 46134000452360265, i32 171, i32 150), !dbg !191
  br i1 %cmp.n, label %middle.block.for_begin_xx.for_end_xx_crit_edge.split.us50.us.us.us.us.15_crit_edge, label %for_body_xx.us48.us.us.us.us.15.preheader, !dbg !191, !prof !227

middle.block.for_begin_xx.for_end_xx_crit_edge.split.us50.us.us.us.us.15_crit_edge: ; preds = %middle.block
  call void @llvm.instrprof.increment(ptr @__profn_TVMMod_default_function_compute_, i64 46134000452360265, i32 171, i32 75), !dbg !191
  br label %for_begin_xx.for_end_xx_crit_edge.split.us50.us.us.us.us.15, !dbg !191

for_body_xx.us48.us.us.us.us.15.preheader:        ; preds = %for_begin_xx.preheader.us.us57.us.us.us.15.for_body_xx.us48.us.us.us.us.15.preheader_crit_edge, %middle.block
  %indvars.iv97.15.ph = phi i64 [ 0, %for_begin_xx.preheader.us.us57.us.us.us.15.for_body_xx.us48.us.us.us.us.15.preheader_crit_edge ], [ %n.vec, %middle.block ]
  br i1 %lcmp.mod461.not, label %for_body_xx.us48.us.us.us.us.15.prol.loopexit, label %for_body_xx.us48.us.us.us.us.15.preheader.for_body_xx.us48.us.us.us.us.15.prol_crit_edge, !dbg !191, !prof !194

for_body_xx.us48.us.us.us.us.15.preheader.for_body_xx.us48.us.us.us.us.15.prol_crit_edge: ; preds = %for_body_xx.us48.us.us.us.us.15.preheader
  call void @llvm.instrprof.increment(ptr @__profn_TVMMod_default_function_compute_, i64 46134000452360265, i32 171, i32 123), !dbg !191
  br label %for_body_xx.us48.us.us.us.us.15.prol, !dbg !191

for_body_xx.us48.us.us.us.us.15.prol:             ; preds = %for_body_xx.us48.us.us.us.us.15.preheader.for_body_xx.us48.us.us.us.us.15.prol_crit_edge, %for_body_xx.us48.us.us.us.us.15.prol.for_body_xx.us48.us.us.us.us.15.prol_crit_edge
  %indvars.iv97.15.prol = phi i64 [ %indvars.iv.next98.15.prol, %for_body_xx.us48.us.us.us.us.15.prol.for_body_xx.us48.us.us.us.us.15.prol_crit_edge ], [ %indvars.iv97.15.ph, %for_body_xx.us48.us.us.us.us.15.preheader.for_body_xx.us48.us.us.us.us.15.prol_crit_edge ]
  %prol.iter462 = phi i64 [ %prol.iter462.next, %for_body_xx.us48.us.us.us.us.15.prol.for_body_xx.us48.us.us.us.us.15.prol_crit_edge ], [ 0, %for_body_xx.us48.us.us.us.us.15.preheader.for_body_xx.us48.us.us.us.us.15.prol_crit_edge ]
    #dbg_declare(i64 %indvars.iv97.15.prol, !213, !DIExpression(), !191)
  %451 = mul nsw i64 %indvars.iv97.15.prol, %72, !dbg !191
  %452 = getelementptr float, ptr %447, i64 %451, !dbg !191
  store float 0.000000e+00, ptr %452, align 4, !dbg !191, !tbaa !219
    #dbg_declare(i32 0, !214, !DIExpression(), !191)
  %indvars.iv.next98.15.prol = add nuw nsw i64 %indvars.iv97.15.prol, 1, !dbg !191
    #dbg_declare(i64 %indvars.iv.next98.15.prol, !213, !DIExpression(), !191)
  %prol.iter462.next = add i64 %prol.iter462, 1, !dbg !191
  %prol.iter462.cmp.not = icmp eq i64 %prol.iter462.next, %xtraiter460, !dbg !191
  br i1 %prol.iter462.cmp.not, label %for_body_xx.us48.us.us.us.us.15.prol.loopexit, label %for_body_xx.us48.us.us.us.us.15.prol.for_body_xx.us48.us.us.us.us.15.prol_crit_edge, !dbg !191, !prof !207, !llvm.loop !275

for_body_xx.us48.us.us.us.us.15.prol.for_body_xx.us48.us.us.us.us.15.prol_crit_edge: ; preds = %for_body_xx.us48.us.us.us.us.15.prol
  call void @llvm.instrprof.increment(ptr @__profn_TVMMod_default_function_compute_, i64 46134000452360265, i32 171, i32 58), !dbg !191
  br label %for_body_xx.us48.us.us.us.us.15.prol, !dbg !191

for_body_xx.us48.us.us.us.us.15.prol.loopexit:    ; preds = %for_body_xx.us48.us.us.us.us.15.prol, %for_body_xx.us48.us.us.us.us.15.preheader
  %indvars.iv97.15.unr = phi i64 [ %indvars.iv97.15.ph, %for_body_xx.us48.us.us.us.us.15.preheader ], [ %indvars.iv.next98.15.prol, %for_body_xx.us48.us.us.us.us.15.prol ]
  %453 = sub nsw i64 %indvars.iv97.15.ph, %wide.trip.count100, !dbg !191
  %454 = icmp ugt i64 %453, -4, !dbg !191
  br i1 %454, label %for_body_xx.us48.us.us.us.us.15.prol.loopexit.for_begin_xx.for_end_xx_crit_edge.split.us50.us.us.us.us.15_crit_edge, label %for_body_xx.us48.us.us.us.us.15, !dbg !191, !prof !201

for_body_xx.us48.us.us.us.us.15.prol.loopexit.for_begin_xx.for_end_xx_crit_edge.split.us50.us.us.us.us.15_crit_edge: ; preds = %for_body_xx.us48.us.us.us.us.15.prol.loopexit
  call void @llvm.instrprof.increment(ptr @__profn_TVMMod_default_function_compute_, i64 46134000452360265, i32 171, i32 124), !dbg !191
  br label %for_begin_xx.for_end_xx_crit_edge.split.us50.us.us.us.us.15, !dbg !191

for_body_xx.us48.us.us.us.us.15:                  ; preds = %for_body_xx.us48.us.us.us.us.15.for_body_xx.us48.us.us.us.us.15_crit_edge, %for_body_xx.us48.us.us.us.us.15.prol.loopexit
  %indvars.iv97.15 = phi i64 [ %indvars.iv.next98.15.3, %for_body_xx.us48.us.us.us.us.15.for_body_xx.us48.us.us.us.us.15_crit_edge ], [ %indvars.iv97.15.unr, %for_body_xx.us48.us.us.us.us.15.prol.loopexit ]
    #dbg_declare(i64 %indvars.iv97.15, !213, !DIExpression(), !191)
  %455 = mul nsw i64 %indvars.iv97.15, %72, !dbg !191
  %456 = getelementptr float, ptr %447, i64 %455, !dbg !191
  store float 0.000000e+00, ptr %456, align 4, !dbg !191, !tbaa !219
    #dbg_declare(i32 0, !214, !DIExpression(), !191)
  %indvars.iv.next98.15 = add nuw nsw i64 %indvars.iv97.15, 1, !dbg !191
    #dbg_declare(i64 %indvars.iv.next98.15, !213, !DIExpression(), !191)
    #dbg_declare(i64 %indvars.iv.next98.15, !213, !DIExpression(), !191)
  %457 = mul nsw i64 %indvars.iv.next98.15, %72, !dbg !191
  %458 = getelementptr float, ptr %447, i64 %457, !dbg !191
  store float 0.000000e+00, ptr %458, align 4, !dbg !191, !tbaa !219
    #dbg_declare(i32 0, !214, !DIExpression(), !191)
  %indvars.iv.next98.15.1 = add nuw nsw i64 %indvars.iv97.15, 2, !dbg !191
    #dbg_declare(i64 %indvars.iv.next98.15.1, !213, !DIExpression(), !191)
    #dbg_declare(i64 %indvars.iv.next98.15.1, !213, !DIExpression(), !191)
  %459 = mul nsw i64 %indvars.iv.next98.15.1, %72, !dbg !191
  %460 = getelementptr float, ptr %447, i64 %459, !dbg !191
  store float 0.000000e+00, ptr %460, align 4, !dbg !191, !tbaa !219
    #dbg_declare(i32 0, !214, !DIExpression(), !191)
  %indvars.iv.next98.15.2 = add nuw nsw i64 %indvars.iv97.15, 3, !dbg !191
    #dbg_declare(i64 %indvars.iv.next98.15.2, !213, !DIExpression(), !191)
    #dbg_declare(i64 %indvars.iv.next98.15.2, !213, !DIExpression(), !191)
  %461 = mul nsw i64 %indvars.iv.next98.15.2, %72, !dbg !191
  %462 = getelementptr float, ptr %447, i64 %461, !dbg !191
  store float 0.000000e+00, ptr %462, align 4, !dbg !191, !tbaa !219
    #dbg_declare(i32 0, !214, !DIExpression(), !191)
  %indvars.iv.next98.15.3 = add nuw nsw i64 %indvars.iv97.15, 4, !dbg !191
    #dbg_declare(i64 %indvars.iv.next98.15.3, !213, !DIExpression(), !191)
  %exitcond101.15.not.3 = icmp eq i64 %indvars.iv.next98.15.3, %wide.trip.count100, !dbg !191
  br i1 %exitcond101.15.not.3, label %for_begin_xx.for_end_xx_crit_edge.split.us50.us.us.us.us.15, label %for_body_xx.us48.us.us.us.us.15.for_body_xx.us48.us.us.us.us.15_crit_edge, !dbg !191, !prof !230, !llvm.loop !276

for_body_xx.us48.us.us.us.us.15.for_body_xx.us48.us.us.us.us.15_crit_edge: ; preds = %for_body_xx.us48.us.us.us.us.15
  call void @llvm.instrprof.increment(ptr @__profn_TVMMod_default_function_compute_, i64 46134000452360265, i32 171, i32 59), !dbg !191
  br label %for_body_xx.us48.us.us.us.us.15, !dbg !191

for_begin_xx.for_end_xx_crit_edge.split.us50.us.us.us.us.15: ; preds = %for_body_xx.us48.us.us.us.us.15.prol.loopexit.for_begin_xx.for_end_xx_crit_edge.split.us50.us.us.us.us.15_crit_edge, %middle.block.for_begin_xx.for_end_xx_crit_edge.split.us50.us.us.us.us.15_crit_edge, %for_body_xx.us48.us.us.us.us.15
  %indvars.iv.next103.15 = add nuw nsw i64 %indvars.iv102.15, 1, !dbg !191
    #dbg_declare(i64 %indvars.iv.next103.15, !212, !DIExpression(), !191)
  %exitcond106.15.not = icmp eq i64 %indvars.iv.next103.15, %wide.trip.count105, !dbg !191
  br i1 %exitcond106.15.not, label %for_begin_yy.for_end_yy_crit_edge.split.us.split.us59.us.us.us.15, label %for_begin_xx.preheader.us.us57.us.us.us.15, !dbg !191, !prof !200

for_begin_yy.for_end_yy_crit_edge.split.us.split.us59.us.us.us.15: ; preds = %for_begin_xx.for_end_xx_crit_edge.split.us50.us.us.us.us.15
  call void @llvm.instrprof.increment(ptr @__profn_TVMMod_default_function_compute_, i64 46134000452360265, i32 171, i32 151), !dbg !191
    #dbg_declare(i64 16, !211, !DIExpression(), !191)
  %indvars.iv.next112 = add nuw nsw i64 %indvars.iv111, 1, !dbg !191
    #dbg_declare(i64 %indvars.iv.next112, !208, !DIExpression(), !191)
  %exitcond115.not = icmp eq i64 %indvars.iv.next112, %wide.trip.count114, !dbg !191
  br i1 %exitcond115.not, label %for_begin_yy.for_end_yy_crit_edge.split.us.split.us59.us.us.us.15.for_end_nn_crit_edge, label %for_begin_ff.preheader.us.us, !dbg !191, !prof !200

for_begin_yy.for_end_yy_crit_edge.split.us.split.us59.us.us.us.15.for_end_nn_crit_edge: ; preds = %for_begin_yy.for_end_yy_crit_edge.split.us.split.us59.us.us.us.15
  call void @llvm.instrprof.increment(ptr @__profn_TVMMod_default_function_compute_, i64 46134000452360265, i32 171, i32 152), !dbg !191
  br label %for_end_nn, !dbg !191

for_end_nn:                                       ; preds = %for_begin_yy.for_end_yy_crit_edge.split.us.split.us59.us.us.us.15.for_end_nn_crit_edge, %for_end_ff.split.us.split.us.split.us.us.us.us.for_end_nn_crit_edge, %for_begin_nn.preheader.for_end_nn_crit_edge, %for_begin_ff.preheader.lr.ph, %for_begin_i1.preheader.lr.ph.split.us, %for_begin_i0.preheader
  call void @llvm.instrprof.increment(ptr @__profn_TVMMod_default_function_compute_, i64 46134000452360265, i32 171, i32 153), !dbg !191
  %463 = load ptr, ptr @__TVMBackendFreeWorkspace, align 8, !dbg !191, !tbaa !20
  %464 = ptrtoint ptr %463 to i64, !dbg !191
  call void @llvm.instrprof.value.profile(ptr @__profn_TVMMod_default_function_compute_, i64 46134000452360265, i64 %464, i32 0, i32 1), !dbg !191
  %465 = tail call i32 %463(i32 1, i32 %dev_id, ptr nonnull %pad_temp), !dbg !191
  %.not = icmp ne i32 %465, 0, !dbg !191
  %. = sext i1 %.not to i32, !dbg !191
  br label %common.ret, !dbg !191
}

; Function Attrs: nocallback nofree nosync nounwind speculatable willreturn memory(none)
declare float @llvm.fmuladd.f32(float, float, float) #3

; Function Attrs: nofree nosync nounwind memory(none)
define weak dso_local half @__truncsfhf2(float %a0) local_unnamed_addr #4 section ".text.tvm.fp16.conv" {
b0:
  %v0 = bitcast float %a0 to i32
  %0 = tail call float @llvm.fabs.f32(float %a0)
  %v1 = bitcast float %0 to i32
  %v2 = add nsw i32 %v1, -947912704
  %v3 = add nsw i32 %v1, -1199570944
  %v4 = icmp ult i32 %v2, %v3
  br i1 %v4, label %b1, label %b5

b1:                                               ; preds = %b0
  %v5 = lshr i32 %v0, 13
  %v7 = add nsw i32 %v5, -114688
  %v8 = and i32 %v0, 8191
  %v9 = icmp ugt i32 %v8, 4096
  br i1 %v9, label %b2, label %b3

b2:                                               ; preds = %b1
  call void @llvm.instrprof.increment(ptr @__profn___truncsfhf2, i64 650973723264992368, i32 9, i32 1)
  %v10 = add nsw i32 %v5, -114687
  br label %b13

b3:                                               ; preds = %b1
  call void @llvm.instrprof.increment(ptr @__profn___truncsfhf2, i64 650973723264992368, i32 9, i32 0)
  %v11 = icmp eq i32 %v8, 4096
  br i1 %v11, label %b4, label %b13

b4:                                               ; preds = %b3
  call void @llvm.instrprof.increment(ptr @__profn___truncsfhf2, i64 650973723264992368, i32 9, i32 4)
  %v13 = and i32 %v5, 1
  %v14 = add nsw i32 %v7, %v13
  br label %b13

b5:                                               ; preds = %b0
  %v15 = icmp ugt i32 %v1, 2139095040
  br i1 %v15, label %b6, label %b7

b6:                                               ; preds = %b5
  call void @llvm.instrprof.increment(ptr @__profn___truncsfhf2, i64 650973723264992368, i32 9, i32 3)
  %v16 = lshr i32 %v0, 13
  %v17 = and i32 %v16, 511
  %v18 = or disjoint i32 %v17, 32256
  br label %b13

b7:                                               ; preds = %b5
  call void @llvm.instrprof.increment(ptr @__profn___truncsfhf2, i64 650973723264992368, i32 9, i32 2)
  %v19 = icmp ugt i32 %v1, 1199570943
  br i1 %v19, label %b13, label %b8

b8:                                               ; preds = %b7
  call void @llvm.instrprof.increment(ptr @__profn___truncsfhf2, i64 650973723264992368, i32 9, i32 5)
  %v20 = icmp ult i32 %v1, 754974720
  br i1 %v20, label %b13, label %b9

b9:                                               ; preds = %b8
  %v21 = lshr i32 %v1, 23
  %v22 = sub nsw i32 113, %v21
  %v23 = and i32 %v0, 8388607
  %v24 = or disjoint i32 %v23, 8388608
  %v25 = add nsw i32 %v21, -81
  %v26 = shl i32 %v24, %v25
  %v27 = icmp ne i32 %v26, 0
  %v28 = lshr i32 %v24, %v22
  %v29 = zext i1 %v27 to i32
  %v30 = lshr i32 %v28, 13
  %v31 = and i32 %v28, 8191
  %v32 = or i32 %v31, %v29
  %v33 = icmp ugt i32 %v32, 4096
  br i1 %v33, label %b10, label %b11

b10:                                              ; preds = %b9
  call void @llvm.instrprof.increment(ptr @__profn___truncsfhf2, i64 650973723264992368, i32 9, i32 7)
  %v34 = add nuw nsw i32 %v30, 1
  br label %b13

b11:                                              ; preds = %b9
  call void @llvm.instrprof.increment(ptr @__profn___truncsfhf2, i64 650973723264992368, i32 9, i32 6)
  %v35 = icmp eq i32 %v32, 4096
  br i1 %v35, label %b12, label %b13

b12:                                              ; preds = %b11
  call void @llvm.instrprof.increment(ptr @__profn___truncsfhf2, i64 650973723264992368, i32 9, i32 8)
  %v36 = and i32 %v30, 1
  %v37 = add nuw nsw i32 %v36, %v30
  br label %b13

b13:                                              ; preds = %b12, %b11, %b10, %b8, %b7, %b6, %b4, %b3, %b2
  %v38 = phi i32 [ %v18, %b6 ], [ %v10, %b2 ], [ %v14, %b4 ], [ %v7, %b3 ], [ 31744, %b7 ], [ 0, %b8 ], [ %v34, %b10 ], [ %v37, %b12 ], [ %v30, %b11 ]
  %v39 = lshr i32 %v0, 16
  %v40 = and i32 %v39, 32768
  %v41 = or i32 %v38, %v40
  %vlast = trunc i32 %v41 to i16
  %vres = bitcast i16 %vlast to half
  ret half %vres
}

; Function Attrs: nofree nosync nounwind memory(none)
define weak dso_local float @__extendhfsf2(half %a0) local_unnamed_addr #4 section ".text.tvm.fp16.conv" {
b0:
  %0 = tail call half @llvm.fabs.f16(half %a0)
  %v1 = bitcast half %0 to i16
  %v2 = zext nneg i16 %v1 to i32
  %v3 = add nsw i16 %v1, -1024
  %v4 = icmp ult i16 %v3, 30720
  br i1 %v4, label %b1, label %b2

b1:                                               ; preds = %b0
  call void @llvm.instrprof.increment(ptr @__profn___extendhfsf2, i64 13698032168178065, i32 11, i32 0)
  %v5 = shl nuw nsw i32 %v2, 13
  %v6 = add nuw nsw i32 %v5, 939524096
  br label %b6

b2:                                               ; preds = %b0
  %v7 = icmp ugt i16 %v1, 31743
  br i1 %v7, label %b3, label %b4

b3:                                               ; preds = %b2
  call void @llvm.instrprof.increment(ptr @__profn___extendhfsf2, i64 13698032168178065, i32 11, i32 2)
  %v8 = shl nuw nsw i32 %v2, 13
  %v9 = or i32 %v8, 2139095040
  br label %b6

b4:                                               ; preds = %b2
  call void @llvm.instrprof.increment(ptr @__profn___extendhfsf2, i64 13698032168178065, i32 11, i32 1)
  %v10 = icmp eq i16 %v1, 0
  br i1 %v10, label %b6, label %b5

b5:                                               ; preds = %b4
  call void @llvm.instrprof.increment(ptr @__profn___extendhfsf2, i64 13698032168178065, i32 11, i32 3)
  %v11 = icmp ult i16 %v1, 256
  %v12 = lshr i32 %v2, 8
  %1 = zext i1 %v11 to i64
  call void @llvm.instrprof.increment.step(ptr @__profn___extendhfsf2, i64 13698032168178065, i32 11, i32 4, i64 %1)
  %v13 = select i1 %v11, i32 %v2, i32 %v12
  %2 = zext i1 %v11 to i64
  call void @llvm.instrprof.increment.step(ptr @__profn___extendhfsf2, i64 13698032168178065, i32 11, i32 5, i64 %2)
  %v14 = select i1 %v11, i32 32, i32 24
  %v15 = icmp ult i32 %v13, 16
  %v16 = lshr i32 %v13, 4
  %v17 = add nsw i32 %v14, -4
  %3 = zext i1 %v15 to i64
  call void @llvm.instrprof.increment.step(ptr @__profn___extendhfsf2, i64 13698032168178065, i32 11, i32 6, i64 %3)
  %v18 = select i1 %v15, i32 %v13, i32 %v16
  %4 = zext i1 %v15 to i64
  call void @llvm.instrprof.increment.step(ptr @__profn___extendhfsf2, i64 13698032168178065, i32 11, i32 7, i64 %4)
  %v19 = select i1 %v15, i32 %v14, i32 %v17
  %v20 = icmp ult i32 %v18, 4
  %v21 = lshr i32 %v18, 2
  %v22 = add nsw i32 %v19, -2
  %5 = zext i1 %v20 to i64
  call void @llvm.instrprof.increment.step(ptr @__profn___extendhfsf2, i64 13698032168178065, i32 11, i32 8, i64 %5)
  %v23 = select i1 %v20, i32 %v18, i32 %v21
  %6 = zext i1 %v20 to i64
  call void @llvm.instrprof.increment.step(ptr @__profn___extendhfsf2, i64 13698032168178065, i32 11, i32 9, i64 %6)
  %v24 = select i1 %v20, i32 %v19, i32 %v22
  %v25 = icmp ult i32 %v23, 2
  %v26 = sub nsw i32 0, %v23
  %7 = zext i1 %v25 to i64
  call void @llvm.instrprof.increment.step(ptr @__profn___extendhfsf2, i64 13698032168178065, i32 11, i32 10, i64 %7)
  %v27 = select i1 %v25, i32 %v26, i32 -2
  %v28 = add nsw i32 %v27, %v24
  %v29 = add nsw i32 %v28, -8
  %v30 = shl i32 %v2, %v29
  %v31 = xor i32 %v30, 8388608
  %v32 = shl i32 %v28, 23
  %v33 = sub i32 1124073472, %v32
  %v34 = or i32 %v31, %v33
  br label %b6

b6:                                               ; preds = %b5, %b4, %b3, %b1
  %v35 = phi i32 [ %v6, %b1 ], [ %v9, %b3 ], [ %v34, %b5 ], [ 0, %b4 ]
  %vinp = bitcast half %a0 to i16
  %v36 = and i16 %vinp, -32768
  %v37 = zext i16 %v36 to i32
  %v38 = shl nuw i32 %v37, 16
  %v39 = or i32 %v35, %v38
  %v40 = bitcast i32 %v39 to float
  ret float %v40
}

; Function Attrs: nocallback nofree nosync nounwind speculatable willreturn memory(none)
declare float @llvm.fabs.f32(float) #3

; Function Attrs: nocallback nofree nosync nounwind speculatable willreturn memory(none)
declare half @llvm.fabs.f16(half) #3

; Function Attrs: nocallback nofree nosync nounwind speculatable willreturn memory(none)
declare i32 @llvm.smax.i32(i32, i32) #3

; Function Attrs: nocallback nofree nounwind willreturn memory(argmem: write)
declare void @llvm.memset.p0.i64(ptr nocapture writeonly, i8, i64, i1 immarg) #5

; Function Attrs: nounwind
declare void @llvm.instrprof.increment(ptr, i64, i32, i32) #6

; Function Attrs: nounwind
declare void @llvm.instrprof.increment.step(ptr, i64, i32, i32, i64) #6

; Function Attrs: nounwind
declare void @llvm.instrprof.value.profile(ptr, i64, i64, i32, i32) #6

attributes #0 = { "target-cpu"="generic" }
attributes #1 = { nocallback nofree nosync nounwind willreturn memory(inaccessiblemem: write) }
attributes #2 = { noinline "target-cpu"="generic" }
attributes #3 = { nocallback nofree nosync nounwind speculatable willreturn memory(none) }
attributes #4 = { nofree nosync nounwind memory(none) "target-cpu"="generic" "target-features" }
attributes #5 = { nocallback nofree nounwind willreturn memory(argmem: write) }
attributes #6 = { nounwind }

!llvm.dbg.cu = !{!0}
!llvm.module.flags = !{!2, !3, !4}

!0 = distinct !DICompileUnit(language: DW_LANG_C, file: !1, producer: "TVM", isOptimized: false, runtimeVersion: 0, emissionKind: FullDebug)
!1 = !DIFile(filename: "IRModule.CodeGenLLVM", directory: ".")
!2 = !{i32 2, !"tvm_target", !"llvm -mtriple=x86_64-unknown-linux-gnu"}
!3 = !{i32 4, !"Debug Info Version", i32 3}
!4 = !{i32 4, !"Dwarf Version", i32 4}
!5 = distinct !DISubprogram(name: "default_function", scope: !1, file: !1, type: !6, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !0, retainedNodes: !11)
!6 = !DISubroutineType(types: !7)
!7 = !{!8, !9, !10, !8, !9, !10, !9}
!8 = !DIBasicType(name: "int32", size: 32, encoding: DW_ATE_signed)
!9 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: null)
!10 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !8)
!11 = !{!12, !13, !14, !15, !16, !17}
!12 = !DILocalVariable(name: "args", arg: 1, scope: !5, file: !1, type: !9)
!13 = !DILocalVariable(name: "arg_type_ids", arg: 2, scope: !5, file: !1, type: !10)
!14 = !DILocalVariable(name: "num_args", arg: 3, scope: !5, file: !1, type: !8)
!15 = !DILocalVariable(name: "out_ret_value", arg: 4, scope: !5, file: !1, type: !9)
!16 = !DILocalVariable(name: "out_ret_tcode", arg: 5, scope: !5, file: !1, type: !10)
!17 = !DILocalVariable(name: "resource_handle", arg: 6, scope: !5, file: !1, type: !9)
!18 = !DILocation(line: 0, scope: !5)
!19 = !{!"branch_weights", i32 1048576, i32 1}
!20 = !{!21, !21, i64 0}
!21 = !{!"ctx_ptr", !22, i64 0}
!22 = !{!"tvm-tbaa"}
!23 = !{!"branch_weights", i32 1, i32 1048576}
!24 = !{!25, !25, i64 0}
!25 = !{!"0x63c5d15ce550.w4.b0", !26, i64 0}
!26 = !{!"0x63c5d15ce550.w8.b0", !27, i64 0}
!27 = !{!"0x63c5d15ce550.w16.b0", !28, i64 0}
!28 = !{!"0x63c5d15ce550.w32.b0", !29, i64 0}
!29 = !{!"0x63c5d15ce550.w64.b0", !30, i64 0}
!30 = !{!"0x63c5d15ce550.w128.b0", !31, i64 0}
!31 = !{!"0x63c5d15ce550.w256.b0", !32, i64 0}
!32 = !{!"0x63c5d15ce550.w512.b0", !33, i64 0}
!33 = !{!"0x63c5d15ce550.w1024.b0", !34, i64 0}
!34 = !{!"0x63c5d15ce550", !22, i64 0}
!35 = !DILocalVariable(name: "X.code", scope: !5, file: !1, type: !8)
!36 = !{!37, !37, i64 0}
!37 = !{!"0x63c5d15ce550.w4.b4", !26, i64 0}
!38 = !DILocalVariable(name: "W.code", scope: !5, file: !1, type: !8)
!39 = !{!40, !40, i64 0}
!40 = !{!"0x63c5d15ce550.w4.b8", !41, i64 0}
!41 = !{!"0x63c5d15ce550.w8.b8", !27, i64 0}
!42 = !DILocalVariable(name: "conv2d_nchw.code", scope: !5, file: !1, type: !8)
!43 = !DILocalVariable(name: "X", scope: !5, file: !1, type: !9)
!44 = !DILocalVariable(name: "W", scope: !5, file: !1, type: !9)
!45 = !DILocalVariable(name: "conv2d_nchw", scope: !5, file: !1, type: !9)
!46 = !DILocalVariable(name: "default_function.X.shape", scope: !5, file: !1, type: !47)
!47 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !48)
!48 = !DIBasicType(name: "int64", size: 64, encoding: DW_ATE_signed)
!49 = !{!50, !50, i64 0}
!50 = !{!"0x63c5d13f5a80.w8.b0", !51, i64 0}
!51 = !{!"0x63c5d13f5a80.w16.b0", !52, i64 0}
!52 = !{!"0x63c5d13f5a80.w32.b0", !53, i64 0}
!53 = !{!"0x63c5d13f5a80.w64.b0", !54, i64 0}
!54 = !{!"0x63c5d13f5a80.w128.b0", !55, i64 0}
!55 = !{!"0x63c5d13f5a80.w256.b0", !56, i64 0}
!56 = !{!"0x63c5d13f5a80.w512.b0", !57, i64 0}
!57 = !{!"0x63c5d13f5a80.w1024.b0", !58, i64 0}
!58 = !{!"0x63c5d13f5a80", !22, i64 0}
!59 = !DILocalVariable(name: "batch", scope: !5, file: !1, type: !8)
!60 = !{!61, !61, i64 0}
!61 = !{!"0x63c5d13f5a80.w8.b8", !51, i64 0}
!62 = !DILocalVariable(name: "in_channel", scope: !5, file: !1, type: !8)
!63 = !{!64, !64, i64 0}
!64 = !{!"0x63c5d13f5a80.w8.b16", !65, i64 0}
!65 = !{!"0x63c5d13f5a80.w16.b16", !52, i64 0}
!66 = !DILocalVariable(name: "in_height", scope: !5, file: !1, type: !8)
!67 = !{!68, !68, i64 0}
!68 = !{!"0x63c5d13f5a80.w8.b24", !65, i64 0}
!69 = !DILocalVariable(name: "in_width", scope: !5, file: !1, type: !8)
!70 = !DILocalVariable(name: "default_function.X.strides", scope: !5, file: !1, type: !47)
!71 = !DILocalVariable(name: "stride", scope: !5, file: !1, type: !8)
!72 = !{!73, !73, i64 0}
!73 = !{!"0x63c5d15d42d0.w8.b24", !74, i64 0}
!74 = !{!"0x63c5d15d42d0.w16.b16", !75, i64 0}
!75 = !{!"0x63c5d15d42d0.w32.b0", !76, i64 0}
!76 = !{!"0x63c5d15d42d0.w64.b0", !77, i64 0}
!77 = !{!"0x63c5d15d42d0.w128.b0", !78, i64 0}
!78 = !{!"0x63c5d15d42d0.w256.b0", !79, i64 0}
!79 = !{!"0x63c5d15d42d0.w512.b0", !80, i64 0}
!80 = !{!"0x63c5d15d42d0.w1024.b0", !81, i64 0}
!81 = !{!"0x63c5d15d42d0", !22, i64 0}
!82 = !{!83, !83, i64 0}
!83 = !{!"0x63c5d15d42d0.w8.b16", !74, i64 0}
!84 = !{!85, !85, i64 0}
!85 = !{!"0x63c5d15d42d0.w8.b8", !86, i64 0}
!86 = !{!"0x63c5d15d42d0.w16.b0", !75, i64 0}
!87 = !DILocalVariable(name: "dev_id", scope: !5, file: !1, type: !8)
!88 = !DILocalVariable(name: "X", scope: !5, file: !1, type: !89)
!89 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !90)
!90 = !DIBasicType(name: "float32", size: 32, encoding: DW_ATE_float)
!91 = !{!92, !92, i64 0}
!92 = !{!"0x63c5d15d42d0.w8.b0", !86, i64 0}
!93 = !DILocalVariable(name: "default_function.W.shape", scope: !5, file: !1, type: !47)
!94 = !DILocalVariable(name: "default_function.W.strides", scope: !5, file: !1, type: !47)
!95 = !{!96, !96, i64 0}
!96 = !{!"0x63c5d15d8d20.w8.b24", !97, i64 0}
!97 = !{!"0x63c5d15d8d20.w16.b16", !98, i64 0}
!98 = !{!"0x63c5d15d8d20.w32.b0", !99, i64 0}
!99 = !{!"0x63c5d15d8d20.w64.b0", !100, i64 0}
!100 = !{!"0x63c5d15d8d20.w128.b0", !101, i64 0}
!101 = !{!"0x63c5d15d8d20.w256.b0", !102, i64 0}
!102 = !{!"0x63c5d15d8d20.w512.b0", !103, i64 0}
!103 = !{!"0x63c5d15d8d20.w1024.b0", !104, i64 0}
!104 = !{!"0x63c5d15d8d20", !22, i64 0}
!105 = !{!106, !106, i64 0}
!106 = !{!"0x63c5d15d8d20.w8.b16", !97, i64 0}
!107 = !{!108, !108, i64 0}
!108 = !{!"0x63c5d15d8d20.w8.b8", !109, i64 0}
!109 = !{!"0x63c5d15d8d20.w16.b0", !98, i64 0}
!110 = !{!111, !111, i64 0}
!111 = !{!"0x63c5d15d8d20.w8.b0", !109, i64 0}
!112 = !DILocalVariable(name: "W", scope: !5, file: !1, type: !89)
!113 = !DILocalVariable(name: "default_function.conv2d_nchw.shape", scope: !5, file: !1, type: !47)
!114 = !DILocalVariable(name: "default_function.conv2d_nchw.strides", scope: !5, file: !1, type: !47)
!115 = !{!116, !116, i64 0}
!116 = !{!"0x63c5d15dd340.w8.b24", !117, i64 0}
!117 = !{!"0x63c5d15dd340.w16.b16", !118, i64 0}
!118 = !{!"0x63c5d15dd340.w32.b0", !119, i64 0}
!119 = !{!"0x63c5d15dd340.w64.b0", !120, i64 0}
!120 = !{!"0x63c5d15dd340.w128.b0", !121, i64 0}
!121 = !{!"0x63c5d15dd340.w256.b0", !122, i64 0}
!122 = !{!"0x63c5d15dd340.w512.b0", !123, i64 0}
!123 = !{!"0x63c5d15dd340.w1024.b0", !124, i64 0}
!124 = !{!"0x63c5d15dd340", !22, i64 0}
!125 = !{!126, !126, i64 0}
!126 = !{!"0x63c5d15dd340.w8.b16", !117, i64 0}
!127 = !{!128, !128, i64 0}
!128 = !{!"0x63c5d15dd340.w8.b8", !129, i64 0}
!129 = !{!"0x63c5d15dd340.w16.b0", !118, i64 0}
!130 = !DILocalVariable(name: "conv2d_nchw", scope: !5, file: !1, type: !89)
!131 = !{!132, !132, i64 0}
!132 = !{!"0x63c5d15dd340.w8.b0", !129, i64 0}
!133 = !{!134, !134, i64 0}
!134 = !{!"0x63c5d15d83c0.w8.b0", !135, i64 0}
!135 = !{!"0x63c5d15d83c0.w16.b0", !136, i64 0}
!136 = !{!"0x63c5d15d83c0.w32.b0", !137, i64 0}
!137 = !{!"0x63c5d15d83c0.w64.b0", !138, i64 0}
!138 = !{!"0x63c5d15d83c0.w128.b0", !139, i64 0}
!139 = !{!"0x63c5d15d83c0.w256.b0", !140, i64 0}
!140 = !{!"0x63c5d15d83c0.w512.b0", !141, i64 0}
!141 = !{!"0x63c5d15d83c0.w1024.b0", !142, i64 0}
!142 = !{!"0x63c5d15d83c0", !22, i64 0}
!143 = !{!144, !144, i64 0}
!144 = !{!"0x63c5d15d83c0.w8.b8", !135, i64 0}
!145 = !{!146, !146, i64 0}
!146 = !{!"0x63c5d15d83c0.w8.b16", !147, i64 0}
!147 = !{!"0x63c5d15d83c0.w16.b16", !136, i64 0}
!148 = !{!149, !149, i64 0}
!149 = !{!"0x63c5d15d83c0.w8.b24", !147, i64 0}
!150 = !{!151, !151, i64 0}
!151 = !{!"0x63c5d15dbbb0.w8.b0", !152, i64 0}
!152 = !{!"0x63c5d15dbbb0.w16.b0", !153, i64 0}
!153 = !{!"0x63c5d15dbbb0.w32.b0", !154, i64 0}
!154 = !{!"0x63c5d15dbbb0.w64.b0", !155, i64 0}
!155 = !{!"0x63c5d15dbbb0.w128.b0", !156, i64 0}
!156 = !{!"0x63c5d15dbbb0.w256.b0", !157, i64 0}
!157 = !{!"0x63c5d15dbbb0.w512.b0", !158, i64 0}
!158 = !{!"0x63c5d15dbbb0.w1024.b0", !159, i64 0}
!159 = !{!"0x63c5d15dbbb0", !22, i64 0}
!160 = !{!161, !161, i64 0}
!161 = !{!"0x63c5d15dbbb0.w8.b8", !152, i64 0}
!162 = !{!163, !163, i64 0}
!163 = !{!"0x63c5d15dbbb0.w8.b16", !164, i64 0}
!164 = !{!"0x63c5d15dbbb0.w16.b16", !153, i64 0}
!165 = !{!166, !166, i64 0}
!166 = !{!"0x63c5d15dbbb0.w8.b24", !164, i64 0}
!167 = distinct !DISubprogram(name: "default_function_compute_", scope: !1, file: !1, type: !168, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !0, retainedNodes: !170)
!168 = !DISubroutineType(types: !169)
!169 = !{!8, !8, !8, !8, !8, !8, !89, !8, !8, !8, !8, !89, !8, !8, !8, !8, !89, !8, !8, !8, !8}
!170 = !{!171, !172, !173, !174, !175, !176, !177, !178, !179, !180, !181, !182, !183, !184, !185, !186, !187, !188, !189, !190}
!171 = !DILocalVariable(name: "dev_id", arg: 1, scope: !167, file: !1, type: !8)
!172 = !DILocalVariable(name: "batch", arg: 2, scope: !167, file: !1, type: !8)
!173 = !DILocalVariable(name: "in_channel", arg: 3, scope: !167, file: !1, type: !8)
!174 = !DILocalVariable(name: "in_height", arg: 4, scope: !167, file: !1, type: !8)
!175 = !DILocalVariable(name: "in_width", arg: 5, scope: !167, file: !1, type: !8)
!176 = !DILocalVariable(name: "X", arg: 6, scope: !167, file: !1, type: !89)
!177 = !DILocalVariable(name: "stride", arg: 7, scope: !167, file: !1, type: !8)
!178 = !DILocalVariable(name: "stride1", arg: 8, scope: !167, file: !1, type: !8)
!179 = !DILocalVariable(name: "stride2", arg: 9, scope: !167, file: !1, type: !8)
!180 = !DILocalVariable(name: "stride3", arg: 10, scope: !167, file: !1, type: !8)
!181 = !DILocalVariable(name: "conv2d_nchw", arg: 11, scope: !167, file: !1, type: !89)
!182 = !DILocalVariable(name: "stride4", arg: 12, scope: !167, file: !1, type: !8)
!183 = !DILocalVariable(name: "stride5", arg: 13, scope: !167, file: !1, type: !8)
!184 = !DILocalVariable(name: "stride6", arg: 14, scope: !167, file: !1, type: !8)
!185 = !DILocalVariable(name: "stride7", arg: 15, scope: !167, file: !1, type: !8)
!186 = !DILocalVariable(name: "W", arg: 16, scope: !167, file: !1, type: !89)
!187 = !DILocalVariable(name: "stride8", arg: 17, scope: !167, file: !1, type: !8)
!188 = !DILocalVariable(name: "stride9", arg: 18, scope: !167, file: !1, type: !8)
!189 = !DILocalVariable(name: "stride10", arg: 19, scope: !167, file: !1, type: !8)
!190 = !DILocalVariable(name: "stride11", arg: 20, scope: !167, file: !1, type: !8)
!191 = !DILocation(line: 0, scope: !167)
!192 = !DILocalVariable(name: "pad_temp", scope: !167, file: !1, type: !89)
!193 = !DILocalVariable(name: "i0", scope: !167, file: !1, type: !8)
!194 = !{!"branch_weights", i32 127, i32 1}
!195 = !DILocalVariable(name: "i1", scope: !167, file: !1, type: !8)
!196 = !DILocalVariable(name: "i2", scope: !167, file: !1, type: !8)
!197 = !DILocalVariable(name: "i3", scope: !167, file: !1, type: !8)
!198 = !{!199, !199, i64 0}
!199 = !{!"0x63c5d15bce40", !22, i64 0}
!200 = !{!"branch_weights", i32 127, i32 134217601}
!201 = !{!"branch_weights", i32 1, i32 127}
!202 = !{!203, !203, i64 0}
!203 = !{!"0x63c5d14db4f0", !22, i64 0}
!204 = !{!"branch_weights", i32 127, i32 67108705}
!205 = distinct !{!205, !206}
!206 = !{!"llvm.loop.peeled.count", i32 1}
!207 = !{!"branch_weights", i32 1, i32 1}
!208 = !DILocalVariable(name: "nn", scope: !167, file: !1, type: !8)
!209 = !{!"branch_weights", i32 1073741824, i32 1073741824}
!210 = !{!"branch_weights", i32 2130706432, i32 -2130706432}
!211 = !DILocalVariable(name: "ff", scope: !167, file: !1, type: !8)
!212 = !DILocalVariable(name: "yy", scope: !167, file: !1, type: !8)
!213 = !DILocalVariable(name: "xx", scope: !167, file: !1, type: !8)
!214 = !DILocalVariable(name: "rc", scope: !167, file: !1, type: !8)
!215 = !DILocalVariable(name: "ry", scope: !167, file: !1, type: !8)
!216 = !DILocalVariable(name: "rx", scope: !167, file: !1, type: !8)
!217 = !{!218, !218, i64 0}
!218 = !{!"0x63c5d1527a00", !22, i64 0}
!219 = !{!220, !220, i64 0}
!220 = !{!"0x63c5d145f230", !22, i64 0}
!221 = !{!"branch_weights", i32 1, i32 1048575}
!222 = !{!"branch_weights", i32 16129, i32 255}
!223 = !{!"branch_weights", i32 127, i32 16777081}
!224 = distinct !{!224, !225, !226}
!225 = !{!"llvm.loop.isvectorized", i32 1}
!226 = !{!"llvm.loop.unroll.runtime.disable"}
!227 = !{!"branch_weights", i32 1, i32 7}
!228 = distinct !{!228, !229}
!229 = !{!"llvm.loop.unroll.disable"}
!230 = !{!"branch_weights", i32 0, i32 0}
!231 = distinct !{!231, !225}
!232 = distinct !{!232, !225, !226}
!233 = distinct !{!233, !229}
!234 = distinct !{!234, !225}
!235 = distinct !{!235, !225, !226}
!236 = distinct !{!236, !229}
!237 = distinct !{!237, !225}
!238 = distinct !{!238, !225, !226}
!239 = distinct !{!239, !229}
!240 = distinct !{!240, !225}
!241 = distinct !{!241, !225, !226}
!242 = distinct !{!242, !229}
!243 = distinct !{!243, !225}
!244 = distinct !{!244, !225, !226}
!245 = distinct !{!245, !229}
!246 = distinct !{!246, !225}
!247 = distinct !{!247, !225, !226}
!248 = distinct !{!248, !229}
!249 = distinct !{!249, !225}
!250 = distinct !{!250, !225, !226}
!251 = distinct !{!251, !229}
!252 = distinct !{!252, !225}
!253 = distinct !{!253, !225, !226}
!254 = distinct !{!254, !229}
!255 = distinct !{!255, !225}
!256 = distinct !{!256, !225, !226}
!257 = distinct !{!257, !229}
!258 = distinct !{!258, !225}
!259 = distinct !{!259, !225, !226}
!260 = distinct !{!260, !229}
!261 = distinct !{!261, !225}
!262 = distinct !{!262, !225, !226}
!263 = distinct !{!263, !229}
!264 = distinct !{!264, !225}
!265 = distinct !{!265, !225, !226}
!266 = distinct !{!266, !229}
!267 = distinct !{!267, !225}
!268 = distinct !{!268, !225, !226}
!269 = distinct !{!269, !229}
!270 = distinct !{!270, !225}
!271 = distinct !{!271, !225, !226}
!272 = distinct !{!272, !229}
!273 = distinct !{!273, !225}
!274 = distinct !{!274, !225, !226}
!275 = distinct !{!275, !229}
!276 = distinct !{!276, !225}
