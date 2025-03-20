; ModuleID = './matmul_tvm.ll'
source_filename = "TVMMod"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-i128:128-f80:128-n8:16:32:64-S128"
target triple = "x86_64-unknown-linux-gnu"

module asm ".globl _ZSt21ios_base_library_initv"

%"class.std::basic_ostream" = type { ptr, %"class.std::basic_ios" }
%"class.std::basic_ios" = type { %"class.std::ios_base", ptr, i8, i8, ptr, ptr, ptr, ptr }
%"class.std::ios_base" = type { ptr, i64, i64, i32, i32, i32, ptr, %"struct.std::ios_base::_Words", [8 x %"struct.std::ios_base::_Words"], i32, ptr, %"class.std::locale" }
%"struct.std::ios_base::_Words" = type { ptr, i64 }
%"class.std::locale" = type { ptr }

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
@for_begin_k.for_end_k_crit_edge.us.us.us.unr-lcssa.loopexit_bbCounter = common global i64 0
@for_body_k.us.us.us.preheader_bbCounter = common global i64 0
@for_begin_ax1.for_end_ax1_crit_edge.split.us.us.us_bbCounter = common global i64 0
@for_begin_ax1.preheader.us.us_bbCounter = common global i64 0
@for_body_ax1.us.us.us_bbCounter = common global i64 0
@for_begin_k.for_end_k_crit_edge.us.us.us_bbCounter = common global i64 0
@for_begin_k.for_end_k_crit_edge.us.us.us.unr-lcssa_bbCounter = common global i64 0
@for_body_k.us.us.us_bbCounter = common global i64 0
@for_body_k.us.us.us.epil_bbCounter = common global i64 0
@entry_bbCounter = common global i64 0
@for_begin_ax1.preheader.lr.ph.split.us_bbCounter = common global i64 0
@for_begin_ax1.preheader.us.preheader_bbCounter = common global i64 0
@for_begin_ax1.preheader.us.us.preheader_bbCounter = common global i64 0
@for_begin_ax1.preheader.us_bbCounter = common global i64 0
@vector.body.preheader_bbCounter = common global i64 0
@vector.body_bbCounter = common global i64 0
@middle.block_bbCounter = common global i64 0
@for_body_ax1.us9.preheader_bbCounter = common global i64 0
@for_body_ax1.us9.prol.preheader_bbCounter = common global i64 0
@for_body_ax1.us9.prol_bbCounter = common global i64 0
@for_body_ax1.us9.prol.loopexit.loopexit_bbCounter = common global i64 0
@for_body_ax1.us9.prol.loopexit_bbCounter = common global i64 0
@for_body_ax1.us9.preheader1_bbCounter = common global i64 0
@for_body_ax1.us9_bbCounter = common global i64 0
@for_begin_ax1.for_end_ax1_crit_edge.split.us11.loopexit_bbCounter = common global i64 0
@for_begin_ax1.for_end_ax1_crit_edge.split.us11_bbCounter = common global i64 0
@for_end_ax0.loopexit_bbCounter = common global i64 0
@for_end_ax0.loopexit2_bbCounter = common global i64 0
@for_end_ax0_bbCounter = common global i64 0
@_ZSt4cout = external global %"class.std::basic_ostream", align 8
@0 = private unnamed_addr constant [39 x i8] c"for_begin_ax1.preheader.lr.ph.split.us\00", align 1
@1 = private unnamed_addr constant [40 x i8] c"for_begin_ax1.preheader.us.us.preheader\00", align 1
@2 = private unnamed_addr constant [6 x i8] c"entry\00", align 1
@3 = private unnamed_addr constant [60 x i8] c"for_begin_k.for_end_k_crit_edge.us.us.us.unr-lcssa.loopexit\00", align 1
@4 = private unnamed_addr constant [40 x i8] c"for_body_ax1.us9.prol.loopexit.loopexit\00", align 1
@5 = private unnamed_addr constant [30 x i8] c"for_body_k.us.us.us.preheader\00", align 1
@6 = private unnamed_addr constant [22 x i8] c"vector.body.preheader\00", align 1
@7 = private unnamed_addr constant [47 x i8] c"for_begin_ax1.for_end_ax1_crit_edge.split.us11\00", align 1
@8 = private unnamed_addr constant [51 x i8] c"for_begin_ax1.for_end_ax1_crit_edge.split.us.us.us\00", align 1
@9 = private unnamed_addr constant [12 x i8] c"for_end_ax0\00", align 1
@10 = private unnamed_addr constant [28 x i8] c"for_body_ax1.us9.preheader1\00", align 1
@11 = private unnamed_addr constant [21 x i8] c"for_end_ax0.loopexit\00", align 1
@12 = private unnamed_addr constant [56 x i8] c"for_begin_ax1.for_end_ax1_crit_edge.split.us11.loopexit\00", align 1
@13 = private unnamed_addr constant [32 x i8] c"for_body_ax1.us9.prol.preheader\00", align 1
@14 = private unnamed_addr constant [22 x i8] c"for_end_ax0.loopexit2\00", align 1
@15 = private unnamed_addr constant [30 x i8] c"for_begin_ax1.preheader.us.us\00", align 1
@16 = private unnamed_addr constant [37 x i8] c"for_begin_ax1.preheader.us.preheader\00", align 1
@17 = private unnamed_addr constant [27 x i8] c"for_begin_ax1.preheader.us\00", align 1
@18 = private unnamed_addr constant [22 x i8] c"for_body_ax1.us.us.us\00", align 1
@19 = private unnamed_addr constant [41 x i8] c"for_begin_k.for_end_k_crit_edge.us.us.us\00", align 1
@20 = private unnamed_addr constant [51 x i8] c"for_begin_k.for_end_k_crit_edge.us.us.us.unr-lcssa\00", align 1
@21 = private unnamed_addr constant [20 x i8] c"for_body_k.us.us.us\00", align 1
@22 = private unnamed_addr constant [31 x i8] c"for_body_ax1.us9.prol.loopexit\00", align 1
@23 = private unnamed_addr constant [22 x i8] c"for_body_ax1.us9.prol\00", align 1
@24 = private unnamed_addr constant [17 x i8] c"for_body_ax1.us9\00", align 1
@25 = private unnamed_addr constant [25 x i8] c"for_body_k.us.us.us.epil\00", align 1
@26 = private unnamed_addr constant [12 x i8] c"vector.body\00", align 1
@27 = private unnamed_addr constant [13 x i8] c"middle.block\00", align 1
@28 = private unnamed_addr constant [27 x i8] c"for_body_ax1.us9.preheader\00", align 1

define dllexport range(i32 -1, 1) i32 @matmul(ptr noalias readonly %args, ptr noalias readonly %arg_type_ids, i32 %num_args, ptr noalias nocapture readnone %out_ret_value, ptr noalias nocapture readnone %out_ret_tcode, ptr noalias nocapture readnone %resource_handle) local_unnamed_addr #0 !dbg !11 {
entry:
    #dbg_value(ptr %args, !18, !DIExpression(), !24)
    #dbg_value(ptr %arg_type_ids, !19, !DIExpression(), !24)
    #dbg_value(i32 %num_args, !20, !DIExpression(), !24)
    #dbg_value(ptr %out_ret_value, !21, !DIExpression(), !24)
    #dbg_value(ptr %out_ret_tcode, !22, !DIExpression(), !24)
    #dbg_value(ptr %resource_handle, !23, !DIExpression(), !24)
  %0 = icmp eq i32 %num_args, 3, !dbg !24
  br i1 %0, label %assert_end, label %assert_fail, !dbg !24, !prof !25

common.ret:                                       ; preds = %assert_end105, %assert_fail104, %assert_fail102, %assert_fail100, %assert_fail98, %assert_fail96, %assert_fail94, %assert_fail92, %assert_fail90, %assert_fail88, %assert_fail86, %assert_fail84, %assert_fail82, %assert_fail80, %assert_fail78, %assert_fail76, %assert_fail74, %assert_fail72, %assert_fail52, %assert_fail50, %assert_fail30, %assert_fail28, %assert_fail13, %assert_fail11, %assert_fail9, %assert_fail7, %assert_fail5, %assert_fail3, %assert_fail1, %assert_fail
  %common.ret.op = phi i32 [ -1, %assert_fail ], [ -1, %assert_fail1 ], [ -1, %assert_fail3 ], [ -1, %assert_fail5 ], [ -1, %assert_fail7 ], [ -1, %assert_fail9 ], [ -1, %assert_fail11 ], [ -1, %assert_fail13 ], [ -1, %assert_fail28 ], [ -1, %assert_fail30 ], [ -1, %assert_fail50 ], [ -1, %assert_fail52 ], [ -1, %assert_fail72 ], [ -1, %assert_fail74 ], [ -1, %assert_fail76 ], [ -1, %assert_fail78 ], [ -1, %assert_fail80 ], [ -1, %assert_fail82 ], [ -1, %assert_fail84 ], [ -1, %assert_fail86 ], [ -1, %assert_fail88 ], [ -1, %assert_fail90 ], [ -1, %assert_fail92 ], [ -1, %assert_fail94 ], [ -1, %assert_fail96 ], [ -1, %assert_fail98 ], [ -1, %assert_fail100 ], [ -1, %assert_fail102 ], [ -1, %assert_fail104 ], [ 0, %assert_end105 ]
  ret i32 %common.ret.op, !dbg !24

assert_fail:                                      ; preds = %entry
  %1 = load ptr, ptr @__TVMAPISetLastError, align 8, !dbg !24, !tbaa !26
  tail call void %1(ptr nonnull @.str), !dbg !24
  br label %common.ret, !dbg !24

assert_end:                                       ; preds = %entry
  %.not = icmp eq ptr %args, null, !dbg !24
  br i1 %.not, label %assert_fail1, label %assert_end2, !dbg !24, !prof !29

assert_fail1:                                     ; preds = %assert_end
  %2 = load ptr, ptr @__TVMAPISetLastError, align 8, !dbg !24, !tbaa !26
  tail call void %2(ptr nonnull @.str.1), !dbg !24
  br label %common.ret, !dbg !24

assert_end2:                                      ; preds = %assert_end
  %.not114 = icmp eq ptr %arg_type_ids, null, !dbg !24
  br i1 %.not114, label %assert_fail3, label %assert_end4, !dbg !24, !prof !29

assert_fail3:                                     ; preds = %assert_end2
  %3 = load ptr, ptr @__TVMAPISetLastError, align 8, !dbg !24, !tbaa !26
  tail call void %3(ptr nonnull @.str.2), !dbg !24
  br label %common.ret, !dbg !24

assert_end4:                                      ; preds = %assert_end2
  %A.code = load i32, ptr %arg_type_ids, align 4, !dbg !24, !tbaa !30
    #dbg_declare(i32 %A.code, !41, !DIExpression(), !24)
    #dbg_declare(i32 %A.code, !41, !DIExpression(), !24)
  switch i32 %A.code, label %assert_fail5 [
    i32 13, label %assert_end6
    i32 7, label %assert_end6
    i32 4, label %assert_end6
    i32 3, label %assert_end6
  ], !dbg !24

assert_fail5:                                     ; preds = %assert_end4
  %4 = load ptr, ptr @__TVMAPISetLastError, align 8, !dbg !24, !tbaa !26
  tail call void %4(ptr nonnull @.str.3), !dbg !24
  br label %common.ret, !dbg !24

assert_end6:                                      ; preds = %assert_end4, %assert_end4, %assert_end4, %assert_end4
  %5 = getelementptr inbounds i8, ptr %arg_type_ids, i64 4, !dbg !24
  %B.code = load i32, ptr %5, align 4, !dbg !24, !tbaa !42
    #dbg_declare(i32 %B.code, !44, !DIExpression(), !24)
    #dbg_declare(i32 %B.code, !44, !DIExpression(), !24)
  switch i32 %B.code, label %assert_fail7 [
    i32 13, label %assert_end8
    i32 7, label %assert_end8
    i32 4, label %assert_end8
    i32 3, label %assert_end8
  ], !dbg !24

assert_fail7:                                     ; preds = %assert_end6
  %6 = load ptr, ptr @__TVMAPISetLastError, align 8, !dbg !24, !tbaa !26
  tail call void %6(ptr nonnull @.str.4), !dbg !24
  br label %common.ret, !dbg !24

assert_end8:                                      ; preds = %assert_end6, %assert_end6, %assert_end6, %assert_end6
  %7 = getelementptr inbounds i8, ptr %arg_type_ids, i64 8, !dbg !24
  %T_matmul.code = load i32, ptr %7, align 4, !dbg !24, !tbaa !45
    #dbg_declare(i32 %T_matmul.code, !48, !DIExpression(), !24)
    #dbg_declare(i32 %T_matmul.code, !48, !DIExpression(), !24)
  switch i32 %T_matmul.code, label %assert_fail9 [
    i32 13, label %assert_end10
    i32 7, label %assert_end10
    i32 4, label %assert_end10
    i32 3, label %assert_end10
  ], !dbg !24

assert_fail9:                                     ; preds = %assert_end8
  %8 = load ptr, ptr @__TVMAPISetLastError, align 8, !dbg !24, !tbaa !26
  tail call void %8(ptr nonnull @.str.5), !dbg !24
  br label %common.ret, !dbg !24

assert_end10:                                     ; preds = %assert_end8, %assert_end8, %assert_end8, %assert_end8
  %A = load ptr, ptr %args, align 8, !dbg !24
    #dbg_declare(ptr %A, !49, !DIExpression(), !24)
    #dbg_declare(ptr %A, !49, !DIExpression(), !24)
  %9 = getelementptr inbounds i8, ptr %args, i64 8, !dbg !24
  %B = load ptr, ptr %9, align 8, !dbg !24
    #dbg_declare(ptr %B, !50, !DIExpression(), !24)
    #dbg_declare(ptr %B, !50, !DIExpression(), !24)
  %10 = getelementptr inbounds i8, ptr %args, i64 16, !dbg !24
  %T_matmul = load ptr, ptr %10, align 8, !dbg !24
    #dbg_declare(ptr %T_matmul, !51, !DIExpression(), !24)
    #dbg_declare(ptr %T_matmul, !51, !DIExpression(), !24)
  %.not115 = icmp eq ptr %A, null, !dbg !24
  br i1 %.not115, label %assert_fail11, label %assert_end12, !dbg !24, !prof !29

assert_fail11:                                    ; preds = %assert_end10
  %11 = load ptr, ptr @__TVMAPISetLastError, align 8, !dbg !24, !tbaa !26
  tail call void %11(ptr nonnull @.str.6), !dbg !24
  br label %common.ret, !dbg !24

assert_end12:                                     ; preds = %assert_end10
  %12 = getelementptr inbounds i8, ptr %A, i64 16, !dbg !24
  %13 = load i32, ptr %12, align 4, !dbg !24
  %14 = icmp eq i32 %13, 2, !dbg !24
  br i1 %14, label %assert_end14, label %assert_fail13, !dbg !24, !prof !25

assert_fail13:                                    ; preds = %assert_end12
  %15 = load ptr, ptr @__TVMAPISetLastError, align 8, !dbg !24, !tbaa !26
  tail call void %15(ptr nonnull @.str.7), !dbg !24
  br label %common.ret, !dbg !24

assert_end14:                                     ; preds = %assert_end12
  %16 = getelementptr inbounds i8, ptr %A, i64 24, !dbg !24
  %matmul.A.shape = load ptr, ptr %16, align 8, !dbg !24
    #dbg_declare(ptr %matmul.A.shape, !52, !DIExpression(), !24)
    #dbg_declare(ptr %matmul.A.shape, !52, !DIExpression(), !24)
  %17 = load i64, ptr %matmul.A.shape, align 8, !dbg !24, !tbaa !55
  %M = trunc i64 %17 to i32, !dbg !24
    #dbg_declare(i32 %M, !65, !DIExpression(), !24)
    #dbg_declare(i32 %M, !65, !DIExpression(), !24)
  %18 = getelementptr inbounds i8, ptr %matmul.A.shape, i64 8, !dbg !24
  %19 = load i64, ptr %18, align 8, !dbg !24, !tbaa !66
  %K = trunc i64 %19 to i32, !dbg !24
    #dbg_declare(i32 %K, !68, !DIExpression(), !24)
    #dbg_declare(i32 %K, !68, !DIExpression(), !24)
  %20 = getelementptr inbounds i8, ptr %A, i64 32, !dbg !24
  %matmul.A.strides = load ptr, ptr %20, align 8, !dbg !24
    #dbg_declare(ptr %matmul.A.strides, !69, !DIExpression(), !24)
    #dbg_declare(ptr %matmul.A.strides, !69, !DIExpression(), !24)
  %21 = icmp eq i32 %K, 1, !dbg !24
  br i1 %21, label %if_end, label %if_else, !dbg !24

if_else:                                          ; preds = %assert_end14
  %22 = icmp eq ptr %matmul.A.strides, null, !dbg !24
  br i1 %22, label %if_end.thread, label %if_else16, !dbg !24

if_end:                                           ; preds = %if_else16, %assert_end14
  %stride = phi i32 [ 0, %assert_end14 ], [ %27, %if_else16 ], !dbg !24
    #dbg_declare(i32 %stride, !70, !DIExpression(), !24)
    #dbg_declare(i32 %stride, !70, !DIExpression(), !24)
  %23 = icmp eq i32 %M, 1, !dbg !24
  br i1 %23, label %if_end20, label %if_else19, !dbg !24

if_end.thread:                                    ; preds = %if_else
    #dbg_declare(i32 1, !70, !DIExpression(), !24)
    #dbg_declare(i32 1, !70, !DIExpression(), !24)
  %24 = icmp eq i32 %M, 1, !dbg !24
  %spec.select130 = select i1 %24, i32 0, i32 %K, !dbg !24
  br label %if_end20, !dbg !24

if_else16:                                        ; preds = %if_else
  %25 = getelementptr inbounds i8, ptr %matmul.A.strides, i64 8, !dbg !24
  %26 = load i64, ptr %25, align 8, !dbg !24, !tbaa !71
  %27 = trunc i64 %26 to i32, !dbg !24
  br label %if_end, !dbg !24

if_else19:                                        ; preds = %if_end
  %28 = icmp eq ptr %matmul.A.strides, null, !dbg !24
  br i1 %28, label %if_end20, label %if_else22, !dbg !24

if_end20:                                         ; preds = %if_else22, %if_else19, %if_end.thread, %if_end
  %29 = phi i1 [ true, %if_end ], [ false, %if_else22 ], [ false, %if_else19 ], [ %24, %if_end.thread ]
  %stride120 = phi i32 [ %stride, %if_end ], [ %stride, %if_else22 ], [ %stride, %if_else19 ], [ 1, %if_end.thread ]
  %stride110 = phi i32 [ 0, %if_end ], [ %32, %if_else22 ], [ %K, %if_else19 ], [ %spec.select130, %if_end.thread ], !dbg !24
    #dbg_declare(i32 %stride110, !70, !DIExpression(), !24)
    #dbg_declare(i32 %stride110, !70, !DIExpression(), !24)
  %30 = getelementptr inbounds i8, ptr %A, i64 12, !dbg !24
  %dev_id = load i32, ptr %30, align 4, !dbg !24
    #dbg_declare(i32 %dev_id, !81, !DIExpression(), !24)
    #dbg_declare(i32 %dev_id, !81, !DIExpression(), !24)
  %A109 = load ptr, ptr %A, align 8, !dbg !24
    #dbg_declare(ptr %A109, !82, !DIExpression(), !24)
    #dbg_declare(ptr %A109, !82, !DIExpression(), !24)
  call void @llvm.assume(i1 true) [ "align"(ptr %A109, i64 64) ], !dbg !24
  %.not116 = icmp eq ptr %B, null, !dbg !24
  br i1 %.not116, label %assert_fail28, label %assert_end29, !dbg !24, !prof !29

if_else22:                                        ; preds = %if_else19
  %31 = load i64, ptr %matmul.A.strides, align 8, !dbg !24, !tbaa !85
  %32 = trunc i64 %31 to i32, !dbg !24
  br label %if_end20, !dbg !24

assert_fail28:                                    ; preds = %if_end20
  %33 = load ptr, ptr @__TVMAPISetLastError, align 8, !dbg !24, !tbaa !26
  tail call void %33(ptr nonnull @.str.8), !dbg !24
  br label %common.ret, !dbg !24

assert_end29:                                     ; preds = %if_end20
  %34 = getelementptr inbounds i8, ptr %B, i64 16, !dbg !24
  %35 = load i32, ptr %34, align 4, !dbg !24
  %36 = icmp eq i32 %35, 2, !dbg !24
  br i1 %36, label %assert_end31, label %assert_fail30, !dbg !24, !prof !25

assert_fail30:                                    ; preds = %assert_end29
  %37 = load ptr, ptr @__TVMAPISetLastError, align 8, !dbg !24, !tbaa !26
  tail call void %37(ptr nonnull @.str.9), !dbg !24
  br label %common.ret, !dbg !24

assert_end31:                                     ; preds = %assert_end29
  %38 = getelementptr inbounds i8, ptr %B, i64 24, !dbg !24
  %matmul.B.shape = load ptr, ptr %38, align 8, !dbg !24
    #dbg_declare(ptr %matmul.B.shape, !87, !DIExpression(), !24)
    #dbg_declare(ptr %matmul.B.shape, !87, !DIExpression(), !24)
  %39 = getelementptr inbounds i8, ptr %matmul.B.shape, i64 8, !dbg !24
  %40 = load i64, ptr %39, align 8, !dbg !24, !tbaa !88
  %N = trunc i64 %40 to i32, !dbg !24
    #dbg_declare(i32 %N, !98, !DIExpression(), !24)
    #dbg_declare(i32 %N, !98, !DIExpression(), !24)
  %41 = getelementptr inbounds i8, ptr %B, i64 32, !dbg !24
  %matmul.B.strides = load ptr, ptr %41, align 8, !dbg !24
    #dbg_declare(ptr %matmul.B.strides, !99, !DIExpression(), !24)
    #dbg_declare(ptr %matmul.B.strides, !99, !DIExpression(), !24)
  %42 = icmp eq i32 %N, 1, !dbg !24
  br i1 %42, label %if_end34, label %if_else33, !dbg !24

if_else33:                                        ; preds = %assert_end31
  %43 = icmp eq ptr %matmul.B.strides, null, !dbg !24
  br i1 %43, label %if_end34.thread, label %if_else36, !dbg !24

if_end34:                                         ; preds = %if_else36, %assert_end31
  %stride113 = phi i32 [ 0, %assert_end31 ], [ %46, %if_else36 ], !dbg !24
    #dbg_declare(i32 %stride113, !70, !DIExpression(), !24)
    #dbg_declare(i32 %stride113, !70, !DIExpression(), !24)
  br i1 %21, label %if_end42, label %if_else41, !dbg !24

if_end34.thread:                                  ; preds = %if_else33
    #dbg_declare(i32 1, !70, !DIExpression(), !24)
    #dbg_declare(i32 1, !70, !DIExpression(), !24)
  %spec.select131 = select i1 %21, i32 0, i32 %N, !dbg !24
  br label %if_end42, !dbg !24

if_else36:                                        ; preds = %if_else33
  %44 = getelementptr inbounds i8, ptr %matmul.B.strides, i64 8, !dbg !24
  %45 = load i64, ptr %44, align 8, !dbg !24, !tbaa !100
  %46 = trunc i64 %45 to i32, !dbg !24
  br label %if_end34, !dbg !24

if_else41:                                        ; preds = %if_end34
  %47 = icmp eq ptr %matmul.B.strides, null, !dbg !24
  br i1 %47, label %if_end42, label %if_else44, !dbg !24

if_end42:                                         ; preds = %if_else44, %if_else41, %if_end34.thread, %if_end34
  %stride113124 = phi i32 [ %stride113, %if_end34 ], [ %stride113, %if_else44 ], [ %stride113, %if_else41 ], [ 1, %if_end34.thread ]
  %stride112 = phi i32 [ 0, %if_end34 ], [ %49, %if_else44 ], [ %N, %if_else41 ], [ %spec.select131, %if_end34.thread ], !dbg !24
    #dbg_declare(i32 %stride112, !70, !DIExpression(), !24)
    #dbg_declare(i32 %stride112, !70, !DIExpression(), !24)
  %B111 = load ptr, ptr %B, align 8, !dbg !24
    #dbg_declare(ptr %B111, !110, !DIExpression(), !24)
    #dbg_declare(ptr %B111, !110, !DIExpression(), !24)
  call void @llvm.assume(i1 true) [ "align"(ptr %B111, i64 64) ], !dbg !24
  %.not117 = icmp eq ptr %T_matmul, null, !dbg !24
  br i1 %.not117, label %assert_fail50, label %assert_end51, !dbg !24, !prof !29

if_else44:                                        ; preds = %if_else41
  %48 = load i64, ptr %matmul.B.strides, align 8, !dbg !24, !tbaa !111
  %49 = trunc i64 %48 to i32, !dbg !24
  br label %if_end42, !dbg !24

assert_fail50:                                    ; preds = %if_end42
  %50 = load ptr, ptr @__TVMAPISetLastError, align 8, !dbg !24, !tbaa !26
  tail call void %50(ptr nonnull @.str.10), !dbg !24
  br label %common.ret, !dbg !24

assert_end51:                                     ; preds = %if_end42
  %51 = getelementptr inbounds i8, ptr %T_matmul, i64 16, !dbg !24
  %52 = load i32, ptr %51, align 4, !dbg !24
  %53 = icmp eq i32 %52, 2, !dbg !24
  br i1 %53, label %assert_end53, label %assert_fail52, !dbg !24, !prof !25

assert_fail52:                                    ; preds = %assert_end51
  %54 = load ptr, ptr @__TVMAPISetLastError, align 8, !dbg !24, !tbaa !26
  tail call void %54(ptr nonnull @.str.11), !dbg !24
  br label %common.ret, !dbg !24

assert_end53:                                     ; preds = %assert_end51
  %55 = getelementptr inbounds i8, ptr %T_matmul, i64 24, !dbg !24
  %matmul.T_matmul.shape = load ptr, ptr %55, align 8, !dbg !24
    #dbg_declare(ptr %matmul.T_matmul.shape, !113, !DIExpression(), !24)
    #dbg_declare(ptr %matmul.T_matmul.shape, !113, !DIExpression(), !24)
  %56 = getelementptr inbounds i8, ptr %T_matmul, i64 32, !dbg !24
  %matmul.T_matmul.strides = load ptr, ptr %56, align 8, !dbg !24
    #dbg_declare(ptr %matmul.T_matmul.strides, !114, !DIExpression(), !24)
    #dbg_declare(ptr %matmul.T_matmul.strides, !114, !DIExpression(), !24)
  br i1 %42, label %if_end56, label %if_else55, !dbg !24

if_else55:                                        ; preds = %assert_end53
  %57 = icmp eq ptr %matmul.T_matmul.strides, null, !dbg !24
  br i1 %57, label %if_end56.thread, label %if_else58, !dbg !24

if_end56:                                         ; preds = %if_else58, %assert_end53
  %stride108 = phi i32 [ 0, %assert_end53 ], [ %60, %if_else58 ], !dbg !24
    #dbg_declare(i32 %stride108, !70, !DIExpression(), !24)
    #dbg_declare(i32 %stride108, !70, !DIExpression(), !24)
  br i1 %29, label %if_end64, label %if_else63, !dbg !24

if_end56.thread:                                  ; preds = %if_else55
    #dbg_declare(i32 1, !70, !DIExpression(), !24)
    #dbg_declare(i32 1, !70, !DIExpression(), !24)
  %spec.select132 = select i1 %29, i32 0, i32 %N, !dbg !24
  br label %if_end64, !dbg !24

if_else58:                                        ; preds = %if_else55
  %58 = getelementptr inbounds i8, ptr %matmul.T_matmul.strides, i64 8, !dbg !24
  %59 = load i64, ptr %58, align 8, !dbg !24, !tbaa !115
  %60 = trunc i64 %59 to i32, !dbg !24
  br label %if_end56, !dbg !24

if_else63:                                        ; preds = %if_end56
  %61 = icmp eq ptr %matmul.T_matmul.strides, null, !dbg !24
  br i1 %61, label %if_end64, label %if_else66, !dbg !24

if_end64:                                         ; preds = %if_else66, %if_else63, %if_end56.thread, %if_end56
  %stride108128 = phi i32 [ %stride108, %if_end56 ], [ %stride108, %if_else66 ], [ %stride108, %if_else63 ], [ 1, %if_end56.thread ]
  %stride107 = phi i32 [ 0, %if_end56 ], [ %74, %if_else66 ], [ %N, %if_else63 ], [ %spec.select132, %if_end56.thread ], !dbg !24
    #dbg_declare(i32 %stride107, !70, !DIExpression(), !24)
    #dbg_declare(i32 %stride107, !70, !DIExpression(), !24)
  %T_matmul106 = load ptr, ptr %T_matmul, align 8, !dbg !24
    #dbg_declare(ptr %T_matmul106, !125, !DIExpression(), !24)
    #dbg_declare(ptr %T_matmul106, !125, !DIExpression(), !24)
  call void @llvm.assume(i1 true) [ "align"(ptr %T_matmul106, i64 64) ], !dbg !24
  %62 = getelementptr inbounds i8, ptr %A, i64 22, !dbg !24
  %63 = load i16, ptr %62, align 2, !dbg !24
  %64 = icmp eq i16 %63, 1, !dbg !24
  %65 = getelementptr inbounds i8, ptr %A, i64 21, !dbg !24
  %66 = load i8, ptr %65, align 1, !dbg !24
  %67 = icmp eq i8 %66, 32, !dbg !24
  %68 = getelementptr inbounds i8, ptr %A, i64 20, !dbg !24
  %69 = load i8, ptr %68, align 1, !dbg !24
  %70 = icmp eq i8 %69, 2, !dbg !24
  %71 = and i1 %67, %70, !dbg !24
  %72 = and i1 %64, %71, !dbg !24
  br i1 %72, label %assert_end73, label %assert_fail72, !dbg !24, !prof !25

if_else66:                                        ; preds = %if_else63
  %73 = load i64, ptr %matmul.T_matmul.strides, align 8, !dbg !24, !tbaa !126
  %74 = trunc i64 %73 to i32, !dbg !24
  br label %if_end64, !dbg !24

assert_fail72:                                    ; preds = %if_end64
  %75 = load ptr, ptr @__TVMAPISetLastError, align 8, !dbg !24, !tbaa !26
  tail call void %75(ptr nonnull @.str.12), !dbg !24
  br label %common.ret, !dbg !24

assert_end73:                                     ; preds = %if_end64
  %76 = getelementptr inbounds i8, ptr %A, i64 40, !dbg !24
  %77 = load i64, ptr %76, align 8, !dbg !24
  %78 = icmp eq i64 %77, 0, !dbg !24
  br i1 %78, label %assert_end75, label %assert_fail74, !dbg !24, !prof !25

assert_fail74:                                    ; preds = %assert_end73
  %79 = load ptr, ptr @__TVMAPISetLastError, align 8, !dbg !24, !tbaa !26
  tail call void %79(ptr nonnull @.str.13), !dbg !24
  br label %common.ret, !dbg !24

assert_end75:                                     ; preds = %assert_end73
  %80 = getelementptr inbounds i8, ptr %A, i64 8, !dbg !24
  %81 = load i32, ptr %80, align 4, !dbg !24
  %82 = icmp eq i32 %81, 1, !dbg !24
  br i1 %82, label %assert_end77, label %assert_fail76, !dbg !24, !prof !25

assert_fail76:                                    ; preds = %assert_end75
  %83 = load ptr, ptr @__TVMAPISetLastError, align 8, !dbg !24, !tbaa !26
  tail call void %83(ptr nonnull @.str.14), !dbg !24
  br label %common.ret, !dbg !24

assert_end77:                                     ; preds = %assert_end75
  %84 = icmp ne ptr %A109, null, !dbg !24
  %85 = mul nsw i32 %K, %M, !dbg !24
  %86 = icmp eq i32 %85, 0, !dbg !24
  %87 = or i1 %86, %84, !dbg !24
  br i1 %87, label %assert_end79, label %assert_fail78, !dbg !24, !prof !25

assert_fail78:                                    ; preds = %assert_end77
  %88 = load ptr, ptr @__TVMAPISetLastError, align 8, !dbg !24, !tbaa !26
  tail call void %88(ptr nonnull @.str.15), !dbg !24
  br label %common.ret, !dbg !24

assert_end79:                                     ; preds = %assert_end77
  %89 = getelementptr inbounds i8, ptr %B, i64 22, !dbg !24
  %90 = load i16, ptr %89, align 2, !dbg !24
  %91 = icmp eq i16 %90, 1, !dbg !24
  %92 = getelementptr inbounds i8, ptr %B, i64 21, !dbg !24
  %93 = load i8, ptr %92, align 1, !dbg !24
  %94 = icmp eq i8 %93, 32, !dbg !24
  %95 = getelementptr inbounds i8, ptr %B, i64 20, !dbg !24
  %96 = load i8, ptr %95, align 1, !dbg !24
  %97 = icmp eq i8 %96, 2, !dbg !24
  %98 = and i1 %94, %97, !dbg !24
  %99 = and i1 %91, %98, !dbg !24
  br i1 %99, label %assert_end81, label %assert_fail80, !dbg !24, !prof !25

assert_fail80:                                    ; preds = %assert_end79
  %100 = load ptr, ptr @__TVMAPISetLastError, align 8, !dbg !24, !tbaa !26
  tail call void %100(ptr nonnull @.str.16), !dbg !24
  br label %common.ret, !dbg !24

assert_end81:                                     ; preds = %assert_end79
  %101 = load i64, ptr %matmul.B.shape, align 8, !dbg !24, !tbaa !128
  %102 = trunc i64 %101 to i32, !dbg !24
  %103 = icmp eq i32 %K, %102, !dbg !24
  br i1 %103, label %assert_end83, label %assert_fail82, !dbg !24, !prof !25

assert_fail82:                                    ; preds = %assert_end81
  %104 = load ptr, ptr @__TVMAPISetLastError, align 8, !dbg !24, !tbaa !26
  tail call void %104(ptr nonnull @.str.17), !dbg !24
  br label %common.ret, !dbg !24

assert_end83:                                     ; preds = %assert_end81
  %105 = getelementptr inbounds i8, ptr %B, i64 40, !dbg !24
  %106 = load i64, ptr %105, align 8, !dbg !24
  %107 = icmp eq i64 %106, 0, !dbg !24
  br i1 %107, label %assert_end85, label %assert_fail84, !dbg !24, !prof !25

assert_fail84:                                    ; preds = %assert_end83
  %108 = load ptr, ptr @__TVMAPISetLastError, align 8, !dbg !24, !tbaa !26
  tail call void %108(ptr nonnull @.str.18), !dbg !24
  br label %common.ret, !dbg !24

assert_end85:                                     ; preds = %assert_end83
  %109 = getelementptr inbounds i8, ptr %B, i64 8, !dbg !24
  %110 = load i32, ptr %109, align 4, !dbg !24
  %111 = icmp eq i32 %110, 1, !dbg !24
  br i1 %111, label %assert_end87, label %assert_fail86, !dbg !24, !prof !25

assert_fail86:                                    ; preds = %assert_end85
  %112 = load ptr, ptr @__TVMAPISetLastError, align 8, !dbg !24, !tbaa !26
  tail call void %112(ptr nonnull @.str.19), !dbg !24
  br label %common.ret, !dbg !24

assert_end87:                                     ; preds = %assert_end85
  %113 = getelementptr inbounds i8, ptr %B, i64 12, !dbg !24
  %114 = load i32, ptr %113, align 4, !dbg !24
  %115 = icmp eq i32 %dev_id, %114, !dbg !24
  br i1 %115, label %assert_end89, label %assert_fail88, !dbg !24, !prof !25

assert_fail88:                                    ; preds = %assert_end87
  %116 = load ptr, ptr @__TVMAPISetLastError, align 8, !dbg !24, !tbaa !26
  tail call void %116(ptr nonnull @.str.20), !dbg !24
  br label %common.ret, !dbg !24

assert_end89:                                     ; preds = %assert_end87
  %117 = icmp ne ptr %B111, null, !dbg !24
  %118 = mul nsw i32 %N, %K, !dbg !24
  %119 = icmp eq i32 %118, 0, !dbg !24
  %120 = or i1 %119, %117, !dbg !24
  br i1 %120, label %assert_end91, label %assert_fail90, !dbg !24, !prof !25

assert_fail90:                                    ; preds = %assert_end89
  %121 = load ptr, ptr @__TVMAPISetLastError, align 8, !dbg !24, !tbaa !26
  tail call void %121(ptr nonnull @.str.21), !dbg !24
  br label %common.ret, !dbg !24

assert_end91:                                     ; preds = %assert_end89
  %122 = getelementptr inbounds i8, ptr %T_matmul, i64 22, !dbg !24
  %123 = load i16, ptr %122, align 2, !dbg !24
  %124 = icmp eq i16 %123, 1, !dbg !24
  %125 = getelementptr inbounds i8, ptr %T_matmul, i64 21, !dbg !24
  %126 = load i8, ptr %125, align 1, !dbg !24
  %127 = icmp eq i8 %126, 32, !dbg !24
  %128 = getelementptr inbounds i8, ptr %T_matmul, i64 20, !dbg !24
  %129 = load i8, ptr %128, align 1, !dbg !24
  %130 = icmp eq i8 %129, 2, !dbg !24
  %131 = and i1 %127, %130, !dbg !24
  %132 = and i1 %124, %131, !dbg !24
  br i1 %132, label %assert_end93, label %assert_fail92, !dbg !24, !prof !25

assert_fail92:                                    ; preds = %assert_end91
  %133 = load ptr, ptr @__TVMAPISetLastError, align 8, !dbg !24, !tbaa !26
  tail call void %133(ptr nonnull @.str.22), !dbg !24
  br label %common.ret, !dbg !24

assert_end93:                                     ; preds = %assert_end91
  %134 = load i64, ptr %matmul.T_matmul.shape, align 8, !dbg !24, !tbaa !130
  %135 = trunc i64 %134 to i32, !dbg !24
  %136 = icmp eq i32 %M, %135, !dbg !24
  br i1 %136, label %assert_end95, label %assert_fail94, !dbg !24, !prof !25

assert_fail94:                                    ; preds = %assert_end93
  %137 = load ptr, ptr @__TVMAPISetLastError, align 8, !dbg !24, !tbaa !26
  tail call void %137(ptr nonnull @.str.23), !dbg !24
  br label %common.ret, !dbg !24

assert_end95:                                     ; preds = %assert_end93
  %138 = getelementptr inbounds i8, ptr %matmul.T_matmul.shape, i64 8, !dbg !24
  %139 = load i64, ptr %138, align 8, !dbg !24, !tbaa !140
  %140 = trunc i64 %139 to i32, !dbg !24
  %141 = icmp eq i32 %N, %140, !dbg !24
  br i1 %141, label %assert_end97, label %assert_fail96, !dbg !24, !prof !25

assert_fail96:                                    ; preds = %assert_end95
  %142 = load ptr, ptr @__TVMAPISetLastError, align 8, !dbg !24, !tbaa !26
  tail call void %142(ptr nonnull @.str.24), !dbg !24
  br label %common.ret, !dbg !24

assert_end97:                                     ; preds = %assert_end95
  %143 = getelementptr inbounds i8, ptr %T_matmul, i64 40, !dbg !24
  %144 = load i64, ptr %143, align 8, !dbg !24
  %145 = icmp eq i64 %144, 0, !dbg !24
  br i1 %145, label %assert_end99, label %assert_fail98, !dbg !24, !prof !25

assert_fail98:                                    ; preds = %assert_end97
  %146 = load ptr, ptr @__TVMAPISetLastError, align 8, !dbg !24, !tbaa !26
  tail call void %146(ptr nonnull @.str.25), !dbg !24
  br label %common.ret, !dbg !24

assert_end99:                                     ; preds = %assert_end97
  %147 = getelementptr inbounds i8, ptr %T_matmul, i64 8, !dbg !24
  %148 = load i32, ptr %147, align 4, !dbg !24
  %149 = icmp eq i32 %148, 1, !dbg !24
  br i1 %149, label %assert_end101, label %assert_fail100, !dbg !24, !prof !25

assert_fail100:                                   ; preds = %assert_end99
  %150 = load ptr, ptr @__TVMAPISetLastError, align 8, !dbg !24, !tbaa !26
  tail call void %150(ptr nonnull @.str.26), !dbg !24
  br label %common.ret, !dbg !24

assert_end101:                                    ; preds = %assert_end99
  %151 = getelementptr inbounds i8, ptr %T_matmul, i64 12, !dbg !24
  %152 = load i32, ptr %151, align 4, !dbg !24
  %153 = icmp eq i32 %dev_id, %152, !dbg !24
  br i1 %153, label %assert_end103, label %assert_fail102, !dbg !24, !prof !25

assert_fail102:                                   ; preds = %assert_end101
  %154 = load ptr, ptr @__TVMAPISetLastError, align 8, !dbg !24, !tbaa !26
  tail call void %154(ptr nonnull @.str.27), !dbg !24
  br label %common.ret, !dbg !24

assert_end103:                                    ; preds = %assert_end101
  %155 = icmp ne ptr %T_matmul106, null, !dbg !24
  %156 = mul nsw i32 %N, %M, !dbg !24
  %157 = icmp eq i32 %156, 0, !dbg !24
  %158 = or i1 %157, %155, !dbg !24
  br i1 %158, label %assert_end105, label %assert_fail104, !dbg !24, !prof !25

assert_fail104:                                   ; preds = %assert_end103
  %159 = load ptr, ptr @__TVMAPISetLastError, align 8, !dbg !24, !tbaa !26
  tail call void %159(ptr nonnull @.str.28), !dbg !24
  br label %common.ret, !dbg !24

assert_end105:                                    ; preds = %assert_end103
  tail call fastcc void @matmul_compute_(i32 %M, i32 %N, ptr %T_matmul106, i32 %stride107, i32 %stride108128, i32 %K, ptr %A109, i32 %stride110, i32 %stride120, ptr %B111, i32 %stride112, i32 %stride113124), !dbg !24
  br label %common.ret, !dbg !24
}

; Function Attrs: nocallback nofree nosync nounwind willreturn memory(inaccessiblemem: write)
declare void @llvm.assume(i1 noundef) #1

; Function Attrs: nofree noinline norecurse nosync nounwind memory(argmem: readwrite)
define fastcc void @matmul_compute_(i32 %M, i32 %N, ptr noalias nocapture writeonly align 64 %T_matmul, i32 %stride, i32 %stride1, i32 %K, ptr noalias nocapture readonly align 64 %A, i32 %stride2, i32 %stride3, ptr noalias nocapture readonly align 64 %B, i32 %stride4, i32 %stride5) unnamed_addr #2 !dbg !142 {
entry:
    #dbg_value(i32 %M, !146, !DIExpression(), !158)
    #dbg_value(i32 %N, !147, !DIExpression(), !158)
    #dbg_value(ptr %T_matmul, !148, !DIExpression(), !158)
    #dbg_value(i32 %stride, !149, !DIExpression(), !158)
    #dbg_value(i32 %stride1, !150, !DIExpression(), !158)
    #dbg_value(i32 %K, !151, !DIExpression(), !158)
    #dbg_value(ptr %A, !152, !DIExpression(), !158)
    #dbg_value(i32 %stride2, !153, !DIExpression(), !158)
    #dbg_value(i32 %stride3, !154, !DIExpression(), !158)
    #dbg_value(ptr %B, !155, !DIExpression(), !158)
    #dbg_value(i32 %stride4, !156, !DIExpression(), !158)
    #dbg_value(i32 %stride5, !157, !DIExpression(), !158)
    #dbg_declare(i32 0, !159, !DIExpression(), !158)
  %0 = icmp sgt i32 %M, 0, !dbg !158
  %1 = icmp sgt i32 %N, 0
  %or.cond = select i1 %0, i1 %1, i1 false, !dbg !158
  %old.bb.count19 = load i64, ptr @entry_bbCounter, align 8
  %new.bb.count20 = add i64 %old.bb.count19, 1
  store i64 %new.bb.count20, ptr @entry_bbCounter, align 8
  br i1 %or.cond, label %for_begin_ax1.preheader.lr.ph.split.us, label %for_end_ax0, !dbg !158, !prof !160

for_begin_ax1.preheader.lr.ph.split.us:           ; preds = %entry
  %2 = icmp sgt i32 %K, 0
  %old.bb.count21 = load i64, ptr @for_begin_ax1.preheader.lr.ph.split.us_bbCounter, align 8
  %new.bb.count22 = add i64 %old.bb.count21, 1
  store i64 %new.bb.count22, ptr @for_begin_ax1.preheader.lr.ph.split.us_bbCounter, align 8
  br i1 %2, label %for_begin_ax1.preheader.us.us.preheader, label %for_begin_ax1.preheader.us.preheader, !prof !161

for_begin_ax1.preheader.us.preheader:             ; preds = %for_begin_ax1.preheader.lr.ph.split.us
  %wide.trip.count19 = zext nneg i32 %M to i64, !dbg !158
  %wide.trip.count = zext nneg i32 %N to i64
  %min.iters.check = icmp ugt i32 %N, 7
  %ident.check.not = icmp eq i32 %stride1, 1
  %or.cond2 = select i1 %min.iters.check, i1 %ident.check.not, i1 false
  %n.vec = and i64 %wide.trip.count, 2147483640
  %cmp.n = icmp eq i64 %n.vec, %wide.trip.count
  %xtraiter = and i64 %wide.trip.count, 3
  %lcmp.mod.not = icmp eq i64 %xtraiter, 0
  %old.bb.count23 = load i64, ptr @for_begin_ax1.preheader.us.preheader_bbCounter, align 8
  %new.bb.count24 = add i64 %old.bb.count23, 1
  store i64 %new.bb.count24, ptr @for_begin_ax1.preheader.us.preheader_bbCounter, align 8
  br label %for_begin_ax1.preheader.us, !dbg !158

for_begin_ax1.preheader.us.us.preheader:          ; preds = %for_begin_ax1.preheader.lr.ph.split.us
  %wide.trip.count34 = zext i32 %M to i64, !dbg !158
  %wide.trip.count29 = zext i32 %N to i64
  %wide.trip.count24 = zext nneg i32 %K to i64
  %xtraiter4 = and i64 %wide.trip.count24, 1
  %3 = icmp eq i32 %K, 1
  %unroll_iter = and i64 %wide.trip.count24, 2147483646
  %lcmp.mod5.not = icmp eq i64 %xtraiter4, 0
  %4 = mul i64 %wide.trip.count29, %wide.trip.count34, !dbg !158
  %5 = add nsw i64 %unroll_iter, -2, !dbg !158
  %6 = lshr i64 %5, 1, !dbg !158
  %7 = add nuw i64 %6, 1, !dbg !158
  %8 = mul i64 %7, %wide.trip.count29, !dbg !158
  %9 = mul i64 %8, %wide.trip.count34, !dbg !158
  %old.bb.count25 = load i64, ptr @for_begin_ax1.preheader.us.us.preheader_bbCounter, align 8
  %new.bb.count26 = add i64 %old.bb.count25, 1
  store i64 %new.bb.count26, ptr @for_begin_ax1.preheader.us.us.preheader_bbCounter, align 8
  br label %for_begin_ax1.preheader.us.us, !dbg !158

for_begin_ax1.preheader.us.us:                    ; preds = %for_begin_ax1.preheader.us.us.preheader
  %indvars.iv31 = phi i64 [ 0, %for_begin_ax1.preheader.us.us.preheader ]
    #dbg_declare(i64 %indvars.iv31, !159, !DIExpression(), !158)
    #dbg_declare(i32 0, !162, !DIExpression(), !158)
  %old.bb.count7 = load i64, ptr @for_begin_ax1.preheader.us.us_bbCounter, align 8
  %new.bb.count8 = add i64 %old.bb.count7, %wide.trip.count34
  store i64 %new.bb.count8, ptr @for_begin_ax1.preheader.us.us_bbCounter, align 8
  br label %for_body_ax1.us.us.us, !dbg !158

for_body_ax1.us.us.us:                            ; preds = %for_begin_ax1.preheader.us.us
  %indvars.iv26 = phi i64 [ 0, %for_begin_ax1.preheader.us.us ]
    #dbg_declare(i64 %indvars.iv26, !162, !DIExpression(), !158)
    #dbg_declare(i32 0, !163, !DIExpression(), !158)
  %old.bb.count9 = load i64, ptr @for_body_ax1.us.us.us_bbCounter, align 8
  %new.bb.count10 = add i64 %old.bb.count9, %4
  store i64 %new.bb.count10, ptr @for_body_ax1.us.us.us_bbCounter, align 8
  br i1 %3, label %for_begin_k.for_end_k_crit_edge.us.us.us.unr-lcssa, label %for_body_k.us.us.us.preheader, !dbg !158, !prof !164

for_body_k.us.us.us.preheader:                    ; preds = %for_body_ax1.us.us.us
  %old.bb.count3 = load i64, ptr @for_body_k.us.us.us.preheader_bbCounter, align 8
  %new.bb.count4 = add i64 %old.bb.count3, %4
  store i64 %new.bb.count4, ptr @for_body_k.us.us.us.preheader_bbCounter, align 8
  br label %for_body_k.us.us.us, !dbg !158

for_body_k.us.us.us:                              ; preds = %for_body_k.us.us.us.preheader
  %niter = phi i64 [ 0, %for_body_k.us.us.us.preheader ]
    #dbg_declare(i64 undef, !163, !DIExpression(), !158)
    #dbg_declare(i64 undef, !163, !DIExpression(), !158)
    #dbg_declare(i64 undef, !163, !DIExpression(), !158)
    #dbg_declare(i64 undef, !163, !DIExpression(), !158)
  %niter.next.1 = add i64 %niter, 2, !dbg !158
  %niter.ncmp.1 = icmp eq i64 %niter.next.1, %unroll_iter, !dbg !158
  %old.bb.count15 = load i64, ptr @for_body_k.us.us.us_bbCounter, align 8
  %new.bb.count16 = add i64 %old.bb.count15, %9
  store i64 %new.bb.count16, ptr @for_body_k.us.us.us_bbCounter, align 8
  br label %for_begin_k.for_end_k_crit_edge.us.us.us.unr-lcssa.loopexit

for_begin_k.for_end_k_crit_edge.us.us.us.unr-lcssa.loopexit: ; preds = %for_body_k.us.us.us
  %old.bb.count = load i64, ptr @for_begin_k.for_end_k_crit_edge.us.us.us.unr-lcssa.loopexit_bbCounter, align 8
  %new.bb.count = add i64 %old.bb.count, %4
  store i64 %new.bb.count, ptr @for_begin_k.for_end_k_crit_edge.us.us.us.unr-lcssa.loopexit_bbCounter, align 8
  br label %for_begin_k.for_end_k_crit_edge.us.us.us.unr-lcssa, !dbg !158

for_begin_k.for_end_k_crit_edge.us.us.us.unr-lcssa: ; preds = %for_begin_k.for_end_k_crit_edge.us.us.us.unr-lcssa.loopexit, %for_body_ax1.us.us.us
  %old.bb.count13 = load i64, ptr @for_begin_k.for_end_k_crit_edge.us.us.us.unr-lcssa_bbCounter, align 8
  %new.bb.count14 = add i64 %old.bb.count13, %4
  store i64 %new.bb.count14, ptr @for_begin_k.for_end_k_crit_edge.us.us.us.unr-lcssa_bbCounter, align 8
  br i1 %lcmp.mod5.not, label %for_begin_k.for_end_k_crit_edge.us.us.us, label %for_body_k.us.us.us.epil, !dbg !158, !prof !165

for_body_k.us.us.us.epil:                         ; preds = %for_begin_k.for_end_k_crit_edge.us.us.us.unr-lcssa
    #dbg_declare(i64 undef, !163, !DIExpression(), !158)
    #dbg_declare(i64 undef, !163, !DIExpression(DW_OP_plus_uconst, 1), !158)
  %old.bb.count17 = load i64, ptr @for_body_k.us.us.us.epil_bbCounter, align 8
  %new.bb.count18 = add i64 %old.bb.count17, %4
  store i64 %new.bb.count18, ptr @for_body_k.us.us.us.epil_bbCounter, align 8
  br label %for_begin_k.for_end_k_crit_edge.us.us.us, !dbg !158

for_begin_k.for_end_k_crit_edge.us.us.us:         ; preds = %for_body_k.us.us.us.epil, %for_begin_k.for_end_k_crit_edge.us.us.us.unr-lcssa
  %indvars.iv.next27 = add nuw nsw i64 %indvars.iv26, 1, !dbg !158
    #dbg_declare(i64 %indvars.iv.next27, !162, !DIExpression(), !158)
  %exitcond30.not = icmp eq i64 %indvars.iv.next27, %wide.trip.count29, !dbg !158
  %old.bb.count11 = load i64, ptr @for_begin_k.for_end_k_crit_edge.us.us.us_bbCounter, align 8
  %new.bb.count12 = add i64 %old.bb.count11, %4
  store i64 %new.bb.count12, ptr @for_begin_k.for_end_k_crit_edge.us.us.us_bbCounter, align 8
  br label %for_begin_ax1.for_end_ax1_crit_edge.split.us.us.us

for_begin_ax1.for_end_ax1_crit_edge.split.us.us.us: ; preds = %for_begin_k.for_end_k_crit_edge.us.us.us
  %indvars.iv.next32 = add nuw nsw i64 %indvars.iv31, 1, !dbg !158
    #dbg_declare(i64 %indvars.iv.next32, !159, !DIExpression(), !158)
  %exitcond35.not = icmp eq i64 %indvars.iv.next32, %wide.trip.count34, !dbg !158
  %old.bb.count5 = load i64, ptr @for_begin_ax1.for_end_ax1_crit_edge.split.us.us.us_bbCounter, align 8
  %new.bb.count6 = add i64 %old.bb.count5, %wide.trip.count34
  store i64 %new.bb.count6, ptr @for_begin_ax1.for_end_ax1_crit_edge.split.us.us.us_bbCounter, align 8
  br label %for_end_ax0.loopexit

for_begin_ax1.preheader.us:                       ; preds = %for_begin_ax1.for_end_ax1_crit_edge.split.us11, %for_begin_ax1.preheader.us.preheader
  %indvars.iv16 = phi i64 [ 0, %for_begin_ax1.preheader.us.preheader ], [ %indvars.iv.next17, %for_begin_ax1.for_end_ax1_crit_edge.split.us11 ]
    #dbg_declare(i64 %indvars.iv16, !159, !DIExpression(), !158)
    #dbg_declare(i32 0, !162, !DIExpression(), !158)
  %old.bb.count27 = load i64, ptr @for_begin_ax1.preheader.us_bbCounter, align 8
  %new.bb.count28 = add i64 %old.bb.count27, 1
  store i64 %new.bb.count28, ptr @for_begin_ax1.preheader.us_bbCounter, align 8
  br i1 %or.cond2, label %vector.body.preheader, label %for_body_ax1.us9.preheader, !dbg !158, !prof !160

vector.body.preheader:                            ; preds = %for_begin_ax1.preheader.us
  %old.bb.count29 = load i64, ptr @vector.body.preheader_bbCounter, align 8
  %new.bb.count30 = add i64 %old.bb.count29, 1
  store i64 %new.bb.count30, ptr @vector.body.preheader_bbCounter, align 8
  br label %vector.body, !dbg !158

vector.body:                                      ; preds = %vector.body.preheader, %vector.body
  %index = phi i64 [ %index.next, %vector.body ], [ 0, %vector.body.preheader ], !dbg !158
  %index.next = add nuw i64 %index, 8, !dbg !158
  %10 = icmp eq i64 %index.next, %n.vec, !dbg !158
  %old.bb.count31 = load i64, ptr @vector.body_bbCounter, align 8
  %new.bb.count32 = add i64 %old.bb.count31, 1
  store i64 %new.bb.count32, ptr @vector.body_bbCounter, align 8
  br i1 %10, label %middle.block, label %vector.body, !dbg !158, !prof !166, !llvm.loop !167

middle.block:                                     ; preds = %vector.body
  %old.bb.count33 = load i64, ptr @middle.block_bbCounter, align 8
  %new.bb.count34 = add i64 %old.bb.count33, 1
  store i64 %new.bb.count34, ptr @middle.block_bbCounter, align 8
  br i1 %cmp.n, label %for_begin_ax1.for_end_ax1_crit_edge.split.us11, label %for_body_ax1.us9.preheader, !dbg !158, !prof !170

for_body_ax1.us9.preheader:                       ; preds = %middle.block, %for_begin_ax1.preheader.us
  %indvars.iv.ph = phi i64 [ 0, %for_begin_ax1.preheader.us ], [ %n.vec, %middle.block ]
  %old.bb.count35 = load i64, ptr @for_body_ax1.us9.preheader_bbCounter, align 8
  %new.bb.count36 = add i64 %old.bb.count35, 1
  store i64 %new.bb.count36, ptr @for_body_ax1.us9.preheader_bbCounter, align 8
  br i1 %lcmp.mod.not, label %for_body_ax1.us9.prol.loopexit, label %for_body_ax1.us9.prol.preheader, !dbg !158, !prof !161

for_body_ax1.us9.prol.preheader:                  ; preds = %for_body_ax1.us9.preheader
  %old.bb.count37 = load i64, ptr @for_body_ax1.us9.prol.preheader_bbCounter, align 8
  %new.bb.count38 = add i64 %old.bb.count37, 1
  store i64 %new.bb.count38, ptr @for_body_ax1.us9.prol.preheader_bbCounter, align 8
  br label %for_body_ax1.us9.prol, !dbg !158

for_body_ax1.us9.prol:                            ; preds = %for_body_ax1.us9.prol.preheader, %for_body_ax1.us9.prol
  %indvars.iv.prol = phi i64 [ %indvars.iv.next.prol, %for_body_ax1.us9.prol ], [ %indvars.iv.ph, %for_body_ax1.us9.prol.preheader ]
  %prol.iter = phi i64 [ %prol.iter.next, %for_body_ax1.us9.prol ], [ 0, %for_body_ax1.us9.prol.preheader ]
    #dbg_declare(i64 %indvars.iv.prol, !162, !DIExpression(), !158)
    #dbg_declare(i32 0, !163, !DIExpression(), !158)
  %indvars.iv.next.prol = add nuw nsw i64 %indvars.iv.prol, 1, !dbg !158
    #dbg_declare(i64 %indvars.iv.next.prol, !162, !DIExpression(), !158)
  %prol.iter.next = add i64 %prol.iter, 1, !dbg !158
  %prol.iter.cmp.not = icmp eq i64 %prol.iter.next, %xtraiter, !dbg !158
  %old.bb.count39 = load i64, ptr @for_body_ax1.us9.prol_bbCounter, align 8
  %new.bb.count40 = add i64 %old.bb.count39, 1
  store i64 %new.bb.count40, ptr @for_body_ax1.us9.prol_bbCounter, align 8
  br i1 %prol.iter.cmp.not, label %for_body_ax1.us9.prol.loopexit.loopexit, label %for_body_ax1.us9.prol, !dbg !158, !prof !165, !llvm.loop !171

for_body_ax1.us9.prol.loopexit.loopexit:          ; preds = %for_body_ax1.us9.prol
  %old.bb.count41 = load i64, ptr @for_body_ax1.us9.prol.loopexit.loopexit_bbCounter, align 8
  %new.bb.count42 = add i64 %old.bb.count41, 1
  store i64 %new.bb.count42, ptr @for_body_ax1.us9.prol.loopexit.loopexit_bbCounter, align 8
  br label %for_body_ax1.us9.prol.loopexit, !dbg !158

for_body_ax1.us9.prol.loopexit:                   ; preds = %for_body_ax1.us9.prol.loopexit.loopexit, %for_body_ax1.us9.preheader
  %indvars.iv.unr = phi i64 [ %indvars.iv.ph, %for_body_ax1.us9.preheader ], [ %indvars.iv.next.prol, %for_body_ax1.us9.prol.loopexit.loopexit ]
  %11 = sub nsw i64 %indvars.iv.ph, %wide.trip.count, !dbg !158
  %12 = icmp ugt i64 %11, -4, !dbg !158
  %old.bb.count43 = load i64, ptr @for_body_ax1.us9.prol.loopexit_bbCounter, align 8
  %new.bb.count44 = add i64 %old.bb.count43, 1
  store i64 %new.bb.count44, ptr @for_body_ax1.us9.prol.loopexit_bbCounter, align 8
  br i1 %12, label %for_begin_ax1.for_end_ax1_crit_edge.split.us11, label %for_body_ax1.us9.preheader1, !dbg !158, !prof !164

for_body_ax1.us9.preheader1:                      ; preds = %for_body_ax1.us9.prol.loopexit
  %old.bb.count45 = load i64, ptr @for_body_ax1.us9.preheader1_bbCounter, align 8
  %new.bb.count46 = add i64 %old.bb.count45, 1
  store i64 %new.bb.count46, ptr @for_body_ax1.us9.preheader1_bbCounter, align 8
  br label %for_body_ax1.us9, !dbg !158

for_body_ax1.us9:                                 ; preds = %for_body_ax1.us9.preheader1, %for_body_ax1.us9
  %indvars.iv = phi i64 [ %indvars.iv.next.3, %for_body_ax1.us9 ], [ %indvars.iv.unr, %for_body_ax1.us9.preheader1 ]
    #dbg_declare(i64 %indvars.iv, !162, !DIExpression(), !158)
    #dbg_declare(i32 0, !163, !DIExpression(), !158)
    #dbg_declare(i64 undef, !162, !DIExpression(), !158)
    #dbg_declare(i64 undef, !162, !DIExpression(), !158)
    #dbg_declare(i32 0, !163, !DIExpression(), !158)
    #dbg_declare(i64 undef, !162, !DIExpression(), !158)
    #dbg_declare(i64 undef, !162, !DIExpression(), !158)
    #dbg_declare(i32 0, !163, !DIExpression(), !158)
    #dbg_declare(i64 undef, !162, !DIExpression(), !158)
    #dbg_declare(i64 undef, !162, !DIExpression(), !158)
    #dbg_declare(i32 0, !163, !DIExpression(), !158)
  %indvars.iv.next.3 = add nuw nsw i64 %indvars.iv, 4, !dbg !158
    #dbg_declare(i64 %indvars.iv.next.3, !162, !DIExpression(), !158)
  %exitcond.not.3 = icmp eq i64 %indvars.iv.next.3, %wide.trip.count, !dbg !158
  %old.bb.count47 = load i64, ptr @for_body_ax1.us9_bbCounter, align 8
  %new.bb.count48 = add i64 %old.bb.count47, 1
  store i64 %new.bb.count48, ptr @for_body_ax1.us9_bbCounter, align 8
  br i1 %exitcond.not.3, label %for_begin_ax1.for_end_ax1_crit_edge.split.us11.loopexit, label %for_body_ax1.us9, !dbg !158, !prof !173, !llvm.loop !174

for_begin_ax1.for_end_ax1_crit_edge.split.us11.loopexit: ; preds = %for_body_ax1.us9
  %old.bb.count49 = load i64, ptr @for_begin_ax1.for_end_ax1_crit_edge.split.us11.loopexit_bbCounter, align 8
  %new.bb.count50 = add i64 %old.bb.count49, 1
  store i64 %new.bb.count50, ptr @for_begin_ax1.for_end_ax1_crit_edge.split.us11.loopexit_bbCounter, align 8
  br label %for_begin_ax1.for_end_ax1_crit_edge.split.us11, !dbg !158

for_begin_ax1.for_end_ax1_crit_edge.split.us11:   ; preds = %for_begin_ax1.for_end_ax1_crit_edge.split.us11.loopexit, %for_body_ax1.us9.prol.loopexit, %middle.block
  %indvars.iv.next17 = add nuw nsw i64 %indvars.iv16, 1, !dbg !158
    #dbg_declare(i64 %indvars.iv.next17, !159, !DIExpression(), !158)
  %exitcond20.not = icmp eq i64 %indvars.iv.next17, %wide.trip.count19, !dbg !158
  %old.bb.count51 = load i64, ptr @for_begin_ax1.for_end_ax1_crit_edge.split.us11_bbCounter, align 8
  %new.bb.count52 = add i64 %old.bb.count51, 1
  store i64 %new.bb.count52, ptr @for_begin_ax1.for_end_ax1_crit_edge.split.us11_bbCounter, align 8
  br i1 %exitcond20.not, label %for_end_ax0.loopexit2, label %for_begin_ax1.preheader.us, !dbg !158, !prof !175

for_end_ax0.loopexit:                             ; preds = %for_begin_ax1.for_end_ax1_crit_edge.split.us.us.us
  %old.bb.count53 = load i64, ptr @for_end_ax0.loopexit_bbCounter, align 8
  %new.bb.count54 = add i64 %old.bb.count53, 1
  store i64 %new.bb.count54, ptr @for_end_ax0.loopexit_bbCounter, align 8
  br label %for_end_ax0, !dbg !158

for_end_ax0.loopexit2:                            ; preds = %for_begin_ax1.for_end_ax1_crit_edge.split.us11
  %old.bb.count55 = load i64, ptr @for_end_ax0.loopexit2_bbCounter, align 8
  %new.bb.count56 = add i64 %old.bb.count55, 1
  store i64 %new.bb.count56, ptr @for_end_ax0.loopexit2_bbCounter, align 8
  br label %for_end_ax0, !dbg !158

for_end_ax0:                                      ; preds = %for_end_ax0.loopexit2, %for_end_ax0.loopexit, %entry
  %old.bb.count57 = load i64, ptr @for_end_ax0_bbCounter, align 8
  %new.bb.count58 = add i64 %old.bb.count57, 1
  store i64 %new.bb.count58, ptr @for_end_ax0_bbCounter, align 8
  call void @matmul_compute__print_bb_count()
  ret void
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
declare float @llvm.fabs.f32(float) #3

; Function Attrs: nocallback nofree nosync nounwind speculatable willreturn memory(none)
declare half @llvm.fabs.f16(half) #3

define void @matmul_compute__print_bb_count() {
entry:
  %bb.count = load i64, ptr @for_begin_ax1.preheader.lr.ph.split.us_bbCounter, align 8
  call void @print_counter(i32 1015978224, ptr @0, i64 %bb.count)
  %bb.count1 = load i64, ptr @for_begin_ax1.preheader.us.us.preheader_bbCounter, align 8
  call void @print_counter(i32 1015978464, ptr @1, i64 %bb.count1)
  %bb.count2 = load i64, ptr @entry_bbCounter, align 8
  call void @print_counter(i32 1015978992, ptr @2, i64 %bb.count2)
  %bb.count3 = load i64, ptr @for_begin_k.for_end_k_crit_edge.us.us.us.unr-lcssa.loopexit_bbCounter, align 8
  call void @print_counter(i32 1015990928, ptr @3, i64 %bb.count3)
  %bb.count4 = load i64, ptr @for_body_ax1.us9.prol.loopexit.loopexit_bbCounter, align 8
  call void @print_counter(i32 1015994720, ptr @4, i64 %bb.count4)
  %bb.count5 = load i64, ptr @for_body_k.us.us.us.preheader_bbCounter, align 8
  call void @print_counter(i32 1016015504, ptr @5, i64 %bb.count5)
  %bb.count6 = load i64, ptr @vector.body.preheader_bbCounter, align 8
  call void @print_counter(i32 1016016112, ptr @6, i64 %bb.count6)
  %bb.count7 = load i64, ptr @for_begin_ax1.for_end_ax1_crit_edge.split.us11_bbCounter, align 8
  call void @print_counter(i32 1016026000, ptr @7, i64 %bb.count7)
  %bb.count8 = load i64, ptr @for_begin_ax1.for_end_ax1_crit_edge.split.us.us.us_bbCounter, align 8
  call void @print_counter(i32 1016026352, ptr @8, i64 %bb.count8)
  %bb.count9 = load i64, ptr @for_end_ax0_bbCounter, align 8
  call void @print_counter(i32 1016037312, ptr @9, i64 %bb.count9)
  %bb.count10 = load i64, ptr @for_body_ax1.us9.preheader1_bbCounter, align 8
  call void @print_counter(i32 1016059808, ptr @10, i64 %bb.count10)
  %bb.count11 = load i64, ptr @for_end_ax0.loopexit_bbCounter, align 8
  call void @print_counter(i32 1016069728, ptr @11, i64 %bb.count11)
  %bb.count12 = load i64, ptr @for_begin_ax1.for_end_ax1_crit_edge.split.us11.loopexit_bbCounter, align 8
  call void @print_counter(i32 1016092320, ptr @12, i64 %bb.count12)
  %bb.count13 = load i64, ptr @for_body_ax1.us9.prol.preheader_bbCounter, align 8
  call void @print_counter(i32 1016112320, ptr @13, i64 %bb.count13)
  %bb.count14 = load i64, ptr @for_end_ax0.loopexit2_bbCounter, align 8
  call void @print_counter(i32 1016123152, ptr @14, i64 %bb.count14)
  %bb.count15 = load i64, ptr @for_begin_ax1.preheader.us.us_bbCounter, align 8
  call void @print_counter(i32 1016130240, ptr @15, i64 %bb.count15)
  %bb.count16 = load i64, ptr @for_begin_ax1.preheader.us.preheader_bbCounter, align 8
  call void @print_counter(i32 1016130336, ptr @16, i64 %bb.count16)
  %bb.count17 = load i64, ptr @for_begin_ax1.preheader.us_bbCounter, align 8
  call void @print_counter(i32 1016130496, ptr @17, i64 %bb.count17)
  %bb.count18 = load i64, ptr @for_body_ax1.us.us.us_bbCounter, align 8
  call void @print_counter(i32 1016143280, ptr @18, i64 %bb.count18)
  %bb.count19 = load i64, ptr @for_begin_k.for_end_k_crit_edge.us.us.us_bbCounter, align 8
  call void @print_counter(i32 1016143792, ptr @19, i64 %bb.count19)
  %bb.count20 = load i64, ptr @for_begin_k.for_end_k_crit_edge.us.us.us.unr-lcssa_bbCounter, align 8
  call void @print_counter(i32 1016148864, ptr @20, i64 %bb.count20)
  %bb.count21 = load i64, ptr @for_body_k.us.us.us_bbCounter, align 8
  call void @print_counter(i32 1016149248, ptr @21, i64 %bb.count21)
  %bb.count22 = load i64, ptr @for_body_ax1.us9.prol.loopexit_bbCounter, align 8
  call void @print_counter(i32 1016161824, ptr @22, i64 %bb.count22)
  %bb.count23 = load i64, ptr @for_body_ax1.us9.prol_bbCounter, align 8
  call void @print_counter(i32 1016162128, ptr @23, i64 %bb.count23)
  %bb.count24 = load i64, ptr @for_body_ax1.us9_bbCounter, align 8
  call void @print_counter(i32 1016162272, ptr @24, i64 %bb.count24)
  %bb.count25 = load i64, ptr @for_body_k.us.us.us.epil_bbCounter, align 8
  call void @print_counter(i32 1016169232, ptr @25, i64 %bb.count25)
  %bb.count26 = load i64, ptr @vector.body_bbCounter, align 8
  call void @print_counter(i32 1016176496, ptr @26, i64 %bb.count26)
  %bb.count27 = load i64, ptr @middle.block_bbCounter, align 8
  call void @print_counter(i32 1016176640, ptr @27, i64 %bb.count27)
  %bb.count28 = load i64, ptr @for_body_ax1.us9.preheader_bbCounter, align 8
  call void @print_counter(i32 1016176784, ptr @28, i64 %bb.count28)
  ret void
}

; Function Attrs: mustprogress noinline optnone sspstrong uwtable
define dso_local void @print_counter(i32 noundef %0, ptr noundef %1, i64 noundef %2) #5 {
  %4 = alloca i32, align 4
  %5 = alloca ptr, align 8
  %6 = alloca i64, align 8
  store i32 %0, ptr %4, align 4
  store ptr %1, ptr %5, align 8
  store i64 %2, ptr %6, align 8
  %7 = load i32, ptr %4, align 4
  %8 = call noundef nonnull align 8 dereferenceable(8) ptr @_ZNSolsEi(ptr noundef nonnull align 8 dereferenceable(8) @_ZSt4cout, i32 noundef %7)
  %9 = call noundef nonnull align 8 dereferenceable(8) ptr @_ZStlsISt11char_traitsIcEERSt13basic_ostreamIcT_ES5_c(ptr noundef nonnull align 8 dereferenceable(8) %8, i8 noundef signext 32)
  %10 = load ptr, ptr %5, align 8
  %11 = call noundef nonnull align 8 dereferenceable(8) ptr @_ZStlsISt11char_traitsIcEERSt13basic_ostreamIcT_ES5_PKc(ptr noundef nonnull align 8 dereferenceable(8) %9, ptr noundef %10)
  %12 = call noundef nonnull align 8 dereferenceable(8) ptr @_ZStlsISt11char_traitsIcEERSt13basic_ostreamIcT_ES5_c(ptr noundef nonnull align 8 dereferenceable(8) %11, i8 noundef signext 32)
  %13 = load i64, ptr %6, align 8
  %14 = call noundef nonnull align 8 dereferenceable(8) ptr @_ZNSolsEl(ptr noundef nonnull align 8 dereferenceable(8) %12, i64 noundef %13)
  %15 = call noundef nonnull align 8 dereferenceable(8) ptr @_ZNSolsEPFRSoS_E(ptr noundef nonnull align 8 dereferenceable(8) %14, ptr noundef @_ZSt4endlIcSt11char_traitsIcEERSt13basic_ostreamIT_T0_ES6_)
  ret void
}

declare noundef nonnull align 8 dereferenceable(8) ptr @_ZNSolsEi(ptr noundef nonnull align 8 dereferenceable(8), i32 noundef) #6

declare noundef nonnull align 8 dereferenceable(8) ptr @_ZStlsISt11char_traitsIcEERSt13basic_ostreamIcT_ES5_c(ptr noundef nonnull align 8 dereferenceable(8), i8 noundef signext) #6

declare noundef nonnull align 8 dereferenceable(8) ptr @_ZStlsISt11char_traitsIcEERSt13basic_ostreamIcT_ES5_PKc(ptr noundef nonnull align 8 dereferenceable(8), ptr noundef) #6

declare noundef nonnull align 8 dereferenceable(8) ptr @_ZNSolsEl(ptr noundef nonnull align 8 dereferenceable(8), i64 noundef) #6

declare noundef nonnull align 8 dereferenceable(8) ptr @_ZSt4endlIcSt11char_traitsIcEERSt13basic_ostreamIT_T0_ES6_(ptr noundef nonnull align 8 dereferenceable(8)) #6

declare noundef nonnull align 8 dereferenceable(8) ptr @_ZNSolsEPFRSoS_E(ptr noundef nonnull align 8 dereferenceable(8), ptr noundef) #6

attributes #0 = { "target-cpu"="generic" }
attributes #1 = { nocallback nofree nosync nounwind willreturn memory(inaccessiblemem: write) }
attributes #2 = { nofree noinline norecurse nosync nounwind memory(argmem: readwrite) "target-cpu"="generic" }
attributes #3 = { nocallback nofree nosync nounwind speculatable willreturn memory(none) }
attributes #4 = { nofree nosync nounwind memory(none) "target-cpu"="generic" "target-features" }
attributes #5 = { mustprogress noinline optnone sspstrong uwtable "frame-pointer"="all" "min-legal-vector-width"="0" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cmov,+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #6 = { "frame-pointer"="all" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cmov,+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }

!llvm.dbg.cu = !{!0}
!llvm.module.flags = !{!2, !3, !4, !5, !6, !7, !8, !9}
!llvm.ident = !{!10}

!0 = distinct !DICompileUnit(language: DW_LANG_C, file: !1, producer: "TVM", isOptimized: false, runtimeVersion: 0, emissionKind: FullDebug)
!1 = !DIFile(filename: "IRModule.CodeGenLLVM", directory: ".")
!2 = !{i32 2, !"tvm_target", !"llvm -mtriple=x86_64-unknown-linux-gnu"}
!3 = !{i32 4, !"Debug Info Version", i32 3}
!4 = !{i32 4, !"Dwarf Version", i32 4}
!5 = !{i32 1, !"wchar_size", i32 4}
!6 = !{i32 8, !"PIC Level", i32 0}
!7 = !{i32 7, !"PIE Level", i32 2}
!8 = !{i32 7, !"uwtable", i32 2}
!9 = !{i32 7, !"frame-pointer", i32 2}
!10 = !{!"clang version 19.1.7"}
!11 = distinct !DISubprogram(name: "matmul", scope: !1, file: !1, type: !12, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !0, retainedNodes: !17)
!12 = !DISubroutineType(types: !13)
!13 = !{!14, !15, !16, !14, !15, !16, !15}
!14 = !DIBasicType(name: "int32", size: 32, encoding: DW_ATE_signed)
!15 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: null)
!16 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !14)
!17 = !{!18, !19, !20, !21, !22, !23}
!18 = !DILocalVariable(name: "args", arg: 1, scope: !11, file: !1, type: !15)
!19 = !DILocalVariable(name: "arg_type_ids", arg: 2, scope: !11, file: !1, type: !16)
!20 = !DILocalVariable(name: "num_args", arg: 3, scope: !11, file: !1, type: !14)
!21 = !DILocalVariable(name: "out_ret_value", arg: 4, scope: !11, file: !1, type: !15)
!22 = !DILocalVariable(name: "out_ret_tcode", arg: 5, scope: !11, file: !1, type: !16)
!23 = !DILocalVariable(name: "resource_handle", arg: 6, scope: !11, file: !1, type: !15)
!24 = !DILocation(line: 0, scope: !11)
!25 = !{!"branch_weights", i32 1048576, i32 1}
!26 = !{!27, !27, i64 0}
!27 = !{!"ctx_ptr", !28, i64 0}
!28 = !{!"tvm-tbaa"}
!29 = !{!"branch_weights", i32 1, i32 1048576}
!30 = !{!31, !31, i64 0}
!31 = !{!"0x5f597a0ce0f0.w4.b0", !32, i64 0}
!32 = !{!"0x5f597a0ce0f0.w8.b0", !33, i64 0}
!33 = !{!"0x5f597a0ce0f0.w16.b0", !34, i64 0}
!34 = !{!"0x5f597a0ce0f0.w32.b0", !35, i64 0}
!35 = !{!"0x5f597a0ce0f0.w64.b0", !36, i64 0}
!36 = !{!"0x5f597a0ce0f0.w128.b0", !37, i64 0}
!37 = !{!"0x5f597a0ce0f0.w256.b0", !38, i64 0}
!38 = !{!"0x5f597a0ce0f0.w512.b0", !39, i64 0}
!39 = !{!"0x5f597a0ce0f0.w1024.b0", !40, i64 0}
!40 = !{!"0x5f597a0ce0f0", !28, i64 0}
!41 = !DILocalVariable(name: "A.code", scope: !11, file: !1, type: !14)
!42 = !{!43, !43, i64 0}
!43 = !{!"0x5f597a0ce0f0.w4.b4", !32, i64 0}
!44 = !DILocalVariable(name: "B.code", scope: !11, file: !1, type: !14)
!45 = !{!46, !46, i64 0}
!46 = !{!"0x5f597a0ce0f0.w4.b8", !47, i64 0}
!47 = !{!"0x5f597a0ce0f0.w8.b8", !33, i64 0}
!48 = !DILocalVariable(name: "T_matmul.code", scope: !11, file: !1, type: !14)
!49 = !DILocalVariable(name: "A", scope: !11, file: !1, type: !15)
!50 = !DILocalVariable(name: "B", scope: !11, file: !1, type: !15)
!51 = !DILocalVariable(name: "T_matmul", scope: !11, file: !1, type: !15)
!52 = !DILocalVariable(name: "matmul.A.shape", scope: !11, file: !1, type: !53)
!53 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !54)
!54 = !DIBasicType(name: "int64", size: 64, encoding: DW_ATE_signed)
!55 = !{!56, !56, i64 0}
!56 = !{!"0x5f597a13d420.w8.b0", !57, i64 0}
!57 = !{!"0x5f597a13d420.w16.b0", !58, i64 0}
!58 = !{!"0x5f597a13d420.w32.b0", !59, i64 0}
!59 = !{!"0x5f597a13d420.w64.b0", !60, i64 0}
!60 = !{!"0x5f597a13d420.w128.b0", !61, i64 0}
!61 = !{!"0x5f597a13d420.w256.b0", !62, i64 0}
!62 = !{!"0x5f597a13d420.w512.b0", !63, i64 0}
!63 = !{!"0x5f597a13d420.w1024.b0", !64, i64 0}
!64 = !{!"0x5f597a13d420", !28, i64 0}
!65 = !DILocalVariable(name: "M", scope: !11, file: !1, type: !14)
!66 = !{!67, !67, i64 0}
!67 = !{!"0x5f597a13d420.w8.b8", !57, i64 0}
!68 = !DILocalVariable(name: "K", scope: !11, file: !1, type: !14)
!69 = !DILocalVariable(name: "matmul.A.strides", scope: !11, file: !1, type: !53)
!70 = !DILocalVariable(name: "stride", scope: !11, file: !1, type: !14)
!71 = !{!72, !72, i64 0}
!72 = !{!"0x5f597a166230.w8.b8", !73, i64 0}
!73 = !{!"0x5f597a166230.w16.b0", !74, i64 0}
!74 = !{!"0x5f597a166230.w32.b0", !75, i64 0}
!75 = !{!"0x5f597a166230.w64.b0", !76, i64 0}
!76 = !{!"0x5f597a166230.w128.b0", !77, i64 0}
!77 = !{!"0x5f597a166230.w256.b0", !78, i64 0}
!78 = !{!"0x5f597a166230.w512.b0", !79, i64 0}
!79 = !{!"0x5f597a166230.w1024.b0", !80, i64 0}
!80 = !{!"0x5f597a166230", !28, i64 0}
!81 = !DILocalVariable(name: "dev_id", scope: !11, file: !1, type: !14)
!82 = !DILocalVariable(name: "A", scope: !11, file: !1, type: !83)
!83 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !84)
!84 = !DIBasicType(name: "float32", size: 32, encoding: DW_ATE_float)
!85 = !{!86, !86, i64 0}
!86 = !{!"0x5f597a166230.w8.b0", !73, i64 0}
!87 = !DILocalVariable(name: "matmul.B.shape", scope: !11, file: !1, type: !53)
!88 = !{!89, !89, i64 0}
!89 = !{!"0x5f597a174950.w8.b8", !90, i64 0}
!90 = !{!"0x5f597a174950.w16.b0", !91, i64 0}
!91 = !{!"0x5f597a174950.w32.b0", !92, i64 0}
!92 = !{!"0x5f597a174950.w64.b0", !93, i64 0}
!93 = !{!"0x5f597a174950.w128.b0", !94, i64 0}
!94 = !{!"0x5f597a174950.w256.b0", !95, i64 0}
!95 = !{!"0x5f597a174950.w512.b0", !96, i64 0}
!96 = !{!"0x5f597a174950.w1024.b0", !97, i64 0}
!97 = !{!"0x5f597a174950", !28, i64 0}
!98 = !DILocalVariable(name: "N", scope: !11, file: !1, type: !14)
!99 = !DILocalVariable(name: "matmul.B.strides", scope: !11, file: !1, type: !53)
!100 = !{!101, !101, i64 0}
!101 = !{!"0x5f597a1755b0.w8.b8", !102, i64 0}
!102 = !{!"0x5f597a1755b0.w16.b0", !103, i64 0}
!103 = !{!"0x5f597a1755b0.w32.b0", !104, i64 0}
!104 = !{!"0x5f597a1755b0.w64.b0", !105, i64 0}
!105 = !{!"0x5f597a1755b0.w128.b0", !106, i64 0}
!106 = !{!"0x5f597a1755b0.w256.b0", !107, i64 0}
!107 = !{!"0x5f597a1755b0.w512.b0", !108, i64 0}
!108 = !{!"0x5f597a1755b0.w1024.b0", !109, i64 0}
!109 = !{!"0x5f597a1755b0", !28, i64 0}
!110 = !DILocalVariable(name: "B", scope: !11, file: !1, type: !83)
!111 = !{!112, !112, i64 0}
!112 = !{!"0x5f597a1755b0.w8.b0", !102, i64 0}
!113 = !DILocalVariable(name: "matmul.T_matmul.shape", scope: !11, file: !1, type: !53)
!114 = !DILocalVariable(name: "matmul.T_matmul.strides", scope: !11, file: !1, type: !53)
!115 = !{!116, !116, i64 0}
!116 = !{!"0x5f597a1779b0.w8.b8", !117, i64 0}
!117 = !{!"0x5f597a1779b0.w16.b0", !118, i64 0}
!118 = !{!"0x5f597a1779b0.w32.b0", !119, i64 0}
!119 = !{!"0x5f597a1779b0.w64.b0", !120, i64 0}
!120 = !{!"0x5f597a1779b0.w128.b0", !121, i64 0}
!121 = !{!"0x5f597a1779b0.w256.b0", !122, i64 0}
!122 = !{!"0x5f597a1779b0.w512.b0", !123, i64 0}
!123 = !{!"0x5f597a1779b0.w1024.b0", !124, i64 0}
!124 = !{!"0x5f597a1779b0", !28, i64 0}
!125 = !DILocalVariable(name: "T_matmul", scope: !11, file: !1, type: !83)
!126 = !{!127, !127, i64 0}
!127 = !{!"0x5f597a1779b0.w8.b0", !117, i64 0}
!128 = !{!129, !129, i64 0}
!129 = !{!"0x5f597a174950.w8.b0", !90, i64 0}
!130 = !{!131, !131, i64 0}
!131 = !{!"0x5f597a1775e0.w8.b0", !132, i64 0}
!132 = !{!"0x5f597a1775e0.w16.b0", !133, i64 0}
!133 = !{!"0x5f597a1775e0.w32.b0", !134, i64 0}
!134 = !{!"0x5f597a1775e0.w64.b0", !135, i64 0}
!135 = !{!"0x5f597a1775e0.w128.b0", !136, i64 0}
!136 = !{!"0x5f597a1775e0.w256.b0", !137, i64 0}
!137 = !{!"0x5f597a1775e0.w512.b0", !138, i64 0}
!138 = !{!"0x5f597a1775e0.w1024.b0", !139, i64 0}
!139 = !{!"0x5f597a1775e0", !28, i64 0}
!140 = !{!141, !141, i64 0}
!141 = !{!"0x5f597a1775e0.w8.b8", !132, i64 0}
!142 = distinct !DISubprogram(name: "matmul_compute_", scope: !1, file: !1, type: !143, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !0, retainedNodes: !145)
!143 = !DISubroutineType(cc: DW_CC_nocall, types: !144)
!144 = !{!14, !14, !14, !83, !14, !14, !14, !83, !14, !14, !83, !14, !14}
!145 = !{!146, !147, !148, !149, !150, !151, !152, !153, !154, !155, !156, !157}
!146 = !DILocalVariable(name: "M", arg: 1, scope: !142, file: !1, type: !14)
!147 = !DILocalVariable(name: "N", arg: 2, scope: !142, file: !1, type: !14)
!148 = !DILocalVariable(name: "T_matmul", arg: 3, scope: !142, file: !1, type: !83)
!149 = !DILocalVariable(name: "stride", arg: 4, scope: !142, file: !1, type: !14)
!150 = !DILocalVariable(name: "stride1", arg: 5, scope: !142, file: !1, type: !14)
!151 = !DILocalVariable(name: "K", arg: 6, scope: !142, file: !1, type: !14)
!152 = !DILocalVariable(name: "A", arg: 7, scope: !142, file: !1, type: !83)
!153 = !DILocalVariable(name: "stride2", arg: 8, scope: !142, file: !1, type: !14)
!154 = !DILocalVariable(name: "stride3", arg: 9, scope: !142, file: !1, type: !14)
!155 = !DILocalVariable(name: "B", arg: 10, scope: !142, file: !1, type: !83)
!156 = !DILocalVariable(name: "stride4", arg: 11, scope: !142, file: !1, type: !14)
!157 = !DILocalVariable(name: "stride5", arg: 12, scope: !142, file: !1, type: !14)
!158 = !DILocation(line: 0, scope: !142)
!159 = !DILocalVariable(name: "ax0", scope: !142, file: !1, type: !14)
!160 = !{!"branch_weights", i32 16129, i32 255}
!161 = !{!"branch_weights", i32 127, i32 1}
!162 = !DILocalVariable(name: "ax1", scope: !142, file: !1, type: !14)
!163 = !DILocalVariable(name: "k", scope: !142, file: !1, type: !14)
!164 = !{!"branch_weights", i32 1, i32 127}
!165 = !{!"branch_weights", i32 1, i32 1}
!166 = !{!"branch_weights", i32 127, i32 16777081}
!167 = distinct !{!167, !168, !169}
!168 = !{!"llvm.loop.isvectorized", i32 1}
!169 = !{!"llvm.loop.unroll.runtime.disable"}
!170 = !{!"branch_weights", i32 1, i32 7}
!171 = distinct !{!171, !172}
!172 = !{!"llvm.loop.unroll.disable"}
!173 = !{!"branch_weights", i32 0, i32 0}
!174 = distinct !{!174, !168}
!175 = !{!"branch_weights", i32 127, i32 134217601}
