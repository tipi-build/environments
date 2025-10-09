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

# -stdlib=libc++ : libc++ headers are used.
# -nostdlib++ no automatic linkage to libc++ or libc++abi
set(CMAKE_CXX_FLAGS " ${CMAKE_CXX_FLAGS} -stdlib=libc++ -nostdlib++")
set(CMAKE_EXE_LINKER_FLAGS "${CMAKE_EXE_LINKER_FLAGS} -fuse-ld=lld -stdlib=libc++ -static /usr/local/share/.tipi/clang/4f846ee/lib/libc++.a /usr/local/share/.tipi/clang/4f846ee/lib/libc++abi.a")