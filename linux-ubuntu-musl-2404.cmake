set(SYSROOT "/opt/sysroot/musl")

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


set(CMAKE_SYSROOT "${SYSROOT}")
set(CMAKE_C_COMPILER "${SYSROOT}/bin/clang")
set(CMAKE_CXX_COMPILER "${SYSROOT}/bin/clang++")

set(CMAKE_C_COMPILER_TARGET "x86_64-unknown-linux-musl")
set(CMAKE_CXX_COMPILER_TARGET "x86_64-unknown-linux-musl")

include("${CMAKE_CURRENT_LIST_DIR}/flags/cxx17.cmake")

set(CMAKE_EXE_LINKER_FLAGS "${CMAKE_EXE_LINKER_FLAGS} -static")

set(CMAKE_FIND_ROOT_PATH_MODE_PROGRAM BOTH)
set(CMAKE_FIND_ROOT_PATH_MODE_LIBRARY ONLY)
set(CMAKE_FIND_ROOT_PATH_MODE_INCLUDE ONLY)
set(CMAKE_FIND_ROOT_PATH_MODE_PACKAGE ONLY)
