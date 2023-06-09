// RUN: mlir-opt -test-derived-attr -verify-diagnostics %s | FileCheck %s

// CHECK-LABEL: verifyDerivedAttributes
func.func @verifyDerivedAttributes() {
  // expected-remark @+2 {{element_dtype = f32}}
  // expected-remark @+1 {{num_elements = 10}}
  %0 = "test.derived_type_attr"() : () -> tensor<10xf32>

  // expected-remark @+2 {{element_dtype = i79}}
  // expected-remark @+1 {{num_elements = 12}}
  %1 = "test.derived_type_attr"() : () -> tensor<12xi79>

  // expected-remark @+2 {{element_dtype = complex<f32>}}
  // expected-remark @+1 {{num_elements = 12}}
  %2 = "test.derived_type_attr"() : () -> tensor<12xcomplex<f32>>

  return
}
