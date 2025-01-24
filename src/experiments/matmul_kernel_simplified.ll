; ModuleID = '/home/jingyu/projects/playground/triton_kernels/matmul_kernel.ll'
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
@entry_bbCounter = common global i64 0
@common.ret_bbCounter = common global i64 0
@assert_fail_bbCounter = common global i64 0
@assert_end_bbCounter = common global i64 0
@assert_fail1_bbCounter = common global i64 0
@assert_end2_bbCounter = common global i64 0
@assert_fail3_bbCounter = common global i64 0
@assert_end4_bbCounter = common global i64 0
@assert_fail5_bbCounter = common global i64 0
@assert_end6_bbCounter = common global i64 0
@assert_fail7_bbCounter = common global i64 0
@assert_end8_bbCounter = common global i64 0
@assert_fail9_bbCounter = common global i64 0
@assert_end10_bbCounter = common global i64 0
@assert_fail11_bbCounter = common global i64 0
@assert_end12_bbCounter = common global i64 0
@assert_fail13_bbCounter = common global i64 0
@assert_end14_bbCounter = common global i64 0
@if_else_bbCounter = common global i64 0
@if_end_bbCounter = common global i64 0
@if_end.thread_bbCounter = common global i64 0
@if_else16_bbCounter = common global i64 0
@if_else19_bbCounter = common global i64 0
@if_end20_bbCounter = common global i64 0
@if_else22_bbCounter = common global i64 0
@assert_fail28_bbCounter = common global i64 0
@assert_end29_bbCounter = common global i64 0
@assert_fail30_bbCounter = common global i64 0
@assert_end31_bbCounter = common global i64 0
@if_else33_bbCounter = common global i64 0
@if_end34_bbCounter = common global i64 0
@if_end34.thread_bbCounter = common global i64 0
@if_else36_bbCounter = common global i64 0
@if_else41_bbCounter = common global i64 0
@if_end42_bbCounter = common global i64 0
@if_else44_bbCounter = common global i64 0
@assert_fail50_bbCounter = common global i64 0
@assert_end51_bbCounter = common global i64 0
@assert_fail52_bbCounter = common global i64 0
@assert_end53_bbCounter = common global i64 0
@if_else55_bbCounter = common global i64 0
@if_end56_bbCounter = common global i64 0
@if_end56.thread_bbCounter = common global i64 0
@if_else58_bbCounter = common global i64 0
@if_else63_bbCounter = common global i64 0
@if_end64_bbCounter = common global i64 0
@if_else66_bbCounter = common global i64 0
@assert_fail72_bbCounter = common global i64 0
@assert_end73_bbCounter = common global i64 0
@assert_fail74_bbCounter = common global i64 0
@assert_end75_bbCounter = common global i64 0
@assert_fail76_bbCounter = common global i64 0
@assert_end77_bbCounter = common global i64 0
@assert_fail78_bbCounter = common global i64 0
@assert_end79_bbCounter = common global i64 0
@assert_fail80_bbCounter = common global i64 0
@assert_end81_bbCounter = common global i64 0
@assert_fail82_bbCounter = common global i64 0
@assert_end83_bbCounter = common global i64 0
@assert_fail84_bbCounter = common global i64 0
@assert_end85_bbCounter = common global i64 0
@assert_fail86_bbCounter = common global i64 0
@assert_end87_bbCounter = common global i64 0
@assert_fail88_bbCounter = common global i64 0
@assert_end89_bbCounter = common global i64 0
@assert_fail90_bbCounter = common global i64 0
@assert_end91_bbCounter = common global i64 0
@assert_fail92_bbCounter = common global i64 0
@assert_end93_bbCounter = common global i64 0
@assert_fail94_bbCounter = common global i64 0
@assert_end95_bbCounter = common global i64 0
@assert_fail96_bbCounter = common global i64 0
@assert_end97_bbCounter = common global i64 0
@assert_fail98_bbCounter = common global i64 0
@assert_end99_bbCounter = common global i64 0
@assert_fail100_bbCounter = common global i64 0
@assert_end101_bbCounter = common global i64 0
@assert_fail102_bbCounter = common global i64 0
@assert_end103_bbCounter = common global i64 0
@assert_fail104_bbCounter = common global i64 0
@assert_end105_bbCounter = common global i64 0
@entry_bbCounter.1 = common global i64 0
@for_begin_ax1.preheader.lr.ph.split.us_bbCounter = common global i64 0
@for_begin_ax1.preheader.us.preheader_bbCounter = common global i64 0
@for_begin_ax1.preheader.us.us.preheader_bbCounter = common global i64 0
@for_begin_ax1.preheader.us.us_bbCounter = common global i64 0
@for_body_ax1.us.us.us_bbCounter = common global i64 0
@for_body_k.us.us.us.preheader_bbCounter = common global i64 0
@for_body_k.us.us.us_bbCounter = common global i64 0
@for_begin_k.for_end_k_crit_edge.us.us.us.unr-lcssa.loopexit_bbCounter = common global i64 0
@for_begin_k.for_end_k_crit_edge.us.us.us.unr-lcssa_bbCounter = common global i64 0
@for_body_k.us.us.us.epil_bbCounter = common global i64 0
@for_begin_k.for_end_k_crit_edge.us.us.us_bbCounter = common global i64 0
@for_begin_ax1.for_end_ax1_crit_edge.split.us.us.us_bbCounter = common global i64 0
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
@b0_bbCounter = common global i64 0
@b1_bbCounter = common global i64 0
@b2_bbCounter = common global i64 0
@b3_bbCounter = common global i64 0
@b4_bbCounter = common global i64 0
@b5_bbCounter = common global i64 0
@b6_bbCounter = common global i64 0
@b7_bbCounter = common global i64 0
@b8_bbCounter = common global i64 0
@b9_bbCounter = common global i64 0
@b10_bbCounter = common global i64 0
@b11_bbCounter = common global i64 0
@b12_bbCounter = common global i64 0
@b13_bbCounter = common global i64 0
@b0_bbCounter.2 = common global i64 0
@b1_bbCounter.3 = common global i64 0
@b2_bbCounter.4 = common global i64 0
@b3_bbCounter.5 = common global i64 0
@b4_bbCounter.6 = common global i64 0
@b5_bbCounter.7 = common global i64 0
@b6_bbCounter.8 = common global i64 0

define dllexport range(i32 -1, 1) i32 @matmul(ptr noalias readonly %args, ptr noalias readonly %arg_type_ids, i32 %num_args, ptr noalias nocapture readnone %out_ret_value, ptr noalias nocapture readnone %out_ret_tcode, ptr noalias nocapture readnone %resource_handle) local_unnamed_addr #0 !dbg !5 {
entry:
    #dbg_value(ptr %args, !12, !DIExpression(), !18)
    #dbg_value(ptr %arg_type_ids, !13, !DIExpression(), !18)
    #dbg_value(i32 %num_args, !14, !DIExpression(), !18)
    #dbg_value(ptr %out_ret_value, !15, !DIExpression(), !18)
    #dbg_value(ptr %out_ret_tcode, !16, !DIExpression(), !18)
    #dbg_value(ptr %resource_handle, !17, !DIExpression(), !18)
  %0 = icmp eq i32 %num_args, 3, !dbg !18
  %old.bb.count = load i64, ptr @entry_bbCounter, align 8
  %new.bb.count = add i64 %old.bb.count, 1
  store i64 %new.bb.count, ptr @entry_bbCounter, align 8
  br i1 %0, label %assert_end, label %assert_fail, !dbg !18, !prof !19

common.ret:                                       ; preds = %assert_end105, %assert_fail104, %assert_fail102, %assert_fail100, %assert_fail98, %assert_fail96, %assert_fail94, %assert_fail92, %assert_fail90, %assert_fail88, %assert_fail86, %assert_fail84, %assert_fail82, %assert_fail80, %assert_fail78, %assert_fail76, %assert_fail74, %assert_fail72, %assert_fail52, %assert_fail50, %assert_fail30, %assert_fail28, %assert_fail13, %assert_fail11, %assert_fail9, %assert_fail7, %assert_fail5, %assert_fail3, %assert_fail1, %assert_fail
  %old.bb.count1 = load i64, ptr @common.ret_bbCounter, align 8
  %new.bb.count2 = add i64 %old.bb.count1, 1
  store i64 %new.bb.count2, ptr @common.ret_bbCounter, align 8
  call void @print_bb_count()
  ret i32 undef

assert_fail:                                      ; preds = %entry
  %old.bb.count3 = load i64, ptr @assert_fail_bbCounter, align 8
  %new.bb.count4 = add i64 %old.bb.count3, 1
  store i64 %new.bb.count4, ptr @assert_fail_bbCounter, align 8
  br label %common.ret, !dbg !18

assert_end:                                       ; preds = %entry
  %.not = icmp eq ptr %args, null, !dbg !18
  %old.bb.count5 = load i64, ptr @assert_end_bbCounter, align 8
  %new.bb.count6 = add i64 %old.bb.count5, 1
  store i64 %new.bb.count6, ptr @assert_end_bbCounter, align 8
  br i1 %.not, label %assert_fail1, label %assert_end2, !dbg !18, !prof !20

assert_fail1:                                     ; preds = %assert_end
  %old.bb.count7 = load i64, ptr @assert_fail1_bbCounter, align 8
  %new.bb.count8 = add i64 %old.bb.count7, 1
  store i64 %new.bb.count8, ptr @assert_fail1_bbCounter, align 8
  br label %common.ret, !dbg !18

assert_end2:                                      ; preds = %assert_end
  %.not114 = icmp eq ptr %arg_type_ids, null, !dbg !18
  %old.bb.count9 = load i64, ptr @assert_end2_bbCounter, align 8
  %new.bb.count10 = add i64 %old.bb.count9, 1
  store i64 %new.bb.count10, ptr @assert_end2_bbCounter, align 8
  br i1 %.not114, label %assert_fail3, label %assert_end4, !dbg !18, !prof !20

assert_fail3:                                     ; preds = %assert_end2
  %old.bb.count11 = load i64, ptr @assert_fail3_bbCounter, align 8
  %new.bb.count12 = add i64 %old.bb.count11, 1
  store i64 %new.bb.count12, ptr @assert_fail3_bbCounter, align 8
  br label %common.ret, !dbg !18

assert_end4:                                      ; preds = %assert_end2
  %A.code = load i32, ptr %arg_type_ids, align 4, !dbg !18, !tbaa !21
    #dbg_declare(i32 %A.code, !33, !DIExpression(), !18)
    #dbg_declare(i32 %A.code, !33, !DIExpression(), !18)
  %old.bb.count13 = load i64, ptr @assert_end4_bbCounter, align 8
  %new.bb.count14 = add i64 %old.bb.count13, 1
  store i64 %new.bb.count14, ptr @assert_end4_bbCounter, align 8
  switch i32 %A.code, label %assert_fail5 [
    i32 13, label %assert_end6
    i32 7, label %assert_end6
    i32 4, label %assert_end6
    i32 3, label %assert_end6
  ], !dbg !18

assert_fail5:                                     ; preds = %assert_end4
  %old.bb.count15 = load i64, ptr @assert_fail5_bbCounter, align 8
  %new.bb.count16 = add i64 %old.bb.count15, 1
  store i64 %new.bb.count16, ptr @assert_fail5_bbCounter, align 8
  br label %common.ret, !dbg !18

assert_end6:                                      ; preds = %assert_end4, %assert_end4, %assert_end4, %assert_end4
  %1 = getelementptr inbounds i8, ptr %arg_type_ids, i64 4, !dbg !18
  %B.code = load i32, ptr %1, align 4, !dbg !18, !tbaa !34
    #dbg_declare(i32 %B.code, !36, !DIExpression(), !18)
    #dbg_declare(i32 %B.code, !36, !DIExpression(), !18)
  %old.bb.count17 = load i64, ptr @assert_end6_bbCounter, align 8
  %new.bb.count18 = add i64 %old.bb.count17, 1
  store i64 %new.bb.count18, ptr @assert_end6_bbCounter, align 8
  switch i32 %B.code, label %assert_fail7 [
    i32 13, label %assert_end8
    i32 7, label %assert_end8
    i32 4, label %assert_end8
    i32 3, label %assert_end8
  ], !dbg !18

assert_fail7:                                     ; preds = %assert_end6
  %old.bb.count19 = load i64, ptr @assert_fail7_bbCounter, align 8
  %new.bb.count20 = add i64 %old.bb.count19, 1
  store i64 %new.bb.count20, ptr @assert_fail7_bbCounter, align 8
  br label %common.ret, !dbg !18

assert_end8:                                      ; preds = %assert_end6, %assert_end6, %assert_end6, %assert_end6
  %2 = getelementptr inbounds i8, ptr %arg_type_ids, i64 8, !dbg !18
  %T_matmul.code = load i32, ptr %2, align 4, !dbg !18, !tbaa !37
    #dbg_declare(i32 %T_matmul.code, !40, !DIExpression(), !18)
    #dbg_declare(i32 %T_matmul.code, !40, !DIExpression(), !18)
  %old.bb.count21 = load i64, ptr @assert_end8_bbCounter, align 8
  %new.bb.count22 = add i64 %old.bb.count21, 1
  store i64 %new.bb.count22, ptr @assert_end8_bbCounter, align 8
  switch i32 %T_matmul.code, label %assert_fail9 [
    i32 13, label %assert_end10
    i32 7, label %assert_end10
    i32 4, label %assert_end10
    i32 3, label %assert_end10
  ], !dbg !18

assert_fail9:                                     ; preds = %assert_end8
  %old.bb.count23 = load i64, ptr @assert_fail9_bbCounter, align 8
  %new.bb.count24 = add i64 %old.bb.count23, 1
  store i64 %new.bb.count24, ptr @assert_fail9_bbCounter, align 8
  br label %common.ret, !dbg !18

assert_end10:                                     ; preds = %assert_end8, %assert_end8, %assert_end8, %assert_end8
  %A = load ptr, ptr %args, align 8, !dbg !18
    #dbg_declare(ptr %A, !41, !DIExpression(), !18)
    #dbg_declare(ptr %A, !41, !DIExpression(), !18)
  %3 = getelementptr inbounds i8, ptr %args, i64 8, !dbg !18
  %B = load ptr, ptr %3, align 8, !dbg !18
    #dbg_declare(ptr %B, !42, !DIExpression(), !18)
    #dbg_declare(ptr %B, !42, !DIExpression(), !18)
  %4 = getelementptr inbounds i8, ptr %args, i64 16, !dbg !18
  %T_matmul = load ptr, ptr %4, align 8, !dbg !18
    #dbg_declare(ptr %T_matmul, !43, !DIExpression(), !18)
    #dbg_declare(ptr %T_matmul, !43, !DIExpression(), !18)
  %.not115 = icmp eq ptr %A, null, !dbg !18
  %old.bb.count25 = load i64, ptr @assert_end10_bbCounter, align 8
  %new.bb.count26 = add i64 %old.bb.count25, 1
  store i64 %new.bb.count26, ptr @assert_end10_bbCounter, align 8
  br i1 %.not115, label %assert_fail11, label %assert_end12, !dbg !18, !prof !20

assert_fail11:                                    ; preds = %assert_end10
  %old.bb.count27 = load i64, ptr @assert_fail11_bbCounter, align 8
  %new.bb.count28 = add i64 %old.bb.count27, 1
  store i64 %new.bb.count28, ptr @assert_fail11_bbCounter, align 8
  br label %common.ret, !dbg !18

assert_end12:                                     ; preds = %assert_end10
  %5 = getelementptr inbounds i8, ptr %A, i64 16, !dbg !18
  %6 = load i32, ptr %5, align 4, !dbg !18
  %7 = icmp eq i32 %6, 2, !dbg !18
  %old.bb.count29 = load i64, ptr @assert_end12_bbCounter, align 8
  %new.bb.count30 = add i64 %old.bb.count29, 1
  store i64 %new.bb.count30, ptr @assert_end12_bbCounter, align 8
  br i1 %7, label %assert_end14, label %assert_fail13, !dbg !18, !prof !19

assert_fail13:                                    ; preds = %assert_end12
  %old.bb.count31 = load i64, ptr @assert_fail13_bbCounter, align 8
  %new.bb.count32 = add i64 %old.bb.count31, 1
  store i64 %new.bb.count32, ptr @assert_fail13_bbCounter, align 8
  br label %common.ret, !dbg !18

assert_end14:                                     ; preds = %assert_end12
  %8 = getelementptr inbounds i8, ptr %A, i64 24, !dbg !18
  %matmul.A.shape = load ptr, ptr %8, align 8, !dbg !18
    #dbg_declare(ptr %matmul.A.shape, !44, !DIExpression(), !18)
    #dbg_declare(ptr %matmul.A.shape, !44, !DIExpression(), !18)
  %9 = load i64, ptr %matmul.A.shape, align 8, !dbg !18, !tbaa !47
  %M = trunc i64 %9 to i32, !dbg !18
    #dbg_declare(i32 %M, !57, !DIExpression(), !18)
    #dbg_declare(i32 %M, !57, !DIExpression(), !18)
  %10 = getelementptr inbounds i8, ptr %matmul.A.shape, i64 8, !dbg !18
  %11 = load i64, ptr %10, align 8, !dbg !18, !tbaa !58
  %K = trunc i64 %11 to i32, !dbg !18
    #dbg_declare(i32 %K, !60, !DIExpression(), !18)
    #dbg_declare(i32 %K, !60, !DIExpression(), !18)
  %12 = getelementptr inbounds i8, ptr %A, i64 32, !dbg !18
  %matmul.A.strides = load ptr, ptr %12, align 8, !dbg !18
    #dbg_declare(ptr %matmul.A.strides, !61, !DIExpression(), !18)
    #dbg_declare(ptr %matmul.A.strides, !61, !DIExpression(), !18)
  %13 = icmp eq i32 %K, 1, !dbg !18
  %old.bb.count33 = load i64, ptr @assert_end14_bbCounter, align 8
  %new.bb.count34 = add i64 %old.bb.count33, 1
  store i64 %new.bb.count34, ptr @assert_end14_bbCounter, align 8
  br i1 %13, label %if_end, label %if_else, !dbg !18

if_else:                                          ; preds = %assert_end14
  %14 = icmp eq ptr %matmul.A.strides, null, !dbg !18
  %old.bb.count35 = load i64, ptr @if_else_bbCounter, align 8
  %new.bb.count36 = add i64 %old.bb.count35, 1
  store i64 %new.bb.count36, ptr @if_else_bbCounter, align 8
  br i1 %14, label %if_end.thread, label %if_else16, !dbg !18

if_end:                                           ; preds = %if_else16, %assert_end14
    #dbg_declare(i32 undef, !62, !DIExpression(), !18)
    #dbg_declare(i32 undef, !62, !DIExpression(), !18)
  %15 = icmp eq i32 %M, 1, !dbg !18
  %old.bb.count37 = load i64, ptr @if_end_bbCounter, align 8
  %new.bb.count38 = add i64 %old.bb.count37, 1
  store i64 %new.bb.count38, ptr @if_end_bbCounter, align 8
  br i1 %15, label %if_end20, label %if_else19, !dbg !18

if_end.thread:                                    ; preds = %if_else
    #dbg_declare(i32 1, !62, !DIExpression(), !18)
    #dbg_declare(i32 1, !62, !DIExpression(), !18)
  %16 = icmp eq i32 %M, 1, !dbg !18
  %old.bb.count39 = load i64, ptr @if_end.thread_bbCounter, align 8
  %new.bb.count40 = add i64 %old.bb.count39, 1
  store i64 %new.bb.count40, ptr @if_end.thread_bbCounter, align 8
  br label %if_end20, !dbg !18

if_else16:                                        ; preds = %if_else
  %old.bb.count41 = load i64, ptr @if_else16_bbCounter, align 8
  %new.bb.count42 = add i64 %old.bb.count41, 1
  store i64 %new.bb.count42, ptr @if_else16_bbCounter, align 8
  br label %if_end, !dbg !18

if_else19:                                        ; preds = %if_end
  %17 = icmp eq ptr %matmul.A.strides, null, !dbg !18
  %old.bb.count43 = load i64, ptr @if_else19_bbCounter, align 8
  %new.bb.count44 = add i64 %old.bb.count43, 1
  store i64 %new.bb.count44, ptr @if_else19_bbCounter, align 8
  br i1 %17, label %if_end20, label %if_else22, !dbg !18

if_end20:                                         ; preds = %if_else22, %if_else19, %if_end.thread, %if_end
  %18 = phi i1 [ true, %if_end ], [ false, %if_else22 ], [ false, %if_else19 ], [ %16, %if_end.thread ]
    #dbg_declare(i32 undef, !62, !DIExpression(), !18)
    #dbg_declare(i32 undef, !62, !DIExpression(), !18)
  %19 = getelementptr inbounds i8, ptr %A, i64 12, !dbg !18
  %dev_id = load i32, ptr %19, align 4, !dbg !18
    #dbg_declare(i32 %dev_id, !63, !DIExpression(), !18)
    #dbg_declare(i32 %dev_id, !63, !DIExpression(), !18)
  %A109 = load ptr, ptr %A, align 8, !dbg !18
    #dbg_declare(ptr %A109, !64, !DIExpression(), !18)
    #dbg_declare(ptr %A109, !64, !DIExpression(), !18)
  %.not116 = icmp eq ptr %B, null, !dbg !18
  %old.bb.count45 = load i64, ptr @if_end20_bbCounter, align 8
  %new.bb.count46 = add i64 %old.bb.count45, 1
  store i64 %new.bb.count46, ptr @if_end20_bbCounter, align 8
  br i1 %.not116, label %assert_fail28, label %assert_end29, !dbg !18, !prof !20

if_else22:                                        ; preds = %if_else19
  %old.bb.count47 = load i64, ptr @if_else22_bbCounter, align 8
  %new.bb.count48 = add i64 %old.bb.count47, 1
  store i64 %new.bb.count48, ptr @if_else22_bbCounter, align 8
  br label %if_end20, !dbg !18

assert_fail28:                                    ; preds = %if_end20
  %old.bb.count49 = load i64, ptr @assert_fail28_bbCounter, align 8
  %new.bb.count50 = add i64 %old.bb.count49, 1
  store i64 %new.bb.count50, ptr @assert_fail28_bbCounter, align 8
  br label %common.ret, !dbg !18

assert_end29:                                     ; preds = %if_end20
  %20 = getelementptr inbounds i8, ptr %B, i64 16, !dbg !18
  %21 = load i32, ptr %20, align 4, !dbg !18
  %22 = icmp eq i32 %21, 2, !dbg !18
  %old.bb.count51 = load i64, ptr @assert_end29_bbCounter, align 8
  %new.bb.count52 = add i64 %old.bb.count51, 1
  store i64 %new.bb.count52, ptr @assert_end29_bbCounter, align 8
  br i1 %22, label %assert_end31, label %assert_fail30, !dbg !18, !prof !19

assert_fail30:                                    ; preds = %assert_end29
  %old.bb.count53 = load i64, ptr @assert_fail30_bbCounter, align 8
  %new.bb.count54 = add i64 %old.bb.count53, 1
  store i64 %new.bb.count54, ptr @assert_fail30_bbCounter, align 8
  br label %common.ret, !dbg !18

assert_end31:                                     ; preds = %assert_end29
  %23 = getelementptr inbounds i8, ptr %B, i64 24, !dbg !18
  %matmul.B.shape = load ptr, ptr %23, align 8, !dbg !18
    #dbg_declare(ptr %matmul.B.shape, !67, !DIExpression(), !18)
    #dbg_declare(ptr %matmul.B.shape, !67, !DIExpression(), !18)
  %24 = getelementptr inbounds i8, ptr %matmul.B.shape, i64 8, !dbg !18
  %25 = load i64, ptr %24, align 8, !dbg !18, !tbaa !68
  %N = trunc i64 %25 to i32, !dbg !18
    #dbg_declare(i32 %N, !78, !DIExpression(), !18)
    #dbg_declare(i32 %N, !78, !DIExpression(), !18)
  %26 = getelementptr inbounds i8, ptr %B, i64 32, !dbg !18
  %matmul.B.strides = load ptr, ptr %26, align 8, !dbg !18
    #dbg_declare(ptr %matmul.B.strides, !79, !DIExpression(), !18)
    #dbg_declare(ptr %matmul.B.strides, !79, !DIExpression(), !18)
  %27 = icmp eq i32 %N, 1, !dbg !18
  %old.bb.count55 = load i64, ptr @assert_end31_bbCounter, align 8
  %new.bb.count56 = add i64 %old.bb.count55, 1
  store i64 %new.bb.count56, ptr @assert_end31_bbCounter, align 8
  br i1 %27, label %if_end34, label %if_else33, !dbg !18

if_else33:                                        ; preds = %assert_end31
  %28 = icmp eq ptr %matmul.B.strides, null, !dbg !18
  %old.bb.count57 = load i64, ptr @if_else33_bbCounter, align 8
  %new.bb.count58 = add i64 %old.bb.count57, 1
  store i64 %new.bb.count58, ptr @if_else33_bbCounter, align 8
  br i1 %28, label %if_end34.thread, label %if_else36, !dbg !18

if_end34:                                         ; preds = %if_else36, %assert_end31
    #dbg_declare(i32 undef, !62, !DIExpression(), !18)
    #dbg_declare(i32 undef, !62, !DIExpression(), !18)
  %old.bb.count59 = load i64, ptr @if_end34_bbCounter, align 8
  %new.bb.count60 = add i64 %old.bb.count59, 1
  store i64 %new.bb.count60, ptr @if_end34_bbCounter, align 8
  br i1 %13, label %if_end42, label %if_else41, !dbg !18

if_end34.thread:                                  ; preds = %if_else33
    #dbg_declare(i32 1, !62, !DIExpression(), !18)
    #dbg_declare(i32 1, !62, !DIExpression(), !18)
  %old.bb.count61 = load i64, ptr @if_end34.thread_bbCounter, align 8
  %new.bb.count62 = add i64 %old.bb.count61, 1
  store i64 %new.bb.count62, ptr @if_end34.thread_bbCounter, align 8
  br label %if_end42, !dbg !18

if_else36:                                        ; preds = %if_else33
  %old.bb.count63 = load i64, ptr @if_else36_bbCounter, align 8
  %new.bb.count64 = add i64 %old.bb.count63, 1
  store i64 %new.bb.count64, ptr @if_else36_bbCounter, align 8
  br label %if_end34, !dbg !18

if_else41:                                        ; preds = %if_end34
  %29 = icmp eq ptr %matmul.B.strides, null, !dbg !18
  %old.bb.count65 = load i64, ptr @if_else41_bbCounter, align 8
  %new.bb.count66 = add i64 %old.bb.count65, 1
  store i64 %new.bb.count66, ptr @if_else41_bbCounter, align 8
  br i1 %29, label %if_end42, label %if_else44, !dbg !18

if_end42:                                         ; preds = %if_else44, %if_else41, %if_end34.thread, %if_end34
    #dbg_declare(i32 undef, !62, !DIExpression(), !18)
    #dbg_declare(i32 undef, !62, !DIExpression(), !18)
  %B111 = load ptr, ptr %B, align 8, !dbg !18
    #dbg_declare(ptr %B111, !80, !DIExpression(), !18)
    #dbg_declare(ptr %B111, !80, !DIExpression(), !18)
  %.not117 = icmp eq ptr %T_matmul, null, !dbg !18
  %old.bb.count67 = load i64, ptr @if_end42_bbCounter, align 8
  %new.bb.count68 = add i64 %old.bb.count67, 1
  store i64 %new.bb.count68, ptr @if_end42_bbCounter, align 8
  br i1 %.not117, label %assert_fail50, label %assert_end51, !dbg !18, !prof !20

if_else44:                                        ; preds = %if_else41
  %old.bb.count69 = load i64, ptr @if_else44_bbCounter, align 8
  %new.bb.count70 = add i64 %old.bb.count69, 1
  store i64 %new.bb.count70, ptr @if_else44_bbCounter, align 8
  br label %if_end42, !dbg !18

assert_fail50:                                    ; preds = %if_end42
  %old.bb.count71 = load i64, ptr @assert_fail50_bbCounter, align 8
  %new.bb.count72 = add i64 %old.bb.count71, 1
  store i64 %new.bb.count72, ptr @assert_fail50_bbCounter, align 8
  br label %common.ret, !dbg !18

assert_end51:                                     ; preds = %if_end42
  %30 = getelementptr inbounds i8, ptr %T_matmul, i64 16, !dbg !18
  %31 = load i32, ptr %30, align 4, !dbg !18
  %32 = icmp eq i32 %31, 2, !dbg !18
  %old.bb.count73 = load i64, ptr @assert_end51_bbCounter, align 8
  %new.bb.count74 = add i64 %old.bb.count73, 1
  store i64 %new.bb.count74, ptr @assert_end51_bbCounter, align 8
  br i1 %32, label %assert_end53, label %assert_fail52, !dbg !18, !prof !19

assert_fail52:                                    ; preds = %assert_end51
  %old.bb.count75 = load i64, ptr @assert_fail52_bbCounter, align 8
  %new.bb.count76 = add i64 %old.bb.count75, 1
  store i64 %new.bb.count76, ptr @assert_fail52_bbCounter, align 8
  br label %common.ret, !dbg !18

assert_end53:                                     ; preds = %assert_end51
  %33 = getelementptr inbounds i8, ptr %T_matmul, i64 24, !dbg !18
  %matmul.T_matmul.shape = load ptr, ptr %33, align 8, !dbg !18
    #dbg_declare(ptr %matmul.T_matmul.shape, !81, !DIExpression(), !18)
    #dbg_declare(ptr %matmul.T_matmul.shape, !81, !DIExpression(), !18)
  %34 = getelementptr inbounds i8, ptr %T_matmul, i64 32, !dbg !18
  %matmul.T_matmul.strides = load ptr, ptr %34, align 8, !dbg !18
    #dbg_declare(ptr %matmul.T_matmul.strides, !82, !DIExpression(), !18)
    #dbg_declare(ptr %matmul.T_matmul.strides, !82, !DIExpression(), !18)
  %old.bb.count77 = load i64, ptr @assert_end53_bbCounter, align 8
  %new.bb.count78 = add i64 %old.bb.count77, 1
  store i64 %new.bb.count78, ptr @assert_end53_bbCounter, align 8
  br i1 %27, label %if_end56, label %if_else55, !dbg !18

if_else55:                                        ; preds = %assert_end53
  %35 = icmp eq ptr %matmul.T_matmul.strides, null, !dbg !18
  %old.bb.count79 = load i64, ptr @if_else55_bbCounter, align 8
  %new.bb.count80 = add i64 %old.bb.count79, 1
  store i64 %new.bb.count80, ptr @if_else55_bbCounter, align 8
  br i1 %35, label %if_end56.thread, label %if_else58, !dbg !18

if_end56:                                         ; preds = %if_else58, %assert_end53
    #dbg_declare(i32 undef, !62, !DIExpression(), !18)
    #dbg_declare(i32 undef, !62, !DIExpression(), !18)
  %old.bb.count81 = load i64, ptr @if_end56_bbCounter, align 8
  %new.bb.count82 = add i64 %old.bb.count81, 1
  store i64 %new.bb.count82, ptr @if_end56_bbCounter, align 8
  br i1 %18, label %if_end64, label %if_else63, !dbg !18

if_end56.thread:                                  ; preds = %if_else55
    #dbg_declare(i32 1, !62, !DIExpression(), !18)
    #dbg_declare(i32 1, !62, !DIExpression(), !18)
  %old.bb.count83 = load i64, ptr @if_end56.thread_bbCounter, align 8
  %new.bb.count84 = add i64 %old.bb.count83, 1
  store i64 %new.bb.count84, ptr @if_end56.thread_bbCounter, align 8
  br label %if_end64, !dbg !18

if_else58:                                        ; preds = %if_else55
  %old.bb.count85 = load i64, ptr @if_else58_bbCounter, align 8
  %new.bb.count86 = add i64 %old.bb.count85, 1
  store i64 %new.bb.count86, ptr @if_else58_bbCounter, align 8
  br label %if_end56, !dbg !18

if_else63:                                        ; preds = %if_end56
  %36 = icmp eq ptr %matmul.T_matmul.strides, null, !dbg !18
  %old.bb.count87 = load i64, ptr @if_else63_bbCounter, align 8
  %new.bb.count88 = add i64 %old.bb.count87, 1
  store i64 %new.bb.count88, ptr @if_else63_bbCounter, align 8
  br i1 %36, label %if_end64, label %if_else66, !dbg !18

if_end64:                                         ; preds = %if_else66, %if_else63, %if_end56.thread, %if_end56
    #dbg_declare(i32 undef, !62, !DIExpression(), !18)
    #dbg_declare(i32 undef, !62, !DIExpression(), !18)
  %T_matmul106 = load ptr, ptr %T_matmul, align 8, !dbg !18
    #dbg_declare(ptr %T_matmul106, !83, !DIExpression(), !18)
    #dbg_declare(ptr %T_matmul106, !83, !DIExpression(), !18)
  %37 = getelementptr inbounds i8, ptr %A, i64 22, !dbg !18
  %38 = load i16, ptr %37, align 2, !dbg !18
  %39 = icmp eq i16 %38, 1, !dbg !18
  %40 = getelementptr inbounds i8, ptr %A, i64 21, !dbg !18
  %41 = load i8, ptr %40, align 1, !dbg !18
  %42 = icmp eq i8 %41, 32, !dbg !18
  %43 = getelementptr inbounds i8, ptr %A, i64 20, !dbg !18
  %44 = load i8, ptr %43, align 1, !dbg !18
  %45 = icmp eq i8 %44, 2, !dbg !18
  %46 = and i1 %42, %45, !dbg !18
  %47 = and i1 %39, %46, !dbg !18
  %old.bb.count89 = load i64, ptr @if_end64_bbCounter, align 8
  %new.bb.count90 = add i64 %old.bb.count89, 1
  store i64 %new.bb.count90, ptr @if_end64_bbCounter, align 8
  br i1 %47, label %assert_end73, label %assert_fail72, !dbg !18, !prof !19

if_else66:                                        ; preds = %if_else63
  %old.bb.count91 = load i64, ptr @if_else66_bbCounter, align 8
  %new.bb.count92 = add i64 %old.bb.count91, 1
  store i64 %new.bb.count92, ptr @if_else66_bbCounter, align 8
  br label %if_end64, !dbg !18

assert_fail72:                                    ; preds = %if_end64
  %old.bb.count93 = load i64, ptr @assert_fail72_bbCounter, align 8
  %new.bb.count94 = add i64 %old.bb.count93, 1
  store i64 %new.bb.count94, ptr @assert_fail72_bbCounter, align 8
  br label %common.ret, !dbg !18

assert_end73:                                     ; preds = %if_end64
  %48 = getelementptr inbounds i8, ptr %A, i64 40, !dbg !18
  %49 = load i64, ptr %48, align 8, !dbg !18
  %50 = icmp eq i64 %49, 0, !dbg !18
  %old.bb.count95 = load i64, ptr @assert_end73_bbCounter, align 8
  %new.bb.count96 = add i64 %old.bb.count95, 1
  store i64 %new.bb.count96, ptr @assert_end73_bbCounter, align 8
  br i1 %50, label %assert_end75, label %assert_fail74, !dbg !18, !prof !19

assert_fail74:                                    ; preds = %assert_end73
  %old.bb.count97 = load i64, ptr @assert_fail74_bbCounter, align 8
  %new.bb.count98 = add i64 %old.bb.count97, 1
  store i64 %new.bb.count98, ptr @assert_fail74_bbCounter, align 8
  br label %common.ret, !dbg !18

assert_end75:                                     ; preds = %assert_end73
  %51 = getelementptr inbounds i8, ptr %A, i64 8, !dbg !18
  %52 = load i32, ptr %51, align 4, !dbg !18
  %53 = icmp eq i32 %52, 1, !dbg !18
  %old.bb.count99 = load i64, ptr @assert_end75_bbCounter, align 8
  %new.bb.count100 = add i64 %old.bb.count99, 1
  store i64 %new.bb.count100, ptr @assert_end75_bbCounter, align 8
  br i1 %53, label %assert_end77, label %assert_fail76, !dbg !18, !prof !19

assert_fail76:                                    ; preds = %assert_end75
  %old.bb.count101 = load i64, ptr @assert_fail76_bbCounter, align 8
  %new.bb.count102 = add i64 %old.bb.count101, 1
  store i64 %new.bb.count102, ptr @assert_fail76_bbCounter, align 8
  br label %common.ret, !dbg !18

assert_end77:                                     ; preds = %assert_end75
  %54 = icmp ne ptr %A109, null, !dbg !18
  %55 = mul nsw i32 %K, %M, !dbg !18
  %56 = icmp eq i32 %55, 0, !dbg !18
  %57 = or i1 %56, %54, !dbg !18
  %old.bb.count103 = load i64, ptr @assert_end77_bbCounter, align 8
  %new.bb.count104 = add i64 %old.bb.count103, 1
  store i64 %new.bb.count104, ptr @assert_end77_bbCounter, align 8
  br i1 %57, label %assert_end79, label %assert_fail78, !dbg !18, !prof !19

assert_fail78:                                    ; preds = %assert_end77
  %old.bb.count105 = load i64, ptr @assert_fail78_bbCounter, align 8
  %new.bb.count106 = add i64 %old.bb.count105, 1
  store i64 %new.bb.count106, ptr @assert_fail78_bbCounter, align 8
  br label %common.ret, !dbg !18

assert_end79:                                     ; preds = %assert_end77
  %58 = getelementptr inbounds i8, ptr %B, i64 22, !dbg !18
  %59 = load i16, ptr %58, align 2, !dbg !18
  %60 = icmp eq i16 %59, 1, !dbg !18
  %61 = getelementptr inbounds i8, ptr %B, i64 21, !dbg !18
  %62 = load i8, ptr %61, align 1, !dbg !18
  %63 = icmp eq i8 %62, 32, !dbg !18
  %64 = getelementptr inbounds i8, ptr %B, i64 20, !dbg !18
  %65 = load i8, ptr %64, align 1, !dbg !18
  %66 = icmp eq i8 %65, 2, !dbg !18
  %67 = and i1 %63, %66, !dbg !18
  %68 = and i1 %60, %67, !dbg !18
  %old.bb.count107 = load i64, ptr @assert_end79_bbCounter, align 8
  %new.bb.count108 = add i64 %old.bb.count107, 1
  store i64 %new.bb.count108, ptr @assert_end79_bbCounter, align 8
  br i1 %68, label %assert_end81, label %assert_fail80, !dbg !18, !prof !19

assert_fail80:                                    ; preds = %assert_end79
  %old.bb.count109 = load i64, ptr @assert_fail80_bbCounter, align 8
  %new.bb.count110 = add i64 %old.bb.count109, 1
  store i64 %new.bb.count110, ptr @assert_fail80_bbCounter, align 8
  br label %common.ret, !dbg !18

assert_end81:                                     ; preds = %assert_end79
  %69 = load i64, ptr %matmul.B.shape, align 8, !dbg !18, !tbaa !84
  %70 = trunc i64 %69 to i32, !dbg !18
  %71 = icmp eq i32 %K, %70, !dbg !18
  %old.bb.count111 = load i64, ptr @assert_end81_bbCounter, align 8
  %new.bb.count112 = add i64 %old.bb.count111, 1
  store i64 %new.bb.count112, ptr @assert_end81_bbCounter, align 8
  br i1 %71, label %assert_end83, label %assert_fail82, !dbg !18, !prof !19

assert_fail82:                                    ; preds = %assert_end81
  %old.bb.count113 = load i64, ptr @assert_fail82_bbCounter, align 8
  %new.bb.count114 = add i64 %old.bb.count113, 1
  store i64 %new.bb.count114, ptr @assert_fail82_bbCounter, align 8
  br label %common.ret, !dbg !18

assert_end83:                                     ; preds = %assert_end81
  %72 = getelementptr inbounds i8, ptr %B, i64 40, !dbg !18
  %73 = load i64, ptr %72, align 8, !dbg !18
  %74 = icmp eq i64 %73, 0, !dbg !18
  %old.bb.count115 = load i64, ptr @assert_end83_bbCounter, align 8
  %new.bb.count116 = add i64 %old.bb.count115, 1
  store i64 %new.bb.count116, ptr @assert_end83_bbCounter, align 8
  br i1 %74, label %assert_end85, label %assert_fail84, !dbg !18, !prof !19

assert_fail84:                                    ; preds = %assert_end83
  %old.bb.count117 = load i64, ptr @assert_fail84_bbCounter, align 8
  %new.bb.count118 = add i64 %old.bb.count117, 1
  store i64 %new.bb.count118, ptr @assert_fail84_bbCounter, align 8
  br label %common.ret, !dbg !18

assert_end85:                                     ; preds = %assert_end83
  %75 = getelementptr inbounds i8, ptr %B, i64 8, !dbg !18
  %76 = load i32, ptr %75, align 4, !dbg !18
  %77 = icmp eq i32 %76, 1, !dbg !18
  %old.bb.count119 = load i64, ptr @assert_end85_bbCounter, align 8
  %new.bb.count120 = add i64 %old.bb.count119, 1
  store i64 %new.bb.count120, ptr @assert_end85_bbCounter, align 8
  br i1 %77, label %assert_end87, label %assert_fail86, !dbg !18, !prof !19

assert_fail86:                                    ; preds = %assert_end85
  %old.bb.count121 = load i64, ptr @assert_fail86_bbCounter, align 8
  %new.bb.count122 = add i64 %old.bb.count121, 1
  store i64 %new.bb.count122, ptr @assert_fail86_bbCounter, align 8
  br label %common.ret, !dbg !18

assert_end87:                                     ; preds = %assert_end85
  %78 = getelementptr inbounds i8, ptr %B, i64 12, !dbg !18
  %79 = load i32, ptr %78, align 4, !dbg !18
  %80 = icmp eq i32 %dev_id, %79, !dbg !18
  %old.bb.count123 = load i64, ptr @assert_end87_bbCounter, align 8
  %new.bb.count124 = add i64 %old.bb.count123, 1
  store i64 %new.bb.count124, ptr @assert_end87_bbCounter, align 8
  br i1 %80, label %assert_end89, label %assert_fail88, !dbg !18, !prof !19

assert_fail88:                                    ; preds = %assert_end87
  %old.bb.count125 = load i64, ptr @assert_fail88_bbCounter, align 8
  %new.bb.count126 = add i64 %old.bb.count125, 1
  store i64 %new.bb.count126, ptr @assert_fail88_bbCounter, align 8
  br label %common.ret, !dbg !18

assert_end89:                                     ; preds = %assert_end87
  %81 = icmp ne ptr %B111, null, !dbg !18
  %82 = mul nsw i32 %N, %K, !dbg !18
  %83 = icmp eq i32 %82, 0, !dbg !18
  %84 = or i1 %83, %81, !dbg !18
  %old.bb.count127 = load i64, ptr @assert_end89_bbCounter, align 8
  %new.bb.count128 = add i64 %old.bb.count127, 1
  store i64 %new.bb.count128, ptr @assert_end89_bbCounter, align 8
  br i1 %84, label %assert_end91, label %assert_fail90, !dbg !18, !prof !19

assert_fail90:                                    ; preds = %assert_end89
  %old.bb.count129 = load i64, ptr @assert_fail90_bbCounter, align 8
  %new.bb.count130 = add i64 %old.bb.count129, 1
  store i64 %new.bb.count130, ptr @assert_fail90_bbCounter, align 8
  br label %common.ret, !dbg !18

assert_end91:                                     ; preds = %assert_end89
  %85 = getelementptr inbounds i8, ptr %T_matmul, i64 22, !dbg !18
  %86 = load i16, ptr %85, align 2, !dbg !18
  %87 = icmp eq i16 %86, 1, !dbg !18
  %88 = getelementptr inbounds i8, ptr %T_matmul, i64 21, !dbg !18
  %89 = load i8, ptr %88, align 1, !dbg !18
  %90 = icmp eq i8 %89, 32, !dbg !18
  %91 = getelementptr inbounds i8, ptr %T_matmul, i64 20, !dbg !18
  %92 = load i8, ptr %91, align 1, !dbg !18
  %93 = icmp eq i8 %92, 2, !dbg !18
  %94 = and i1 %90, %93, !dbg !18
  %95 = and i1 %87, %94, !dbg !18
  %old.bb.count131 = load i64, ptr @assert_end91_bbCounter, align 8
  %new.bb.count132 = add i64 %old.bb.count131, 1
  store i64 %new.bb.count132, ptr @assert_end91_bbCounter, align 8
  br i1 %95, label %assert_end93, label %assert_fail92, !dbg !18, !prof !19

assert_fail92:                                    ; preds = %assert_end91
  %old.bb.count133 = load i64, ptr @assert_fail92_bbCounter, align 8
  %new.bb.count134 = add i64 %old.bb.count133, 1
  store i64 %new.bb.count134, ptr @assert_fail92_bbCounter, align 8
  br label %common.ret, !dbg !18

assert_end93:                                     ; preds = %assert_end91
  %96 = load i64, ptr %matmul.T_matmul.shape, align 8, !dbg !18, !tbaa !86
  %97 = trunc i64 %96 to i32, !dbg !18
  %98 = icmp eq i32 %M, %97, !dbg !18
  %old.bb.count135 = load i64, ptr @assert_end93_bbCounter, align 8
  %new.bb.count136 = add i64 %old.bb.count135, 1
  store i64 %new.bb.count136, ptr @assert_end93_bbCounter, align 8
  br i1 %98, label %assert_end95, label %assert_fail94, !dbg !18, !prof !19

assert_fail94:                                    ; preds = %assert_end93
  %old.bb.count137 = load i64, ptr @assert_fail94_bbCounter, align 8
  %new.bb.count138 = add i64 %old.bb.count137, 1
  store i64 %new.bb.count138, ptr @assert_fail94_bbCounter, align 8
  br label %common.ret, !dbg !18

assert_end95:                                     ; preds = %assert_end93
  %99 = getelementptr inbounds i8, ptr %matmul.T_matmul.shape, i64 8, !dbg !18
  %100 = load i64, ptr %99, align 8, !dbg !18, !tbaa !96
  %101 = trunc i64 %100 to i32, !dbg !18
  %102 = icmp eq i32 %N, %101, !dbg !18
  %old.bb.count139 = load i64, ptr @assert_end95_bbCounter, align 8
  %new.bb.count140 = add i64 %old.bb.count139, 1
  store i64 %new.bb.count140, ptr @assert_end95_bbCounter, align 8
  br i1 %102, label %assert_end97, label %assert_fail96, !dbg !18, !prof !19

assert_fail96:                                    ; preds = %assert_end95
  %old.bb.count141 = load i64, ptr @assert_fail96_bbCounter, align 8
  %new.bb.count142 = add i64 %old.bb.count141, 1
  store i64 %new.bb.count142, ptr @assert_fail96_bbCounter, align 8
  br label %common.ret, !dbg !18

assert_end97:                                     ; preds = %assert_end95
  %103 = getelementptr inbounds i8, ptr %T_matmul, i64 40, !dbg !18
  %104 = load i64, ptr %103, align 8, !dbg !18
  %105 = icmp eq i64 %104, 0, !dbg !18
  %old.bb.count143 = load i64, ptr @assert_end97_bbCounter, align 8
  %new.bb.count144 = add i64 %old.bb.count143, 1
  store i64 %new.bb.count144, ptr @assert_end97_bbCounter, align 8
  br i1 %105, label %assert_end99, label %assert_fail98, !dbg !18, !prof !19

assert_fail98:                                    ; preds = %assert_end97
  %old.bb.count145 = load i64, ptr @assert_fail98_bbCounter, align 8
  %new.bb.count146 = add i64 %old.bb.count145, 1
  store i64 %new.bb.count146, ptr @assert_fail98_bbCounter, align 8
  br label %common.ret, !dbg !18

assert_end99:                                     ; preds = %assert_end97
  %106 = getelementptr inbounds i8, ptr %T_matmul, i64 8, !dbg !18
  %107 = load i32, ptr %106, align 4, !dbg !18
  %108 = icmp eq i32 %107, 1, !dbg !18
  %old.bb.count147 = load i64, ptr @assert_end99_bbCounter, align 8
  %new.bb.count148 = add i64 %old.bb.count147, 1
  store i64 %new.bb.count148, ptr @assert_end99_bbCounter, align 8
  br i1 %108, label %assert_end101, label %assert_fail100, !dbg !18, !prof !19

assert_fail100:                                   ; preds = %assert_end99
  %old.bb.count149 = load i64, ptr @assert_fail100_bbCounter, align 8
  %new.bb.count150 = add i64 %old.bb.count149, 1
  store i64 %new.bb.count150, ptr @assert_fail100_bbCounter, align 8
  br label %common.ret, !dbg !18

assert_end101:                                    ; preds = %assert_end99
  %109 = getelementptr inbounds i8, ptr %T_matmul, i64 12, !dbg !18
  %110 = load i32, ptr %109, align 4, !dbg !18
  %111 = icmp eq i32 %dev_id, %110, !dbg !18
  %old.bb.count151 = load i64, ptr @assert_end101_bbCounter, align 8
  %new.bb.count152 = add i64 %old.bb.count151, 1
  store i64 %new.bb.count152, ptr @assert_end101_bbCounter, align 8
  br i1 %111, label %assert_end103, label %assert_fail102, !dbg !18, !prof !19

assert_fail102:                                   ; preds = %assert_end101
  %old.bb.count153 = load i64, ptr @assert_fail102_bbCounter, align 8
  %new.bb.count154 = add i64 %old.bb.count153, 1
  store i64 %new.bb.count154, ptr @assert_fail102_bbCounter, align 8
  br label %common.ret, !dbg !18

assert_end103:                                    ; preds = %assert_end101
  %112 = icmp ne ptr %T_matmul106, null, !dbg !18
  %113 = mul nsw i32 %N, %M, !dbg !18
  %114 = icmp eq i32 %113, 0, !dbg !18
  %115 = or i1 %114, %112, !dbg !18
  %old.bb.count155 = load i64, ptr @assert_end103_bbCounter, align 8
  %new.bb.count156 = add i64 %old.bb.count155, 1
  store i64 %new.bb.count156, ptr @assert_end103_bbCounter, align 8
  br i1 %115, label %assert_end105, label %assert_fail104, !dbg !18, !prof !19

assert_fail104:                                   ; preds = %assert_end103
  %old.bb.count157 = load i64, ptr @assert_fail104_bbCounter, align 8
  %new.bb.count158 = add i64 %old.bb.count157, 1
  store i64 %new.bb.count158, ptr @assert_fail104_bbCounter, align 8
  br label %common.ret, !dbg !18

assert_end105:                                    ; preds = %assert_end103
  %old.bb.count159 = load i64, ptr @assert_end105_bbCounter, align 8
  %new.bb.count160 = add i64 %old.bb.count159, 1
  store i64 %new.bb.count160, ptr @assert_end105_bbCounter, align 8
  br label %common.ret, !dbg !18
}

; Function Attrs: nocallback nofree nosync nounwind willreturn memory(inaccessiblemem: write)
declare void @llvm.assume(i1 noundef) #1

; Function Attrs: nofree noinline norecurse nosync nounwind memory(argmem: readwrite)
define external fastcc void @matmul_compute_(i32 %M, i32 %N, ptr noalias nocapture writeonly align 64 %T_matmul, i32 %stride, i32 %stride1, i32 %K, ptr noalias nocapture readonly align 64 %A, i32 %stride2, i32 %stride3, ptr noalias nocapture readonly align 64 %B, i32 %stride4, i32 %stride5) unnamed_addr #2 !dbg !98 {
entry:
    #dbg_value(i32 %M, !102, !DIExpression(), !114)
    #dbg_value(i32 %N, !103, !DIExpression(), !114)
    #dbg_value(ptr %T_matmul, !104, !DIExpression(), !114)
    #dbg_value(i32 %stride, !105, !DIExpression(), !114)
    #dbg_value(i32 %stride1, !106, !DIExpression(), !114)
    #dbg_value(i32 %K, !107, !DIExpression(), !114)
    #dbg_value(ptr %A, !108, !DIExpression(), !114)
    #dbg_value(i32 %stride2, !109, !DIExpression(), !114)
    #dbg_value(i32 %stride3, !110, !DIExpression(), !114)
    #dbg_value(ptr %B, !111, !DIExpression(), !114)
    #dbg_value(i32 %stride4, !112, !DIExpression(), !114)
    #dbg_value(i32 %stride5, !113, !DIExpression(), !114)
    #dbg_declare(i32 0, !115, !DIExpression(), !114)
  %0 = icmp sgt i32 %M, 0, !dbg !114
  %1 = icmp sgt i32 %N, 0
  %or.cond = select i1 %0, i1 %1, i1 false, !dbg !114
  %old.bb.count = load i64, ptr @entry_bbCounter.1, align 8
  %new.bb.count = add i64 %old.bb.count, 1
  store i64 %new.bb.count, ptr @entry_bbCounter.1, align 8
  br i1 %or.cond, label %for_begin_ax1.preheader.lr.ph.split.us, label %for_end_ax0, !dbg !114, !prof !116

for_begin_ax1.preheader.lr.ph.split.us:           ; preds = %entry
  %2 = icmp sgt i32 %K, 0
  %old.bb.count3 = load i64, ptr @for_begin_ax1.preheader.lr.ph.split.us_bbCounter, align 8
  %new.bb.count4 = add i64 %old.bb.count3, 1
  store i64 %new.bb.count4, ptr @for_begin_ax1.preheader.lr.ph.split.us_bbCounter, align 8
  br i1 %2, label %for_begin_ax1.preheader.us.us.preheader, label %for_begin_ax1.preheader.us.preheader, !prof !117

for_begin_ax1.preheader.us.preheader:             ; preds = %for_begin_ax1.preheader.lr.ph.split.us
  %wide.trip.count19 = zext nneg i32 %M to i64, !dbg !114
  %wide.trip.count = zext nneg i32 %N to i64
  %min.iters.check = icmp ugt i32 %N, 7
  %ident.check.not = icmp eq i32 %stride1, 1
  %or.cond2 = select i1 %min.iters.check, i1 %ident.check.not, i1 false
  %n.vec = and i64 %wide.trip.count, 2147483640
  %cmp.n = icmp eq i64 %n.vec, %wide.trip.count
  %xtraiter = and i64 %wide.trip.count, 3
  %lcmp.mod.not = icmp eq i64 %xtraiter, 0
  %old.bb.count5 = load i64, ptr @for_begin_ax1.preheader.us.preheader_bbCounter, align 8
  %new.bb.count6 = add i64 %old.bb.count5, 1
  store i64 %new.bb.count6, ptr @for_begin_ax1.preheader.us.preheader_bbCounter, align 8
  br label %for_begin_ax1.preheader.us, !dbg !114

for_begin_ax1.preheader.us.us.preheader:          ; preds = %for_begin_ax1.preheader.lr.ph.split.us
  %wide.trip.count34 = zext nneg i32 %M to i64, !dbg !114
  %wide.trip.count29 = zext nneg i32 %N to i64
  %wide.trip.count24 = zext nneg i32 %K to i64
  %xtraiter4 = and i64 %wide.trip.count24, 1
  %3 = icmp eq i32 %K, 1
  %unroll_iter = and i64 %wide.trip.count24, 2147483646
  %lcmp.mod5.not = icmp eq i64 %xtraiter4, 0
  %old.bb.count7 = load i64, ptr @for_begin_ax1.preheader.us.us.preheader_bbCounter, align 8
  %new.bb.count8 = add i64 %old.bb.count7, 1
  store i64 %new.bb.count8, ptr @for_begin_ax1.preheader.us.us.preheader_bbCounter, align 8
  br label %for_begin_ax1.preheader.us.us, !dbg !114

for_begin_ax1.preheader.us.us:                    ; preds = %for_begin_ax1.preheader.us.us.preheader
    #dbg_declare(i64 undef, !115, !DIExpression(), !114)
    #dbg_declare(i32 0, !118, !DIExpression(), !114)
  %old.bb.count9 = load i64, ptr @for_begin_ax1.preheader.us.us_bbCounter, align 8
  %new.bb.count10 = add i64 %old.bb.count9, 1
  store i64 %new.bb.count10, ptr @for_begin_ax1.preheader.us.us_bbCounter, align 8
  br label %for_body_ax1.us.us.us, !dbg !114

for_body_ax1.us.us.us:                            ; preds = %for_begin_ax1.preheader.us.us
    #dbg_declare(i64 undef, !118, !DIExpression(), !114)
    #dbg_declare(i32 0, !119, !DIExpression(), !114)
  %old.bb.count11 = load i64, ptr @for_body_ax1.us.us.us_bbCounter, align 8
  %new.bb.count12 = add i64 %old.bb.count11, 1
  store i64 %new.bb.count12, ptr @for_body_ax1.us.us.us_bbCounter, align 8
  br i1 %3, label %for_begin_k.for_end_k_crit_edge.us.us.us.unr-lcssa, label %for_body_k.us.us.us.preheader, !dbg !114, !prof !120

for_body_k.us.us.us.preheader:                    ; preds = %for_body_ax1.us.us.us
  %old.bb.count13 = load i64, ptr @for_body_k.us.us.us.preheader_bbCounter, align 8
  %new.bb.count14 = add i64 %old.bb.count13, 1
  store i64 %new.bb.count14, ptr @for_body_k.us.us.us.preheader_bbCounter, align 8
  br label %for_body_k.us.us.us, !dbg !114

for_body_k.us.us.us:                              ; preds = %for_body_k.us.us.us.preheader
    #dbg_declare(i64 undef, !119, !DIExpression(), !114)
    #dbg_declare(i64 undef, !119, !DIExpression(), !114)
    #dbg_declare(i64 undef, !119, !DIExpression(), !114)
    #dbg_declare(i64 undef, !119, !DIExpression(), !114)
  %old.bb.count15 = load i64, ptr @for_body_k.us.us.us_bbCounter, align 8
  %new.bb.count16 = add i64 %old.bb.count15, 1
  store i64 %new.bb.count16, ptr @for_body_k.us.us.us_bbCounter, align 8
  br label %for_begin_k.for_end_k_crit_edge.us.us.us.unr-lcssa.loopexit

for_begin_k.for_end_k_crit_edge.us.us.us.unr-lcssa.loopexit: ; preds = %for_body_k.us.us.us
  %old.bb.count17 = load i64, ptr @for_begin_k.for_end_k_crit_edge.us.us.us.unr-lcssa.loopexit_bbCounter, align 8
  %new.bb.count18 = add i64 %old.bb.count17, 1
  store i64 %new.bb.count18, ptr @for_begin_k.for_end_k_crit_edge.us.us.us.unr-lcssa.loopexit_bbCounter, align 8
  br label %for_begin_k.for_end_k_crit_edge.us.us.us.unr-lcssa, !dbg !114

for_begin_k.for_end_k_crit_edge.us.us.us.unr-lcssa: ; preds = %for_begin_k.for_end_k_crit_edge.us.us.us.unr-lcssa.loopexit, %for_body_ax1.us.us.us
  %old.bb.count19 = load i64, ptr @for_begin_k.for_end_k_crit_edge.us.us.us.unr-lcssa_bbCounter, align 8
  %new.bb.count20 = add i64 %old.bb.count19, 1
  store i64 %new.bb.count20, ptr @for_begin_k.for_end_k_crit_edge.us.us.us.unr-lcssa_bbCounter, align 8
  br i1 %lcmp.mod5.not, label %for_begin_k.for_end_k_crit_edge.us.us.us, label %for_body_k.us.us.us.epil, !dbg !114, !prof !121

for_body_k.us.us.us.epil:                         ; preds = %for_begin_k.for_end_k_crit_edge.us.us.us.unr-lcssa
    #dbg_declare(i64 undef, !119, !DIExpression(), !114)
    #dbg_declare(i64 undef, !119, !DIExpression(DW_OP_plus_uconst, 1), !114)
  %old.bb.count21 = load i64, ptr @for_body_k.us.us.us.epil_bbCounter, align 8
  %new.bb.count22 = add i64 %old.bb.count21, 1
  store i64 %new.bb.count22, ptr @for_body_k.us.us.us.epil_bbCounter, align 8
  br label %for_begin_k.for_end_k_crit_edge.us.us.us, !dbg !114

for_begin_k.for_end_k_crit_edge.us.us.us:         ; preds = %for_body_k.us.us.us.epil, %for_begin_k.for_end_k_crit_edge.us.us.us.unr-lcssa
    #dbg_declare(i64 undef, !118, !DIExpression(), !114)
  %old.bb.count23 = load i64, ptr @for_begin_k.for_end_k_crit_edge.us.us.us_bbCounter, align 8
  %new.bb.count24 = add i64 %old.bb.count23, 1
  store i64 %new.bb.count24, ptr @for_begin_k.for_end_k_crit_edge.us.us.us_bbCounter, align 8
  br label %for_begin_ax1.for_end_ax1_crit_edge.split.us.us.us

for_begin_ax1.for_end_ax1_crit_edge.split.us.us.us: ; preds = %for_begin_k.for_end_k_crit_edge.us.us.us
    #dbg_declare(i64 undef, !115, !DIExpression(), !114)
  %old.bb.count25 = load i64, ptr @for_begin_ax1.for_end_ax1_crit_edge.split.us.us.us_bbCounter, align 8
  %new.bb.count26 = add i64 %old.bb.count25, 1
  store i64 %new.bb.count26, ptr @for_begin_ax1.for_end_ax1_crit_edge.split.us.us.us_bbCounter, align 8
  br label %for_end_ax0.loopexit

for_begin_ax1.preheader.us:                       ; preds = %for_begin_ax1.for_end_ax1_crit_edge.split.us11, %for_begin_ax1.preheader.us.preheader
  %indvars.iv16 = phi i64 [ 0, %for_begin_ax1.preheader.us.preheader ], [ %indvars.iv.next17, %for_begin_ax1.for_end_ax1_crit_edge.split.us11 ]
    #dbg_declare(i64 %indvars.iv16, !115, !DIExpression(), !114)
    #dbg_declare(i32 0, !118, !DIExpression(), !114)
  %old.bb.count27 = load i64, ptr @for_begin_ax1.preheader.us_bbCounter, align 8
  %new.bb.count28 = add i64 %old.bb.count27, 1
  store i64 %new.bb.count28, ptr @for_begin_ax1.preheader.us_bbCounter, align 8
  br i1 %or.cond2, label %vector.body.preheader, label %for_body_ax1.us9.preheader, !dbg !114, !prof !116

vector.body.preheader:                            ; preds = %for_begin_ax1.preheader.us
  %old.bb.count29 = load i64, ptr @vector.body.preheader_bbCounter, align 8
  %new.bb.count30 = add i64 %old.bb.count29, 1
  store i64 %new.bb.count30, ptr @vector.body.preheader_bbCounter, align 8
  br label %vector.body, !dbg !114

vector.body:                                      ; preds = %vector.body.preheader, %vector.body
  %index = phi i64 [ %index.next, %vector.body ], [ 0, %vector.body.preheader ], !dbg !114
  %index.next = add nuw i64 %index, 8, !dbg !114
  %4 = icmp eq i64 %index.next, %n.vec, !dbg !114
  %old.bb.count31 = load i64, ptr @vector.body_bbCounter, align 8
  %new.bb.count32 = add i64 %old.bb.count31, 1
  store i64 %new.bb.count32, ptr @vector.body_bbCounter, align 8
  br i1 %4, label %middle.block, label %vector.body, !dbg !114, !prof !122, !llvm.loop !123

middle.block:                                     ; preds = %vector.body
  %old.bb.count33 = load i64, ptr @middle.block_bbCounter, align 8
  %new.bb.count34 = add i64 %old.bb.count33, 1
  store i64 %new.bb.count34, ptr @middle.block_bbCounter, align 8
  br i1 %cmp.n, label %for_begin_ax1.for_end_ax1_crit_edge.split.us11, label %for_body_ax1.us9.preheader, !dbg !114, !prof !126

for_body_ax1.us9.preheader:                       ; preds = %middle.block, %for_begin_ax1.preheader.us
  %indvars.iv.ph = phi i64 [ 0, %for_begin_ax1.preheader.us ], [ %n.vec, %middle.block ]
  %old.bb.count35 = load i64, ptr @for_body_ax1.us9.preheader_bbCounter, align 8
  %new.bb.count36 = add i64 %old.bb.count35, 1
  store i64 %new.bb.count36, ptr @for_body_ax1.us9.preheader_bbCounter, align 8
  br i1 %lcmp.mod.not, label %for_body_ax1.us9.prol.loopexit, label %for_body_ax1.us9.prol.preheader, !dbg !114, !prof !117

for_body_ax1.us9.prol.preheader:                  ; preds = %for_body_ax1.us9.preheader
  %old.bb.count37 = load i64, ptr @for_body_ax1.us9.prol.preheader_bbCounter, align 8
  %new.bb.count38 = add i64 %old.bb.count37, 1
  store i64 %new.bb.count38, ptr @for_body_ax1.us9.prol.preheader_bbCounter, align 8
  br label %for_body_ax1.us9.prol, !dbg !114

for_body_ax1.us9.prol:                            ; preds = %for_body_ax1.us9.prol.preheader, %for_body_ax1.us9.prol
  %indvars.iv.prol = phi i64 [ %indvars.iv.next.prol, %for_body_ax1.us9.prol ], [ %indvars.iv.ph, %for_body_ax1.us9.prol.preheader ]
  %prol.iter = phi i64 [ %prol.iter.next, %for_body_ax1.us9.prol ], [ 0, %for_body_ax1.us9.prol.preheader ]
    #dbg_declare(i64 %indvars.iv.prol, !118, !DIExpression(), !114)
    #dbg_declare(i32 0, !119, !DIExpression(), !114)
  %indvars.iv.next.prol = add nuw nsw i64 %indvars.iv.prol, 1, !dbg !114
    #dbg_declare(i64 %indvars.iv.next.prol, !118, !DIExpression(), !114)
  %prol.iter.next = add i64 %prol.iter, 1, !dbg !114
  %prol.iter.cmp.not = icmp eq i64 %prol.iter.next, %xtraiter, !dbg !114
  %old.bb.count39 = load i64, ptr @for_body_ax1.us9.prol_bbCounter, align 8
  %new.bb.count40 = add i64 %old.bb.count39, 1
  store i64 %new.bb.count40, ptr @for_body_ax1.us9.prol_bbCounter, align 8
  br i1 %prol.iter.cmp.not, label %for_body_ax1.us9.prol.loopexit.loopexit, label %for_body_ax1.us9.prol, !dbg !114, !prof !121, !llvm.loop !127

for_body_ax1.us9.prol.loopexit.loopexit:          ; preds = %for_body_ax1.us9.prol
  %old.bb.count41 = load i64, ptr @for_body_ax1.us9.prol.loopexit.loopexit_bbCounter, align 8
  %new.bb.count42 = add i64 %old.bb.count41, 1
  store i64 %new.bb.count42, ptr @for_body_ax1.us9.prol.loopexit.loopexit_bbCounter, align 8
  br label %for_body_ax1.us9.prol.loopexit, !dbg !114

for_body_ax1.us9.prol.loopexit:                   ; preds = %for_body_ax1.us9.prol.loopexit.loopexit, %for_body_ax1.us9.preheader
  %indvars.iv.unr = phi i64 [ %indvars.iv.ph, %for_body_ax1.us9.preheader ], [ %indvars.iv.next.prol, %for_body_ax1.us9.prol.loopexit.loopexit ]
  %5 = sub nsw i64 %indvars.iv.ph, %wide.trip.count, !dbg !114
  %6 = icmp ugt i64 %5, -4, !dbg !114
  %old.bb.count43 = load i64, ptr @for_body_ax1.us9.prol.loopexit_bbCounter, align 8
  %new.bb.count44 = add i64 %old.bb.count43, 1
  store i64 %new.bb.count44, ptr @for_body_ax1.us9.prol.loopexit_bbCounter, align 8
  br i1 %6, label %for_begin_ax1.for_end_ax1_crit_edge.split.us11, label %for_body_ax1.us9.preheader1, !dbg !114, !prof !120

for_body_ax1.us9.preheader1:                      ; preds = %for_body_ax1.us9.prol.loopexit
  %old.bb.count45 = load i64, ptr @for_body_ax1.us9.preheader1_bbCounter, align 8
  %new.bb.count46 = add i64 %old.bb.count45, 1
  store i64 %new.bb.count46, ptr @for_body_ax1.us9.preheader1_bbCounter, align 8
  br label %for_body_ax1.us9, !dbg !114

for_body_ax1.us9:                                 ; preds = %for_body_ax1.us9.preheader1, %for_body_ax1.us9
  %indvars.iv = phi i64 [ %indvars.iv.next.3, %for_body_ax1.us9 ], [ %indvars.iv.unr, %for_body_ax1.us9.preheader1 ]
    #dbg_declare(i64 %indvars.iv, !118, !DIExpression(), !114)
    #dbg_declare(i32 0, !119, !DIExpression(), !114)
    #dbg_declare(i64 undef, !118, !DIExpression(), !114)
    #dbg_declare(i64 undef, !118, !DIExpression(), !114)
    #dbg_declare(i32 0, !119, !DIExpression(), !114)
    #dbg_declare(i64 undef, !118, !DIExpression(), !114)
    #dbg_declare(i64 undef, !118, !DIExpression(), !114)
    #dbg_declare(i32 0, !119, !DIExpression(), !114)
    #dbg_declare(i64 undef, !118, !DIExpression(), !114)
    #dbg_declare(i64 undef, !118, !DIExpression(), !114)
    #dbg_declare(i32 0, !119, !DIExpression(), !114)
  %indvars.iv.next.3 = add nuw nsw i64 %indvars.iv, 4, !dbg !114
    #dbg_declare(i64 %indvars.iv.next.3, !118, !DIExpression(), !114)
  %exitcond.not.3 = icmp eq i64 %indvars.iv.next.3, %wide.trip.count, !dbg !114
  %old.bb.count47 = load i64, ptr @for_body_ax1.us9_bbCounter, align 8
  %new.bb.count48 = add i64 %old.bb.count47, 1
  store i64 %new.bb.count48, ptr @for_body_ax1.us9_bbCounter, align 8
  br i1 %exitcond.not.3, label %for_begin_ax1.for_end_ax1_crit_edge.split.us11.loopexit, label %for_body_ax1.us9, !dbg !114, !prof !129, !llvm.loop !130

for_begin_ax1.for_end_ax1_crit_edge.split.us11.loopexit: ; preds = %for_body_ax1.us9
  %old.bb.count49 = load i64, ptr @for_begin_ax1.for_end_ax1_crit_edge.split.us11.loopexit_bbCounter, align 8
  %new.bb.count50 = add i64 %old.bb.count49, 1
  store i64 %new.bb.count50, ptr @for_begin_ax1.for_end_ax1_crit_edge.split.us11.loopexit_bbCounter, align 8
  br label %for_begin_ax1.for_end_ax1_crit_edge.split.us11, !dbg !114

for_begin_ax1.for_end_ax1_crit_edge.split.us11:   ; preds = %for_begin_ax1.for_end_ax1_crit_edge.split.us11.loopexit, %for_body_ax1.us9.prol.loopexit, %middle.block
  %indvars.iv.next17 = add nuw nsw i64 %indvars.iv16, 1, !dbg !114
    #dbg_declare(i64 %indvars.iv.next17, !115, !DIExpression(), !114)
  %exitcond20.not = icmp eq i64 %indvars.iv.next17, %wide.trip.count19, !dbg !114
  %old.bb.count51 = load i64, ptr @for_begin_ax1.for_end_ax1_crit_edge.split.us11_bbCounter, align 8
  %new.bb.count52 = add i64 %old.bb.count51, 1
  store i64 %new.bb.count52, ptr @for_begin_ax1.for_end_ax1_crit_edge.split.us11_bbCounter, align 8
  br i1 %exitcond20.not, label %for_end_ax0.loopexit2, label %for_begin_ax1.preheader.us, !dbg !114, !prof !131

for_end_ax0.loopexit:                             ; preds = %for_begin_ax1.for_end_ax1_crit_edge.split.us.us.us
  %old.bb.count53 = load i64, ptr @for_end_ax0.loopexit_bbCounter, align 8
  %new.bb.count54 = add i64 %old.bb.count53, 1
  store i64 %new.bb.count54, ptr @for_end_ax0.loopexit_bbCounter, align 8
  br label %for_end_ax0, !dbg !114

for_end_ax0.loopexit2:                            ; preds = %for_begin_ax1.for_end_ax1_crit_edge.split.us11
  %old.bb.count55 = load i64, ptr @for_end_ax0.loopexit2_bbCounter, align 8
  %new.bb.count56 = add i64 %old.bb.count55, 1
  store i64 %new.bb.count56, ptr @for_end_ax0.loopexit2_bbCounter, align 8
  br label %for_end_ax0, !dbg !114

for_end_ax0:                                      ; preds = %for_end_ax0.loopexit2, %for_end_ax0.loopexit, %entry
  %old.bb.count57 = load i64, ptr @for_end_ax0_bbCounter, align 8
  %new.bb.count58 = add i64 %old.bb.count57, 1
  store i64 %new.bb.count58, ptr @for_end_ax0_bbCounter, align 8
  call void @print_bb_count()
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
  %old.bb.count = load i64, ptr @b0_bbCounter, align 8
  %new.bb.count = add i64 %old.bb.count, 1
  store i64 %new.bb.count, ptr @b0_bbCounter, align 8
  br i1 %v4, label %b1, label %b5

b1:                                               ; preds = %b0
  %v8 = and i32 %v0, 8191
  %v9 = icmp ugt i32 %v8, 4096
  %old.bb.count1 = load i64, ptr @b1_bbCounter, align 8
  %new.bb.count2 = add i64 %old.bb.count1, 1
  store i64 %new.bb.count2, ptr @b1_bbCounter, align 8
  br i1 %v9, label %b2, label %b3

b2:                                               ; preds = %b1
  %old.bb.count3 = load i64, ptr @b2_bbCounter, align 8
  %new.bb.count4 = add i64 %old.bb.count3, 1
  store i64 %new.bb.count4, ptr @b2_bbCounter, align 8
  br label %b13

b3:                                               ; preds = %b1
  %v11 = icmp eq i32 %v8, 4096
  %old.bb.count5 = load i64, ptr @b3_bbCounter, align 8
  %new.bb.count6 = add i64 %old.bb.count5, 1
  store i64 %new.bb.count6, ptr @b3_bbCounter, align 8
  br i1 %v11, label %b4, label %b13

b4:                                               ; preds = %b3
  %old.bb.count7 = load i64, ptr @b4_bbCounter, align 8
  %new.bb.count8 = add i64 %old.bb.count7, 1
  store i64 %new.bb.count8, ptr @b4_bbCounter, align 8
  br label %b13

b5:                                               ; preds = %b0
  %v15 = icmp ugt i32 %v1, 2139095040
  %old.bb.count9 = load i64, ptr @b5_bbCounter, align 8
  %new.bb.count10 = add i64 %old.bb.count9, 1
  store i64 %new.bb.count10, ptr @b5_bbCounter, align 8
  br i1 %v15, label %b6, label %b7

b6:                                               ; preds = %b5
  %old.bb.count11 = load i64, ptr @b6_bbCounter, align 8
  %new.bb.count12 = add i64 %old.bb.count11, 1
  store i64 %new.bb.count12, ptr @b6_bbCounter, align 8
  br label %b13

b7:                                               ; preds = %b5
  %v19 = icmp ugt i32 %v1, 1199570943
  %old.bb.count13 = load i64, ptr @b7_bbCounter, align 8
  %new.bb.count14 = add i64 %old.bb.count13, 1
  store i64 %new.bb.count14, ptr @b7_bbCounter, align 8
  br i1 %v19, label %b13, label %b8

b8:                                               ; preds = %b7
  %v20 = icmp ult i32 %v1, 754974720
  %old.bb.count15 = load i64, ptr @b8_bbCounter, align 8
  %new.bb.count16 = add i64 %old.bb.count15, 1
  store i64 %new.bb.count16, ptr @b8_bbCounter, align 8
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
  %v31 = and i32 %v28, 8191
  %v32 = or i32 %v31, %v29
  %v33 = icmp ugt i32 %v32, 4096
  %old.bb.count17 = load i64, ptr @b9_bbCounter, align 8
  %new.bb.count18 = add i64 %old.bb.count17, 1
  store i64 %new.bb.count18, ptr @b9_bbCounter, align 8
  br i1 %v33, label %b10, label %b11

b10:                                              ; preds = %b9
  %old.bb.count19 = load i64, ptr @b10_bbCounter, align 8
  %new.bb.count20 = add i64 %old.bb.count19, 1
  store i64 %new.bb.count20, ptr @b10_bbCounter, align 8
  br label %b13

b11:                                              ; preds = %b9
  %v35 = icmp eq i32 %v32, 4096
  %old.bb.count21 = load i64, ptr @b11_bbCounter, align 8
  %new.bb.count22 = add i64 %old.bb.count21, 1
  store i64 %new.bb.count22, ptr @b11_bbCounter, align 8
  br i1 %v35, label %b12, label %b13

b12:                                              ; preds = %b11
  %old.bb.count23 = load i64, ptr @b12_bbCounter, align 8
  %new.bb.count24 = add i64 %old.bb.count23, 1
  store i64 %new.bb.count24, ptr @b12_bbCounter, align 8
  br label %b13

b13:                                              ; preds = %b12, %b11, %b10, %b8, %b7, %b6, %b4, %b3, %b2
  %old.bb.count25 = load i64, ptr @b13_bbCounter, align 8
  %new.bb.count26 = add i64 %old.bb.count25, 1
  store i64 %new.bb.count26, ptr @b13_bbCounter, align 8
  call void @print_bb_count()
  ret half undef
}

; Function Attrs: nofree nosync nounwind memory(none)
define weak dso_local float @__extendhfsf2(half %a0) local_unnamed_addr #4 section ".text.tvm.fp16.conv" {
b0:
  %0 = tail call half @llvm.fabs.f16(half %a0)
  %v1 = bitcast half %0 to i16
  %v3 = add nsw i16 %v1, -1024
  %v4 = icmp ult i16 %v3, 30720
  %old.bb.count = load i64, ptr @b0_bbCounter.2, align 8
  %new.bb.count = add i64 %old.bb.count, 1
  store i64 %new.bb.count, ptr @b0_bbCounter.2, align 8
  br i1 %v4, label %b1, label %b2

b1:                                               ; preds = %b0
  %old.bb.count1 = load i64, ptr @b1_bbCounter.3, align 8
  %new.bb.count2 = add i64 %old.bb.count1, 1
  store i64 %new.bb.count2, ptr @b1_bbCounter.3, align 8
  br label %b6

b2:                                               ; preds = %b0
  %v7 = icmp ugt i16 %v1, 31743
  %old.bb.count3 = load i64, ptr @b2_bbCounter.4, align 8
  %new.bb.count4 = add i64 %old.bb.count3, 1
  store i64 %new.bb.count4, ptr @b2_bbCounter.4, align 8
  br i1 %v7, label %b3, label %b4

b3:                                               ; preds = %b2
  %old.bb.count5 = load i64, ptr @b3_bbCounter.5, align 8
  %new.bb.count6 = add i64 %old.bb.count5, 1
  store i64 %new.bb.count6, ptr @b3_bbCounter.5, align 8
  br label %b6

b4:                                               ; preds = %b2
  %v10 = icmp eq i16 %v1, 0
  %old.bb.count7 = load i64, ptr @b4_bbCounter.6, align 8
  %new.bb.count8 = add i64 %old.bb.count7, 1
  store i64 %new.bb.count8, ptr @b4_bbCounter.6, align 8
  br i1 %v10, label %b6, label %b5

b5:                                               ; preds = %b4
  %old.bb.count9 = load i64, ptr @b5_bbCounter.7, align 8
  %new.bb.count10 = add i64 %old.bb.count9, 1
  store i64 %new.bb.count10, ptr @b5_bbCounter.7, align 8
  br label %b6

b6:                                               ; preds = %b5, %b4, %b3, %b1
  %old.bb.count11 = load i64, ptr @b6_bbCounter.8, align 8
  %new.bb.count12 = add i64 %old.bb.count11, 1
  store i64 %new.bb.count12, ptr @b6_bbCounter.8, align 8
  call void @print_bb_count()
  ret float undef
}

; Function Attrs: nocallback nofree nosync nounwind speculatable willreturn memory(none)
declare float @llvm.fabs.f32(float) #3

; Function Attrs: nocallback nofree nosync nounwind speculatable willreturn memory(none)
declare half @llvm.fabs.f16(half) #3

define void @print_bb_count() {
entry:
  %bb.count = load i64, ptr @entry_bbCounter, align 8
  call void @_Z5printl(i64 %bb.count)
  %bb.count1 = load i64, ptr @common.ret_bbCounter, align 8
  call void @_Z5printl(i64 %bb.count1)
  %bb.count2 = load i64, ptr @assert_fail_bbCounter, align 8
  call void @_Z5printl(i64 %bb.count2)
  %bb.count3 = load i64, ptr @assert_end_bbCounter, align 8
  call void @_Z5printl(i64 %bb.count3)
  %bb.count4 = load i64, ptr @assert_fail1_bbCounter, align 8
  call void @_Z5printl(i64 %bb.count4)
  %bb.count5 = load i64, ptr @assert_end2_bbCounter, align 8
  call void @_Z5printl(i64 %bb.count5)
  %bb.count6 = load i64, ptr @assert_fail3_bbCounter, align 8
  call void @_Z5printl(i64 %bb.count6)
  %bb.count7 = load i64, ptr @assert_end4_bbCounter, align 8
  call void @_Z5printl(i64 %bb.count7)
  %bb.count8 = load i64, ptr @assert_fail5_bbCounter, align 8
  call void @_Z5printl(i64 %bb.count8)
  %bb.count9 = load i64, ptr @assert_end6_bbCounter, align 8
  call void @_Z5printl(i64 %bb.count9)
  %bb.count10 = load i64, ptr @assert_fail7_bbCounter, align 8
  call void @_Z5printl(i64 %bb.count10)
  %bb.count11 = load i64, ptr @assert_end8_bbCounter, align 8
  call void @_Z5printl(i64 %bb.count11)
  %bb.count12 = load i64, ptr @assert_fail9_bbCounter, align 8
  call void @_Z5printl(i64 %bb.count12)
  %bb.count13 = load i64, ptr @assert_end10_bbCounter, align 8
  call void @_Z5printl(i64 %bb.count13)
  %bb.count14 = load i64, ptr @assert_fail11_bbCounter, align 8
  call void @_Z5printl(i64 %bb.count14)
  %bb.count15 = load i64, ptr @assert_end12_bbCounter, align 8
  call void @_Z5printl(i64 %bb.count15)
  %bb.count16 = load i64, ptr @assert_fail13_bbCounter, align 8
  call void @_Z5printl(i64 %bb.count16)
  %bb.count17 = load i64, ptr @assert_end14_bbCounter, align 8
  call void @_Z5printl(i64 %bb.count17)
  %bb.count18 = load i64, ptr @if_else_bbCounter, align 8
  call void @_Z5printl(i64 %bb.count18)
  %bb.count19 = load i64, ptr @if_end_bbCounter, align 8
  call void @_Z5printl(i64 %bb.count19)
  %bb.count20 = load i64, ptr @if_end.thread_bbCounter, align 8
  call void @_Z5printl(i64 %bb.count20)
  %bb.count21 = load i64, ptr @if_else16_bbCounter, align 8
  call void @_Z5printl(i64 %bb.count21)
  %bb.count22 = load i64, ptr @if_else19_bbCounter, align 8
  call void @_Z5printl(i64 %bb.count22)
  %bb.count23 = load i64, ptr @if_end20_bbCounter, align 8
  call void @_Z5printl(i64 %bb.count23)
  %bb.count24 = load i64, ptr @if_else22_bbCounter, align 8
  call void @_Z5printl(i64 %bb.count24)
  %bb.count25 = load i64, ptr @assert_fail28_bbCounter, align 8
  call void @_Z5printl(i64 %bb.count25)
  %bb.count26 = load i64, ptr @assert_end29_bbCounter, align 8
  call void @_Z5printl(i64 %bb.count26)
  %bb.count27 = load i64, ptr @assert_fail30_bbCounter, align 8
  call void @_Z5printl(i64 %bb.count27)
  %bb.count28 = load i64, ptr @assert_end31_bbCounter, align 8
  call void @_Z5printl(i64 %bb.count28)
  %bb.count29 = load i64, ptr @if_else33_bbCounter, align 8
  call void @_Z5printl(i64 %bb.count29)
  %bb.count30 = load i64, ptr @if_end34_bbCounter, align 8
  call void @_Z5printl(i64 %bb.count30)
  %bb.count31 = load i64, ptr @if_end34.thread_bbCounter, align 8
  call void @_Z5printl(i64 %bb.count31)
  %bb.count32 = load i64, ptr @if_else36_bbCounter, align 8
  call void @_Z5printl(i64 %bb.count32)
  %bb.count33 = load i64, ptr @if_else41_bbCounter, align 8
  call void @_Z5printl(i64 %bb.count33)
  %bb.count34 = load i64, ptr @if_end42_bbCounter, align 8
  call void @_Z5printl(i64 %bb.count34)
  %bb.count35 = load i64, ptr @if_else44_bbCounter, align 8
  call void @_Z5printl(i64 %bb.count35)
  %bb.count36 = load i64, ptr @assert_fail50_bbCounter, align 8
  call void @_Z5printl(i64 %bb.count36)
  %bb.count37 = load i64, ptr @assert_end51_bbCounter, align 8
  call void @_Z5printl(i64 %bb.count37)
  %bb.count38 = load i64, ptr @assert_fail52_bbCounter, align 8
  call void @_Z5printl(i64 %bb.count38)
  %bb.count39 = load i64, ptr @assert_end53_bbCounter, align 8
  call void @_Z5printl(i64 %bb.count39)
  %bb.count40 = load i64, ptr @if_else55_bbCounter, align 8
  call void @_Z5printl(i64 %bb.count40)
  %bb.count41 = load i64, ptr @if_end56_bbCounter, align 8
  call void @_Z5printl(i64 %bb.count41)
  %bb.count42 = load i64, ptr @if_end56.thread_bbCounter, align 8
  call void @_Z5printl(i64 %bb.count42)
  %bb.count43 = load i64, ptr @if_else58_bbCounter, align 8
  call void @_Z5printl(i64 %bb.count43)
  %bb.count44 = load i64, ptr @if_else63_bbCounter, align 8
  call void @_Z5printl(i64 %bb.count44)
  %bb.count45 = load i64, ptr @if_end64_bbCounter, align 8
  call void @_Z5printl(i64 %bb.count45)
  %bb.count46 = load i64, ptr @if_else66_bbCounter, align 8
  call void @_Z5printl(i64 %bb.count46)
  %bb.count47 = load i64, ptr @assert_fail72_bbCounter, align 8
  call void @_Z5printl(i64 %bb.count47)
  %bb.count48 = load i64, ptr @assert_end73_bbCounter, align 8
  call void @_Z5printl(i64 %bb.count48)
  %bb.count49 = load i64, ptr @assert_fail74_bbCounter, align 8
  call void @_Z5printl(i64 %bb.count49)
  %bb.count50 = load i64, ptr @assert_end75_bbCounter, align 8
  call void @_Z5printl(i64 %bb.count50)
  %bb.count51 = load i64, ptr @assert_fail76_bbCounter, align 8
  call void @_Z5printl(i64 %bb.count51)
  %bb.count52 = load i64, ptr @assert_end77_bbCounter, align 8
  call void @_Z5printl(i64 %bb.count52)
  %bb.count53 = load i64, ptr @assert_fail78_bbCounter, align 8
  call void @_Z5printl(i64 %bb.count53)
  %bb.count54 = load i64, ptr @assert_end79_bbCounter, align 8
  call void @_Z5printl(i64 %bb.count54)
  %bb.count55 = load i64, ptr @assert_fail80_bbCounter, align 8
  call void @_Z5printl(i64 %bb.count55)
  %bb.count56 = load i64, ptr @assert_end81_bbCounter, align 8
  call void @_Z5printl(i64 %bb.count56)
  %bb.count57 = load i64, ptr @assert_fail82_bbCounter, align 8
  call void @_Z5printl(i64 %bb.count57)
  %bb.count58 = load i64, ptr @assert_end83_bbCounter, align 8
  call void @_Z5printl(i64 %bb.count58)
  %bb.count59 = load i64, ptr @assert_fail84_bbCounter, align 8
  call void @_Z5printl(i64 %bb.count59)
  %bb.count60 = load i64, ptr @assert_end85_bbCounter, align 8
  call void @_Z5printl(i64 %bb.count60)
  %bb.count61 = load i64, ptr @assert_fail86_bbCounter, align 8
  call void @_Z5printl(i64 %bb.count61)
  %bb.count62 = load i64, ptr @assert_end87_bbCounter, align 8
  call void @_Z5printl(i64 %bb.count62)
  %bb.count63 = load i64, ptr @assert_fail88_bbCounter, align 8
  call void @_Z5printl(i64 %bb.count63)
  %bb.count64 = load i64, ptr @assert_end89_bbCounter, align 8
  call void @_Z5printl(i64 %bb.count64)
  %bb.count65 = load i64, ptr @assert_fail90_bbCounter, align 8
  call void @_Z5printl(i64 %bb.count65)
  %bb.count66 = load i64, ptr @assert_end91_bbCounter, align 8
  call void @_Z5printl(i64 %bb.count66)
  %bb.count67 = load i64, ptr @assert_fail92_bbCounter, align 8
  call void @_Z5printl(i64 %bb.count67)
  %bb.count68 = load i64, ptr @assert_end93_bbCounter, align 8
  call void @_Z5printl(i64 %bb.count68)
  %bb.count69 = load i64, ptr @assert_fail94_bbCounter, align 8
  call void @_Z5printl(i64 %bb.count69)
  %bb.count70 = load i64, ptr @assert_end95_bbCounter, align 8
  call void @_Z5printl(i64 %bb.count70)
  %bb.count71 = load i64, ptr @assert_fail96_bbCounter, align 8
  call void @_Z5printl(i64 %bb.count71)
  %bb.count72 = load i64, ptr @assert_end97_bbCounter, align 8
  call void @_Z5printl(i64 %bb.count72)
  %bb.count73 = load i64, ptr @assert_fail98_bbCounter, align 8
  call void @_Z5printl(i64 %bb.count73)
  %bb.count74 = load i64, ptr @assert_end99_bbCounter, align 8
  call void @_Z5printl(i64 %bb.count74)
  %bb.count75 = load i64, ptr @assert_fail100_bbCounter, align 8
  call void @_Z5printl(i64 %bb.count75)
  %bb.count76 = load i64, ptr @assert_end101_bbCounter, align 8
  call void @_Z5printl(i64 %bb.count76)
  %bb.count77 = load i64, ptr @assert_fail102_bbCounter, align 8
  call void @_Z5printl(i64 %bb.count77)
  %bb.count78 = load i64, ptr @assert_end103_bbCounter, align 8
  call void @_Z5printl(i64 %bb.count78)
  %bb.count79 = load i64, ptr @assert_fail104_bbCounter, align 8
  call void @_Z5printl(i64 %bb.count79)
  %bb.count80 = load i64, ptr @assert_end105_bbCounter, align 8
  call void @_Z5printl(i64 %bb.count80)
  %bb.count81 = load i64, ptr @entry_bbCounter.1, align 8
  call void @_Z5printl(i64 %bb.count81)
  %bb.count82 = load i64, ptr @for_begin_ax1.preheader.lr.ph.split.us_bbCounter, align 8
  call void @_Z5printl(i64 %bb.count82)
  %bb.count83 = load i64, ptr @for_begin_ax1.preheader.us.preheader_bbCounter, align 8
  call void @_Z5printl(i64 %bb.count83)
  %bb.count84 = load i64, ptr @for_begin_ax1.preheader.us.us.preheader_bbCounter, align 8
  call void @_Z5printl(i64 %bb.count84)
  %bb.count85 = load i64, ptr @for_begin_ax1.preheader.us.us_bbCounter, align 8
  call void @_Z5printl(i64 %bb.count85)
  %bb.count86 = load i64, ptr @for_body_ax1.us.us.us_bbCounter, align 8
  call void @_Z5printl(i64 %bb.count86)
  %bb.count87 = load i64, ptr @for_body_k.us.us.us.preheader_bbCounter, align 8
  call void @_Z5printl(i64 %bb.count87)
  %bb.count88 = load i64, ptr @for_body_k.us.us.us_bbCounter, align 8
  call void @_Z5printl(i64 %bb.count88)
  %bb.count89 = load i64, ptr @for_begin_k.for_end_k_crit_edge.us.us.us.unr-lcssa.loopexit_bbCounter, align 8
  call void @_Z5printl(i64 %bb.count89)
  %bb.count90 = load i64, ptr @for_begin_k.for_end_k_crit_edge.us.us.us.unr-lcssa_bbCounter, align 8
  call void @_Z5printl(i64 %bb.count90)
  %bb.count91 = load i64, ptr @for_body_k.us.us.us.epil_bbCounter, align 8
  call void @_Z5printl(i64 %bb.count91)
  %bb.count92 = load i64, ptr @for_begin_k.for_end_k_crit_edge.us.us.us_bbCounter, align 8
  call void @_Z5printl(i64 %bb.count92)
  %bb.count93 = load i64, ptr @for_begin_ax1.for_end_ax1_crit_edge.split.us.us.us_bbCounter, align 8
  call void @_Z5printl(i64 %bb.count93)
  %bb.count94 = load i64, ptr @for_begin_ax1.preheader.us_bbCounter, align 8
  call void @_Z5printl(i64 %bb.count94)
  %bb.count95 = load i64, ptr @vector.body.preheader_bbCounter, align 8
  call void @_Z5printl(i64 %bb.count95)
  %bb.count96 = load i64, ptr @vector.body_bbCounter, align 8
  call void @_Z5printl(i64 %bb.count96)
  %bb.count97 = load i64, ptr @middle.block_bbCounter, align 8
  call void @_Z5printl(i64 %bb.count97)
  %bb.count98 = load i64, ptr @for_body_ax1.us9.preheader_bbCounter, align 8
  call void @_Z5printl(i64 %bb.count98)
  %bb.count99 = load i64, ptr @for_body_ax1.us9.prol.preheader_bbCounter, align 8
  call void @_Z5printl(i64 %bb.count99)
  %bb.count100 = load i64, ptr @for_body_ax1.us9.prol_bbCounter, align 8
  call void @_Z5printl(i64 %bb.count100)
  %bb.count101 = load i64, ptr @for_body_ax1.us9.prol.loopexit.loopexit_bbCounter, align 8
  call void @_Z5printl(i64 %bb.count101)
  %bb.count102 = load i64, ptr @for_body_ax1.us9.prol.loopexit_bbCounter, align 8
  call void @_Z5printl(i64 %bb.count102)
  %bb.count103 = load i64, ptr @for_body_ax1.us9.preheader1_bbCounter, align 8
  call void @_Z5printl(i64 %bb.count103)
  %bb.count104 = load i64, ptr @for_body_ax1.us9_bbCounter, align 8
  call void @_Z5printl(i64 %bb.count104)
  %bb.count105 = load i64, ptr @for_begin_ax1.for_end_ax1_crit_edge.split.us11.loopexit_bbCounter, align 8
  call void @_Z5printl(i64 %bb.count105)
  %bb.count106 = load i64, ptr @for_begin_ax1.for_end_ax1_crit_edge.split.us11_bbCounter, align 8
  call void @_Z5printl(i64 %bb.count106)
  %bb.count107 = load i64, ptr @for_end_ax0.loopexit_bbCounter, align 8
  call void @_Z5printl(i64 %bb.count107)
  %bb.count108 = load i64, ptr @for_end_ax0.loopexit2_bbCounter, align 8
  call void @_Z5printl(i64 %bb.count108)
  %bb.count109 = load i64, ptr @for_end_ax0_bbCounter, align 8
  call void @_Z5printl(i64 %bb.count109)
  %bb.count110 = load i64, ptr @b0_bbCounter, align 8
  call void @_Z5printl(i64 %bb.count110)
  %bb.count111 = load i64, ptr @b1_bbCounter, align 8
  call void @_Z5printl(i64 %bb.count111)
  %bb.count112 = load i64, ptr @b2_bbCounter, align 8
  call void @_Z5printl(i64 %bb.count112)
  %bb.count113 = load i64, ptr @b3_bbCounter, align 8
  call void @_Z5printl(i64 %bb.count113)
  %bb.count114 = load i64, ptr @b4_bbCounter, align 8
  call void @_Z5printl(i64 %bb.count114)
  %bb.count115 = load i64, ptr @b5_bbCounter, align 8
  call void @_Z5printl(i64 %bb.count115)
  %bb.count116 = load i64, ptr @b6_bbCounter, align 8
  call void @_Z5printl(i64 %bb.count116)
  %bb.count117 = load i64, ptr @b7_bbCounter, align 8
  call void @_Z5printl(i64 %bb.count117)
  %bb.count118 = load i64, ptr @b8_bbCounter, align 8
  call void @_Z5printl(i64 %bb.count118)
  %bb.count119 = load i64, ptr @b9_bbCounter, align 8
  call void @_Z5printl(i64 %bb.count119)
  %bb.count120 = load i64, ptr @b10_bbCounter, align 8
  call void @_Z5printl(i64 %bb.count120)
  %bb.count121 = load i64, ptr @b11_bbCounter, align 8
  call void @_Z5printl(i64 %bb.count121)
  %bb.count122 = load i64, ptr @b12_bbCounter, align 8
  call void @_Z5printl(i64 %bb.count122)
  %bb.count123 = load i64, ptr @b13_bbCounter, align 8
  call void @_Z5printl(i64 %bb.count123)
  %bb.count124 = load i64, ptr @b0_bbCounter.2, align 8
  call void @_Z5printl(i64 %bb.count124)
  %bb.count125 = load i64, ptr @b1_bbCounter.3, align 8
  call void @_Z5printl(i64 %bb.count125)
  %bb.count126 = load i64, ptr @b2_bbCounter.4, align 8
  call void @_Z5printl(i64 %bb.count126)
  %bb.count127 = load i64, ptr @b3_bbCounter.5, align 8
  call void @_Z5printl(i64 %bb.count127)
  %bb.count128 = load i64, ptr @b4_bbCounter.6, align 8
  call void @_Z5printl(i64 %bb.count128)
  %bb.count129 = load i64, ptr @b5_bbCounter.7, align 8
  call void @_Z5printl(i64 %bb.count129)
  %bb.count130 = load i64, ptr @b6_bbCounter.8, align 8
  call void @_Z5printl(i64 %bb.count130)
  ret void
}

declare void @_Z5printl(i64)

attributes #0 = { "target-cpu"="generic" }
attributes #1 = { nocallback nofree nosync nounwind willreturn memory(inaccessiblemem: write) }
attributes #2 = { nofree noinline norecurse nosync nounwind memory(argmem: readwrite) "target-cpu"="generic" }
attributes #3 = { nocallback nofree nosync nounwind speculatable willreturn memory(none) }
attributes #4 = { nofree nosync nounwind memory(none) "target-cpu"="generic" "target-features" }

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
!20 = !{!"branch_weights", i32 1, i32 1048576}
!21 = !{!22, !22, i64 0}
!22 = !{!"0x5f597a0ce0f0.w4.b0", !23, i64 0}
!23 = !{!"0x5f597a0ce0f0.w8.b0", !24, i64 0}
!24 = !{!"0x5f597a0ce0f0.w16.b0", !25, i64 0}
!25 = !{!"0x5f597a0ce0f0.w32.b0", !26, i64 0}
!26 = !{!"0x5f597a0ce0f0.w64.b0", !27, i64 0}
!27 = !{!"0x5f597a0ce0f0.w128.b0", !28, i64 0}
!28 = !{!"0x5f597a0ce0f0.w256.b0", !29, i64 0}
!29 = !{!"0x5f597a0ce0f0.w512.b0", !30, i64 0}
!30 = !{!"0x5f597a0ce0f0.w1024.b0", !31, i64 0}
!31 = !{!"0x5f597a0ce0f0", !32, i64 0}
!32 = !{!"tvm-tbaa"}
!33 = !DILocalVariable(name: "A.code", scope: !5, file: !1, type: !8)
!34 = !{!35, !35, i64 0}
!35 = !{!"0x5f597a0ce0f0.w4.b4", !23, i64 0}
!36 = !DILocalVariable(name: "B.code", scope: !5, file: !1, type: !8)
!37 = !{!38, !38, i64 0}
!38 = !{!"0x5f597a0ce0f0.w4.b8", !39, i64 0}
!39 = !{!"0x5f597a0ce0f0.w8.b8", !24, i64 0}
!40 = !DILocalVariable(name: "T_matmul.code", scope: !5, file: !1, type: !8)
!41 = !DILocalVariable(name: "A", scope: !5, file: !1, type: !9)
!42 = !DILocalVariable(name: "B", scope: !5, file: !1, type: !9)
!43 = !DILocalVariable(name: "T_matmul", scope: !5, file: !1, type: !9)
!44 = !DILocalVariable(name: "matmul.A.shape", scope: !5, file: !1, type: !45)
!45 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !46)
!46 = !DIBasicType(name: "int64", size: 64, encoding: DW_ATE_signed)
!47 = !{!48, !48, i64 0}
!48 = !{!"0x5f597a13d420.w8.b0", !49, i64 0}
!49 = !{!"0x5f597a13d420.w16.b0", !50, i64 0}
!50 = !{!"0x5f597a13d420.w32.b0", !51, i64 0}
!51 = !{!"0x5f597a13d420.w64.b0", !52, i64 0}
!52 = !{!"0x5f597a13d420.w128.b0", !53, i64 0}
!53 = !{!"0x5f597a13d420.w256.b0", !54, i64 0}
!54 = !{!"0x5f597a13d420.w512.b0", !55, i64 0}
!55 = !{!"0x5f597a13d420.w1024.b0", !56, i64 0}
!56 = !{!"0x5f597a13d420", !32, i64 0}
!57 = !DILocalVariable(name: "M", scope: !5, file: !1, type: !8)
!58 = !{!59, !59, i64 0}
!59 = !{!"0x5f597a13d420.w8.b8", !49, i64 0}
!60 = !DILocalVariable(name: "K", scope: !5, file: !1, type: !8)
!61 = !DILocalVariable(name: "matmul.A.strides", scope: !5, file: !1, type: !45)
!62 = !DILocalVariable(name: "stride", scope: !5, file: !1, type: !8)
!63 = !DILocalVariable(name: "dev_id", scope: !5, file: !1, type: !8)
!64 = !DILocalVariable(name: "A", scope: !5, file: !1, type: !65)
!65 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !66)
!66 = !DIBasicType(name: "float32", size: 32, encoding: DW_ATE_float)
!67 = !DILocalVariable(name: "matmul.B.shape", scope: !5, file: !1, type: !45)
!68 = !{!69, !69, i64 0}
!69 = !{!"0x5f597a174950.w8.b8", !70, i64 0}
!70 = !{!"0x5f597a174950.w16.b0", !71, i64 0}
!71 = !{!"0x5f597a174950.w32.b0", !72, i64 0}
!72 = !{!"0x5f597a174950.w64.b0", !73, i64 0}
!73 = !{!"0x5f597a174950.w128.b0", !74, i64 0}
!74 = !{!"0x5f597a174950.w256.b0", !75, i64 0}
!75 = !{!"0x5f597a174950.w512.b0", !76, i64 0}
!76 = !{!"0x5f597a174950.w1024.b0", !77, i64 0}
!77 = !{!"0x5f597a174950", !32, i64 0}
!78 = !DILocalVariable(name: "N", scope: !5, file: !1, type: !8)
!79 = !DILocalVariable(name: "matmul.B.strides", scope: !5, file: !1, type: !45)
!80 = !DILocalVariable(name: "B", scope: !5, file: !1, type: !65)
!81 = !DILocalVariable(name: "matmul.T_matmul.shape", scope: !5, file: !1, type: !45)
!82 = !DILocalVariable(name: "matmul.T_matmul.strides", scope: !5, file: !1, type: !45)
!83 = !DILocalVariable(name: "T_matmul", scope: !5, file: !1, type: !65)
!84 = !{!85, !85, i64 0}
!85 = !{!"0x5f597a174950.w8.b0", !70, i64 0}
!86 = !{!87, !87, i64 0}
!87 = !{!"0x5f597a1775e0.w8.b0", !88, i64 0}
!88 = !{!"0x5f597a1775e0.w16.b0", !89, i64 0}
!89 = !{!"0x5f597a1775e0.w32.b0", !90, i64 0}
!90 = !{!"0x5f597a1775e0.w64.b0", !91, i64 0}
!91 = !{!"0x5f597a1775e0.w128.b0", !92, i64 0}
!92 = !{!"0x5f597a1775e0.w256.b0", !93, i64 0}
!93 = !{!"0x5f597a1775e0.w512.b0", !94, i64 0}
!94 = !{!"0x5f597a1775e0.w1024.b0", !95, i64 0}
!95 = !{!"0x5f597a1775e0", !32, i64 0}
!96 = !{!97, !97, i64 0}
!97 = !{!"0x5f597a1775e0.w8.b8", !88, i64 0}
!98 = distinct !DISubprogram(name: "matmul_compute_", scope: !1, file: !1, type: !99, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !0, retainedNodes: !101)
!99 = !DISubroutineType(cc: DW_CC_nocall, types: !100)
!100 = !{!8, !8, !8, !65, !8, !8, !8, !65, !8, !8, !65, !8, !8}
!101 = !{!102, !103, !104, !105, !106, !107, !108, !109, !110, !111, !112, !113}
!102 = !DILocalVariable(name: "M", arg: 1, scope: !98, file: !1, type: !8)
!103 = !DILocalVariable(name: "N", arg: 2, scope: !98, file: !1, type: !8)
!104 = !DILocalVariable(name: "T_matmul", arg: 3, scope: !98, file: !1, type: !65)
!105 = !DILocalVariable(name: "stride", arg: 4, scope: !98, file: !1, type: !8)
!106 = !DILocalVariable(name: "stride1", arg: 5, scope: !98, file: !1, type: !8)
!107 = !DILocalVariable(name: "K", arg: 6, scope: !98, file: !1, type: !8)
!108 = !DILocalVariable(name: "A", arg: 7, scope: !98, file: !1, type: !65)
!109 = !DILocalVariable(name: "stride2", arg: 8, scope: !98, file: !1, type: !8)
!110 = !DILocalVariable(name: "stride3", arg: 9, scope: !98, file: !1, type: !8)
!111 = !DILocalVariable(name: "B", arg: 10, scope: !98, file: !1, type: !65)
!112 = !DILocalVariable(name: "stride4", arg: 11, scope: !98, file: !1, type: !8)
!113 = !DILocalVariable(name: "stride5", arg: 12, scope: !98, file: !1, type: !8)
!114 = !DILocation(line: 0, scope: !98)
!115 = !DILocalVariable(name: "ax0", scope: !98, file: !1, type: !8)
!116 = !{!"branch_weights", i32 16129, i32 255}
!117 = !{!"branch_weights", i32 127, i32 1}
!118 = !DILocalVariable(name: "ax1", scope: !98, file: !1, type: !8)
!119 = !DILocalVariable(name: "k", scope: !98, file: !1, type: !8)
!120 = !{!"branch_weights", i32 1, i32 127}
!121 = !{!"branch_weights", i32 1, i32 1}
!122 = !{!"branch_weights", i32 127, i32 16777081}
!123 = distinct !{!123, !124, !125}
!124 = !{!"llvm.loop.isvectorized", i32 1}
!125 = !{!"llvm.loop.unroll.runtime.disable"}
!126 = !{!"branch_weights", i32 1, i32 7}
!127 = distinct !{!127, !128}
!128 = !{!"llvm.loop.unroll.disable"}
!129 = !{!"branch_weights", i32 0, i32 0}
!130 = distinct !{!130, !124}
!131 = !{!"branch_weights", i32 127, i32 134217601}
