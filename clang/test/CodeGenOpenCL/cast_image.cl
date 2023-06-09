// RUN: %clang_cc1 -no-opaque-pointers -emit-llvm -o - -triple amdgcn--amdhsa %s | FileCheck --check-prefix=AMDGCN %s
// RUN: %clang_cc1 -no-opaque-pointers -emit-llvm -o - -triple x86_64-unknown-unknown %s | FileCheck --check-prefix=X86 %s

#ifdef __AMDGCN__

constant int* convert(image2d_t img) {
  // AMDGCN: bitcast %opencl.image2d_ro_t addrspace(4)* %img to i32 addrspace(4)*
  return __builtin_astype(img, constant int*);
}

#else

global int* convert(image2d_t img) {
  // X86: bitcast %opencl.image2d_ro_t* %img to i32*
  return __builtin_astype(img, global int*);
}

#endif
