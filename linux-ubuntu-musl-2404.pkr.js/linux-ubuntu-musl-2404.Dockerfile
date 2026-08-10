ARG SYSROOT_PATH=/opt/sysroot/musl
ARG UBUNTU_24_04="ubuntu@sha256:04f510bf1f2528604dc2ff46b517dbdbb85c262d62eacc4aa4d3629783036096"
ARG DEBIAN_FRONTEND=noninteractive

FROM ${UBUNTU_24_04} AS build

ARG LINUX_VERSION=v6.17
ARG LLVM_VERSION=llvmorg-21.1.4
ARG MUSL_VERSION=v1.2.5

ARG LINUX_ARCH=x86
ARG LLVM_ARCH=X86
ARG TARGET_TRIPLE=x86_64-unknown-linux-musl
ARG TARGET_TRIPLE_COMPAT=x86_64-linux-gnu
ARG SYSROOT_PATH
ARG DEBIAN_FRONTEND

RUN apt-get update && apt-get install -y --no-install-recommends \
  ca-certificates \
  build-essential \
  git \
  clang \
  lld \
  llvm \
  ccache \
  cmake \
  ninja-build \
  python3 \
  rsync \
  && rm -rf /var/lib/apt/lists/*

# Get all the sources
RUN mkdir /sources

WORKDIR /sources
RUN git clone https://github.com/llvm/llvm-project.git --recurse-submodules --shallow-submodules --depth=1 --branch ${LLVM_VERSION}
RUN git clone https://github.com/nxxm/musl.git --recurse-submodules --shallow-submodules --depth=1 --branch ${MUSL_VERSION}
RUN git clone https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git --depth=1 --branch=${LINUX_VERSION}

# Install the musl headers and libs, built with host clang
WORKDIR /sources/musl
RUN AR=llvm-ar RANLIB=llvm-ranlib CC=clang ./configure --disable-shared --prefix="${SYSROOT_PATH}" && make -j$(nproc) install

# Install the linux headers, required by libc++
WORKDIR /sources/linux
RUN make headers_install -j$(nproc) ARCH=${LINUX_ARCH} INSTALL_HDR_PATH="${SYSROOT_PATH}" \
  && mkdir -p "${SYSROOT_PATH}/include/${TARGET_TRIPLE}" \
  && mv "${SYSROOT_PATH}/include/asm" "${SYSROOT_PATH}/include/${TARGET_TRIPLE}/"

# Add a compatibility link to ensure that the Clang driver automatically adds it to the include path if needed
RUN mkdir -p "${SYSROOT_PATH}/usr" \
  && ln -s ../include "${SYSROOT_PATH}/usr/include" \
  && if [ -n "${TARGET_TRIPLE_COMPAT}" -a "${TARGET_TRIPLE}" != "${TARGET_TRIPLE_COMPAT}" ]; then \
       ln -s "${TARGET_TRIPLE}" "${SYSROOT_PATH}/include/${TARGET_TRIPLE_COMPAT}"; \
     fi

# Build and install Clang, LLD, LLVM tools and runtimes
WORKDIR /sources/llvm-project
RUN --mount=type=cache,target=/root/.cache/ccache cmake -G Ninja -S llvm -B build/musl \
  -DLLVM_ENABLE_PROJECTS="clang;lld" \
  -DLLVM_ENABLE_RUNTIMES="libcxx;libcxxabi;libunwind;compiler-rt" \
  -DLLVM_DEFAULT_TARGET_TRIPLE="${TARGET_TRIPLE}" \
  -DLLVM_RUNTIME_TARGETS="${TARGET_TRIPLE}" \
  -DLLVM_BUILTIN_TARGETS="${TARGET_TRIPLE}" \
  -DLLVM_TARGETS_TO_BUILD="${LLVM_ARCH}" \
  -DLLVM_INSTALL_TOOLCHAIN_ONLY=ON \
  -DLLVM_INSTALL_BINUTILS_SYMLINKS=ON \
  -DLLVM_ENABLE_LLD=ON \
  -DLLVM_ENABLE_LTO=Thin \
  -DLLVM_CCACHE_BUILD=ON \
  -DCLANG_DEFAULT_RTLIB=compiler-rt \
  -DCLANG_DEFAULT_LINKER=lld \
  -DCLANG_DEFAULT_CXX_STDLIB=libc++ \
  -DCLANG_DEFAULT_UNWINDLIB=libunwind \
  -DRUNTIMES_${TARGET_TRIPLE}_COMPILER_RT_CXX_LIBRARY=libcxx \
  -DRUNTIMES_${TARGET_TRIPLE}_COMPILER_RT_USE_LLVM_UNWINDER=ON \
  -DRUNTIMES_${TARGET_TRIPLE}_COMPILER_RT_BUILD_LIBFUZZER=OFF \
  -DRUNTIMES_${TARGET_TRIPLE}_COMPILER_RT_BUILD_ORC=OFF \
  -DRUNTIMES_${TARGET_TRIPLE}_COMPILER_RT_BUILD_XRAY=OFF \
  -DRUNTIMES_${TARGET_TRIPLE}_COMPILER_RT_BUILD_SANITIZERS=OFF \
  -DRUNTIMES_${TARGET_TRIPLE}_LIBCXX_ENABLE_SHARED=OFF \
  -DRUNTIMES_${TARGET_TRIPLE}_LIBCXX_HAS_MUSL_LIBC=ON \
  -DRUNTIMES_${TARGET_TRIPLE}_LIBCXX_STATICALLY_LINK_ABI_IN_STATIC_LIBRARY=ON \
  -DRUNTIMES_${TARGET_TRIPLE}_LIBCXXABI_ENABLE_SHARED=OFF \
  -DRUNTIMES_${TARGET_TRIPLE}_LIBCXXABI_USE_COMPILER_RT=ON \
  -DRUNTIMES_${TARGET_TRIPLE}_LIBCXXABI_USE_LLVM_UNWINDER=ON \
  -DRUNTIMES_${TARGET_TRIPLE}_LIBUNWIND_ENABLE_SHARED=OFF \
  -DRUNTIMES_${TARGET_TRIPLE}_CMAKE_SYSROOT="${SYSROOT_PATH}" \
  -DCMAKE_INSTALL_PREFIX="${SYSROOT_PATH}" \
  -DCMAKE_BUILD_TYPE=Release \
  -DCMAKE_C_COMPILER=clang \
  -DCMAKE_CXX_COMPILER=clang++ \
  && ninja -C build/musl \
  && cmake --install build/musl --strip \
  && echo "--sysroot=<CFGDIR>/.." > "${SYSROOT_PATH}/bin/${TARGET_TRIPLE}.cfg"

# Create an empty libatomic archive to improve compatibility with builds requiring it on Linux
# even though the functionality is already provided by compiler-rt.
RUN ${SYSROOT_PATH}/bin/llvm-ar -r ${SYSROOT_PATH}/lib/libatomic.a

FROM ${UBUNTU_24_04}

ARG SYSROOT_PATH
ARG DEBIAN_FRONTEND

# Copy the sysroot from the previous stage
COPY --from=build "${SYSROOT_PATH}" "${SYSROOT_PATH}"

# Copy the just-built tipi release from previous CI stage
ENV TIPI_DISTRO_MODE=default
ENV TIPI_INSTALL_LEGACY_PACKAGES=OFF
ENV TIPI_INSTALL_SOURCE=file:///tipi-linux-x86_64.zip
COPY --from=tipi /tipi-linux-x86_64.zip .

# Install tipi and cmake-re
RUN apt-get update && apt-get install -y --no-install-recommends \
  ca-certificates \
  curl \
  gettext \
  && rm -rf /var/lib/apt/lists/*
# Install script for v0.0.80
RUN curl -fsSL https://raw.githubusercontent.com/tipi-build/cli/11469c0ac2612565000444950cf0e8dcdd827657/install/container/ubuntu.sh -o ubuntu.sh && /bin/bash ubuntu.sh

# Configure tipi user
USER tipi
WORKDIR /home/tipi
EXPOSE 22
