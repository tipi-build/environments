# Copyright (c) 2016-2018, Ruslan Baratov
# Copyright (c) 2017, David Hirvonen
# All rights reserved.

if(DEFINED POLLY_WINDOWS_CXX17_CMAKE_)
  return()
else()
  set(POLLY_WINDOWS_CXX17_CMAKE_ 1)
endif()

include("${CMAKE_CURRENT_LIST_DIR}/utilities/polly_init.cmake")

polly_init(
    "clang / c++17 support"
    "MinGW Makefiles"
)

add_compile_definitions(
    WIN32_LEAN_AND_MEAN
    _WIN32_WINNT=0x0A00 
    __kernel_entry
	  BOOST_USE_WINDOWS_H
)

set (CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS}  -femulated-tls " CACHE STRING "")
include("${CMAKE_CURRENT_LIST_DIR}/utilities/polly_common.cmake")
include("${CMAKE_CURRENT_LIST_DIR}/compiler/clang.cmake")
include("${CMAKE_CURRENT_LIST_DIR}/flags/cxx17.cmake")
