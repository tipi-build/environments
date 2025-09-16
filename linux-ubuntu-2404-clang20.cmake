include("${CMAKE_CURRENT_LIST_DIR}/utilities/polly_init.cmake")

polly_init(
    "clang 20 / C++ 23"
    "Ninja"
)
include("${CMAKE_CURRENT_LIST_DIR}/utilities/polly_common.cmake")
include("${CMAKE_CURRENT_LIST_DIR}/compiler/clang.cmake")
include("${CMAKE_CURRENT_LIST_DIR}/flags/cxx23.cmake")
