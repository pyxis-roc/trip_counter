; ModuleID = '../../../kernel_examples/matmul/matmul_kernel.llir'
source_filename = "LLVMDialectModule"

@global_smem = external local_unnamed_addr addrspace(3) global [0 x i8], align 16
@_bbCounter = common global i64 0
@_bbCounter.1 = common global i64 0
@.._crit_edge_crit_edge_bbCounter = common global i64 0
@.lr.ph_bbCounter = common global i64 0
@._crit_edge.loopexit_bbCounter = common global i64 0
@._crit_edge_bbCounter = common global i64 0

define void @matmul_kernel(ptr addrspace(1) %0, ptr addrspace(1) %1, ptr addrspace(1) %2, i32 %3, i32 %4, i32 %5, i32 %6, i32 %7, i32 %8) local_unnamed_addr !dbg !7 {
  %10 = add i32 %5, 31, !dbg !10
  %11 = sdiv i32 %10, 32, !dbg !14
  %12 = icmp sgt i32 %10, 31, !dbg !15
  %old.bb.count1 = load i32, ptr @_bbCounter.1, align 4
  %new.bb.count2 = add i32 %old.bb.count1, 1
  store i32 %new.bb.count2, ptr @_bbCounter.1, align 4
  br i1 %12, label %.lr.ph, label %.._crit_edge_crit_edge, !dbg !15

.._crit_edge_crit_edge:                           ; preds = %9
  %old.bb.count3 = load i32, ptr @.._crit_edge_crit_edge_bbCounter, align 4
  %new.bb.count4 = add i32 %old.bb.count3, 1
  store i32 %new.bb.count4, ptr @.._crit_edge_crit_edge_bbCounter, align 4
  br label %._crit_edge, !dbg !15

.lr.ph:                                           ; preds = %9
  %13 = add nsw i32 %11, -1, !dbg !15
  %old.bb.count5 = load i32, ptr @.lr.ph_bbCounter, align 4
  %new.bb.count6 = add i32 %old.bb.count5, 1
  store i32 %new.bb.count6, ptr @.lr.ph_bbCounter, align 4
  br label %14, !dbg !15

14:                                               ; preds = %.lr.ph
  %old.bb.count = load i32, ptr @_bbCounter, align 4
  %new.bb.count = add i32 %old.bb.count, %13
  store i32 %new.bb.count, ptr @_bbCounter, align 4
  br label %._crit_edge.loopexit

._crit_edge.loopexit:                             ; preds = %14
  %old.bb.count7 = load i32, ptr @._crit_edge.loopexit_bbCounter, align 4
  %new.bb.count8 = add i32 %old.bb.count7, 1
  store i32 %new.bb.count8, ptr @._crit_edge.loopexit_bbCounter, align 4
  br label %._crit_edge, !dbg !16

._crit_edge:                                      ; preds = %._crit_edge.loopexit, %.._crit_edge_crit_edge
  %old.bb.count9 = load i32, ptr @._crit_edge_bbCounter, align 4
  %new.bb.count10 = add i32 %old.bb.count9, 1
  store i32 %new.bb.count10, ptr @._crit_edge_bbCounter, align 4
  call void @print_bb_count()
  ret void
}

; Function Attrs: nocallback nofree nosync nounwind speculatable willreturn memory(none)
declare i32 @llvm.smin.i32(i32, i32) #0

; Function Attrs: nocallback nofree nosync nounwind speculatable willreturn memory(none)
declare noundef i32 @llvm.nvvm.read.ptx.sreg.tid.x() #0

; Function Attrs: convergent nocallback nounwind
declare void @llvm.nvvm.barrier0() #1

; Function Attrs: nocallback nofree nosync nounwind speculatable willreturn memory(none)
declare i5 @llvm.bitreverse.i5(i5) #0

define void @print_bb_count() {
entry:
  %bb.count = load i64, ptr @_bbCounter.1, align 4
  call void @_Z5printl(i64 %bb.count)
  %bb.count1 = load i64, ptr @.lr.ph_bbCounter, align 4
  call void @_Z5printl(i64 %bb.count1)
  %bb.count2 = load i64, ptr @.._crit_edge_crit_edge_bbCounter, align 4
  call void @_Z5printl(i64 %bb.count2)
  %bb.count3 = load i64, ptr @._crit_edge_bbCounter, align 4
  call void @_Z5printl(i64 %bb.count3)
  %bb.count4 = load i64, ptr @_bbCounter, align 4
  call void @_Z5printl(i64 %bb.count4)
  %bb.count5 = load i64, ptr @._crit_edge.loopexit_bbCounter, align 4
  call void @_Z5printl(i64 %bb.count5)
  ret void
}

declare void @_Z5printl(i64)

attributes #0 = { nocallback nofree nosync nounwind speculatable willreturn memory(none) }
attributes #1 = { convergent nocallback nounwind }

!llvm.module.flags = !{!0, !1}
!llvm.dbg.cu = !{!2}
!nvvm.annotations = !{!4, !5}
!llvm.ident = !{!6}

!0 = !{i32 2, !"Debug Info Version", i32 3}
!1 = !{i32 4, !"nvvm-reflect-ftz", i32 1}
!2 = distinct !DICompileUnit(language: DW_LANG_C, file: !3, producer: "triton", isOptimized: true, runtimeVersion: 0, emissionKind: LineTablesOnly)
!3 = !DIFile(filename: "03-matrix-multiplication.py", directory: "/localdisk/lwsim/triton-tutorial/.")
!4 = !{ptr @matmul_kernel, !"kernel", i32 1}
!5 = !{ptr @matmul_kernel, !"maxntidx", i32 64}
!6 = !{!"clang version 3.8.0 (tags/RELEASE_380/final)"}
!7 = distinct !DISubprogram(name: "matmul_kernel", linkageName: "matmul_kernel", scope: !3, file: !3, line: 242, type: !8, scopeLine: 242, spFlags: DISPFlagDefinition | DISPFlagOptimized, unit: !2)
!8 = !DISubroutineType(cc: DW_CC_normal, types: !9)
!9 = !{}
!10 = !DILocation(line: 40, column: 22, scope: !11, inlinedAt: !13)
!11 = distinct !DILexicalBlockFile(scope: !7, file: !12, discriminator: 0)
!12 = !DIFile(filename: "standard.py", directory: "/localdisk/lwsim/triton/python/triton/language")
!13 = !DILocation(line: 294, column: 33, scope: !7)
!14 = !DILocation(line: 40, column: 28, scope: !11, inlinedAt: !13)
!15 = !DILocation(line: 294, column: 22, scope: !7)
!16 = !DILocation(line: 282, column: 51, scope: !7)
