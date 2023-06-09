// RUN: llvm-mc -filetype=obj -triple x86_64-pc-win32 %s -o - | llvm-readobj -S --symbols --sd --addrsig - | FileCheck %s

// CHECK:      Name: .llvm_addrsig
// CHECK-NEXT: VirtualSize: 0x0
// CHECK-NEXT: VirtualAddress: 0x0
// CHECK-NEXT: RawDataSize: 6
// CHECK-NEXT: PointerToRawData:
// CHECK-NEXT: PointerToRelocations: 0x0
// CHECK-NEXT: PointerToLineNumbers: 0x0
// CHECK-NEXT: RelocationCount: 0
// CHECK-NEXT: LineNumberCount: 0
// CHECK-NEXT: Characteristics [ (0x100800)
// CHECK-NEXT:   IMAGE_SCN_ALIGN_1BYTES (0x100000)
// CHECK-NEXT:   IMAGE_SCN_LNK_REMOVE (0x800)
// CHECK-NEXT: ]
// CHECK-NEXT: SectionData (
// CHECK-NEXT:   0000: 080B0A02
// CHECK-NEXT: )

// CHECK: Symbols [
// CHECK:      Name:
// CHECK-SAME: {{^}} .text
// CHECK: AuxSectionDef
// CHECK:      Name:
// CHECK-SAME: {{^}} .data
// CHECK: AuxSectionDef
// CHECK:      Name:
// CHECK-SAME: {{^}} .bss
// CHECK: AuxSectionDef
// CHECK:      Name:
// CHECK-SAME: {{^}} .llvm_addrsig
// CHECK: AuxSectionDef
// CHECK:      Name:
// CHECK-SAME: {{^}} g1
// CHECK:      Name:
// CHECK-SAME: {{^}} g2
// CHECK:      Name:
// CHECK-SAME: {{^}} local
// CHECK:      Name:
// CHECK-SAME: {{^}} g3
// CHECK-NOT:  Name:
// CHECK: }

// CHECK:      Addrsig [
// CHECK-NEXT:   Sym: g1 (8)
// CHECK-NEXT:   Sym: g3 (11)
// CHECK-NEXT:   Sym: local (10)
// CHECK-NEXT:   Sym: .data (2)
// CHECK-NEXT:   Sym: weak_sym (12)
// CHECK-NEXT:   Sym: .data (2)
// CHECK-NEXT: ]

.globl g1

.addrsig
.addrsig_sym g1
.globl g2
.addrsig_sym g3
.addrsig_sym local
.addrsig_sym .Llocal
.addrsig_sym .Lunseen
.addrsig_sym unseen

local:
.globl g3

.data
.Llocal:

.weak weak_sym
weak_sym:
.addrsig_sym weak_sym

.set .Lalias_weak_sym, weak_sym
.addrsig_sym .Lalias_weak_sym
