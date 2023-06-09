; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt -S -passes=instcombine < %s | FileCheck %s

declare double @llvm.exp2.f64(double) nounwind readnone speculatable
declare void @use(double)

; exp2(a) * exp2(b) no reassoc flags
define double @exp2_a_exp2_b(double %a, double %b) {
; CHECK-LABEL: @exp2_a_exp2_b(
; CHECK-NEXT:    [[T:%.*]] = call double @llvm.exp2.f64(double [[A:%.*]])
; CHECK-NEXT:    [[T1:%.*]] = call double @llvm.exp2.f64(double [[B:%.*]])
; CHECK-NEXT:    [[MUL:%.*]] = fmul double [[T]], [[T1]]
; CHECK-NEXT:    ret double [[MUL]]
;
  %t = call double @llvm.exp2.f64(double %a)
  %t1 = call double @llvm.exp2.f64(double %b)
  %mul = fmul double %t, %t1
  ret double %mul
}

; exp2(a) * exp2(b) reassoc, multiple uses
define double @exp2_a_exp2_b_multiple_uses(double %a, double %b) {
; CHECK-LABEL: @exp2_a_exp2_b_multiple_uses(
; CHECK-NEXT:    [[T1:%.*]] = call double @llvm.exp2.f64(double [[B:%.*]])
; CHECK-NEXT:    [[TMP1:%.*]] = fadd reassoc double [[A:%.*]], [[B]]
; CHECK-NEXT:    [[MUL:%.*]] = call reassoc double @llvm.exp2.f64(double [[TMP1]])
; CHECK-NEXT:    call void @use(double [[T1]])
; CHECK-NEXT:    ret double [[MUL]]
;
  %t = call double @llvm.exp2.f64(double %a)
  %t1 = call double @llvm.exp2.f64(double %b)
  %mul = fmul reassoc double %t, %t1
  call void @use(double %t1)
  ret double %mul
}

define double @exp2_a_a(double %a) {
; CHECK-LABEL: @exp2_a_a(
; CHECK-NEXT:    [[TMP1:%.*]] = fadd reassoc double [[A:%.*]], [[A]]
; CHECK-NEXT:    [[M:%.*]] = call reassoc double @llvm.exp2.f64(double [[TMP1]])
; CHECK-NEXT:    ret double [[M]]
;
  %t = call double @llvm.exp2.f64(double %a)
  %m = fmul reassoc double %t, %t
  ret double %m
}

; exp2(a) * exp2(b) reassoc, both with multiple uses
define double @exp2_a_exp2_b_multiple_uses_both(double %a, double %b) {
; CHECK-LABEL: @exp2_a_exp2_b_multiple_uses_both(
; CHECK-NEXT:    [[T:%.*]] = call double @llvm.exp2.f64(double [[A:%.*]])
; CHECK-NEXT:    [[T1:%.*]] = call double @llvm.exp2.f64(double [[B:%.*]])
; CHECK-NEXT:    [[MUL:%.*]] = fmul reassoc double [[T]], [[T1]]
; CHECK-NEXT:    call void @use(double [[T]])
; CHECK-NEXT:    call void @use(double [[T1]])
; CHECK-NEXT:    ret double [[MUL]]
;
  %t = call double @llvm.exp2.f64(double %a)
  %t1 = call double @llvm.exp2.f64(double %b)
  %mul = fmul reassoc double %t, %t1
  call void @use(double %t)
  call void @use(double %t1)
  ret double %mul
}

; exp2(a) * exp2(b) => exp2(a+b) with reassoc
define double @exp2_a_exp2_b_reassoc(double %a, double %b) {
; CHECK-LABEL: @exp2_a_exp2_b_reassoc(
; CHECK-NEXT:    [[TMP1:%.*]] = fadd reassoc double [[A:%.*]], [[B:%.*]]
; CHECK-NEXT:    [[MUL:%.*]] = call reassoc double @llvm.exp2.f64(double [[TMP1]])
; CHECK-NEXT:    ret double [[MUL]]
;
  %t = call double @llvm.exp2.f64(double %a)
  %t1 = call double @llvm.exp2.f64(double %b)
  %mul = fmul reassoc double %t, %t1
  ret double %mul
}

; exp2(a) * exp2(b) * exp2(c) * exp2(d) => exp2(a+b+c+d) with reassoc
define double @exp2_a_exp2_b_exp2_c_exp2_d(double %a, double %b, double %c, double %d) {
; CHECK-LABEL: @exp2_a_exp2_b_exp2_c_exp2_d(
; CHECK-NEXT:    [[TMP1:%.*]] = fadd reassoc double [[A:%.*]], [[B:%.*]]
; CHECK-NEXT:    [[TMP2:%.*]] = fadd reassoc double [[TMP1]], [[C:%.*]]
; CHECK-NEXT:    [[TMP3:%.*]] = fadd reassoc double [[TMP2]], [[D:%.*]]
; CHECK-NEXT:    [[MUL2:%.*]] = call reassoc double @llvm.exp2.f64(double [[TMP3]])
; CHECK-NEXT:    ret double [[MUL2]]
;
  %t = call double @llvm.exp2.f64(double %a)
  %t1 = call double @llvm.exp2.f64(double %b)
  %mul = fmul reassoc double %t, %t1
  %t2 = call double @llvm.exp2.f64(double %c)
  %mul1 = fmul reassoc double %mul, %t2
  %t3 = call double @llvm.exp2.f64(double %d)
  %mul2 = fmul reassoc double %mul1, %t3
  ret double %mul2
}
