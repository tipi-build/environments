# Copyright (c) 2015-2018, Ruslan Baratov
# All rights reserved.

if(DEFINED POLLY_VS_16_2019_STORE_10_ZW_CMAKE_)
  return()
else()
  set(POLLY_VS_16_2019_STORE_10_ZW_CMAKE_ 1)
endif()

include("${CMAKE_CURRENT_LIST_DIR}/utilities/polly_init.cmake")

set(CMAKE_SYSTEM_NAME WindowsStore)
set(CMAKE_SYSTEM_VERSION 10.0)

polly_init(
    "Visual Studio 16 2019 / ${CMAKE_SYSTEM_NAME} ${CMAKE_SYSTEM_VERSION} / ZW"
    "Visual Studio 16 2019"
)

include("${CMAKE_CURRENT_LIST_DIR}/utilities/polly_common.cmake")
include("${CMAKE_CURRENT_LIST_DIR}/flags/vs-zw.cmake")
