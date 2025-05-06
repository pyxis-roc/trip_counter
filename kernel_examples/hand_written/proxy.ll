warning: Linking two modules of different target triples: '/home/jingyu/projects/research/lwsim/trip_counter/src/llvm/IR_plugin/print.ll' is 'x86_64-unknown-linux-gnu' whereas './control_inside_loop.ll' is 'x86_64-pc-linux-gnu'

; ModuleID = './control_inside_loop.ll'
source_filename = "control_inside_loop.cc"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-i128:128-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

@_bbCounter = common global i64 0
@_bbCounter.1 = common global i64 0
@_bbCounter.2 = common global i64 0
@_bbCounter.3 = common global i64 0
@_bbCounter.4 = common global i64 0
@_bbCounter.5 = common global i64 0
@_bbCounter.6 = common global i64 0
@_bbCounter.7 = common global i64 0
@.str = private unnamed_addr constant [11 x i8] c"%d %s %ld\0A\00", align 1
@0 = private unnamed_addr constant [1 x i8] zeroinitializer, align 1
@1 = private unnamed_addr constant [1 x i8] zeroinitializer, align 1
@2 = private unnamed_addr constant [1 x i8] zeroinitializer, align 1
@3 = private unnamed_addr constant [1 x i8] zeroinitializer, align 1
@4 = private unnamed_addr constant [1 x i8] zeroinitializer, align 1
@5 = private unnamed_addr constant [1 x i8] zeroinitializer, align 1
@6 = private unnamed_addr constant [1 x i8] zeroinitializer, align 1
@7 = private unnamed_addr constant [1 x i8] zeroinitializer, align 1

; Function Attrs: mustprogress noinline norecurse nounwind optnone sspstrong uwtable
define dso_local noundef i32 @main() #0 {
  %old.bb.count17 = load i64, ptr @_bbCounter.6, align 8
  %new.bb.count18 = add i64 %old.bb.count17, 1
  store i64 %new.bb.count18, ptr @_bbCounter.6, align 8
  br label %1

1:                                                ; preds = %0
  %.0 = phi i32 [ 0, %0 ]
  %2 = icmp slt i32 %.0, 10
  %sext = sext i32 11 to i64
  %old.bb.count = load i64, ptr @_bbCounter, align 8
  %new.bb.count = add i64 %old.bb.count, %sext
  store i64 %new.bb.count, ptr @_bbCounter, align 8
  br i1 %2, label %3, label %10

3:                                                ; preds = %1
  %4 = icmp eq i32 0, 0
  %sext2 = sext i32 10 to i64
  %old.bb.count3 = load i64, ptr @_bbCounter.1, align 8
  %new.bb.count4 = add i64 %old.bb.count3, %sext2
  store i64 %new.bb.count4, ptr @_bbCounter.1, align 8
  br i1 %4, label %5, label %6

5:                                                ; preds = %3
  %sext5 = sext i32 10 to i64
  %old.bb.count6 = load i64, ptr @_bbCounter.2, align 8
  %new.bb.count7 = add i64 %old.bb.count6, %sext5
  store i64 %new.bb.count7, ptr @_bbCounter.2, align 8
  br label %7

6:                                                ; preds = %3
  %sext8 = sext i32 10 to i64
  %old.bb.count9 = load i64, ptr @_bbCounter.3, align 8
  %new.bb.count10 = add i64 %old.bb.count9, %sext8
  store i64 %new.bb.count10, ptr @_bbCounter.3, align 8
  br label %7

7:                                                ; preds = %6, %5
  %sext11 = sext i32 10 to i64
  %old.bb.count12 = load i64, ptr @_bbCounter.4, align 8
  %new.bb.count13 = add i64 %old.bb.count12, %sext11
  store i64 %new.bb.count13, ptr @_bbCounter.4, align 8
  br label %8

8:                                                ; preds = %7
  %9 = add nsw i32 %.0, 1
  %sext14 = sext i32 10 to i64
  %old.bb.count15 = load i64, ptr @_bbCounter.5, align 8
  %new.bb.count16 = add i64 %old.bb.count15, %sext14
  store i64 %new.bb.count16, ptr @_bbCounter.5, align 8
  br label %10

10:                                               ; preds = %8, %1
  %old.bb.count19 = load i64, ptr @_bbCounter.7, align 8
  %new.bb.count20 = add i64 %old.bb.count19, 1
  store i64 %new.bb.count20, ptr @_bbCounter.7, align 8
  call void @main_print_bb_count()
  ret i32 undef
}

define void @main_print_bb_count() {
entry:
  %bb.count = load i64, ptr @_bbCounter.6, align 8
  call void @print_counter(i32 -1063574224, ptr @0, i64 %bb.count)
  %bb.count1 = load i64, ptr @_bbCounter, align 8
  call void @print_counter(i32 -1063573840, ptr @1, i64 %bb.count1)
  %bb.count2 = load i64, ptr @_bbCounter.1, align 8
  call void @print_counter(i32 -1063561152, ptr @2, i64 %bb.count2)
  %bb.count3 = load i64, ptr @_bbCounter.7, align 8
  call void @print_counter(i32 -1063561056, ptr @3, i64 %bb.count3)
  %bb.count4 = load i64, ptr @_bbCounter.2, align 8
  call void @print_counter(i32 -1063560448, ptr @4, i64 %bb.count4)
  %bb.count5 = load i64, ptr @_bbCounter.3, align 8
  call void @print_counter(i32 -1063560352, ptr @5, i64 %bb.count5)
  %bb.count6 = load i64, ptr @_bbCounter.4, align 8
  call void @print_counter(i32 -1063559584, ptr @6, i64 %bb.count6)
  %bb.count7 = load i64, ptr @_bbCounter.5, align 8
  call void @print_counter(i32 -1063558784, ptr @7, i64 %bb.count7)
  ret void
}

; Function Attrs: noinline nounwind optnone uwtable
define dso_local void @print_counter(i32 noundef %0, ptr noundef %1, i64 noundef %2) #1 {
  %4 = alloca i32, align 4
  %5 = alloca ptr, align 8
  %6 = alloca i64, align 8
  store i32 %0, ptr %4, align 4
  store ptr %1, ptr %5, align 8
  store i64 %2, ptr %6, align 8
  %7 = load i32, ptr %4, align 4
  %8 = load ptr, ptr %5, align 8
  %9 = load i64, ptr %6, align 8
  %10 = call i32 (ptr, ...) @printf(ptr noundef @.str, i32 noundef %7, ptr noundef %8, i64 noundef %9)
  ret void
}

declare i32 @printf(ptr noundef, ...) #2

attributes #0 = { mustprogress noinline norecurse nounwind optnone sspstrong uwtable "frame-pointer"="all" "min-legal-vector-width"="0" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cmov,+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #1 = { noinline nounwind optnone uwtable "frame-pointer"="all" "min-legal-vector-width"="0" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cmov,+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #2 = { "frame-pointer"="all" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cmov,+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }

!llvm.module.flags = !{!0, !1, !2, !3, !4}
!llvm.ident = !{!5, !6}

!0 = !{i32 1, !"wchar_size", i32 4}
!1 = !{i32 8, !"PIC Level", i32 2}
!2 = !{i32 7, !"PIE Level", i32 2}
!3 = !{i32 7, !"uwtable", i32 2}
!4 = !{i32 7, !"frame-pointer", i32 2}
!5 = !{!"clang version 18.1.8"}
!6 = !{!"clang version 19.1.0"}
