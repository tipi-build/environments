# Copyright (c) 2016-2018, Ruslan Baratov
# Copyright (c) 2017, David Hirvonen
# All rights reserved.

if(DEFINED POLLY_CLANG_CXX17_CMAKE_)
  return()
else()
  set(POLLY_CLANG_CXX17_CMAKE_ 1)
endif()

include("${CMAKE_CURRENT_LIST_DIR}/utilities/polly_init.cmake")

polly_init(
    "clang / c++17 support"
    "Ninja"
)
include("${CMAKE_CURRENT_LIST_DIR}/utilities/polly_common.cmake")

include("${CMAKE_CURRENT_LIST_DIR}/compiler/clang.cmake")
include("${CMAKE_CURRENT_LIST_DIR}/flags/cxx17.cmake")

set(CMAKE_CXX_FLAGS " ${CMAKE_CXX_FLAGS} -stdlib=libc++ ")
set(CMAKE_EXE_LINKER_FLAGS "${CMAKE_EXE_LINKER_FLAGS} -fuse-ld=lld")

set (CMAKE_POSITION_INDEPENDENT_CODE ON)
