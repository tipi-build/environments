# Copyright (c) 2020-2023, tipi technologies Ltd
# All rights reserved.

if(DEFINED TIPI_WINDOWS_MSVC_2022_WIN64_CXX17_CMAKE_)
  return()
else()
  set(TIPI_WINDOWS_MSVC_2022_WIN64_CXX17_CMAKE_ 1)
endif()

include("${CMAKE_CURRENT_LIST_DIR}/utilities/polly_init.cmake")

polly_init(
    "Visual Studio 17 2022 Win64 / C++17"
    "Visual Studio 17 2022"
)

include("${CMAKE_CURRENT_LIST_DIR}/utilities/polly_common.cmake")
include("${CMAKE_CURRENT_LIST_DIR}/flags/vs-cxx17.cmake")
