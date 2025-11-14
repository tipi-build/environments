# Compilation and linker flags to ensure proper sanitizer support
set (CMAKE_POSITION_INDEPENDENT_CODE ON)

add_compile_options($<$<COMPILE_LANGUAGE:C,CXX>:-fsanitize=thread>)
add_link_options($<$<COMPILE_LANGUAGE:C,CXX>:-fsanitize=thread>)

add_compile_options(
  $<$<COMPILE_LANGUAGE:C,CXX>:-fno-omit-frame-pointer>
)
add_link_options(
  $<$<COMPILE_LANGUAGE:C,CXX>:-fno-omit-frame-pointer>
)