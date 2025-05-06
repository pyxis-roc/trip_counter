; ModuleID = '../../../kernel_examples/example/example.ll'
source_filename = "example.cc"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-i128:128-f80:128-n8:16:32:64-S128"
target triple = "x86_64-unknown-linux-gnu"

@_bbCounter = common global i64 0
@_bbCounter.1 = common global i64 0
@_bbCounter.2 = common global i64 0
@_bbCounter.3 = common global i64 0
@_bbCounter.4 = common global i64 0
@_bbCounter.5 = common global i64 0
@_bbCounter.6 = common global i64 0
@_bbCounter.7 = common global i64 0
@_bbCounter.8 = common global i64 0
@_bbCounter.9 = common global i64 0
@_bbCounter.10 = common global i64 0
@_bbCounter.11 = common global i64 0
@0 = private unnamed_addr constant [1 x i8] zeroinitializer, align 1
@1 = private unnamed_addr constant [1 x i8] zeroinitializer, align 1
@2 = private unnamed_addr constant [1 x i8] zeroinitializer, align 1
@3 = private unnamed_addr constant [1 x i8] zeroinitializer, align 1
@4 = private unnamed_addr constant [1 x i8] zeroinitializer, align 1
@5 = private unnamed_addr constant [1 x i8] zeroinitializer, align 1
@6 = private unnamed_addr constant [1 x i8] zeroinitializer, align 1
@7 = private unnamed_addr constant [1 x i8] zeroinitializer, align 1
@8 = private unnamed_addr constant [1 x i8] zeroinitializer, align 1
@9 = private unnamed_addr constant [1 x i8] zeroinitializer, align 1
@10 = private unnamed_addr constant [1 x i8] zeroinitializer, align 1
@11 = private unnamed_addr constant [1 x i8] zeroinitializer, align 1

; Function Attrs: mustprogress noinline nounwind optnone uwtable
define dso_local noundef i32 @_Z7exampleiib(i32 noundef %0, i32 noundef %1, i1 noundef zeroext %2) #0 {
  %4 = zext i1 %2 to i8
  %smax = call i32 @llvm.smax.i32(i32 %0, i32 0)
  %5 = add nuw i32 %smax, 1
  %smax3 = call i32 @llvm.smax.i32(i32 %0, i32 0)
  %smax6 = call i32 @llvm.smax.i32(i32 %0, i32 0)
  %smax7 = call i32 @llvm.smax.i32(i32 %1, i32 0)
  %6 = add nuw i32 %smax7, 1
  %7 = mul i32 %smax6, %6
  %smax10 = call i32 @llvm.smax.i32(i32 %1, i32 0)
  %smax11 = call i32 @llvm.smax.i32(i32 %0, i32 0)
  %8 = mul i32 %smax10, %smax11
  %smax14 = call i32 @llvm.smax.i32(i32 %0, i32 0)
  %smax17 = call i32 @llvm.smax.i32(i32 %1, i32 0)
  %smax18 = call i32 @llvm.smax.i32(i32 %0, i32 0)
  %9 = mul i32 %smax17, %smax18
  %smax21 = call i32 @llvm.smax.i32(i32 %1, i32 0)
  %smax22 = call i32 @llvm.smax.i32(i32 %0, i32 0)
  %10 = mul i32 %smax21, %smax22
  %smax25 = call i32 @llvm.smax.i32(i32 %1, i32 0)
  %smax26 = call i32 @llvm.smax.i32(i32 %0, i32 0)
  %11 = mul i32 %smax25, %smax26
  %smax29 = call i32 @llvm.smax.i32(i32 %1, i32 0)
  %smax30 = call i32 @llvm.smax.i32(i32 %0, i32 0)
  %12 = mul i32 %smax29, %smax30
  %smax33 = call i32 @llvm.smax.i32(i32 %0, i32 0)
  %old.bb.count36 = load i32, ptr @_bbCounter.10, align 4
  %new.bb.count37 = add i32 %old.bb.count36, 1
  store i32 %new.bb.count37, ptr @_bbCounter.10, align 4
  br label %13

13:                                               ; preds = %3
  %.01 = phi i32 [ 0, %3 ]
  %14 = icmp slt i32 %.01, %0
  %old.bb.count = load i32, ptr @_bbCounter, align 4
  %new.bb.count = add i32 %old.bb.count, %5
  store i32 %new.bb.count, ptr @_bbCounter, align 4
  br i1 %14, label %15, label %28

15:                                               ; preds = %13
  %old.bb.count4 = load i32, ptr @_bbCounter.1, align 4
  %new.bb.count5 = add i32 %old.bb.count4, %smax3
  store i32 %new.bb.count5, ptr @_bbCounter.1, align 4
  br label %16

16:                                               ; preds = %15
  %.0 = phi i32 [ 0, %15 ]
  %17 = icmp slt i32 %.0, %1
  %old.bb.count8 = load i32, ptr @_bbCounter.2, align 4
  %new.bb.count9 = add i32 %old.bb.count8, %7
  store i32 %new.bb.count9, ptr @_bbCounter.2, align 4
  br i1 %17, label %18, label %25

18:                                               ; preds = %16
  %19 = trunc i8 %4 to i1
  %old.bb.count12 = load i32, ptr @_bbCounter.3, align 4
  %new.bb.count13 = add i32 %old.bb.count12, %8
  store i32 %new.bb.count13, ptr @_bbCounter.3, align 4
  br i1 %19, label %20, label %21

20:                                               ; preds = %18
  %old.bb.count19 = load i32, ptr @_bbCounter.5, align 4
  %new.bb.count20 = add i32 %old.bb.count19, %9
  store i32 %new.bb.count20, ptr @_bbCounter.5, align 4
  br label %22

21:                                               ; preds = %18
  %old.bb.count23 = load i32, ptr @_bbCounter.6, align 4
  %new.bb.count24 = add i32 %old.bb.count23, %10
  store i32 %new.bb.count24, ptr @_bbCounter.6, align 4
  br label %22

22:                                               ; preds = %21, %20
  %old.bb.count27 = load i32, ptr @_bbCounter.7, align 4
  %new.bb.count28 = add i32 %old.bb.count27, %11
  store i32 %new.bb.count28, ptr @_bbCounter.7, align 4
  br label %23

23:                                               ; preds = %22
  %24 = add nsw i32 %.0, 1
  %old.bb.count31 = load i32, ptr @_bbCounter.8, align 4
  %new.bb.count32 = add i32 %old.bb.count31, %12
  store i32 %new.bb.count32, ptr @_bbCounter.8, align 4
  br label %25

25:                                               ; preds = %23, %16
  %old.bb.count15 = load i32, ptr @_bbCounter.4, align 4
  %new.bb.count16 = add i32 %old.bb.count15, %smax14
  store i32 %new.bb.count16, ptr @_bbCounter.4, align 4
  br label %26

26:                                               ; preds = %25
  %27 = add nsw i32 %.01, 1
  %old.bb.count34 = load i32, ptr @_bbCounter.9, align 4
  %new.bb.count35 = add i32 %old.bb.count34, %smax33
  store i32 %new.bb.count35, ptr @_bbCounter.9, align 4
  br label %28

28:                                               ; preds = %26, %13
  %old.bb.count38 = load i32, ptr @_bbCounter.11, align 4
  %new.bb.count39 = add i32 %old.bb.count38, 1
  store i32 %new.bb.count39, ptr @_bbCounter.11, align 4
  call void @_Z7exampleiib_print_bb_count()
  ret i32 undef
}

; Function Attrs: mustprogress noinline norecurse nounwind optnone uwtable
define dso_local noundef i32 @main() #1 {
  %1 = alloca i32, align 4
  store i32 0, ptr %1, align 4
  %2 = call noundef i32 @_Z7exampleiib(i32 noundef 10, i32 noundef 12, i1 noundef zeroext false)
  ret i32 0
}

; Function Attrs: nocallback nofree nosync nounwind speculatable willreturn memory(none)
declare i32 @llvm.smax.i32(i32, i32) #2

define void @_Z7exampleiib_print_bb_count() {
entry:
  %bb.count = load i64, ptr @_bbCounter.10, align 8
  call void @_Z13print_counteriPci(i32 -1559737696, ptr @0, i64 %bb.count)
  %bb.count1 = load i64, ptr @_bbCounter, align 8
  call void @_Z13print_counteriPci(i32 -1559737248, ptr @1, i64 %bb.count1)
  %bb.count2 = load i64, ptr @_bbCounter.1, align 8
  call void @_Z13print_counteriPci(i32 -1559725280, ptr @2, i64 %bb.count2)
  %bb.count3 = load i64, ptr @_bbCounter.11, align 8
  call void @_Z13print_counteriPci(i32 -1559725184, ptr @3, i64 %bb.count3)
  %bb.count4 = load i64, ptr @_bbCounter.2, align 8
  call void @_Z13print_counteriPci(i32 -1559724688, ptr @4, i64 %bb.count4)
  %bb.count5 = load i64, ptr @_bbCounter.3, align 8
  call void @_Z13print_counteriPci(i32 -1559724080, ptr @5, i64 %bb.count5)
  %bb.count6 = load i64, ptr @_bbCounter.4, align 8
  call void @_Z13print_counteriPci(i32 -1559723984, ptr @6, i64 %bb.count6)
  %bb.count7 = load i64, ptr @_bbCounter.5, align 8
  call void @_Z13print_counteriPci(i32 -1559723408, ptr @7, i64 %bb.count7)
  %bb.count8 = load i64, ptr @_bbCounter.6, align 8
  call void @_Z13print_counteriPci(i32 -1559723312, ptr @8, i64 %bb.count8)
  %bb.count9 = load i64, ptr @_bbCounter.7, align 8
  call void @_Z13print_counteriPci(i32 -1559722416, ptr @9, i64 %bb.count9)
  %bb.count10 = load i64, ptr @_bbCounter.8, align 8
  call void @_Z13print_counteriPci(i32 -1559721536, ptr @10, i64 %bb.count10)
  %bb.count11 = load i64, ptr @_bbCounter.9, align 8
  call void @_Z13print_counteriPci(i32 -1559718016, ptr @11, i64 %bb.count11)
  ret void
}

declare void @_Z13print_counteriPci(i32, i8, i32)

attributes #0 = { mustprogress noinline nounwind optnone uwtable "frame-pointer"="all" "min-legal-vector-width"="0" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cmov,+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #1 = { mustprogress noinline norecurse nounwind optnone uwtable "frame-pointer"="all" "min-legal-vector-width"="0" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cmov,+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #2 = { nocallback nofree nosync nounwind speculatable willreturn memory(none) }

!llvm.module.flags = !{!0, !1, !2, !3, !4}
!llvm.ident = !{!5}

!0 = !{i32 1, !"wchar_size", i32 4}
!1 = !{i32 8, !"PIC Level", i32 2}
!2 = !{i32 7, !"PIE Level", i32 2}
!3 = !{i32 7, !"uwtable", i32 2}
!4 = !{i32 7, !"frame-pointer", i32 2}
!5 = !{!"clang version 19.1.0"}
