; REQUIRES: x86-registered-target
; RUN: opt %s %loadnewpmbye %loadbye -passes="goodbye" -wave-goodbye -disable-output 2>&1 | FileCheck %s
; RUN: opt %s %loadnewpmbye -passes="goodbye" -wave-goodbye -disable-output 2>&1 | FileCheck %s
; RUN: opt -module-summary %s -o %t.o
; RUN: llvm-lto2 run %t.o %loadbye %loadnewpmbye -wave-goodbye -o %t -r %t.o,somefunk,plx -r %t.o,junk,plx 2>&1 | FileCheck %s
; RUN: llvm-lto2 run %t.o %loadbye %loadnewpmbye -opt-pipeline="goodbye" -wave-goodbye -o %t -r %t.o,somefunk,plx -r %t.o,junk,plx 2>&1 | FileCheck %s
; REQUIRES: plugins, examples
; UNSUPPORTED: target={{.*windows.*}}
; CHECK: Bye

target datalayout = "e-m:e-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-unknown-linux-gnu"
@junk = global i32 0

define ptr @somefunk() {
  ret ptr @junk
}

