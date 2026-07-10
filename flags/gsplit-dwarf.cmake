# Copyright (c) 2025, tipi.build by EngFlow
# All rights reserved.

include_guard()

set(CMAKE_C_FLAGS_DEBUG_INIT "${CMAKE_C_FLAGS_Debug_INIT} -g -gsplit-dwarf")
set(CMAKE_CXX_FLAGS_DEBUG_INIT "${CMAKE_CXX_FLAGS_Debug_INIT} -g -gsplit-dwarf")

set(CMAKE_C_FLAGS_RELWITHDEBINFO_INIT "${CMAKE_C_FLAGS_Debug_INIT} -g -gsplit-dwarf")
set(CMAKE_CXX_FLAGS_RELWITHDEBINFO_INIT "${CMAKE_CXX_FLAGS_Debug_INIT} -g -gsplit-dwarf")

set(CMAKE_C_FLAGS_RELEASE_INIT "${CMAKE_C_FLAGS_Release_INIT} -g -gsplit-dwarf")
set(CMAKE_CXX_FLAGS_RELEASE_INIT "${CMAKE_CXX_FLAGS_Release_INIT} -g -gsplit-dwarf")