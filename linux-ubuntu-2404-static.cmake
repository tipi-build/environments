if(DEFINED POLLY_CLANG_CXX17_STATIC_CMAKE_)
  return()
else()
  set(POLLY_CLANG_CXX17_STATIC_CMAKE_ 1)
endif()

include("${CMAKE_CURRENT_LIST_DIR}/utilities/polly_init.cmake")

polly_init(
 "clang / c++17 support"
    "Ninja"
)
include("${CMAKE_CURRENT_LIST_DIR}/utilities/polly_common.cmake")
include("${CMAKE_CURRENT_LIST_DIR}/compiler/clang.cmake")
include("${CMAKE_CURRENT_LIST_DIR}/flags/cxx17.cmake")

set(CMAKE_C_FLAGS   "-static")
set(CMAKE_CXX_FLAGS "-static -nostdlib++ -stdlib=libc++")
set(CMAKE_C_LINK_FLAGS   "-static -static-libgcc")
set(CMAKE_CXX_LINK_FLAGS "-static -static-libgcc -nostdlib++ -stdlib=libc++  -static-libstdc++ -static-libgcc ")

set(CMAKE_C_STANDARD_LIBRARIES   "${CMAKE_C_STANDARD_LIBRARIES} ${CMAKE_DL_LIBS}")
set(CMAKE_CXX_STANDARD_LIBRARIES "${CMAKE_CXX_STANDARD_LIBRARIES} ${CMAKE_DL_LIBS} /usr/local/share/.tipi/clang/4f846ee/lib/libc++.a /usr/local/share/.tipi/clang/4f846ee/lib/libc++abi.a")

set(CMAKE_POSITION_INDEPENDENT_CODE ON)