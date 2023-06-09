// REQUIRES: system-darwin && asserts
// RUN: %clang -c -o %t %s
// RUN: %llvm_jitlink -debug-only=orc -debugger-support %t 2>&1 \
// RUN:    | FileCheck %s
//
// Check that presence of a "__DWARF" section triggers the
// GDBJITDebugInfoRegistrationPlugin.
//
// This test requires a darwin host (despite being a noexec test) because we use
// the input object's mangling to determine the mangling of the registration
// function to use. Since the input is MachO, the mangling will only line up
// properly on Darwin. (See https://llvm.org/PR52503 for a proposed longer term
// solution).
//
// CHECK: Adding debug object to GDB JIT interface

	.section	__TEXT,__text,regular,pure_instructions
	.globl	_main
	.p2align	4, 0x90
_main:
	xorl	%eax, %eax
	retq

	.section	__DWARF,__debug_str,regular,debug
Linfo_string:
	.asciz	"test dwarf string"

.subsections_via_symbols
