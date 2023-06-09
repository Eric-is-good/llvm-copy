//===-- Loader test to check args to main ---------------------------------===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//

#include "test/IntegrationTest/test.h"

static bool my_streq(const char *lhs, const char *rhs) {
  const char *l, *r;
  for (l = lhs, r = rhs; *l != '\0' && *r != '\0'; ++l, ++r)
    if (*l != *r)
      return false;

  return *l == '\0' && *r == '\0';
}

TEST_MAIN(int argc, char **argv, char **envp) {
  ASSERT_TRUE(argc == 4);
  ASSERT_TRUE(my_streq(argv[1], "1"));
  ASSERT_TRUE(my_streq(argv[2], "2"));
  ASSERT_TRUE(my_streq(argv[3], "3"));

  bool found_france = false;
  bool found_germany = false;
  for (; *envp != nullptr; ++envp) {
    if (my_streq(*envp, "FRANCE=Paris"))
      found_france = true;
    if (my_streq(*envp, "GERMANY=Berlin"))
      found_germany = true;
  }

  ASSERT_TRUE(found_france && found_germany);

  return 0;
}
