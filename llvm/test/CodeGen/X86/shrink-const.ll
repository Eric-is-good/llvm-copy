; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc < %s -mtriple=x86_64-- -mattr=+sse2 | FileCheck %s --check-prefix=SSE
; RUN: llc < %s -mtriple=x86_64-- -mattr=+avx2 | FileCheck %s --check-prefix=AVX

; If targetShrinkDemandedConstant extends xor/or constants ensure it extends from the msb of the active bits
define <4 x i32> @sext_vector_constants(<4 x i32> %a0) {
; SSE-LABEL: sext_vector_constants:
; SSE:       # %bb.0:
; SSE-NEXT:    psrld $9, %xmm0
; SSE-NEXT:    pslld $26, %xmm0
; SSE-NEXT:    pxor {{\.?LCPI[0-9]+_[0-9]+}}(%rip), %xmm0
; SSE-NEXT:    retq
;
; AVX-LABEL: sext_vector_constants:
; AVX:       # %bb.0:
; AVX-NEXT:    vpsrld $9, %xmm0, %xmm0
; AVX-NEXT:    vpslld $26, %xmm0, %xmm0
; AVX-NEXT:    vpxor {{\.?LCPI[0-9]+_[0-9]+}}(%rip), %xmm0, %xmm0
; AVX-NEXT:    retq
  %1 = lshr <4 x i32> %a0, <i32 9, i32 9, i32 9, i32 9>
  %2 = xor <4 x i32> %1, <i32 314523200, i32 -2085372448, i32 144496960, i32 1532773600>
  %3 = shl <4 x i32> %2, <i32 26, i32 26, i32 26, i32 26>
  ret <4 x i32> %3
}
