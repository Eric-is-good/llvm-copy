; NOTE: Assertions have been autogenerated by utils/update_test_checks.py UTC_ARGS: --version 2
; RUN: opt -S -passes=instcombine < %s | FileCheck %s
; rdar://problem/10063307
target datalayout = "e-p:32:32:32-i1:8:32-i8:8:32-i16:16:32-i32:32:32-i64:32:64-f32:32:32-f64:32:64-v64:32:64-v128:32:128-a0:0:32-n32-S32"
target triple = "thumbv7-apple-ios5.0.0"

%0 = type { [2 x i32] }
%struct.CGPoint = type { float, float }

define void @t(ptr %a) nounwind {
; CHECK-LABEL: define void @t
; CHECK-SAME: (ptr [[A:%.*]]) #[[ATTR0:[0-9]+]] {
; CHECK-NEXT:    [[POINT:%.*]] = alloca [[STRUCT_CGPOINT:%.*]], align 4
; CHECK-NEXT:    [[TMP1:%.*]] = load i64, ptr [[A]], align 4
; CHECK-NEXT:    store i64 [[TMP1]], ptr [[POINT]], align 4
; CHECK-NEXT:    call void @foo(ptr nonnull [[POINT]]) #[[ATTR0]]
; CHECK-NEXT:    ret void
;
  %Point = alloca %struct.CGPoint, align 4
  %1 = load i64, ptr %a, align 4
  store i64 %1, ptr %Point, align 4
  call void @foo(ptr %Point) nounwind
  ret void
}

declare void @foo(ptr)
