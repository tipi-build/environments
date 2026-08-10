include_guard()

include("${CMAKE_CURRENT_LIST_DIR}/utilities/polly_init.cmake")

polly_init(
    "clang / c++17 support"
    "Ninja"
)
include("${CMAKE_CURRENT_LIST_DIR}/utilities/polly_common.cmake")


include("${CMAKE_CURRENT_LIST_DIR}/flags/cxx14.cmake")

set(CROSS_COMPILE_TOOLCHAIN_PREFIX aarch64-linux-gnu CACHE STRING "" FORCE) 
include("${CMAKE_CURRENT_LIST_DIR}/compiler/gcc-cross-compile-simple-layout.cmake")

set(CMAKE_LINKER         "${TOOLCHAIN_PATH_AND_PREFIX}-ld.gold"      CACHE PATH "Linker" FORCE)
set(CMAKE_LINKER_TYPE GOLD)