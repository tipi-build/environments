include_guard()

find_program(CMAKE_C_COMPILER gcc)
find_program(CMAKE_CXX_COMPILER g++)

if(NOT CMAKE_C_COMPILER)
  message(FATAL_ERROR "gcc not found")
endif()

if(NOT CMAKE_CXX_COMPILER)
  message(FATAL_ERROR "g++ not found")
endif()

set(
    CMAKE_C_COMPILER
    "${CMAKE_C_COMPILER}"
    CACHE
    STRING
    "C compiler"
    FORCE
)

set(
    CMAKE_CXX_COMPILER
    "${CMAKE_CXX_COMPILER}"
    CACHE
    STRING
    "C++ compiler"
    FORCE
)