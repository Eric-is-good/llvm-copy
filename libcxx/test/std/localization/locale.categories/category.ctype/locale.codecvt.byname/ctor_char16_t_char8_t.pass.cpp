//===----------------------------------------------------------------------===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//

// UNSUPPORTED: c++03, c++11, c++14, c++17

// XFAIL: availability-char8_t_support-missing

// <locale>

// template <> class codecvt_byname<char16_t, char8_t, mbstate_t>

// explicit codecvt_byname(const char* nm, size_t refs = 0);
// explicit codecvt_byname(const string& nm, size_t refs = 0);

#include <locale>
#include <cassert>

#include "test_macros.h"

typedef std::codecvt_byname<char16_t, char8_t, std::mbstate_t> F;

class my_facet
    : public F
{
public:
    static int count;

    explicit my_facet(const char* nm, std::size_t refs = 0)
        : F(nm, refs) {++count;}
    explicit my_facet(const std::string& nm, std::size_t refs = 0)
        : F(nm, refs) {++count;}

    ~my_facet() {--count;}
};

int my_facet::count = 0;

int main(int, char**)
{
    {
        std::locale l(std::locale::classic(), new my_facet("en_US"));
        assert(my_facet::count == 1);
    }
    assert(my_facet::count == 0);
    {
        my_facet f("en_US", 1);
        assert(my_facet::count == 1);
        {
            std::locale l(std::locale::classic(), &f);
            assert(my_facet::count == 1);
        }
        assert(my_facet::count == 1);
    }
    assert(my_facet::count == 0);
    {
        std::locale l(std::locale::classic(), new my_facet(std::string("en_US")));
        assert(my_facet::count == 1);
    }
    assert(my_facet::count == 0);
    {
        my_facet f(std::string("en_US"), 1);
        assert(my_facet::count == 1);
        {
            std::locale l(std::locale::classic(), &f);
            assert(my_facet::count == 1);
        }
        assert(my_facet::count == 1);
    }
    assert(my_facet::count == 0);

  return 0;
}
