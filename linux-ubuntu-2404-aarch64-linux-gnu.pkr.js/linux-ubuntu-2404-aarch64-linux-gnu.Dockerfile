ARG UBUNTU_24_04="ubuntu@sha256:04f510bf1f2528604dc2ff46b517dbdbb85c262d62eacc4aa4d3629783036096"
FROM ${UBUNTU_24_04}


ARG DEBIAN_FRONTEND=noninteractive # avoid tzdata asking for configuration
RUN apt update -y && apt install -y curl gettext build-essential g++-aarch64-linux-gnu
# Install tipi and cmake-re
# 48ce3ef91475343122fe02477555dec5a6df10c2 v0.0.81 
RUN curl -fsSL https://raw.githubusercontent.com/tipi-build/cli/48ce3ef91475343122fe02477555dec5a6df10c2/install/container/ubuntu.sh -o ubuntu.sh && /bin/bash ubuntu.sh
USER tipi
WORKDIR /home/tipi
EXPOSE 22

