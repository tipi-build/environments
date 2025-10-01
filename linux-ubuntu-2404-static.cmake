
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

# C: "-static"
add_compile_options(
  $<$<COMPILE_LANGUAGE:C>:-static>
)

# C++: "-static -nostdlib++ -stdlib=libc++"
add_compile_options(
  $<$<COMPILE_LANGUAGE:CXX>:-static>
  $<$<COMPILE_LANGUAGE:CXX>:-nostdlib++>
  $<$<COMPILE_LANGUAGE:CXX>:-stdlib=libc++>
)

# C link: "-static -static-libgcc"
add_link_options(
  $<$<LINK_LANGUAGE:C>:-static>
  $<$<LINK_LANGUAGE:C>:-static-libgcc>
)

# C++ link: "-static -static-libgcc -nostdlib++ -stdlib=libc++ -static-libstdc++ -static-libgcc"
add_link_options(
  $<$<LINK_LANGUAGE:CXX>:-static>
  $<$<LINK_LANGUAGE:CXX>:-static-libgcc>
  $<$<LINK_LANGUAGE:CXX>:-nostdlib++>
  $<$<LINK_LANGUAGE:CXX>:-stdlib=libc++>
  $<$<LINK_LANGUAGE:CXX>:-static-libstdc++>
  $<$<LINK_LANGUAGE:CXX>:-static-libgcc>
)

link_libraries(${CMAKE_DL_LIBS})
link_libraries(
  $<$<LINK_LANGUAGE:CXX>:/usr/local/share/.tipi/clang/4f846ee/lib/libc++.a>
  $<$<LINK_LANGUAGE:CXX>:/usr/local/share/.tipi/clang/4f846ee/lib/libc++abi.a>
)

set(CMAKE_POSITION_INDEPENDENT_CODE ON)