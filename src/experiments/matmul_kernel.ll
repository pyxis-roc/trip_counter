; ModuleID = 'TVMMod'
source_filename = "TVMMod"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-i128:128-f80:128-n8:16:32:64-S128"
target triple = "x86_64-unknown-linux-gnu"

@__TVMAPISetLastError = linkonce dllexport local_unnamed_addr global ptr null, align 8
@.str = private constant [57 x i8] c"Assert fail: num_args == 3, matmul: num_args should be 3\00", align 1
@.str.1 = private constant [75 x i8] c"Assert fail: not T.isnullptr(args), matmul: TVMValue* arg pointer was NULL\00", align 1
@.str.2 = private constant [77 x i8] c"Assert fail: not T.isnullptr(arg_type_ids), matmul: int* type_codes was NULL\00", align 1
@.str.3 = private constant [108 x i8] c"Assert fail: A_code == 3 or A_code == 13 or A_code == 7 or A_code == 4, matmul: Expect arg[0] to be pointer\00", align 1
@.str.4 = private constant [108 x i8] c"Assert fail: B_code == 3 or B_code == 13 or B_code == 7 or B_code == 4, matmul: Expect arg[1] to be pointer\00", align 1
@.str.5 = private constant [136 x i8] c"Assert fail: T_matmul_code == 3 or T_matmul_code == 13 or T_matmul_code == 7 or T_matmul_code == 4, matmul: Expect arg[2] to be pointer\00", align 1
@.str.6 = private constant [89 x i8] c"Assert fail: not T.isnullptr(A), matmul.A is expected to have non-NULL DLTensor* pointer\00", align 1
@.str.7 = private constant [91 x i8] c"Assert fail: 2 == T.tvm_struct_get(A, 0, 4, \22int32\22), matmul.A.ndim is expected to equal 2\00", align 1
@.str.8 = private constant [89 x i8] c"Assert fail: not T.isnullptr(B), matmul.B is expected to have non-NULL DLTensor* pointer\00", align 1
@.str.9 = private constant [91 x i8] c"Assert fail: 2 == T.tvm_struct_get(B, 0, 4, \22int32\22), matmul.B.ndim is expected to equal 2\00", align 1
@.str.10 = private constant [103 x i8] c"Assert fail: not T.isnullptr(T_matmul), matmul.T_matmul is expected to have non-NULL DLTensor* pointer\00", align 1
@.str.11 = private constant [105 x i8] c"Assert fail: 2 == T.tvm_struct_get(T_matmul, 0, 4, \22int32\22), matmul.T_matmul.ndim is expected to equal 2\00", align 1
@.str.12 = private constant [213 x i8] c"Assert fail: T.tvm_struct_get(A, 0, 5, \22uint8\22) == T.uint8(2) and T.tvm_struct_get(A, 0, 6, \22uint8\22) == T.uint8(32) and T.tvm_struct_get(A, 0, 7, \22uint16\22) == T.uint16(1), matmul.A.dtype is expected to be float32\00", align 1
@.str.13 = private constant [177 x i8] c"Assert fail: T.uint64(0) == T.tvm_struct_get(A, 0, 8, \22uint64\22), Argument matmul.A.byte_offset has an unsatisfied constraint: T.uint64(0) == T.tvm_struct_get(A, 0, 8, \22uint64\22)\00", align 1
@.str.14 = private constant [157 x i8] c"Assert fail: T.tvm_struct_get(A, 0, 10, \22int32\22) == 1, Argument matmul.A.device_type has an unsatisfied constraint: 1 == T.tvm_struct_get(A, 0, 10, \22int32\22)\00", align 1
@.str.15 = private constant [98 x i8] c"Assert fail: M * K == 0 or not T.isnullptr(A), matmul.A is expected to have non-NULL data pointer\00", align 1
@.str.16 = private constant [213 x i8] c"Assert fail: T.tvm_struct_get(B, 0, 5, \22uint8\22) == T.uint8(2) and T.tvm_struct_get(B, 0, 6, \22uint8\22) == T.uint8(32) and T.tvm_struct_get(B, 0, 7, \22uint16\22) == T.uint16(1), matmul.B.dtype is expected to be float32\00", align 1
@.str.17 = private constant [152 x i8] c"Assert fail: K == T.Cast(\22int32\22, matmul_B_shape[0]), Argument matmul.B.shape[0] has an unsatisfied constraint: K == T.Cast(\22int32\22, matmul_B_shape[0])\00", align 1
@.str.18 = private constant [177 x i8] c"Assert fail: T.uint64(0) == T.tvm_struct_get(B, 0, 8, \22uint64\22), Argument matmul.B.byte_offset has an unsatisfied constraint: T.uint64(0) == T.tvm_struct_get(B, 0, 8, \22uint64\22)\00", align 1
@.str.19 = private constant [157 x i8] c"Assert fail: T.tvm_struct_get(B, 0, 10, \22int32\22) == 1, Argument matmul.B.device_type has an unsatisfied constraint: 1 == T.tvm_struct_get(B, 0, 10, \22int32\22)\00", align 1
@.str.20 = private constant [163 x i8] c"Assert fail: dev_id == T.tvm_struct_get(B, 0, 9, \22int32\22), Argument matmul.B.device_id has an unsatisfied constraint: dev_id == T.tvm_struct_get(B, 0, 9, \22int32\22)\00", align 1
@.str.21 = private constant [98 x i8] c"Assert fail: K * N == 0 or not T.isnullptr(B), matmul.B is expected to have non-NULL data pointer\00", align 1
@.str.22 = private constant [241 x i8] c"Assert fail: T.tvm_struct_get(T_matmul, 0, 5, \22uint8\22) == T.uint8(2) and T.tvm_struct_get(T_matmul, 0, 6, \22uint8\22) == T.uint8(32) and T.tvm_struct_get(T_matmul, 0, 7, \22uint16\22) == T.uint16(1), matmul.T_matmul.dtype is expected to be float32\00", align 1
@.str.23 = private constant [173 x i8] c"Assert fail: M == T.Cast(\22int32\22, matmul_T_matmul_shape[0]), Argument matmul.T_matmul.shape[0] has an unsatisfied constraint: M == T.Cast(\22int32\22, matmul_T_matmul_shape[0])\00", align 1
@.str.24 = private constant [173 x i8] c"Assert fail: N == T.Cast(\22int32\22, matmul_T_matmul_shape[1]), Argument matmul.T_matmul.shape[1] has an unsatisfied constraint: N == T.Cast(\22int32\22, matmul_T_matmul_shape[1])\00", align 1
@.str.25 = private constant [198 x i8] c"Assert fail: T.uint64(0) == T.tvm_struct_get(T_matmul, 0, 8, \22uint64\22), Argument matmul.T_matmul.byte_offset has an unsatisfied constraint: T.uint64(0) == T.tvm_struct_get(T_matmul, 0, 8, \22uint64\22)\00", align 1
@.str.26 = private constant [178 x i8] c"Assert fail: T.tvm_struct_get(T_matmul, 0, 10, \22int32\22) == 1, Argument matmul.T_matmul.device_type has an unsatisfied constraint: 1 == T.tvm_struct_get(T_matmul, 0, 10, \22int32\22)\00", align 1
@.str.27 = private constant [184 x i8] c"Assert fail: dev_id == T.tvm_struct_get(T_matmul, 0, 9, \22int32\22), Argument matmul.T_matmul.device_id has an unsatisfied constraint: dev_id == T.tvm_struct_get(T_matmul, 0, 9, \22int32\22)\00", align 1
@.str.28 = private constant [112 x i8] c"Assert fail: M * N == 0 or not T.isnullptr(T_matmul), matmul.T_matmul is expected to have non-NULL data pointer\00", align 1
@__tvm_main__ = weak dllexport local_unnamed_addr constant [7 x i8] c"matmul\00", align 1
@llvm.global_ctors = appending global [0 x { i32, ptr, ptr }] zeroinitializer

define dllexport range(i32 -1, 1) i32 @matmul(ptr noalias readonly %args, ptr noalias readonly %arg_type_ids, i32 %num_args, ptr noalias nocapture readnone %out_ret_value, ptr noalias nocapture readnone %out_ret_tcode, ptr noalias nocapture readnone %resource_handle) local_unnamed_addr #0 !dbg !5 {
entry:
    #dbg_value(ptr %args, !12, !DIExpression(), !18)
    #dbg_value(ptr %arg_type_ids, !13, !DIExpression(), !18)
    #dbg_value(i32 %num_args, !14, !DIExpression(), !18)
    #dbg_value(ptr %out_ret_value, !15, !DIExpression(), !18)
    #dbg_value(ptr %out_ret_tcode, !16, !DIExpression(), !18)
    #dbg_value(ptr %resource_handle, !17, !DIExpression(), !18)
  %0 = icmp eq i32 %num_args, 3, !dbg !18
  br i1 %0, label %assert_end, label %assert_fail, !dbg !18, !prof !19

common.ret:                                       ; preds = %assert_end105, %assert_fail104, %assert_fail102, %assert_fail100, %assert_fail98, %assert_fail96, %assert_fail94, %assert_fail92, %assert_fail90, %assert_fail88, %assert_fail86, %assert_fail84, %assert_fail82, %assert_fail80, %assert_fail78, %assert_fail76, %assert_fail74, %assert_fail72, %assert_fail52, %assert_fail50, %assert_fail30, %assert_fail28, %assert_fail13, %assert_fail11, %assert_fail9, %assert_fail7, %assert_fail5, %assert_fail3, %assert_fail1, %assert_fail
  %common.ret.op = phi i32 [ -1, %assert_fail ], [ -1, %assert_fail1 ], [ -1, %assert_fail3 ], [ -1, %assert_fail5 ], [ -1, %assert_fail7 ], [ -1, %assert_fail9 ], [ -1, %assert_fail11 ], [ -1, %assert_fail13 ], [ -1, %assert_fail28 ], [ -1, %assert_fail30 ], [ -1, %assert_fail50 ], [ -1, %assert_fail52 ], [ -1, %assert_fail72 ], [ -1, %assert_fail74 ], [ -1, %assert_fail76 ], [ -1, %assert_fail78 ], [ -1, %assert_fail80 ], [ -1, %assert_fail82 ], [ -1, %assert_fail84 ], [ -1, %assert_fail86 ], [ -1, %assert_fail88 ], [ -1, %assert_fail90 ], [ -1, %assert_fail92 ], [ -1, %assert_fail94 ], [ -1, %assert_fail96 ], [ -1, %assert_fail98 ], [ -1, %assert_fail100 ], [ -1, %assert_fail102 ], [ -1, %assert_fail104 ], [ 0, %assert_end105 ]
  ret i32 %common.ret.op, !dbg !18

assert_fail:                                      ; preds = %entry
  %1 = load ptr, ptr @__TVMAPISetLastError, align 8, !dbg !18, !tbaa !20
  tail call void %1(ptr nonnull @.str), !dbg !18
  br label %common.ret, !dbg !18

assert_end:                                       ; preds = %entry
  %.not = icmp eq ptr %args, null, !dbg !18
  br i1 %.not, label %assert_fail1, label %assert_end2, !dbg !18, !prof !23

assert_fail1:                                     ; preds = %assert_end
  %2 = load ptr, ptr @__TVMAPISetLastError, align 8, !dbg !18, !tbaa !20
  tail call void %2(ptr nonnull @.str.1), !dbg !18
  br label %common.ret, !dbg !18

assert_end2:                                      ; preds = %assert_end
  %.not114 = icmp eq ptr %arg_type_ids, null, !dbg !18
  br i1 %.not114, label %assert_fail3, label %assert_end4, !dbg !18, !prof !23

assert_fail3:                                     ; preds = %assert_end2
  %3 = load ptr, ptr @__TVMAPISetLastError, align 8, !dbg !18, !tbaa !20
  tail call void %3(ptr nonnull @.str.2), !dbg !18
  br label %common.ret, !dbg !18

assert_end4:                                      ; preds = %assert_end2
  %A.code = load i32, ptr %arg_type_ids, align 4, !dbg !18, !tbaa !24
    #dbg_declare(i32 %A.code, !35, !DIExpression(), !18)
    #dbg_declare(i32 %A.code, !35, !DIExpression(), !18)
  switch i32 %A.code, label %assert_fail5 [
    i32 13, label %assert_end6
    i32 7, label %assert_end6
    i32 4, label %assert_end6
    i32 3, label %assert_end6
  ], !dbg !18

assert_fail5:                                     ; preds = %assert_end4
  %4 = load ptr, ptr @__TVMAPISetLastError, align 8, !dbg !18, !tbaa !20
  tail call void %4(ptr nonnull @.str.3), !dbg !18
  br label %common.ret, !dbg !18

assert_end6:                                      ; preds = %assert_end4, %assert_end4, %assert_end4, %assert_end4
  %5 = getelementptr inbounds i8, ptr %arg_type_ids, i64 4, !dbg !18
  %B.code = load i32, ptr %5, align 4, !dbg !18, !tbaa !36
    #dbg_declare(i32 %B.code, !38, !DIExpression(), !18)
    #dbg_declare(i32 %B.code, !38, !DIExpression(), !18)
  switch i32 %B.code, label %assert_fail7 [
    i32 13, label %assert_end8
    i32 7, label %assert_end8
    i32 4, label %assert_end8
    i32 3, label %assert_end8
  ], !dbg !18

assert_fail7:                                     ; preds = %assert_end6
  %6 = load ptr, ptr @__TVMAPISetLastError, align 8, !dbg !18, !tbaa !20
  tail call void %6(ptr nonnull @.str.4), !dbg !18
  br label %common.ret, !dbg !18

assert_end8:                                      ; preds = %assert_end6, %assert_end6, %assert_end6, %assert_end6
  %7 = getelementptr inbounds i8, ptr %arg_type_ids, i64 8, !dbg !18
  %T_matmul.code = load i32, ptr %7, align 4, !dbg !18, !tbaa !39
    #dbg_declare(i32 %T_matmul.code, !42, !DIExpression(), !18)
    #dbg_declare(i32 %T_matmul.code, !42, !DIExpression(), !18)
  switch i32 %T_matmul.code, label %assert_fail9 [
    i32 13, label %assert_end10
    i32 7, label %assert_end10
    i32 4, label %assert_end10
    i32 3, label %assert_end10
  ], !dbg !18

assert_fail9:                                     ; preds = %assert_end8
  %8 = load ptr, ptr @__TVMAPISetLastError, align 8, !dbg !18, !tbaa !20
  tail call void %8(ptr nonnull @.str.5), !dbg !18
  br label %common.ret, !dbg !18

assert_end10:                                     ; preds = %assert_end8, %assert_end8, %assert_end8, %assert_end8
  %A = load ptr, ptr %args, align 8, !dbg !18
    #dbg_declare(ptr %A, !43, !DIExpression(), !18)
    #dbg_declare(ptr %A, !43, !DIExpression(), !18)
  %9 = getelementptr inbounds i8, ptr %args, i64 8, !dbg !18
  %B = load ptr, ptr %9, align 8, !dbg !18
    #dbg_declare(ptr %B, !44, !DIExpression(), !18)
    #dbg_declare(ptr %B, !44, !DIExpression(), !18)
  %10 = getelementptr inbounds i8, ptr %args, i64 16, !dbg !18
  %T_matmul = load ptr, ptr %10, align 8, !dbg !18
    #dbg_declare(ptr %T_matmul, !45, !DIExpression(), !18)
    #dbg_declare(ptr %T_matmul, !45, !DIExpression(), !18)
  %.not115 = icmp eq ptr %A, null, !dbg !18
  br i1 %.not115, label %assert_fail11, label %assert_end12, !dbg !18, !prof !23

assert_fail11:                                    ; preds = %assert_end10
  %11 = load ptr, ptr @__TVMAPISetLastError, align 8, !dbg !18, !tbaa !20
  tail call void %11(ptr nonnull @.str.6), !dbg !18
  br label %common.ret, !dbg !18

assert_end12:                                     ; preds = %assert_end10
  %12 = getelementptr inbounds i8, ptr %A, i64 16, !dbg !18
  %13 = load i32, ptr %12, align 4, !dbg !18
  %14 = icmp eq i32 %13, 2, !dbg !18
  br i1 %14, label %assert_end14, label %assert_fail13, !dbg !18, !prof !19

assert_fail13:                                    ; preds = %assert_end12
  %15 = load ptr, ptr @__TVMAPISetLastError, align 8, !dbg !18, !tbaa !20
  tail call void %15(ptr nonnull @.str.7), !dbg !18
  br label %common.ret, !dbg !18

assert_end14:                                     ; preds = %assert_end12
  %16 = getelementptr inbounds i8, ptr %A, i64 24, !dbg !18
  %matmul.A.shape = load ptr, ptr %16, align 8, !dbg !18
    #dbg_declare(ptr %matmul.A.shape, !46, !DIExpression(), !18)
    #dbg_declare(ptr %matmul.A.shape, !46, !DIExpression(), !18)
  %17 = load i64, ptr %matmul.A.shape, align 8, !dbg !18, !tbaa !49
  %M = trunc i64 %17 to i32, !dbg !18
    #dbg_declare(i32 %M, !59, !DIExpression(), !18)
    #dbg_declare(i32 %M, !59, !DIExpression(), !18)
  %18 = getelementptr inbounds i8, ptr %matmul.A.shape, i64 8, !dbg !18
  %19 = load i64, ptr %18, align 8, !dbg !18, !tbaa !60
  %K = trunc i64 %19 to i32, !dbg !18
    #dbg_declare(i32 %K, !62, !DIExpression(), !18)
    #dbg_declare(i32 %K, !62, !DIExpression(), !18)
  %20 = getelementptr inbounds i8, ptr %A, i64 32, !dbg !18
  %matmul.A.strides = load ptr, ptr %20, align 8, !dbg !18
    #dbg_declare(ptr %matmul.A.strides, !63, !DIExpression(), !18)
    #dbg_declare(ptr %matmul.A.strides, !63, !DIExpression(), !18)
  %21 = icmp eq i32 %K, 1, !dbg !18
  br i1 %21, label %if_end, label %if_else, !dbg !18

if_else:                                          ; preds = %assert_end14
  %22 = icmp eq ptr %matmul.A.strides, null, !dbg !18
  br i1 %22, label %if_end.thread, label %if_else16, !dbg !18

if_end:                                           ; preds = %if_else16, %assert_end14
  %stride = phi i32 [ 0, %assert_end14 ], [ %27, %if_else16 ], !dbg !18
    #dbg_declare(i32 %stride, !64, !DIExpression(), !18)
    #dbg_declare(i32 %stride, !64, !DIExpression(), !18)
  %23 = icmp eq i32 %M, 1, !dbg !18
  br i1 %23, label %if_end20, label %if_else19, !dbg !18

if_end.thread:                                    ; preds = %if_else
    #dbg_declare(i32 1, !64, !DIExpression(), !18)
    #dbg_declare(i32 1, !64, !DIExpression(), !18)
  %24 = icmp eq i32 %M, 1, !dbg !18
  %spec.select130 = select i1 %24, i32 0, i32 %K, !dbg !18
  br label %if_end20, !dbg !18

if_else16:                                        ; preds = %if_else
  %25 = getelementptr inbounds i8, ptr %matmul.A.strides, i64 8, !dbg !18
  %26 = load i64, ptr %25, align 8, !dbg !18, !tbaa !65
  %27 = trunc i64 %26 to i32, !dbg !18
  br label %if_end, !dbg !18

if_else19:                                        ; preds = %if_end
  %28 = icmp eq ptr %matmul.A.strides, null, !dbg !18
  br i1 %28, label %if_end20, label %if_else22, !dbg !18

if_end20:                                         ; preds = %if_end.thread, %if_else22, %if_else19, %if_end
  %29 = phi i1 [ true, %if_end ], [ false, %if_else22 ], [ false, %if_else19 ], [ %24, %if_end.thread ]
  %stride120 = phi i32 [ %stride, %if_end ], [ %stride, %if_else22 ], [ %stride, %if_else19 ], [ 1, %if_end.thread ]
  %stride110 = phi i32 [ 0, %if_end ], [ %32, %if_else22 ], [ %K, %if_else19 ], [ %spec.select130, %if_end.thread ], !dbg !18
    #dbg_declare(i32 %stride110, !64, !DIExpression(), !18)
    #dbg_declare(i32 %stride110, !64, !DIExpression(), !18)
  %30 = getelementptr inbounds i8, ptr %A, i64 12, !dbg !18
  %dev_id = load i32, ptr %30, align 4, !dbg !18
    #dbg_declare(i32 %dev_id, !75, !DIExpression(), !18)
    #dbg_declare(i32 %dev_id, !75, !DIExpression(), !18)
  %A109 = load ptr, ptr %A, align 8, !dbg !18
    #dbg_declare(ptr %A109, !76, !DIExpression(), !18)
    #dbg_declare(ptr %A109, !76, !DIExpression(), !18)
  call void @llvm.assume(i1 true) [ "align"(ptr %A109, i64 64) ], !dbg !18
  %.not116 = icmp eq ptr %B, null, !dbg !18
  br i1 %.not116, label %assert_fail28, label %assert_end29, !dbg !18, !prof !23

if_else22:                                        ; preds = %if_else19
  %31 = load i64, ptr %matmul.A.strides, align 8, !dbg !18, !tbaa !79
  %32 = trunc i64 %31 to i32, !dbg !18
  br label %if_end20, !dbg !18

assert_fail28:                                    ; preds = %if_end20
  %33 = load ptr, ptr @__TVMAPISetLastError, align 8, !dbg !18, !tbaa !20
  tail call void %33(ptr nonnull @.str.8), !dbg !18
  br label %common.ret, !dbg !18

assert_end29:                                     ; preds = %if_end20
  %34 = getelementptr inbounds i8, ptr %B, i64 16, !dbg !18
  %35 = load i32, ptr %34, align 4, !dbg !18
  %36 = icmp eq i32 %35, 2, !dbg !18
  br i1 %36, label %assert_end31, label %assert_fail30, !dbg !18, !prof !19

assert_fail30:                                    ; preds = %assert_end29
  %37 = load ptr, ptr @__TVMAPISetLastError, align 8, !dbg !18, !tbaa !20
  tail call void %37(ptr nonnull @.str.9), !dbg !18
  br label %common.ret, !dbg !18

assert_end31:                                     ; preds = %assert_end29
  %38 = getelementptr inbounds i8, ptr %B, i64 24, !dbg !18
  %matmul.B.shape = load ptr, ptr %38, align 8, !dbg !18
    #dbg_declare(ptr %matmul.B.shape, !81, !DIExpression(), !18)
    #dbg_declare(ptr %matmul.B.shape, !81, !DIExpression(), !18)
  %39 = getelementptr inbounds i8, ptr %matmul.B.shape, i64 8, !dbg !18
  %40 = load i64, ptr %39, align 8, !dbg !18, !tbaa !82
  %N = trunc i64 %40 to i32, !dbg !18
    #dbg_declare(i32 %N, !92, !DIExpression(), !18)
    #dbg_declare(i32 %N, !92, !DIExpression(), !18)
  %41 = getelementptr inbounds i8, ptr %B, i64 32, !dbg !18
  %matmul.B.strides = load ptr, ptr %41, align 8, !dbg !18
    #dbg_declare(ptr %matmul.B.strides, !93, !DIExpression(), !18)
    #dbg_declare(ptr %matmul.B.strides, !93, !DIExpression(), !18)
  %42 = icmp eq i32 %N, 1, !dbg !18
  br i1 %42, label %if_end34, label %if_else33, !dbg !18

if_else33:                                        ; preds = %assert_end31
  %43 = icmp eq ptr %matmul.B.strides, null, !dbg !18
  br i1 %43, label %if_end34.thread, label %if_else36, !dbg !18

if_end34:                                         ; preds = %if_else36, %assert_end31
  %stride113 = phi i32 [ 0, %assert_end31 ], [ %46, %if_else36 ], !dbg !18
    #dbg_declare(i32 %stride113, !64, !DIExpression(), !18)
    #dbg_declare(i32 %stride113, !64, !DIExpression(), !18)
  br i1 %21, label %if_end42, label %if_else41, !dbg !18

if_end34.thread:                                  ; preds = %if_else33
    #dbg_declare(i32 1, !64, !DIExpression(), !18)
    #dbg_declare(i32 1, !64, !DIExpression(), !18)
  %spec.select131 = select i1 %21, i32 0, i32 %N, !dbg !18
  br label %if_end42, !dbg !18

if_else36:                                        ; preds = %if_else33
  %44 = getelementptr inbounds i8, ptr %matmul.B.strides, i64 8, !dbg !18
  %45 = load i64, ptr %44, align 8, !dbg !18, !tbaa !94
  %46 = trunc i64 %45 to i32, !dbg !18
  br label %if_end34, !dbg !18

if_else41:                                        ; preds = %if_end34
  %47 = icmp eq ptr %matmul.B.strides, null, !dbg !18
  br i1 %47, label %if_end42, label %if_else44, !dbg !18

if_end42:                                         ; preds = %if_end34.thread, %if_else44, %if_else41, %if_end34
  %stride113124 = phi i32 [ %stride113, %if_end34 ], [ %stride113, %if_else44 ], [ %stride113, %if_else41 ], [ 1, %if_end34.thread ]
  %stride112 = phi i32 [ 0, %if_end34 ], [ %49, %if_else44 ], [ %N, %if_else41 ], [ %spec.select131, %if_end34.thread ], !dbg !18
    #dbg_declare(i32 %stride112, !64, !DIExpression(), !18)
    #dbg_declare(i32 %stride112, !64, !DIExpression(), !18)
  %B111 = load ptr, ptr %B, align 8, !dbg !18
    #dbg_declare(ptr %B111, !104, !DIExpression(), !18)
    #dbg_declare(ptr %B111, !104, !DIExpression(), !18)
  call void @llvm.assume(i1 true) [ "align"(ptr %B111, i64 64) ], !dbg !18
  %.not117 = icmp eq ptr %T_matmul, null, !dbg !18
  br i1 %.not117, label %assert_fail50, label %assert_end51, !dbg !18, !prof !23

if_else44:                                        ; preds = %if_else41
  %48 = load i64, ptr %matmul.B.strides, align 8, !dbg !18, !tbaa !105
  %49 = trunc i64 %48 to i32, !dbg !18
  br label %if_end42, !dbg !18

assert_fail50:                                    ; preds = %if_end42
  %50 = load ptr, ptr @__TVMAPISetLastError, align 8, !dbg !18, !tbaa !20
  tail call void %50(ptr nonnull @.str.10), !dbg !18
  br label %common.ret, !dbg !18

assert_end51:                                     ; preds = %if_end42
  %51 = getelementptr inbounds i8, ptr %T_matmul, i64 16, !dbg !18
  %52 = load i32, ptr %51, align 4, !dbg !18
  %53 = icmp eq i32 %52, 2, !dbg !18
  br i1 %53, label %assert_end53, label %assert_fail52, !dbg !18, !prof !19

assert_fail52:                                    ; preds = %assert_end51
  %54 = load ptr, ptr @__TVMAPISetLastError, align 8, !dbg !18, !tbaa !20
  tail call void %54(ptr nonnull @.str.11), !dbg !18
  br label %common.ret, !dbg !18

assert_end53:                                     ; preds = %assert_end51
  %55 = getelementptr inbounds i8, ptr %T_matmul, i64 24, !dbg !18
  %matmul.T_matmul.shape = load ptr, ptr %55, align 8, !dbg !18
    #dbg_declare(ptr %matmul.T_matmul.shape, !107, !DIExpression(), !18)
    #dbg_declare(ptr %matmul.T_matmul.shape, !107, !DIExpression(), !18)
  %56 = getelementptr inbounds i8, ptr %T_matmul, i64 32, !dbg !18
  %matmul.T_matmul.strides = load ptr, ptr %56, align 8, !dbg !18
    #dbg_declare(ptr %matmul.T_matmul.strides, !108, !DIExpression(), !18)
    #dbg_declare(ptr %matmul.T_matmul.strides, !108, !DIExpression(), !18)
  br i1 %42, label %if_end56, label %if_else55, !dbg !18

if_else55:                                        ; preds = %assert_end53
  %57 = icmp eq ptr %matmul.T_matmul.strides, null, !dbg !18
  br i1 %57, label %if_end56.thread, label %if_else58, !dbg !18

if_end56:                                         ; preds = %if_else58, %assert_end53
  %stride108 = phi i32 [ 0, %assert_end53 ], [ %60, %if_else58 ], !dbg !18
    #dbg_declare(i32 %stride108, !64, !DIExpression(), !18)
    #dbg_declare(i32 %stride108, !64, !DIExpression(), !18)
  br i1 %29, label %if_end64, label %if_else63, !dbg !18

if_end56.thread:                                  ; preds = %if_else55
    #dbg_declare(i32 1, !64, !DIExpression(), !18)
    #dbg_declare(i32 1, !64, !DIExpression(), !18)
  %spec.select132 = select i1 %29, i32 0, i32 %N, !dbg !18
  br label %if_end64, !dbg !18

if_else58:                                        ; preds = %if_else55
  %58 = getelementptr inbounds i8, ptr %matmul.T_matmul.strides, i64 8, !dbg !18
  %59 = load i64, ptr %58, align 8, !dbg !18, !tbaa !109
  %60 = trunc i64 %59 to i32, !dbg !18
  br label %if_end56, !dbg !18

if_else63:                                        ; preds = %if_end56
  %61 = icmp eq ptr %matmul.T_matmul.strides, null, !dbg !18
  br i1 %61, label %if_end64, label %if_else66, !dbg !18

if_end64:                                         ; preds = %if_end56.thread, %if_else66, %if_else63, %if_end56
  %stride108128 = phi i32 [ %stride108, %if_end56 ], [ %stride108, %if_else66 ], [ %stride108, %if_else63 ], [ 1, %if_end56.thread ]
  %stride107 = phi i32 [ 0, %if_end56 ], [ %74, %if_else66 ], [ %N, %if_else63 ], [ %spec.select132, %if_end56.thread ], !dbg !18
    #dbg_declare(i32 %stride107, !64, !DIExpression(), !18)
    #dbg_declare(i32 %stride107, !64, !DIExpression(), !18)
  %T_matmul106 = load ptr, ptr %T_matmul, align 8, !dbg !18
    #dbg_declare(ptr %T_matmul106, !119, !DIExpression(), !18)
    #dbg_declare(ptr %T_matmul106, !119, !DIExpression(), !18)
  call void @llvm.assume(i1 true) [ "align"(ptr %T_matmul106, i64 64) ], !dbg !18
  %62 = getelementptr inbounds i8, ptr %A, i64 22, !dbg !18
  %63 = load i16, ptr %62, align 2, !dbg !18
  %64 = icmp eq i16 %63, 1, !dbg !18
  %65 = getelementptr inbounds i8, ptr %A, i64 21, !dbg !18
  %66 = load i8, ptr %65, align 1, !dbg !18
  %67 = icmp eq i8 %66, 32, !dbg !18
  %68 = getelementptr inbounds i8, ptr %A, i64 20, !dbg !18
  %69 = load i8, ptr %68, align 1, !dbg !18
  %70 = icmp eq i8 %69, 2, !dbg !18
  %71 = and i1 %67, %70, !dbg !18
  %72 = and i1 %64, %71, !dbg !18
  br i1 %72, label %assert_end73, label %assert_fail72, !dbg !18, !prof !19

if_else66:                                        ; preds = %if_else63
  %73 = load i64, ptr %matmul.T_matmul.strides, align 8, !dbg !18, !tbaa !120
  %74 = trunc i64 %73 to i32, !dbg !18
  br label %if_end64, !dbg !18

assert_fail72:                                    ; preds = %if_end64
  %75 = load ptr, ptr @__TVMAPISetLastError, align 8, !dbg !18, !tbaa !20
  tail call void %75(ptr nonnull @.str.12), !dbg !18
  br label %common.ret, !dbg !18

assert_end73:                                     ; preds = %if_end64
  %76 = getelementptr inbounds i8, ptr %A, i64 40, !dbg !18
  %77 = load i64, ptr %76, align 8, !dbg !18
  %78 = icmp eq i64 %77, 0, !dbg !18
  br i1 %78, label %assert_end75, label %assert_fail74, !dbg !18, !prof !19

assert_fail74:                                    ; preds = %assert_end73
  %79 = load ptr, ptr @__TVMAPISetLastError, align 8, !dbg !18, !tbaa !20
  tail call void %79(ptr nonnull @.str.13), !dbg !18
  br label %common.ret, !dbg !18

assert_end75:                                     ; preds = %assert_end73
  %80 = getelementptr inbounds i8, ptr %A, i64 8, !dbg !18
  %81 = load i32, ptr %80, align 4, !dbg !18
  %82 = icmp eq i32 %81, 1, !dbg !18
  br i1 %82, label %assert_end77, label %assert_fail76, !dbg !18, !prof !19

assert_fail76:                                    ; preds = %assert_end75
  %83 = load ptr, ptr @__TVMAPISetLastError, align 8, !dbg !18, !tbaa !20
  tail call void %83(ptr nonnull @.str.14), !dbg !18
  br label %common.ret, !dbg !18

assert_end77:                                     ; preds = %assert_end75
  %84 = icmp ne ptr %A109, null, !dbg !18
  %85 = mul nsw i32 %K, %M, !dbg !18
  %86 = icmp eq i32 %85, 0, !dbg !18
  %87 = or i1 %86, %84, !dbg !18
  br i1 %87, label %assert_end79, label %assert_fail78, !dbg !18, !prof !19

assert_fail78:                                    ; preds = %assert_end77
  %88 = load ptr, ptr @__TVMAPISetLastError, align 8, !dbg !18, !tbaa !20
  tail call void %88(ptr nonnull @.str.15), !dbg !18
  br label %common.ret, !dbg !18

assert_end79:                                     ; preds = %assert_end77
  %89 = getelementptr inbounds i8, ptr %B, i64 22, !dbg !18
  %90 = load i16, ptr %89, align 2, !dbg !18
  %91 = icmp eq i16 %90, 1, !dbg !18
  %92 = getelementptr inbounds i8, ptr %B, i64 21, !dbg !18
  %93 = load i8, ptr %92, align 1, !dbg !18
  %94 = icmp eq i8 %93, 32, !dbg !18
  %95 = getelementptr inbounds i8, ptr %B, i64 20, !dbg !18
  %96 = load i8, ptr %95, align 1, !dbg !18
  %97 = icmp eq i8 %96, 2, !dbg !18
  %98 = and i1 %94, %97, !dbg !18
  %99 = and i1 %91, %98, !dbg !18
  br i1 %99, label %assert_end81, label %assert_fail80, !dbg !18, !prof !19

assert_fail80:                                    ; preds = %assert_end79
  %100 = load ptr, ptr @__TVMAPISetLastError, align 8, !dbg !18, !tbaa !20
  tail call void %100(ptr nonnull @.str.16), !dbg !18
  br label %common.ret, !dbg !18

assert_end81:                                     ; preds = %assert_end79
  %101 = load i64, ptr %matmul.B.shape, align 8, !dbg !18, !tbaa !122
  %102 = trunc i64 %101 to i32, !dbg !18
  %103 = icmp eq i32 %K, %102, !dbg !18
  br i1 %103, label %assert_end83, label %assert_fail82, !dbg !18, !prof !19

assert_fail82:                                    ; preds = %assert_end81
  %104 = load ptr, ptr @__TVMAPISetLastError, align 8, !dbg !18, !tbaa !20
  tail call void %104(ptr nonnull @.str.17), !dbg !18
  br label %common.ret, !dbg !18

assert_end83:                                     ; preds = %assert_end81
  %105 = getelementptr inbounds i8, ptr %B, i64 40, !dbg !18
  %106 = load i64, ptr %105, align 8, !dbg !18
  %107 = icmp eq i64 %106, 0, !dbg !18
  br i1 %107, label %assert_end85, label %assert_fail84, !dbg !18, !prof !19

assert_fail84:                                    ; preds = %assert_end83
  %108 = load ptr, ptr @__TVMAPISetLastError, align 8, !dbg !18, !tbaa !20
  tail call void %108(ptr nonnull @.str.18), !dbg !18
  br label %common.ret, !dbg !18

assert_end85:                                     ; preds = %assert_end83
  %109 = getelementptr inbounds i8, ptr %B, i64 8, !dbg !18
  %110 = load i32, ptr %109, align 4, !dbg !18
  %111 = icmp eq i32 %110, 1, !dbg !18
  br i1 %111, label %assert_end87, label %assert_fail86, !dbg !18, !prof !19

assert_fail86:                                    ; preds = %assert_end85
  %112 = load ptr, ptr @__TVMAPISetLastError, align 8, !dbg !18, !tbaa !20
  tail call void %112(ptr nonnull @.str.19), !dbg !18
  br label %common.ret, !dbg !18

assert_end87:                                     ; preds = %assert_end85
  %113 = getelementptr inbounds i8, ptr %B, i64 12, !dbg !18
  %114 = load i32, ptr %113, align 4, !dbg !18
  %115 = icmp eq i32 %dev_id, %114, !dbg !18
  br i1 %115, label %assert_end89, label %assert_fail88, !dbg !18, !prof !19

assert_fail88:                                    ; preds = %assert_end87
  %116 = load ptr, ptr @__TVMAPISetLastError, align 8, !dbg !18, !tbaa !20
  tail call void %116(ptr nonnull @.str.20), !dbg !18
  br label %common.ret, !dbg !18

assert_end89:                                     ; preds = %assert_end87
  %117 = icmp ne ptr %B111, null, !dbg !18
  %118 = mul nsw i32 %N, %K, !dbg !18
  %119 = icmp eq i32 %118, 0, !dbg !18
  %120 = or i1 %119, %117, !dbg !18
  br i1 %120, label %assert_end91, label %assert_fail90, !dbg !18, !prof !19

assert_fail90:                                    ; preds = %assert_end89
  %121 = load ptr, ptr @__TVMAPISetLastError, align 8, !dbg !18, !tbaa !20
  tail call void %121(ptr nonnull @.str.21), !dbg !18
  br label %common.ret, !dbg !18

assert_end91:                                     ; preds = %assert_end89
  %122 = getelementptr inbounds i8, ptr %T_matmul, i64 22, !dbg !18
  %123 = load i16, ptr %122, align 2, !dbg !18
  %124 = icmp eq i16 %123, 1, !dbg !18
  %125 = getelementptr inbounds i8, ptr %T_matmul, i64 21, !dbg !18
  %126 = load i8, ptr %125, align 1, !dbg !18
  %127 = icmp eq i8 %126, 32, !dbg !18
  %128 = getelementptr inbounds i8, ptr %T_matmul, i64 20, !dbg !18
  %129 = load i8, ptr %128, align 1, !dbg !18
  %130 = icmp eq i8 %129, 2, !dbg !18
  %131 = and i1 %127, %130, !dbg !18
  %132 = and i1 %124, %131, !dbg !18
  br i1 %132, label %assert_end93, label %assert_fail92, !dbg !18, !prof !19

assert_fail92:                                    ; preds = %assert_end91
  %133 = load ptr, ptr @__TVMAPISetLastError, align 8, !dbg !18, !tbaa !20
  tail call void %133(ptr nonnull @.str.22), !dbg !18
  br label %common.ret, !dbg !18

assert_end93:                                     ; preds = %assert_end91
  %134 = load i64, ptr %matmul.T_matmul.shape, align 8, !dbg !18, !tbaa !124
  %135 = trunc i64 %134 to i32, !dbg !18
  %136 = icmp eq i32 %M, %135, !dbg !18
  br i1 %136, label %assert_end95, label %assert_fail94, !dbg !18, !prof !19

assert_fail94:                                    ; preds = %assert_end93
  %137 = load ptr, ptr @__TVMAPISetLastError, align 8, !dbg !18, !tbaa !20
  tail call void %137(ptr nonnull @.str.23), !dbg !18
  br label %common.ret, !dbg !18

assert_end95:                                     ; preds = %assert_end93
  %138 = getelementptr inbounds i8, ptr %matmul.T_matmul.shape, i64 8, !dbg !18
  %139 = load i64, ptr %138, align 8, !dbg !18, !tbaa !134
  %140 = trunc i64 %139 to i32, !dbg !18
  %141 = icmp eq i32 %N, %140, !dbg !18
  br i1 %141, label %assert_end97, label %assert_fail96, !dbg !18, !prof !19

assert_fail96:                                    ; preds = %assert_end95
  %142 = load ptr, ptr @__TVMAPISetLastError, align 8, !dbg !18, !tbaa !20
  tail call void %142(ptr nonnull @.str.24), !dbg !18
  br label %common.ret, !dbg !18

assert_end97:                                     ; preds = %assert_end95
  %143 = getelementptr inbounds i8, ptr %T_matmul, i64 40, !dbg !18
  %144 = load i64, ptr %143, align 8, !dbg !18
  %145 = icmp eq i64 %144, 0, !dbg !18
  br i1 %145, label %assert_end99, label %assert_fail98, !dbg !18, !prof !19

assert_fail98:                                    ; preds = %assert_end97
  %146 = load ptr, ptr @__TVMAPISetLastError, align 8, !dbg !18, !tbaa !20
  tail call void %146(ptr nonnull @.str.25), !dbg !18
  br label %common.ret, !dbg !18

assert_end99:                                     ; preds = %assert_end97
  %147 = getelementptr inbounds i8, ptr %T_matmul, i64 8, !dbg !18
  %148 = load i32, ptr %147, align 4, !dbg !18
  %149 = icmp eq i32 %148, 1, !dbg !18
  br i1 %149, label %assert_end101, label %assert_fail100, !dbg !18, !prof !19

assert_fail100:                                   ; preds = %assert_end99
  %150 = load ptr, ptr @__TVMAPISetLastError, align 8, !dbg !18, !tbaa !20
  tail call void %150(ptr nonnull @.str.26), !dbg !18
  br label %common.ret, !dbg !18

assert_end101:                                    ; preds = %assert_end99
  %151 = getelementptr inbounds i8, ptr %T_matmul, i64 12, !dbg !18
  %152 = load i32, ptr %151, align 4, !dbg !18
  %153 = icmp eq i32 %dev_id, %152, !dbg !18
  br i1 %153, label %assert_end103, label %assert_fail102, !dbg !18, !prof !19

assert_fail102:                                   ; preds = %assert_end101
  %154 = load ptr, ptr @__TVMAPISetLastError, align 8, !dbg !18, !tbaa !20
  tail call void %154(ptr nonnull @.str.27), !dbg !18
  br label %common.ret, !dbg !18

assert_end103:                                    ; preds = %assert_end101
  %155 = icmp ne ptr %T_matmul106, null, !dbg !18
  %156 = mul nsw i32 %N, %M, !dbg !18
  %157 = icmp eq i32 %156, 0, !dbg !18
  %158 = or i1 %157, %155, !dbg !18
  br i1 %158, label %assert_end105, label %assert_fail104, !dbg !18, !prof !19

assert_fail104:                                   ; preds = %assert_end103
  %159 = load ptr, ptr @__TVMAPISetLastError, align 8, !dbg !18, !tbaa !20
  tail call void %159(ptr nonnull @.str.28), !dbg !18
  br label %common.ret, !dbg !18

assert_end105:                                    ; preds = %assert_end103
  tail call fastcc void @matmul_compute_(i32 %M, i32 %N, ptr %T_matmul106, i32 %stride107, i32 %stride108128, i32 %K, ptr %A109, i32 %stride110, i32 %stride120, ptr %B111, i32 %stride112, i32 %stride113124), !dbg !18
  br label %common.ret, !dbg !18
}

; Function Attrs: mustprogress nocallback nofree nosync nounwind willreturn memory(inaccessiblemem: write)
declare void @llvm.assume(i1 noundef) #1

; Function Attrs: nofree noinline norecurse nosync nounwind memory(argmem: readwrite)
define external fastcc void @matmul_compute_(i32 %M, i32 %N, ptr noalias nocapture writeonly align 64 %T_matmul, i32 %stride, i32 %stride1, i32 %K, ptr noalias nocapture readonly align 64 %A, i32 %stride2, i32 %stride3, ptr noalias nocapture readonly align 64 %B, i32 %stride4, i32 %stride5) unnamed_addr #2 !dbg !136 {
entry:
    #dbg_value(i32 %M, !140, !DIExpression(), !152)
    #dbg_value(i32 %N, !141, !DIExpression(), !152)
    #dbg_value(ptr %T_matmul, !142, !DIExpression(), !152)
    #dbg_value(i32 %stride, !143, !DIExpression(), !152)
    #dbg_value(i32 %stride1, !144, !DIExpression(), !152)
    #dbg_value(i32 %K, !145, !DIExpression(), !152)
    #dbg_value(ptr %A, !146, !DIExpression(), !152)
    #dbg_value(i32 %stride2, !147, !DIExpression(), !152)
    #dbg_value(i32 %stride3, !148, !DIExpression(), !152)
    #dbg_value(ptr %B, !149, !DIExpression(), !152)
    #dbg_value(i32 %stride4, !150, !DIExpression(), !152)
    #dbg_value(i32 %stride5, !151, !DIExpression(), !152)
    #dbg_declare(i32 0, !153, !DIExpression(), !152)
  %0 = icmp sgt i32 %M, 0, !dbg !152
  %1 = icmp sgt i32 %N, 0
  %or.cond = select i1 %0, i1 %1, i1 false, !dbg !152
  br i1 %or.cond, label %for_begin_ax1.preheader.lr.ph.split.us, label %for_end_ax0, !dbg !152, !prof !154

for_begin_ax1.preheader.lr.ph.split.us:           ; preds = %entry
  %2 = icmp sgt i32 %K, 0
  br i1 %2, label %for_begin_ax1.preheader.us.us.preheader, label %for_begin_ax1.preheader.us.preheader, !prof !155

for_begin_ax1.preheader.us.preheader:             ; preds = %for_begin_ax1.preheader.lr.ph.split.us
  %3 = sext i32 %stride1 to i64, !dbg !152
  %4 = sext i32 %stride to i64, !dbg !152
  %wide.trip.count19 = zext nneg i32 %M to i64, !dbg !152
  %wide.trip.count = zext nneg i32 %N to i64
  %min.iters.check = icmp ugt i32 %N, 7
  %ident.check.not = icmp eq i32 %stride1, 1
  %or.cond2 = select i1 %min.iters.check, i1 %ident.check.not, i1 false
  %n.vec = and i64 %wide.trip.count, 2147483640
  %cmp.n = icmp eq i64 %n.vec, %wide.trip.count
  %xtraiter = and i64 %wide.trip.count, 3
  %lcmp.mod.not = icmp eq i64 %xtraiter, 0
  br label %for_begin_ax1.preheader.us, !dbg !152

for_begin_ax1.preheader.us.us.preheader:          ; preds = %for_begin_ax1.preheader.lr.ph.split.us
  %5 = sext i32 %stride3 to i64, !dbg !152
  %6 = sext i32 %stride4 to i64, !dbg !152
  %7 = sext i32 %stride1 to i64, !dbg !152
  %8 = sext i32 %stride5 to i64, !dbg !152
  %9 = sext i32 %stride to i64, !dbg !152
  %10 = sext i32 %stride2 to i64, !dbg !152
  %wide.trip.count34 = zext nneg i32 %M to i64, !dbg !152
  %wide.trip.count29 = zext nneg i32 %N to i64
  %wide.trip.count24 = zext nneg i32 %K to i64
  %xtraiter4 = and i64 %wide.trip.count24, 1
  %11 = icmp eq i32 %K, 1
  %unroll_iter = and i64 %wide.trip.count24, 2147483646
  %lcmp.mod5.not = icmp eq i64 %xtraiter4, 0
  br label %for_begin_ax1.preheader.us.us, !dbg !152

for_begin_ax1.preheader.us.us:                    ; preds = %for_begin_ax1.preheader.us.us.preheader, %for_begin_ax1.for_end_ax1_crit_edge.split.us.us.us
  %indvars.iv31 = phi i64 [ 0, %for_begin_ax1.preheader.us.us.preheader ], [ %indvars.iv.next32, %for_begin_ax1.for_end_ax1_crit_edge.split.us.us.us ]
    #dbg_declare(i64 %indvars.iv31, !153, !DIExpression(), !152)
    #dbg_declare(i32 0, !156, !DIExpression(), !152)
  %12 = mul nsw i64 %indvars.iv31, %9
  %13 = mul nsw i64 %indvars.iv31, %10
  %invariant.gep41 = getelementptr float, ptr %T_matmul, i64 %12, !dbg !152
  %invariant.gep37 = getelementptr float, ptr %A, i64 %13
  br label %for_body_ax1.us.us.us, !dbg !152

for_body_ax1.us.us.us:                            ; preds = %for_begin_k.for_end_k_crit_edge.us.us.us, %for_begin_ax1.preheader.us.us
  %indvars.iv26 = phi i64 [ %indvars.iv.next27, %for_begin_k.for_end_k_crit_edge.us.us.us ], [ 0, %for_begin_ax1.preheader.us.us ]
    #dbg_declare(i64 %indvars.iv26, !156, !DIExpression(), !152)
  %14 = mul nsw i64 %indvars.iv26, %7, !dbg !152
  %gep42 = getelementptr float, ptr %invariant.gep41, i64 %14, !dbg !152
    #dbg_declare(i32 0, !157, !DIExpression(), !152)
  %15 = mul nsw i64 %indvars.iv26, %8
  %invariant.gep39 = getelementptr float, ptr %B, i64 %15, !dbg !152
  br i1 %11, label %for_begin_k.for_end_k_crit_edge.us.us.us.unr-lcssa, label %for_body_k.us.us.us, !dbg !152, !prof !158

for_body_k.us.us.us:                              ; preds = %for_body_ax1.us.us.us, %for_body_k.us.us.us
  %indvars.iv21 = phi i64 [ %indvars.iv.next22.1, %for_body_k.us.us.us ], [ 0, %for_body_ax1.us.us.us ], !dbg !152
  %16 = phi float [ %26, %for_body_k.us.us.us ], [ 0.000000e+00, %for_body_ax1.us.us.us ], !dbg !152
  %niter = phi i64 [ %niter.next.1, %for_body_k.us.us.us ], [ 0, %for_body_ax1.us.us.us ]
    #dbg_declare(i64 %indvars.iv21, !157, !DIExpression(), !152)
  %17 = mul nsw i64 %indvars.iv21, %5, !dbg !152
  %gep38 = getelementptr float, ptr %invariant.gep37, i64 %17, !dbg !152
  %18 = load float, ptr %gep38, align 4, !dbg !152, !tbaa !159
  %19 = mul nsw i64 %indvars.iv21, %6, !dbg !152
  %gep40 = getelementptr float, ptr %invariant.gep39, i64 %19, !dbg !152
  %20 = load float, ptr %gep40, align 4, !dbg !152, !tbaa !161
  %21 = tail call float @llvm.fmuladd.f32(float %18, float %20, float %16), !dbg !152
  %indvars.iv.next22 = or disjoint i64 %indvars.iv21, 1, !dbg !152
    #dbg_declare(i64 %indvars.iv.next22, !157, !DIExpression(), !152)
    #dbg_declare(i64 %indvars.iv.next22, !157, !DIExpression(), !152)
  %22 = mul nsw i64 %indvars.iv.next22, %5, !dbg !152
  %gep38.1 = getelementptr float, ptr %invariant.gep37, i64 %22, !dbg !152
  %23 = load float, ptr %gep38.1, align 4, !dbg !152, !tbaa !159
  %24 = mul nsw i64 %indvars.iv.next22, %6, !dbg !152
  %gep40.1 = getelementptr float, ptr %invariant.gep39, i64 %24, !dbg !152
  %25 = load float, ptr %gep40.1, align 4, !dbg !152, !tbaa !161
  %26 = tail call float @llvm.fmuladd.f32(float %23, float %25, float %21), !dbg !152
  %indvars.iv.next22.1 = add nuw nsw i64 %indvars.iv21, 2, !dbg !152
    #dbg_declare(i64 %indvars.iv.next22.1, !157, !DIExpression(), !152)
  %niter.next.1 = add i64 %niter, 2, !dbg !152
  %niter.ncmp.1 = icmp eq i64 %niter.next.1, %unroll_iter, !dbg !152
  br i1 %niter.ncmp.1, label %for_begin_k.for_end_k_crit_edge.us.us.us.unr-lcssa, label %for_body_k.us.us.us, !dbg !152, !prof !163

for_begin_k.for_end_k_crit_edge.us.us.us.unr-lcssa: ; preds = %for_body_k.us.us.us, %for_body_ax1.us.us.us
  %.lcssa.ph = phi float [ poison, %for_body_ax1.us.us.us ], [ %26, %for_body_k.us.us.us ]
  %indvars.iv21.unr = phi i64 [ 0, %for_body_ax1.us.us.us ], [ %indvars.iv.next22.1, %for_body_k.us.us.us ]
  %.unr = phi float [ 0.000000e+00, %for_body_ax1.us.us.us ], [ %26, %for_body_k.us.us.us ]
  br i1 %lcmp.mod5.not, label %for_begin_k.for_end_k_crit_edge.us.us.us, label %for_body_k.us.us.us.epil, !dbg !152, !prof !164

for_body_k.us.us.us.epil:                         ; preds = %for_begin_k.for_end_k_crit_edge.us.us.us.unr-lcssa
    #dbg_declare(i64 %indvars.iv21.unr, !157, !DIExpression(), !152)
  %27 = mul nsw i64 %indvars.iv21.unr, %5, !dbg !152
  %gep38.epil = getelementptr float, ptr %invariant.gep37, i64 %27, !dbg !152
  %28 = load float, ptr %gep38.epil, align 4, !dbg !152, !tbaa !159
  %29 = mul nsw i64 %indvars.iv21.unr, %6, !dbg !152
  %gep40.epil = getelementptr float, ptr %invariant.gep39, i64 %29, !dbg !152
  %30 = load float, ptr %gep40.epil, align 4, !dbg !152, !tbaa !161
  %31 = tail call float @llvm.fmuladd.f32(float %28, float %30, float %.unr), !dbg !152
    #dbg_declare(i64 %indvars.iv21.unr, !157, !DIExpression(DW_OP_plus_uconst, 1), !152)
  br label %for_begin_k.for_end_k_crit_edge.us.us.us, !dbg !152

for_begin_k.for_end_k_crit_edge.us.us.us:         ; preds = %for_begin_k.for_end_k_crit_edge.us.us.us.unr-lcssa, %for_body_k.us.us.us.epil
  %.lcssa = phi float [ %.lcssa.ph, %for_begin_k.for_end_k_crit_edge.us.us.us.unr-lcssa ], [ %31, %for_body_k.us.us.us.epil ], !dbg !152
  store float %.lcssa, ptr %gep42, align 4, !dbg !152, !tbaa !165
  %indvars.iv.next27 = add nuw nsw i64 %indvars.iv26, 1, !dbg !152
    #dbg_declare(i64 %indvars.iv.next27, !156, !DIExpression(), !152)
  %exitcond30.not = icmp eq i64 %indvars.iv.next27, %wide.trip.count29, !dbg !152
  br i1 %exitcond30.not, label %for_begin_ax1.for_end_ax1_crit_edge.split.us.us.us, label %for_body_ax1.us.us.us, !dbg !152, !prof !167

for_begin_ax1.for_end_ax1_crit_edge.split.us.us.us: ; preds = %for_begin_k.for_end_k_crit_edge.us.us.us
  %indvars.iv.next32 = add nuw nsw i64 %indvars.iv31, 1, !dbg !152
    #dbg_declare(i64 %indvars.iv.next32, !153, !DIExpression(), !152)
  %exitcond35.not = icmp eq i64 %indvars.iv.next32, %wide.trip.count34, !dbg !152
  br i1 %exitcond35.not, label %for_end_ax0, label %for_begin_ax1.preheader.us.us, !dbg !152, !prof !167

for_begin_ax1.preheader.us:                       ; preds = %for_begin_ax1.preheader.us.preheader, %for_begin_ax1.for_end_ax1_crit_edge.split.us11
  %indvars.iv16 = phi i64 [ 0, %for_begin_ax1.preheader.us.preheader ], [ %indvars.iv.next17, %for_begin_ax1.for_end_ax1_crit_edge.split.us11 ]
    #dbg_declare(i64 %indvars.iv16, !153, !DIExpression(), !152)
    #dbg_declare(i32 0, !156, !DIExpression(), !152)
  %32 = mul nsw i64 %indvars.iv16, %4
  %invariant.gep = getelementptr float, ptr %T_matmul, i64 %32, !dbg !152
  br i1 %or.cond2, label %vector.body, label %for_body_ax1.us9.preheader, !dbg !152, !prof !154

vector.body:                                      ; preds = %for_begin_ax1.preheader.us, %vector.body
  %index = phi i64 [ %index.next, %vector.body ], [ 0, %for_begin_ax1.preheader.us ], !dbg !152
  %33 = getelementptr float, ptr %invariant.gep, i64 %index, !dbg !152
  %34 = getelementptr i8, ptr %33, i64 16, !dbg !152
  store <4 x float> zeroinitializer, ptr %33, align 4, !dbg !152, !tbaa !165
  store <4 x float> zeroinitializer, ptr %34, align 4, !dbg !152, !tbaa !165
  %index.next = add nuw i64 %index, 8, !dbg !152
  %35 = icmp eq i64 %index.next, %n.vec, !dbg !152
  br i1 %35, label %middle.block, label %vector.body, !dbg !152, !prof !168, !llvm.loop !169

middle.block:                                     ; preds = %vector.body
  br i1 %cmp.n, label %for_begin_ax1.for_end_ax1_crit_edge.split.us11, label %for_body_ax1.us9.preheader, !dbg !152, !prof !172

for_body_ax1.us9.preheader:                       ; preds = %middle.block, %for_begin_ax1.preheader.us
  %indvars.iv.ph = phi i64 [ 0, %for_begin_ax1.preheader.us ], [ %n.vec, %middle.block ]
  br i1 %lcmp.mod.not, label %for_body_ax1.us9.prol.loopexit, label %for_body_ax1.us9.prol, !dbg !152, !prof !155

for_body_ax1.us9.prol:                            ; preds = %for_body_ax1.us9.preheader, %for_body_ax1.us9.prol
  %indvars.iv.prol = phi i64 [ %indvars.iv.next.prol, %for_body_ax1.us9.prol ], [ %indvars.iv.ph, %for_body_ax1.us9.preheader ]
  %prol.iter = phi i64 [ %prol.iter.next, %for_body_ax1.us9.prol ], [ 0, %for_body_ax1.us9.preheader ]
    #dbg_declare(i64 %indvars.iv.prol, !156, !DIExpression(), !152)
  %36 = mul nsw i64 %indvars.iv.prol, %3, !dbg !152
  %gep.prol = getelementptr float, ptr %invariant.gep, i64 %36, !dbg !152
  store float 0.000000e+00, ptr %gep.prol, align 4, !dbg !152, !tbaa !165
    #dbg_declare(i32 0, !157, !DIExpression(), !152)
  %indvars.iv.next.prol = add nuw nsw i64 %indvars.iv.prol, 1, !dbg !152
    #dbg_declare(i64 %indvars.iv.next.prol, !156, !DIExpression(), !152)
  %prol.iter.next = add i64 %prol.iter, 1, !dbg !152
  %prol.iter.cmp.not = icmp eq i64 %prol.iter.next, %xtraiter, !dbg !152
  br i1 %prol.iter.cmp.not, label %for_body_ax1.us9.prol.loopexit, label %for_body_ax1.us9.prol, !dbg !152, !prof !164, !llvm.loop !173

for_body_ax1.us9.prol.loopexit:                   ; preds = %for_body_ax1.us9.prol, %for_body_ax1.us9.preheader
  %indvars.iv.unr = phi i64 [ %indvars.iv.ph, %for_body_ax1.us9.preheader ], [ %indvars.iv.next.prol, %for_body_ax1.us9.prol ]
  %37 = sub nsw i64 %indvars.iv.ph, %wide.trip.count, !dbg !152
  %38 = icmp ugt i64 %37, -4, !dbg !152
  br i1 %38, label %for_begin_ax1.for_end_ax1_crit_edge.split.us11, label %for_body_ax1.us9, !dbg !152, !prof !158

for_body_ax1.us9:                                 ; preds = %for_body_ax1.us9.prol.loopexit, %for_body_ax1.us9
  %indvars.iv = phi i64 [ %indvars.iv.next.3, %for_body_ax1.us9 ], [ %indvars.iv.unr, %for_body_ax1.us9.prol.loopexit ]
    #dbg_declare(i64 %indvars.iv, !156, !DIExpression(), !152)
  %39 = mul nsw i64 %indvars.iv, %3, !dbg !152
  %gep = getelementptr float, ptr %invariant.gep, i64 %39, !dbg !152
  store float 0.000000e+00, ptr %gep, align 4, !dbg !152, !tbaa !165
    #dbg_declare(i32 0, !157, !DIExpression(), !152)
  %indvars.iv.next = add nuw nsw i64 %indvars.iv, 1, !dbg !152
    #dbg_declare(i64 %indvars.iv.next, !156, !DIExpression(), !152)
    #dbg_declare(i64 %indvars.iv.next, !156, !DIExpression(), !152)
  %40 = mul nsw i64 %indvars.iv.next, %3, !dbg !152
  %gep.1 = getelementptr float, ptr %invariant.gep, i64 %40, !dbg !152
  store float 0.000000e+00, ptr %gep.1, align 4, !dbg !152, !tbaa !165
    #dbg_declare(i32 0, !157, !DIExpression(), !152)
  %indvars.iv.next.1 = add nuw nsw i64 %indvars.iv, 2, !dbg !152
    #dbg_declare(i64 %indvars.iv.next.1, !156, !DIExpression(), !152)
    #dbg_declare(i64 %indvars.iv.next.1, !156, !DIExpression(), !152)
  %41 = mul nsw i64 %indvars.iv.next.1, %3, !dbg !152
  %gep.2 = getelementptr float, ptr %invariant.gep, i64 %41, !dbg !152
  store float 0.000000e+00, ptr %gep.2, align 4, !dbg !152, !tbaa !165
    #dbg_declare(i32 0, !157, !DIExpression(), !152)
  %indvars.iv.next.2 = add nuw nsw i64 %indvars.iv, 3, !dbg !152
    #dbg_declare(i64 %indvars.iv.next.2, !156, !DIExpression(), !152)
    #dbg_declare(i64 %indvars.iv.next.2, !156, !DIExpression(), !152)
  %42 = mul nsw i64 %indvars.iv.next.2, %3, !dbg !152
  %gep.3 = getelementptr float, ptr %invariant.gep, i64 %42, !dbg !152
  store float 0.000000e+00, ptr %gep.3, align 4, !dbg !152, !tbaa !165
    #dbg_declare(i32 0, !157, !DIExpression(), !152)
  %indvars.iv.next.3 = add nuw nsw i64 %indvars.iv, 4, !dbg !152
    #dbg_declare(i64 %indvars.iv.next.3, !156, !DIExpression(), !152)
  %exitcond.not.3 = icmp eq i64 %indvars.iv.next.3, %wide.trip.count, !dbg !152
  br i1 %exitcond.not.3, label %for_begin_ax1.for_end_ax1_crit_edge.split.us11, label %for_body_ax1.us9, !dbg !152, !prof !175, !llvm.loop !176

for_begin_ax1.for_end_ax1_crit_edge.split.us11:   ; preds = %for_body_ax1.us9.prol.loopexit, %for_body_ax1.us9, %middle.block
  %indvars.iv.next17 = add nuw nsw i64 %indvars.iv16, 1, !dbg !152
    #dbg_declare(i64 %indvars.iv.next17, !153, !DIExpression(), !152)
  %exitcond20.not = icmp eq i64 %indvars.iv.next17, %wide.trip.count19, !dbg !152
  br i1 %exitcond20.not, label %for_end_ax0, label %for_begin_ax1.preheader.us, !dbg !152, !prof !167

for_end_ax0:                                      ; preds = %for_begin_ax1.for_end_ax1_crit_edge.split.us11, %for_begin_ax1.for_end_ax1_crit_edge.split.us.us.us, %entry
  ret void, !dbg !152
}

; Function Attrs: mustprogress nocallback nofree nosync nounwind speculatable willreturn memory(none)
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
  %v10 = add nsw i32 %v5, -114687
  br label %b13

b3:                                               ; preds = %b1
  %v11 = icmp eq i32 %v8, 4096
  br i1 %v11, label %b4, label %b13

b4:                                               ; preds = %b3
  %v13 = and i32 %v5, 1
  %v14 = add nsw i32 %v7, %v13
  br label %b13

b5:                                               ; preds = %b0
  %v15 = icmp ugt i32 %v1, 2139095040
  br i1 %v15, label %b6, label %b7

b6:                                               ; preds = %b5
  %v16 = lshr i32 %v0, 13
  %v17 = and i32 %v16, 511
  %v18 = or disjoint i32 %v17, 32256
  br label %b13

b7:                                               ; preds = %b5
  %v19 = icmp ugt i32 %v1, 1199570943
  br i1 %v19, label %b13, label %b8

b8:                                               ; preds = %b7
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
  %v34 = add nuw nsw i32 %v30, 1
  br label %b13

b11:                                              ; preds = %b9
  %v35 = icmp eq i32 %v32, 4096
  br i1 %v35, label %b12, label %b13

b12:                                              ; preds = %b11
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
  %v5 = shl nuw nsw i32 %v2, 13
  %v6 = add nuw nsw i32 %v5, 939524096
  br label %b6

b2:                                               ; preds = %b0
  %v7 = icmp ugt i16 %v1, 31743
  br i1 %v7, label %b3, label %b4

b3:                                               ; preds = %b2
  %v8 = shl nuw nsw i32 %v2, 13
  %v9 = or i32 %v8, 2139095040
  br label %b6

b4:                                               ; preds = %b2
  %v10 = icmp eq i16 %v1, 0
  br i1 %v10, label %b6, label %b5

b5:                                               ; preds = %b4
  %v11 = icmp ult i16 %v1, 256
  %v12 = lshr i32 %v2, 8
  %v13 = select i1 %v11, i32 %v2, i32 %v12
  %v14 = select i1 %v11, i32 32, i32 24
  %v15 = icmp ult i32 %v13, 16
  %v16 = lshr i32 %v13, 4
  %v17 = add nsw i32 %v14, -4
  %v18 = select i1 %v15, i32 %v13, i32 %v16
  %v19 = select i1 %v15, i32 %v14, i32 %v17
  %v20 = icmp ult i32 %v18, 4
  %v21 = lshr i32 %v18, 2
  %v22 = add nsw i32 %v19, -2
  %v23 = select i1 %v20, i32 %v18, i32 %v21
  %v24 = select i1 %v20, i32 %v19, i32 %v22
  %v25 = icmp ult i32 %v23, 2
  %v26 = sub nsw i32 0, %v23
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
declare float @llvm.fabs.f32(float) #5

; Function Attrs: nocallback nofree nosync nounwind speculatable willreturn memory(none)
declare half @llvm.fabs.f16(half) #5

attributes #0 = { "target-cpu"="generic" }
attributes #1 = { mustprogress nocallback nofree nosync nounwind willreturn memory(inaccessiblemem: write) }
attributes #2 = { nofree noinline norecurse nosync nounwind memory(argmem: readwrite) "target-cpu"="generic" }
attributes #3 = { mustprogress nocallback nofree nosync nounwind speculatable willreturn memory(none) }
attributes #4 = { nofree nosync nounwind memory(none) "target-cpu"="generic" "target-features" }
attributes #5 = { nocallback nofree nosync nounwind speculatable willreturn memory(none) }

!llvm.dbg.cu = !{!0}
!llvm.module.flags = !{!2, !3, !4}

!0 = distinct !DICompileUnit(language: DW_LANG_C, file: !1, producer: "TVM", isOptimized: false, runtimeVersion: 0, emissionKind: FullDebug)
!1 = !DIFile(filename: "IRModule.CodeGenLLVM", directory: ".")
!2 = !{i32 2, !"tvm_target", !"llvm -mtriple=x86_64-unknown-linux-gnu"}
!3 = !{i32 4, !"Debug Info Version", i32 3}
!4 = !{i32 4, !"Dwarf Version", i32 4}
!5 = distinct !DISubprogram(name: "matmul", scope: !1, file: !1, type: !6, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !0, retainedNodes: !11)
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
!25 = !{!"0x5f597a0ce0f0.w4.b0", !26, i64 0}
!26 = !{!"0x5f597a0ce0f0.w8.b0", !27, i64 0}
!27 = !{!"0x5f597a0ce0f0.w16.b0", !28, i64 0}
!28 = !{!"0x5f597a0ce0f0.w32.b0", !29, i64 0}
!29 = !{!"0x5f597a0ce0f0.w64.b0", !30, i64 0}
!30 = !{!"0x5f597a0ce0f0.w128.b0", !31, i64 0}
!31 = !{!"0x5f597a0ce0f0.w256.b0", !32, i64 0}
!32 = !{!"0x5f597a0ce0f0.w512.b0", !33, i64 0}
!33 = !{!"0x5f597a0ce0f0.w1024.b0", !34, i64 0}
!34 = !{!"0x5f597a0ce0f0", !22, i64 0}
!35 = !DILocalVariable(name: "A.code", scope: !5, file: !1, type: !8)
!36 = !{!37, !37, i64 0}
!37 = !{!"0x5f597a0ce0f0.w4.b4", !26, i64 0}
!38 = !DILocalVariable(name: "B.code", scope: !5, file: !1, type: !8)
!39 = !{!40, !40, i64 0}
!40 = !{!"0x5f597a0ce0f0.w4.b8", !41, i64 0}
!41 = !{!"0x5f597a0ce0f0.w8.b8", !27, i64 0}
!42 = !DILocalVariable(name: "T_matmul.code", scope: !5, file: !1, type: !8)
!43 = !DILocalVariable(name: "A", scope: !5, file: !1, type: !9)
!44 = !DILocalVariable(name: "B", scope: !5, file: !1, type: !9)
!45 = !DILocalVariable(name: "T_matmul", scope: !5, file: !1, type: !9)
!46 = !DILocalVariable(name: "matmul.A.shape", scope: !5, file: !1, type: !47)
!47 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !48)
!48 = !DIBasicType(name: "int64", size: 64, encoding: DW_ATE_signed)
!49 = !{!50, !50, i64 0}
!50 = !{!"0x5f597a13d420.w8.b0", !51, i64 0}
!51 = !{!"0x5f597a13d420.w16.b0", !52, i64 0}
!52 = !{!"0x5f597a13d420.w32.b0", !53, i64 0}
!53 = !{!"0x5f597a13d420.w64.b0", !54, i64 0}
!54 = !{!"0x5f597a13d420.w128.b0", !55, i64 0}
!55 = !{!"0x5f597a13d420.w256.b0", !56, i64 0}
!56 = !{!"0x5f597a13d420.w512.b0", !57, i64 0}
!57 = !{!"0x5f597a13d420.w1024.b0", !58, i64 0}
!58 = !{!"0x5f597a13d420", !22, i64 0}
!59 = !DILocalVariable(name: "M", scope: !5, file: !1, type: !8)
!60 = !{!61, !61, i64 0}
!61 = !{!"0x5f597a13d420.w8.b8", !51, i64 0}
!62 = !DILocalVariable(name: "K", scope: !5, file: !1, type: !8)
!63 = !DILocalVariable(name: "matmul.A.strides", scope: !5, file: !1, type: !47)
!64 = !DILocalVariable(name: "stride", scope: !5, file: !1, type: !8)
!65 = !{!66, !66, i64 0}
!66 = !{!"0x5f597a166230.w8.b8", !67, i64 0}
!67 = !{!"0x5f597a166230.w16.b0", !68, i64 0}
!68 = !{!"0x5f597a166230.w32.b0", !69, i64 0}
!69 = !{!"0x5f597a166230.w64.b0", !70, i64 0}
!70 = !{!"0x5f597a166230.w128.b0", !71, i64 0}
!71 = !{!"0x5f597a166230.w256.b0", !72, i64 0}
!72 = !{!"0x5f597a166230.w512.b0", !73, i64 0}
!73 = !{!"0x5f597a166230.w1024.b0", !74, i64 0}
!74 = !{!"0x5f597a166230", !22, i64 0}
!75 = !DILocalVariable(name: "dev_id", scope: !5, file: !1, type: !8)
!76 = !DILocalVariable(name: "A", scope: !5, file: !1, type: !77)
!77 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !78)
!78 = !DIBasicType(name: "float32", size: 32, encoding: DW_ATE_float)
!79 = !{!80, !80, i64 0}
!80 = !{!"0x5f597a166230.w8.b0", !67, i64 0}
!81 = !DILocalVariable(name: "matmul.B.shape", scope: !5, file: !1, type: !47)
!82 = !{!83, !83, i64 0}
!83 = !{!"0x5f597a174950.w8.b8", !84, i64 0}
!84 = !{!"0x5f597a174950.w16.b0", !85, i64 0}
!85 = !{!"0x5f597a174950.w32.b0", !86, i64 0}
!86 = !{!"0x5f597a174950.w64.b0", !87, i64 0}
!87 = !{!"0x5f597a174950.w128.b0", !88, i64 0}
!88 = !{!"0x5f597a174950.w256.b0", !89, i64 0}
!89 = !{!"0x5f597a174950.w512.b0", !90, i64 0}
!90 = !{!"0x5f597a174950.w1024.b0", !91, i64 0}
!91 = !{!"0x5f597a174950", !22, i64 0}
!92 = !DILocalVariable(name: "N", scope: !5, file: !1, type: !8)
!93 = !DILocalVariable(name: "matmul.B.strides", scope: !5, file: !1, type: !47)
!94 = !{!95, !95, i64 0}
!95 = !{!"0x5f597a1755b0.w8.b8", !96, i64 0}
!96 = !{!"0x5f597a1755b0.w16.b0", !97, i64 0}
!97 = !{!"0x5f597a1755b0.w32.b0", !98, i64 0}
!98 = !{!"0x5f597a1755b0.w64.b0", !99, i64 0}
!99 = !{!"0x5f597a1755b0.w128.b0", !100, i64 0}
!100 = !{!"0x5f597a1755b0.w256.b0", !101, i64 0}
!101 = !{!"0x5f597a1755b0.w512.b0", !102, i64 0}
!102 = !{!"0x5f597a1755b0.w1024.b0", !103, i64 0}
!103 = !{!"0x5f597a1755b0", !22, i64 0}
!104 = !DILocalVariable(name: "B", scope: !5, file: !1, type: !77)
!105 = !{!106, !106, i64 0}
!106 = !{!"0x5f597a1755b0.w8.b0", !96, i64 0}
!107 = !DILocalVariable(name: "matmul.T_matmul.shape", scope: !5, file: !1, type: !47)
!108 = !DILocalVariable(name: "matmul.T_matmul.strides", scope: !5, file: !1, type: !47)
!109 = !{!110, !110, i64 0}
!110 = !{!"0x5f597a1779b0.w8.b8", !111, i64 0}
!111 = !{!"0x5f597a1779b0.w16.b0", !112, i64 0}
!112 = !{!"0x5f597a1779b0.w32.b0", !113, i64 0}
!113 = !{!"0x5f597a1779b0.w64.b0", !114, i64 0}
!114 = !{!"0x5f597a1779b0.w128.b0", !115, i64 0}
!115 = !{!"0x5f597a1779b0.w256.b0", !116, i64 0}
!116 = !{!"0x5f597a1779b0.w512.b0", !117, i64 0}
!117 = !{!"0x5f597a1779b0.w1024.b0", !118, i64 0}
!118 = !{!"0x5f597a1779b0", !22, i64 0}
!119 = !DILocalVariable(name: "T_matmul", scope: !5, file: !1, type: !77)
!120 = !{!121, !121, i64 0}
!121 = !{!"0x5f597a1779b0.w8.b0", !111, i64 0}
!122 = !{!123, !123, i64 0}
!123 = !{!"0x5f597a174950.w8.b0", !84, i64 0}
!124 = !{!125, !125, i64 0}
!125 = !{!"0x5f597a1775e0.w8.b0", !126, i64 0}
!126 = !{!"0x5f597a1775e0.w16.b0", !127, i64 0}
!127 = !{!"0x5f597a1775e0.w32.b0", !128, i64 0}
!128 = !{!"0x5f597a1775e0.w64.b0", !129, i64 0}
!129 = !{!"0x5f597a1775e0.w128.b0", !130, i64 0}
!130 = !{!"0x5f597a1775e0.w256.b0", !131, i64 0}
!131 = !{!"0x5f597a1775e0.w512.b0", !132, i64 0}
!132 = !{!"0x5f597a1775e0.w1024.b0", !133, i64 0}
!133 = !{!"0x5f597a1775e0", !22, i64 0}
!134 = !{!135, !135, i64 0}
!135 = !{!"0x5f597a1775e0.w8.b8", !126, i64 0}
!136 = distinct !DISubprogram(name: "matmul_compute_", scope: !1, file: !1, type: !137, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !0, retainedNodes: !139)
!137 = !DISubroutineType(cc: DW_CC_nocall, types: !138)
!138 = !{!8, !8, !8, !77, !8, !8, !8, !77, !8, !8, !77, !8, !8}
!139 = !{!140, !141, !142, !143, !144, !145, !146, !147, !148, !149, !150, !151}
!140 = !DILocalVariable(name: "M", arg: 1, scope: !136, file: !1, type: !8)
!141 = !DILocalVariable(name: "N", arg: 2, scope: !136, file: !1, type: !8)
!142 = !DILocalVariable(name: "T_matmul", arg: 3, scope: !136, file: !1, type: !77)
!143 = !DILocalVariable(name: "stride", arg: 4, scope: !136, file: !1, type: !8)
!144 = !DILocalVariable(name: "stride1", arg: 5, scope: !136, file: !1, type: !8)
!145 = !DILocalVariable(name: "K", arg: 6, scope: !136, file: !1, type: !8)
!146 = !DILocalVariable(name: "A", arg: 7, scope: !136, file: !1, type: !77)
!147 = !DILocalVariable(name: "stride2", arg: 8, scope: !136, file: !1, type: !8)
!148 = !DILocalVariable(name: "stride3", arg: 9, scope: !136, file: !1, type: !8)
!149 = !DILocalVariable(name: "B", arg: 10, scope: !136, file: !1, type: !77)
!150 = !DILocalVariable(name: "stride4", arg: 11, scope: !136, file: !1, type: !8)
!151 = !DILocalVariable(name: "stride5", arg: 12, scope: !136, file: !1, type: !8)
!152 = !DILocation(line: 0, scope: !136)
!153 = !DILocalVariable(name: "ax0", scope: !136, file: !1, type: !8)
!154 = !{!"branch_weights", i32 16129, i32 255}
!155 = !{!"branch_weights", i32 127, i32 1}
!156 = !DILocalVariable(name: "ax1", scope: !136, file: !1, type: !8)
!157 = !DILocalVariable(name: "k", scope: !136, file: !1, type: !8)
!158 = !{!"branch_weights", i32 1, i32 127}
!159 = !{!160, !160, i64 0}
!160 = !{!"0x5f597a05e700", !22, i64 0}
!161 = !{!162, !162, i64 0}
!162 = !{!"0x5f5979eb3350", !22, i64 0}
!163 = !{!"branch_weights", i32 127, i32 67108705}
!164 = !{!"branch_weights", i32 1, i32 1}
!165 = !{!166, !166, i64 0}
!166 = !{!"0x5f5979ebfd30", !22, i64 0}
!167 = !{!"branch_weights", i32 127, i32 134217601}
!168 = !{!"branch_weights", i32 127, i32 16777081}
!169 = distinct !{!169, !170, !171}
!170 = !{!"llvm.loop.isvectorized", i32 1}
!171 = !{!"llvm.loop.unroll.runtime.disable"}
!172 = !{!"branch_weights", i32 1, i32 7}
!173 = distinct !{!173, !174}
!174 = !{!"llvm.loop.unroll.disable"}
!175 = !{!"branch_weights", i32 0, i32 0}
!176 = distinct !{!176, !170}
