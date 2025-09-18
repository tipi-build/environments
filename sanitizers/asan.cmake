# Compilation and linker flags to ensure proper sanitizer support
set (CMAKE_POSITION_INDEPENDENT_CODE ON)

set(ASAN_FLAGS 
  -fsanitize=address
  )

add_compile_options(
  $<$<COMPILE_LANGUAGE:C,CXX>:-fno-omit-frame-pointer>
  ${ASAN_FLAGS})

add_link_options(
  $<$<COMPILE_LANGUAGE:C,CXX>:-fno-omit-frame-pointer>  
  ${ASAN_FLAGS})