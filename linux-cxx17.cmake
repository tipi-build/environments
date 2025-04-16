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
set(CMAKE_EXE_LINKER_FLAGS "${CMAKE_EXE_LINKER_FLAGS} -fuse-ld=lld -stdlib=libc++ -static-libstdc++ -static-libgcc /usr/local/share/.tipi/clang/4f846ee/lib/libc++.a /usr/local/share/.tipi/clang/4f846ee/lib/libc++abi.a")
# Required flags for -stdlib=libc++ are provided in https://github.com/tipi-build/environments/tree/feature/tipi-bootstrap loaded by .tipi/distro.json via .tipi/env
# Thes are in the main distro and not in an opts.toolchain files because for now the cmake-tipi-provider cannot use the opts.toolchain files and this would load a broken
# cpp-pre not using the same flags that is depended by elfshaker CMakeLists.

set (CMAKE_POSITION_INDEPENDENT_CODE ON)
