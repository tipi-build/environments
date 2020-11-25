# Copyright (c) 2015-2017, Ruslan Baratov
# All rights reserved.

if(DEFINED POLLY_VS_16_2019_WIN64_CMAKE_)
  return()
else()
  set(POLLY_VS_16_2019_WIN64_CMAKE_ 1)
endif()

include("${CMAKE_CURRENT_LIST_DIR}/utilities/polly_init.cmake")

polly_init(
    "Visual Studio 16 2019 Win64 LLVM"
    "Visual Studio 16 2019 Win64"
)

include("${CMAKE_CURRENT_LIST_DIR}/utilities/polly_common.cmake")
