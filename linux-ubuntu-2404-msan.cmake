include("${CMAKE_CURRENT_LIST_DIR}/utilities/polly_init.cmake")

polly_init(
    "clang / c++17 support"
    "Ninja"
)
include("${CMAKE_CURRENT_LIST_DIR}/utilities/polly_common.cmake")
include("${CMAKE_CURRENT_LIST_DIR}/compiler/clang.cmake")

# Link to MSAN instrumented libc++
add_compile_options($<$<COMPILE_LANGUAGE:C,CXX>:-nostdlib++>)
add_link_options($<$<COMPILE_LANGUAGE:C,CXX>:-nostdlib++>)
link_libraries("/usr/local/lib/libc++.so.1.0")
link_libraries("/usr/local/lib/libc++abi.so.1.0")

# C++ type is libc++
add_compile_options($<$<COMPILE_LANGUAGE:C,CXX>:-stdlib=libc++>)
add_link_options($<$<COMPILE_LANGUAGE:C,CXX>:-stdlib=libc++>)

#############################################
# MSAN settings

# Find the msan ignore list file
set(SANITIZER_IGNORELIST_PATH "${CMAKE_CURRENT_LIST_DIR}/../msan.ignore")
if(NOT EXISTS "${SANITIZER_IGNORELIST_PATH}")
    message(FATAL_ERROR "Failed to find MSAN Ignorelist at path ${SANITIZER_IGNORELIST_PATH}")
endif()

# linux-ubuntu-2404-msan.sanitize-ignorelist
cmake_path(GET CMAKE_CURRENT_LIST_FILE FILENAME msan_ignore_list_path)
set(msan_ignore_list_path "${msan_ignore_list_path}.sanitize-ignorelist")
if(NOT EXISTS "${msan_ignore_list_path}")
  message(FATAL_ERROR "Failed to find sanitizer ignore list")
endif()

# Compilation and linker flags to ensure proper sanitizer support
set (CMAKE_POSITION_INDEPENDENT_CODE ON)

set(MSAN_FLAGS 
  -fsanitize=memory 
  -fsanitize-memory-track-origins 
  -fsanitize-ignorelist=${msan_ignore_list_path})

add_compile_options(
  $<$<COMPILE_LANGUAGE:C,CXX>:-fno-omit-frame-pointer>
  ${MSAN_FLAGS})

add_link_options(
  $<$<COMPILE_LANGUAGE:C,CXX>:-fno-omit-frame-pointer>  
  ${MSAN_FLAGS})