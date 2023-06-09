set(libc_unit_test_srcs
  ExecuteFunction.h
  Test.h
  LibcTest.cpp
  LibcTest.h
  TestLogger.cpp
  TestLogger.h
)

if(${LIBC_TARGET_OS} STREQUAL "linux")
  list(APPEND libc_unit_test_srcs ExecuteFunctionUnix.cpp)
endif()

add_library(
  LibcUnitTest
  ${libc_unit_test_srcs}
)

target_include_directories(LibcUnitTest PUBLIC ${LIBC_SOURCE_DIR})
add_dependencies(
  LibcUnitTest
  libc.src.__support.CPP.string
  libc.src.__support.CPP.string_view
  libc.src.__support.CPP.type_traits
  libc.src.__support.OSUtil.osutil
  libc.src.__support.uint128)

add_library(
  LibcUnitTestMain
  LibcTestMain.cpp
)

target_include_directories(LibcUnitTestMain PUBLIC ${LIBC_SOURCE_DIR})
add_dependencies(LibcUnitTestMain LibcUnitTest)
target_link_libraries(LibcUnitTestMain PUBLIC LibcUnitTest)

add_header_library(
  string_utils
  HDRS
  StringUtils.h
  DEPENDS
    libc.src.__support.CPP.string
    libc.src.__support.CPP.type_traits
)

add_library(
  LibcFPTestHelpers
  FPExceptMatcher.cpp
  FPExceptMatcher.h
  FPMatcher.h
  RoundingModeUtils.cpp
  RoundingModeUtils.h
)
target_include_directories(LibcFPTestHelpers PUBLIC ${LIBC_SOURCE_DIR})
target_link_libraries(LibcFPTestHelpers LibcUnitTest)
add_dependencies(
  LibcFPTestHelpers
  LibcUnitTest
  libc.test.UnitTest.string_utils
  libc.src.__support.FPUtil.fp_bits
  libc.src.__support.FPUtil.fenv_impl
  libc.test.UnitTest.string_utils
)

add_library(
  LibcMemoryHelpers
  MemoryMatcher.h
  MemoryMatcher.cpp
)
target_include_directories(LibcMemoryHelpers PUBLIC ${LIBC_SOURCE_DIR})
target_link_libraries(LibcMemoryHelpers LibcUnitTest)
add_dependencies(
  LibcMemoryHelpers
  LibcUnitTest
  libc.src.__support.CPP.span
)

add_library(
  LibcPrintfHelpers
  PrintfMatcher.h
  PrintfMatcher.cpp
)
target_include_directories(LibcPrintfHelpers PUBLIC ${LIBC_SOURCE_DIR})
target_link_libraries(LibcPrintfHelpers LibcUnitTest)
add_dependencies(
  LibcPrintfHelpers
  LibcUnitTest
  libc.src.__support.FPUtil.fp_bits
  libc.src.stdio.printf_core.core_structs
  libc.test.UnitTest.string_utils
)

add_library(
  LibcScanfHelpers
  ScanfMatcher.h
  ScanfMatcher.cpp
)
target_include_directories(LibcScanfHelpers PUBLIC ${LIBC_SOURCE_DIR})
target_link_libraries(LibcScanfHelpers LibcUnitTest)
add_dependencies(
  LibcScanfHelpers
  LibcUnitTest
  libc.src.__support.FPUtil.fp_bits
  libc.src.stdio.scanf_core.core_structs
  libc.test.UnitTest.string_utils
)
