ARG TIPI_UBUNTU_CLANG20_24_04="tipibuild/tipi-ubuntu-2404-clang20@sha256:385f613d18a3ce307aeaf4b8be59e3bc82aa1bc5263cad1fb70a8d6735fc77b5"
FROM ${TIPI_UBUNTU_CLANG20_24_04}
MAINTAINER tipi.build by EngFlow

# Preinstall dependencies
RUN mkdir -p /compute_array_sum && \
  git clone --depth 1  https://github.com/tipibuild/unittest-compute_array_sum.git /compute_array_sum && \
  PATH=`tipi run printenv PATH` cmake -DCMAKE_BUILD_TYPE=Release \
    -G Ninja \
    -S /compute_array_sum \
    -B /compute_array_sum/build \
    -DCMAKE_CXX_COMPILER=/usr/bin/clang++ \
    -DCMAKE_C_COMPILER=/usr/bin/clang \
    -DCMAKE_INSTALL_PREFIX=/usr/ && \
  PATH=`tipi run printenv PATH` cmake --build /compute_array_sum/build --target install && \
  rm -rf /compute_array_sum
