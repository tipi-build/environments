# Copyright (c) 2013, 2018 Ruslan Baratov
# Copyright (c) 2023 tipi technologies Ltd
# All rights reserved.

if(DEFINED TIPI_FLAGS_VS_CXXLATEST_CMAKE_)
  return()
else()
  set(TIPI_FLAGS_VS_CXXLATEST_CMAKE_ 1)
endif()

include(polly_add_cache_flag)

polly_add_cache_flag(CMAKE_CXX_FLAGS_INIT "/std:c++latest")

# Set CMAKE_CXX_STANDARD to cache to override project local value if present.
# FORCE added in case CMAKE_CXX_STANDARD already set in cache
# (e.g. set before 'project' by user).
set(CMAKE_CXX_STANDARD 20 CACHE STRING "C++ Standard (toolchain)" FORCE)
set(CMAKE_CXX_STANDARD_REQUIRED YES CACHE BOOL "C++ Standard required" FORCE)
set(CMAKE_CXX_EXTENSIONS NO CACHE BOOL "C++ Standard extensions" FORCE)
