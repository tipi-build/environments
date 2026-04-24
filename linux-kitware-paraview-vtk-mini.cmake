include_guard()

if (NOT CMAKE_HOST_SYSTEM_NAME STREQUAL "Linux") 
  message(FATAL_ERROR "Incompatible System Toolchain, you are running the build on '${CMAKE_HOST_SYSTEM_NAME}' and this toolchain is made for 'Linux'.")
endif()

include("${CMAKE_CURRENT_LIST_DIR}/compiler/clang-no-polly.cmake")
include("${CMAKE_CURRENT_LIST_DIR}/flags/fpic.cmake")
include("${CMAKE_CURRENT_LIST_DIR}/generator/ninja.cmake")
include("${CMAKE_CURRENT_LIST_DIR}/linker/ldd.cmake")

set(CMAKE_BUILD_TYPE "Release" CACHE STRING "" FORCE)
set(VTK_GROUP_ENABLE_Imaging "DONT_WANT" CACHE STRING "" FORCE)
set(VTK_GROUP_ENABLE_Parallel "DONT_WANT" CACHE STRING "" FORCE)
set(VTK_GROUP_ENABLE_Qt "DONT_WANT" CACHE STRING "" FORCE)
set(VTK_GROUP_ENABLE_StandAlone "DONT_WANT" CACHE STRING "" FORCE)
set(VTK_GROUP_ENABLE_Views "DONT_WANT" CACHE STRING "" FORCE)
set(VTK_GROUP_ENABLE_Web "DONT_WANT" CACHE STRING "" FORCE)
set(VTK_SMP_ENABLE_STDTHREAD OFF CACHE BOOL "" FORCE)