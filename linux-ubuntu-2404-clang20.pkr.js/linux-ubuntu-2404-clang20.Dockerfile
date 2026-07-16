ARG UBUNTU_24_04="ubuntu@sha256:04f510bf1f2528604dc2ff46b517dbdbb85c262d62eacc4aa4d3629783036096"
FROM ${UBUNTU_24_04}
MAINTAINER tipi.build by EngFlow

# Install base tooling
RUN apt-get update -y && apt-get install -y gcc g++ make unzip curl wget build-essential gettext autoconf libbz2-dev xz-utils zlib1g-dev libzstd-dev

# Install tipi and cmake-re from just-build cmake-re via env:TIPI_CONTAINER_BUILD_ADDITIONAL_PARAMETERS: "--build-context tipi=${{ github.workspace }}/container-build/additional-docker-context"
COPY --from=tipi /tipi-linux-x86_64.zip .
ENV TIPI_INSTALL_SOURCE=file:///tipi-linux-x86_64.zip
RUN curl -fsSL https://github.com/tipi-build/cli/raw/57fe06218a15ef25764883a64f75a68e7636df9b/install/container/ubuntu.sh -o ubuntu.sh && /bin/bash ubuntu.sh
EXPOSE 22

RUN chmod 777 /usr/local/share/.tipi/.distro.mode \
  && chmod -R 777 /usr/local/share/.tipi

# Standard Clang 20
RUN mkdir -p /llvm-project && \
  git clone --branch llvmorg-20.1.2 --depth 1 https://github.com/llvm/llvm-project.git /llvm-project && \
  PATH=`tipi run printenv PATH` cmake  \
    -GNinja \
    -DCMAKE_BUILD_TYPE=Release \
    -DCMAKE_INSTALL_PREFIX=/usr \
    -DLLVM_ENABLE_ZLIB=FORCE_ON \
    -DLLVM_ENABLE_ZSTD=FORCE_ON \
    -DLLVM_ENABLE_PROJECTS='clang;clang-tools-extra;polly;compiler-rt' \
    -DLLVM_ENABLE_RUNTIMES='libcxx;libcxxabi;libunwind' \
    -DLIBCXXABI_USE_LLVM_UNWINDER=YES \
    -DCLANG_DEFAULT_CXX_STDLIB=libc++ \
    -DLIBCXX_CXX_ABI=libcxxabi \
    -S /llvm-project/llvm \
    -B /llvm-project/build && \
  PATH=`tipi run printenv PATH` cmake --build /llvm-project/build --target install && \
  echo "/usr/lib/x86_64-unknown-linux-gnu" > /etc/ld.so.conf.d/clang.conf && \
  ldconfig && \
  rm -rf /llvm-project/

RUN apt-get remove -y g++ 

# MSAN Clang 20 libcxx
# Installs instrumented libc++.so alongside non-instrumented one (in /usr/local) so that the compiler can run at full speed with MSAN instrumentation
# 
# To enable binary instrumentation, link them with /usr/local/lib/libc++.so
#
RUN mkdir -p /llvm-project && \
  git clone --branch llvmorg-20.1.2 --depth 1 https://github.com/llvm/llvm-project.git /llvm-project && \
  PATH=`tipi run printenv PATH` cmake  \
    -DCMAKE_BUILD_TYPE=Release \
    -G Ninja \
    -S /llvm-project/runtimes \
    -B /llvm-project/build-msan \
    -DCMAKE_CXX_COMPILER=/usr/bin/clang++ \
    -DCMAKE_C_COMPILER=/usr/bin/clang \
    -DCMAKE_INSTALL_PREFIX=/usr/local/instrumented/msan \
    -DLLVM_USE_SANITIZER=MemoryWithOrigins \
    -DLLVM_ENABLE_RUNTIMES='libcxx;libcxxabi' \
    -DLIBCXXABI_USE_LLVM_UNWINDER=Off && \
  PATH=`tipi run printenv PATH` cmake --build /llvm-project/build-msan --target install && \
  rm -rf /llvm-project/

ENV MSAN_SYMBOLIZER_PATH=/usr/bin/llvm-symbolizer

RUN sudo apt-get update -y && sudo apt-get install -y valgrind
