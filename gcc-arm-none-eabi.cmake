# Copyright (c) 2022 Yannic Staudt
# Copyright (c) 2022 tipi technologies ltd (CH / ZH)
# All rights reserved.

# gcc-arm-none-eabi cross compiler installed with tipi

if(DEFINED POLLY_GCC_ARM_NONE_EABI_)
  return()
else()
  set(POLLY_GCC_ARM_NONE_EABI_ 1)
endif()

include("${CMAKE_CURRENT_LIST_DIR}/utilities/polly_init.cmake")

# Set system depended extensions
if(WIN32)
	polly_init(
	    "None / gcc / arm"
		"Ninja"
	)

	# on windows we need to specify a .exe suffix for all tools 
	# for them to be found on the PATH
    set(CROSS_COMPILE_TOOLCHAIN_EXECUTABLE_SUFFIX ".exe" )
else()
    polly_init(
	    "None / gcc / arm"
		"Ninja"
	)

	set(CROSS_COMPILE_TOOLCHAIN_EXECUTABLE_SUFFIX "" )
endif()

include("${CMAKE_CURRENT_LIST_DIR}/utilities/polly_common.cmake")

# Set taget information
set(CMAKE_SYSTEM_NAME Generic)
set(CMAKE_SYSTEM_PROCESSOR ARM)
set(CROSS_COMPILE_TOOLCHAIN_PREFIX "arm-none-eabi")
#set(CMAKE_CROSSCOMPILING_EMULATOR qemu-arm) # used for try_run calls

# set the tools properly (for windows too)
set(CMAKE_AR               ${CROSS_COMPILE_TOOLCHAIN_PREFIX}-ar${CROSS_COMPILE_TOOLCHAIN_EXECUTABLE_SUFFIX}       CACHE INTERNAL "Ar")
set(CMAKE_ASM_COMPILER     ${CROSS_COMPILE_TOOLCHAIN_PREFIX}-gcc${CROSS_COMPILE_TOOLCHAIN_EXECUTABLE_SUFFIX}      CACHE INTERNAL "ASM Compiler")
set(CMAKE_C_COMPILER       ${CROSS_COMPILE_TOOLCHAIN_PREFIX}-gcc${CROSS_COMPILE_TOOLCHAIN_EXECUTABLE_SUFFIX}      CACHE INTERNAL "C Compiler")
set(CMAKE_CXX_COMPILER     ${CROSS_COMPILE_TOOLCHAIN_PREFIX}-g++${CROSS_COMPILE_TOOLCHAIN_EXECUTABLE_SUFFIX}      CACHE INTERNAL "CXX Compiler")
set(CMAKE_LINKER           ${CROSS_COMPILE_TOOLCHAIN_PREFIX}-ld${CROSS_COMPILE_TOOLCHAIN_EXECUTABLE_SUFFIX}       CACHE INTERNAL "Linker")
set(CMAKE_OBJCOPY          ${CROSS_COMPILE_TOOLCHAIN_PREFIX}-objcopy${CROSS_COMPILE_TOOLCHAIN_EXECUTABLE_SUFFIX}  CACHE INTERNAL "ObjCopy")
set(CMAKE_RANLIB           ${CROSS_COMPILE_TOOLCHAIN_PREFIX}-ranlib${CROSS_COMPILE_TOOLCHAIN_EXECUTABLE_SUFFIX}   CACHE INTERNAL "Ranlib")
set(CMAKE_SIZE             ${CROSS_COMPILE_TOOLCHAIN_PREFIX}-size${CROSS_COMPILE_TOOLCHAIN_EXECUTABLE_SUFFIX}     CACHE INTERNAL "Size")
set(CMAKE_STRIP            ${CROSS_COMPILE_TOOLCHAIN_PREFIX}-strip${CROSS_COMPILE_TOOLCHAIN_EXECUTABLE_SUFFIX}    CACHE INTERNAL "Strip")

# Perform compiler test with static library
set(CMAKE_TRY_COMPILE_TARGET_TYPE STATIC_LIBRARY)

include(
    "${CMAKE_CURRENT_LIST_DIR}/compiler/gcc-cross-compile-simple-layout.cmake"
)
#include("${CMAKE_CURRENT_LIST_DIR}/flags/cxx11.cmake")
#include("${CMAKE_CURRENT_LIST_DIR}/flags/hardfloat.cmake")

#---------------------------------------------------------------------------------------
# Set compiler/linker flags
#---------------------------------------------------------------------------------------

# Object build options
# -O0                   No optimizations, reduce compilation time and make debugging produce the expected results.
# -mthumb               Generat thumb instructions.
# -fno-builtin          Do not use built-in functions provided by GCC.
# -Wall                 Print only standard warnings, for all use Wextra
# -ffunction-sections   Place each function item into its own section in the output file.
# -fdata-sections       Place each data item into its own section in the output file.
# -fomit-frame-pointer  Omit the frame pointer in functions that don’t need one.
# -mabi=aapcs           Defines enums to be a variable sized type.
set(OBJECT_GEN_FLAGS "-Os -ffunction-sections -fdata-sections -Wall -Wa,-adhlns=\"$@.lst\" -pipe -fmessage-length=0 -mcpu=cortex-m0 -mthumb -fno-exceptions")

set(CMAKE_C_FLAGS   "${OBJECT_GEN_FLAGS} -std=gnu99 -flto -ffat-lto-objects -mcpu=cortex-m0 " CACHE INTERNAL "C Compiler options")
set(CMAKE_CXX_FLAGS "${OBJECT_GEN_FLAGS} -std=c++17 -fpermissive -fno-rtti -flto -ffat-lto-objects -mcpu=cortex-m0 " CACHE INTERNAL "C++ Compiler options")
set(CMAKE_ASM_FLAGS "-std=gnu99 -mthumb -mcpu=cortex-m0" CACHE INTERNAL "ASM Compiler options")


# -Wl,--gc-sections     Perform the dead code elimination.
# --specs=nano.specs    Link with newlib-nano.
# --specs=nosys.specs   No syscalls, provide empty implementations for the POSIX system calls.
set(CMAKE_EXE_LINKER_FLAGS "-Wl,--cref -Xlinker --gc-sections -Xlinker --print-gc-sections -specs=nano.specs -specs=nosys.specs -Wl,-Map=${CMAKE_PROJECT_NAME}.map -mcpu=cortex-m0 -mthumb -flto"  CACHE INTERNAL "Linker options")


#---------------------------------------------------------------------------------------
# Set debug/release build configuration Options
#---------------------------------------------------------------------------------------

# Options for DEBUG build
# -Og   Enables optimizations that do not interfere with debugging.
# -g    Produce debugging information in the operating system’s native format.
set(CMAKE_C_FLAGS_DEBUG "-Og -g" CACHE INTERNAL "C Compiler options for debug build type")
set(CMAKE_CXX_FLAGS_DEBUG "-Og -g" CACHE INTERNAL "C++ Compiler options for debug build type")
set(CMAKE_ASM_FLAGS_DEBUG "-g" CACHE INTERNAL "ASM Compiler options for debug build type")
set(CMAKE_EXE_LINKER_FLAGS_DEBUG "" CACHE INTERNAL "Linker options for debug build type")

# Options for RELEASE build
# -Os   Optimize for size. -Os enables all -O2 optimizations.
# -flto Runs the standard link-time optimizer.
set(CMAKE_C_FLAGS_RELEASE "-Os" CACHE INTERNAL "C Compiler options for release build type")
set(CMAKE_CXX_FLAGS_RELEASE "-Os" CACHE INTERNAL "C++ Compiler options for release build type")
set(CMAKE_ASM_FLAGS_RELEASE "" CACHE INTERNAL "ASM Compiler options for release build type")
set(CMAKE_EXE_LINKER_FLAGS_RELEASE "" CACHE INTERNAL "Linker options for release build type")