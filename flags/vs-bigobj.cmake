# Copyright (c) 2013, 2018 Ruslan Baratov
# All rights reserved.

if(DEFINED POLLY_FLAGS_VS_BIGOBJ_CMAKE_)
  return()
else()
  set(POLLY_FLAGS_VS_BIGOBJ_CMAKE_ 1)
endif()

include(polly_add_cache_flag)

# Increase Number of Sections in .obj file 
#
# see https://learn.microsoft.com/en-us/cpp/build/reference/bigobj-increase-number-of-sections-in-dot-obj-file?view=msvc-170
#
# NOTE: restricts the linker used, but everything after Visual C++ 2005 should be able to read .obj files that were
# produced with /bigobj so we're running with that as we don't support anything that old anyway
polly_add_cache_flag(CMAKE_CXX_FLAGS_INIT "/bigobj")