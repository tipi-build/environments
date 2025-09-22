include("${CMAKE_CURRENT_LIST_DIR}/linux-cxx17.cmake")
set(CMAKE_C_FLAGS " ${CMAKE_C_FLAGS} -static ")
set(CMAKE_CXX_FLAGS " ${CMAKE_CXX_FLAGS} -static ")
set(CMAKE_EXE_LINKER_FLAGS "${CMAKE_EXE_LINKER_FLAGS} -static ")
