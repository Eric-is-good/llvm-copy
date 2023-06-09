; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt < %s -passes=instcombine -S | FileCheck %s

target datalayout = "E-p:64:64:64-i1:8:8-i8:8:8-i16:16:16-i32:32:32-i64:64:64-f32:32:32-f64:64:64-f128:128:128-v128:128:128-n32:64"
target triple = "powerpc64-unknown-linux-gnu"

; These tests are extracted from bitcast.ll.
; Verify that they also work correctly on big-endian targets.

define float @test2(<2 x float> %A, <2 x i32> %B) {
; CHECK-LABEL: @test2(
; CHECK-NEXT:    [[TMP24:%.*]] = extractelement <2 x float> [[A:%.*]], i64 1
; CHECK-NEXT:    [[BC:%.*]] = bitcast <2 x i32> [[B:%.*]] to <2 x float>
; CHECK-NEXT:    [[TMP4:%.*]] = extractelement <2 x float> [[BC]], i64 1
; CHECK-NEXT:    [[ADD:%.*]] = fadd float [[TMP24]], [[TMP4]]
; CHECK-NEXT:    ret float [[ADD]]
;
  %tmp28 = bitcast <2 x float> %A to i64
  %tmp23 = trunc i64 %tmp28 to i32
  %tmp24 = bitcast i32 %tmp23 to float

  %tmp = bitcast <2 x i32> %B to i64
  %tmp2 = trunc i64 %tmp to i32
  %tmp4 = bitcast i32 %tmp2 to float

  %add = fadd float %tmp24, %tmp4
  ret float %add
}

define float @test3(<2 x float> %A, <2 x i64> %B) {
; CHECK-LABEL: @test3(
; CHECK-NEXT:    [[TMP24:%.*]] = extractelement <2 x float> [[A:%.*]], i64 0
; CHECK-NEXT:    [[BC2:%.*]] = bitcast <2 x i64> [[B:%.*]] to <4 x float>
; CHECK-NEXT:    [[TMP4:%.*]] = extractelement <4 x float> [[BC2]], i64 1
; CHECK-NEXT:    [[ADD:%.*]] = fadd float [[TMP24]], [[TMP4]]
; CHECK-NEXT:    ret float [[ADD]]
;
  %tmp28 = bitcast <2 x float> %A to i64
  %tmp29 = lshr i64 %tmp28, 32
  %tmp23 = trunc i64 %tmp29 to i32
  %tmp24 = bitcast i32 %tmp23 to float

  %tmp = bitcast <2 x i64> %B to i128
  %tmp1 = lshr i128 %tmp, 64
  %tmp2 = trunc i128 %tmp1 to i32
  %tmp4 = bitcast i32 %tmp2 to float

  %add = fadd float %tmp24, %tmp4
  ret float %add
}

define <2 x i32> @test4(i32 %A, i32 %B){
; CHECK-LABEL: @test4(
; CHECK-NEXT:    [[TMP1:%.*]] = insertelement <2 x i32> poison, i32 [[B:%.*]], i64 0
; CHECK-NEXT:    [[TMP43:%.*]] = insertelement <2 x i32> [[TMP1]], i32 [[A:%.*]], i64 1
; CHECK-NEXT:    ret <2 x i32> [[TMP43]]
;
  %tmp38 = zext i32 %A to i64
  %tmp32 = zext i32 %B to i64
  %tmp33 = shl i64 %tmp32, 32
  %ins35 = or i64 %tmp33, %tmp38
  %tmp43 = bitcast i64 %ins35 to <2 x i32>
  ret <2 x i32> %tmp43
}

define <2 x float> @test5(float %A, float %B) {
; CHECK-LABEL: @test5(
; CHECK-NEXT:    [[TMP1:%.*]] = insertelement <2 x float> poison, float [[B:%.*]], i64 0
; CHECK-NEXT:    [[TMP43:%.*]] = insertelement <2 x float> [[TMP1]], float [[A:%.*]], i64 1
; CHECK-NEXT:    ret <2 x float> [[TMP43]]
;
  %tmp37 = bitcast float %A to i32
  %tmp38 = zext i32 %tmp37 to i64
  %tmp31 = bitcast float %B to i32
  %tmp32 = zext i32 %tmp31 to i64
  %tmp33 = shl i64 %tmp32, 32
  %ins35 = or i64 %tmp33, %tmp38
  %tmp43 = bitcast i64 %ins35 to <2 x float>
  ret <2 x float> %tmp43
}

define <2 x float> @test6(float %A){
; CHECK-LABEL: @test6(
; CHECK-NEXT:    [[TMP35:%.*]] = insertelement <2 x float> <float poison, float 4.200000e+01>, float [[A:%.*]], i64 0
; CHECK-NEXT:    ret <2 x float> [[TMP35]]
;
  %tmp23 = bitcast float %A to i32
  %tmp24 = zext i32 %tmp23 to i64
  %tmp25 = shl i64 %tmp24, 32
  %mask20 = or i64 %tmp25, 1109917696
  %tmp35 = bitcast i64 %mask20 to <2 x float>
  ret <2 x float> %tmp35
}

; No change. Bitcasts are canonicalized above bitwise logic.

define <2 x i32> @xor_bitcast_vec_to_vec(<1 x i64> %a) {
; CHECK-LABEL: @xor_bitcast_vec_to_vec(
; CHECK-NEXT:    [[T1:%.*]] = bitcast <1 x i64> [[A:%.*]] to <2 x i32>
; CHECK-NEXT:    [[T2:%.*]] = xor <2 x i32> [[T1]], <i32 1, i32 2>
; CHECK-NEXT:    ret <2 x i32> [[T2]]
;
  %t1 = bitcast <1 x i64> %a to <2 x i32>
  %t2 = xor <2 x i32> <i32 1, i32 2>, %t1
  ret <2 x i32> %t2
}

; No change. Bitcasts are canonicalized above bitwise logic.

define i64 @and_bitcast_vec_to_int(<2 x i32> %a) {
; CHECK-LABEL: @and_bitcast_vec_to_int(
; CHECK-NEXT:    [[T1:%.*]] = bitcast <2 x i32> [[A:%.*]] to i64
; CHECK-NEXT:    [[T2:%.*]] = and i64 [[T1]], 3
; CHECK-NEXT:    ret i64 [[T2]]
;
  %t1 = bitcast <2 x i32> %a to i64
  %t2 = and i64 %t1, 3
  ret i64 %t2
}

; No change. Bitcasts are canonicalized above bitwise logic.

define <2 x i32> @or_bitcast_int_to_vec(i64 %a) {
; CHECK-LABEL: @or_bitcast_int_to_vec(
; CHECK-NEXT:    [[T1:%.*]] = bitcast i64 [[A:%.*]] to <2 x i32>
; CHECK-NEXT:    [[T2:%.*]] = or <2 x i32> [[T1]], <i32 1, i32 2>
; CHECK-NEXT:    ret <2 x i32> [[T2]]
;
  %t1 = bitcast i64 %a to <2 x i32>
  %t2 = or <2 x i32> %t1, <i32 1, i32 2>
  ret <2 x i32> %t2
}

