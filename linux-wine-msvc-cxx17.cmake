# we're cross compiling!
set(CMAKE_SYSTEM_NAME Windows)
set(CMAKE_SYSTEM_PROCESSOR x86_64)
set(CMAKE_HOST_SYSTEM_PROCESSOR x86_64)

find_program(CMAKE_C_COMPILER "cl")
find_program(CMAKE_CXX_COMPILER "cl")

if(NOT CMAKE_C_COMPILER)
  message(FATAL_ERROR "Could not find C compiler CL.exe on PATH")
endif()

if(NOT CMAKE_CXX_COMPILER)
  message(FATAL_ERROR "Could not find CPP compiler CL.exe on PATH")
endif()

include("${CMAKE_CURRENT_LIST_DIR}/utilities/polly_init.cmake")

if(DEFINED POLLY_MAKE_WINE_MSVC_17_2022_CXX17_CMAKE_)
  return()
else()
  set(POLLY_MAKE_WINE_MSVC_17_2022_CXX17_CMAKE_ 1)
endif()

polly_init(
        "Ninja / Visual Studio 2022 / x64"
        "Ninja"
)

SET(CMAKE_CXX_FLAGS_DEBUG "/Ob0 /Od /RTC1" CACHE STRING "")

# can be troublesome for some builds that do not respect that flag, unexpected on "windows"
set(CMAKE_DEBUG_POSTFIX "")

# inject "system include/lib" information from tipi's MSVC-wine environments
set(CMAKE_CXX_STANDARD_INCLUDE_DIRECTORIES $ENV{TIPI_MSVC_WINE__LINUX__INCLUDE})
link_directories($ENV{TIPI_MSVC_WINE__LINUX__LIB})

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

include("${CMAKE_CURRENT_LIST_DIR}/utilities/polly_common.cmake")
include("${CMAKE_CURRENT_LIST_DIR}/flags/vs-cxx17.cmake")