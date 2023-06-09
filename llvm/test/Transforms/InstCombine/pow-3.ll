; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt < %s -disable-simplify-libcalls -passes=instcombine -S | FileCheck %s

declare double @llvm.pow.f64(double, double)
declare double @pow(double, double)

define double @sqrt_libcall(double %x) {
; CHECK-LABEL: @sqrt_libcall(
; CHECK-NEXT:    [[RETVAL:%.*]] = call double @pow(double [[X:%.*]], double 5.000000e-01)
; CHECK-NEXT:    ret double [[RETVAL]]
;
  %retval = call double @pow(double %x, double 0.5)
  ret double %retval
}

define double @sqrt_intrinsic(double %x) {
; CHECK-LABEL: @sqrt_intrinsic(
; CHECK-NEXT:    [[SQRT:%.*]] = call double @llvm.sqrt.f64(double [[X:%.*]])
; CHECK-NEXT:    [[ABS:%.*]] = call double @llvm.fabs.f64(double [[SQRT]])
; CHECK-NEXT:    [[ISINF:%.*]] = fcmp oeq double [[X]], 0xFFF0000000000000
; CHECK-NEXT:    [[RETVAL:%.*]] = select i1 [[ISINF]], double 0x7FF0000000000000, double [[ABS]]
; CHECK-NEXT:    ret double [[RETVAL]]
;
  %retval = call double @llvm.pow.f64(double %x, double 0.5)
  ret double %retval
}

; Shrinking is disabled too.

define float @shrink_libcall(float %f, float %g) {
; CHECK-LABEL: @shrink_libcall(
; CHECK-NEXT:    [[DF:%.*]] = fpext float [[F:%.*]] to double
; CHECK-NEXT:    [[DG:%.*]] = fpext float [[G:%.*]] to double
; CHECK-NEXT:    [[CALL:%.*]] = call fast double @pow(double [[DF]], double [[DG]])
; CHECK-NEXT:    [[FR:%.*]] = fptrunc double [[CALL]] to float
; CHECK-NEXT:    ret float [[FR]]
;
  %df = fpext float %f to double
  %dg = fpext float %g to double
  %call = call fast double @pow(double %df, double %dg)
  %fr = fptrunc double %call to float
  ret float %fr
}

; Shrinking is disabled for the intrinsic too.

define float @shrink_intrinsic(float %f, float %g) {
; CHECK-LABEL: @shrink_intrinsic(
; CHECK-NEXT:    [[DF:%.*]] = fpext float [[F:%.*]] to double
; CHECK-NEXT:    [[DG:%.*]] = fpext float [[G:%.*]] to double
; CHECK-NEXT:    [[CALL:%.*]] = call fast double @llvm.pow.f64(double [[DF]], double [[DG]])
; CHECK-NEXT:    [[FR:%.*]] = fptrunc double [[CALL]] to float
; CHECK-NEXT:    ret float [[FR]]
;
  %df = fpext float %f to double
  %dg = fpext float %g to double
  %call = call fast double @llvm.pow.f64(double %df, double %dg)
  %fr = fptrunc double %call to float
  ret float %fr
}
