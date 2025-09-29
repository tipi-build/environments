include("${CMAKE_CURRENT_LIST_DIR}/linux-cxx17.cmake")
set(_GLIBC_SYSROOT "/root/glibc/build/install")
set(_GLIBC_BUILD   "/root/glibc/build")
set(_CLANG_BIN     "/usr/local/share/.tipi/clang/4f846ee/bin")
set(_CLANG_LIB     "/usr/local/share/.tipi/clang/4f846ee/lib")

# compilers
set(CMAKE_C_COMPILER   "${_CLANG_BIN}/clang")
set(CMAKE_CXX_COMPILER "${_CLANG_BIN}/clang++")
set(CMAKE_AR           "${_CLANG_BIN}/llvm-ar")
set(CMAKE_RANLIB       "${_CLANG_BIN}/llvm-ranlib")

# sysroot wiring
set(CMAKE_SYSROOT "${_GLIBC_SYSROOT}")
set(CMAKE_SYSROOT_COMPILE "${_GLIBC_SYSROOT}")
set(CMAKE_SYSROOT_LINK    "${_GLIBC_SYSROOT}")

set(CMAKE_FIND_ROOT_PATH "${_GLIBC_SYSROOT}")
set(CMAKE_FIND_ROOT_PATH_MODE_PROGRAM NEVER)
set(CMAKE_FIND_ROOT_PATH_MODE_LIBRARY ONLY)
set(CMAKE_FIND_ROOT_PATH_MODE_INCLUDE ONLY)
set(CMAKE_FIND_ROOT_PATH_MODE_PACKAGE ONLY)
set(CMAKE_FIND_LIBRARY_SUFFIXES ".a")

# detect GCC libdir (for link-time startfiles/libgcc)
execute_process(COMMAND gcc -print-libgcc-file-name
  OUTPUT_VARIABLE _LIBGCC_FILE OUTPUT_STRIP_TRAILING_WHITESPACE)
if(NOT _LIBGCC_FILE)
  message(FATAL_ERROR "gcc not found. Install gcc for crtbegin/crtend and libgcc.")
endif()
get_filename_component(_GCC_LIBDIR "${_LIBGCC_FILE}" DIRECTORY)

# Compile flags: **NO --gcc-toolchain/-B here** (so cc crate won’t see it)
set(CMAKE_C_FLAGS   " ${CMAKE_C_FLAGS}   --sysroot=${_GLIBC_SYSROOT} -static")
set(CMAKE_CXX_FLAGS " ${CMAKE_CXX_FLAGS} --sysroot=${_GLIBC_SYSROOT} -static -stdlib=libc++")

# Keep EXE linker flags minimal (corrosion-friendly)
set(CMAKE_EXE_LINKER_FLAGS "${CMAKE_EXE_LINKER_FLAGS} -static -fuse-ld=lld")

# Put GCC hint **only** in link flags (C & C++)
set(CMAKE_C_LINK_FLAGS   "${CMAKE_C_LINK_FLAGS}   --gcc-toolchain=/usr -B${_GCC_LIBDIR}")
set(CMAKE_CXX_LINK_FLAGS "${CMAKE_CXX_LINK_FLAGS} --gcc-toolchain=/usr -B${_GCC_LIBDIR} -nostdlib++")


# libc++ static archives
set(_LIBCXX_ARCHIVES " ${_CLANG_LIB}/libc++.a ${_CLANG_LIB}/libc++abi.a")

# NSS backends (DNS whole-archive + only hosts object)
set(_NSS_DNS_A          "${_GLIBC_BUILD}/resolv/libnss_dns_pic.a")
set(_NSS_FILES_HOSTS_OS "${_GLIBC_BUILD}/nss/files-hosts.os")
if(NOT EXISTS "${_NSS_DNS_A}")
  message(FATAL_ERROR "Missing ${_NSS_DNS_A}")
endif()
if(NOT EXISTS "${_NSS_FILES_HOSTS_OS}")
  message(FATAL_ERROR "Missing ${_NSS_FILES_HOSTS_OS}")
endif()

# tail libs string (kept out of EXE_LINKER_FLAGS)
set(_TAIL_LIBS " -Wl,--whole-archive ${_NSS_DNS_A} -Wl,--no-whole-archive ${_NSS_FILES_HOSTS_OS} -lresolv")

# Append to standard libs so order is correct and corrosion stays happy
set(CMAKE_C_STANDARD_LIBRARIES   "${CMAKE_C_STANDARD_LIBRARIES}${_LIBCXX_ARCHIVES}${_TAIL_LIBS} ${CMAKE_DL_LIBS}")
set(CMAKE_CXX_STANDARD_LIBRARIES "${CMAKE_CXX_STANDARD_LIBRARIES}${_LIBCXX_ARCHIVES}${_TAIL_LIBS} ${CMAKE_DL_LIBS}")

# ------------------- RUST / cc crate env -------------------

# Ensure build scripts (cc crate) use clang without gcc-toolchain in CFLAGS
set(ENV{CC}   "${_CLANG_BIN}/clang")
set(ENV{CXX}  "${_CLANG_BIN}/clang++")
set(ENV{AR}   "${_CLANG_BIN}/llvm-ar")

set(ENV{CC_x86_64_unknown_linux_gnu}   "${_CLANG_BIN}/clang")
set(ENV{CXX_x86_64_unknown_linux_gnu}  "${_CLANG_BIN}/clang++")

# Only portable compile flags here (NO --gcc-toolchain/-B)
set(ENV{CFLAGS_x86_64_unknown_linux_gnu}   "--sysroot=${_GLIBC_SYSROOT} -static -fPIC")
set(ENV{CXXFLAGS_x86_64_unknown_linux_gnu} "--sysroot=${_GLIBC_SYSROOT} -static -fPIC")

# Make rustc link with our link-time hints and suppress auto -lc++
set(ENV{CARGO_TARGET_X86_64_UNKNOWN_LINUX_GNU_RUSTFLAGS}
    "-Clink-arg=--sysroot=${_GLIBC_SYSROOT} -Clink-arg=-B${_GCC_LIBDIR} -Clink-arg=-nostdlib++")

# PIC is fine
set(CMAKE_POSITION_INDEPENDENT_CODE ON)

