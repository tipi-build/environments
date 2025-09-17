# Link to MSAN instrumented libc++
add_compile_options($<$<COMPILE_LANGUAGE:C,CXX>:-nostdlib++>)
add_link_options($<$<COMPILE_LANGUAGE:C,CXX>:-nostdlib++>)
link_libraries("/usr/local/instrumented/msan/lib/libc++.so.1.0")
link_libraries("/usr/local/instrumented/msan/lib/libc++abi.so.1.0")

# C++ type is libc++
add_compile_options($<$<COMPILE_LANGUAGE:C,CXX>:-stdlib=libc++>)
add_link_options($<$<COMPILE_LANGUAGE:C,CXX>:-stdlib=libc++>)

#############################################
# MSAN settings

# Compilation and linker flags to ensure proper sanitizer support
set (CMAKE_POSITION_INDEPENDENT_CODE ON)

set(MSAN_FLAGS 
  -fsanitize=memory 
  -fsanitize-memory-track-origins 
  )

add_compile_options(
  $<$<COMPILE_LANGUAGE:C,CXX>:-fno-omit-frame-pointer>
  ${MSAN_FLAGS})

add_link_options(
  $<$<COMPILE_LANGUAGE:C,CXX>:-fno-omit-frame-pointer>  
  ${MSAN_FLAGS})