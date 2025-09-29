if(DEFINED POLLY_CLANG_CXX17_CMAKE_)
  return()
else()
  set(POLLY_CLANG_CXX17_CMAKE_ 1)
endif()

include("${CMAKE_CURRENT_LIST_DIR}/utilities/polly_init.cmake")
polly_init("clang / c++17 support" "Ninja")
include("${CMAKE_CURRENT_LIST_DIR}/utilities/polly_common.cmake")
include("${CMAKE_CURRENT_LIST_DIR}/compiler/clang.cmake")
include("${CMAKE_CURRENT_LIST_DIR}/flags/cxx17.cmake")

# === Paths ===
set(_GLIBC_SYSROOT "/root/glibc/build/install")
set(_GLIBC_BUILD   "/root/glibc/build")   # contains resolv/libnss_dns_pic.a and nss/files-hosts.os
set(_CLANG_LIB     "/usr/local/share/.tipi/clang/4f846ee/lib")

# === Sysroot wiring ===
set(CMAKE_SYSROOT "${_GLIBC_SYSROOT}")
set(CMAKE_SYSROOT_COMPILE "${_GLIBC_SYSROOT}")
set(CMAKE_SYSROOT_LINK    "${_GLIBC_SYSROOT}")

set(CMAKE_FIND_ROOT_PATH "${_GLIBC_SYSROOT}")
set(CMAKE_FIND_ROOT_PATH_MODE_PROGRAM NEVER)
set(CMAKE_FIND_ROOT_PATH_MODE_LIBRARY ONLY)
set(CMAKE_FIND_ROOT_PATH_MODE_INCLUDE ONLY)
set(CMAKE_FIND_ROOT_PATH_MODE_PACKAGE ONLY)
set(CMAKE_FIND_LIBRARY_SUFFIXES ".a")

# === Find GCC startfiles/libgcc for LINK PHASE (not compile) ===
execute_process(COMMAND gcc -print-libgcc-file-name
  OUTPUT_VARIABLE _LIBGCC_FILE OUTPUT_STRIP_TRAILING_WHITESPACE)
if(NOT _LIBGCC_FILE)
  message(FATAL_ERROR "gcc not found. Install gcc so clang can find crtbegin/crtend and libgcc.")
endif()
get_filename_component(_GCC_LIBDIR "${_LIBGCC_FILE}" DIRECTORY)

# === Compile flags (NO --gcc-toolchain/-B here) ===
set(CMAKE_C_FLAGS   " ${CMAKE_C_FLAGS}   --sysroot=${_GLIBC_SYSROOT} -static")
set(CMAKE_CXX_FLAGS " ${CMAKE_CXX_FLAGS} --sysroot=${_GLIBC_SYSROOT} -static -stdlib=libc++")

# === Keep EXE linker flags minimal (corrosion-safe) ===
# (Do NOT append libc++ archives or NSS here.)
set(CMAKE_EXE_LINKER_FLAGS "${CMAKE_EXE_LINKER_FLAGS}")

# === Per-language LINK flags ===
# Put the GCC hint only at link time:
set(CMAKE_C_LINK_FLAGS   "${CMAKE_C_LINK_FLAGS}   -static -fuse-ld=lld --gcc-toolchain=/usr -B${_GCC_LIBDIR}")
set(CMAKE_CXX_LINK_FLAGS "${CMAKE_CXX_LINK_FLAGS} -static -fuse-ld=lld --gcc-toolchain=/usr -B${_GCC_LIBDIR} -nostdlib++")

# libc++ static archives (added to C++ link flags so they appear exactly once)
set(_LIBCXX_ARCHIVES " ${_CLANG_LIB}/libc++.a ${_CLANG_LIB}/libc++abi.a")

# === NSS backends for static getaddrinfo() ===
set(_NSS_DNS_A "${_GLIBC_BUILD}/resolv/libnss_dns_pic.a")      # keep whole-archive
if(NOT EXISTS "${_NSS_DNS_A}")
  message(FATAL_ERROR "Missing ${_NSS_DNS_A}")
endif()
set(_NSS_FILES_HOSTS_OBJ "${_GLIBC_BUILD}/nss/files-hosts.os") # link only hosts object
if(NOT EXISTS "${_NSS_FILES_HOSTS_OBJ}")
  message(FATAL_ERROR "Missing ${_NSS_FILES_HOSTS_OBJ} (check ${_GLIBC_BUILD}/nss/)")
endif()

# One-time C++ link tail: libc++ archives + NSS + resolv
set(CMAKE_CXX_LINK_FLAGS
  "${CMAKE_CXX_LINK_FLAGS} ${_LIBCXX_ARCHIVES} -Wl,--whole-archive ${_NSS_DNS_A} -Wl,--no-whole-archive ${_NSS_FILES_HOSTS_OBJ} -lresolv")

# === Normalize and append -ldl via standard libs (end of link line) ===
if(NOT DEFINED CMAKE_DL_LIBS OR CMAKE_DL_LIBS STREQUAL "" OR CMAKE_DL_LIBS STREQUAL "dl")
  set(CMAKE_DL_LIBS "-ldl")
endif()
set(CMAKE_C_STANDARD_LIBRARIES   "${CMAKE_C_STANDARD_LIBRARIES} ${CMAKE_DL_LIBS}")
set(CMAKE_CXX_STANDARD_LIBRARIES "${CMAKE_CXX_STANDARD_LIBRARIES} ${CMAKE_DL_LIBS}")

set(CMAKE_POSITION_INDEPENDENT_CODE ON)