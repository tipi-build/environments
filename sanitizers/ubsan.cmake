# Compilation and linker flags to ensure proper sanitizer support
set (CMAKE_POSITION_INDEPENDENT_CODE ON)

set(UBSAN_FLAGS 
  -fsanitize=undefined
  -fno-sanitize-merge
  )

add_compile_options(
  $<$<COMPILE_LANGUAGE:C,CXX>:-fno-omit-frame-pointer>
  ${UBSAN_FLAGS})

add_link_options(
  $<$<COMPILE_LANGUAGE:C,CXX>:-fno-omit-frame-pointer>  
  ${UBSAN_FLAGS})