
include_guard()
include("${CMAKE_CURRENT_LIST_DIR}/linux-kitware-paraview.cmake")

set(CMAKE_BUILD_TYPE "Release" CACHE STRING "" FORCE)
set(VTK_USE_PCH OFF CACHE BOOL "" FORCE)