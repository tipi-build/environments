# Copyright (c) 2015-2017, Ruslan Baratov
# Copyright (c) 2015-2017, Ruslan Baratov
# All rights reserved.

if(DEFINED POLLY_VS_16_2019_WIN64_CXX17_CMAKE_)
  return()
else()
  set(POLLY_VS_16_2019_WIN64_CXX17_CMAKE_ 1)
endif()

include("${CMAKE_CURRENT_LIST_DIR}/utilities/polly_init.cmake")

polly_init(
    "Visual Studio 17 2022 Win64 / C++20"
    "Ninja"
)

include("${CMAKE_CURRENT_LIST_DIR}/utilities/polly_common.cmake")
include("${CMAKE_CURRENT_LIST_DIR}/compiler/cl.cmake")
include("${CMAKE_CURRENT_LIST_DIR}/flags/vs-cxx20.cmake")
