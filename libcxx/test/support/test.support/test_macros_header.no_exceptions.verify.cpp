//===----------------------------------------------------------------------===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//

// Make sure the TEST_HAS_NO_EXCEPTIONS macro is defined when exceptions are
// disabled.

// REQUIRES: no-exceptions

#include "test_macros.h"

#ifndef TEST_HAS_NO_EXCEPTIONS
#  error "TEST_HAS_NO_EXCEPTIONS should be defined"
#endif

void f() {
    try { (void)0; } catch (...) { } // expected-error {{exceptions disabled}}
}
