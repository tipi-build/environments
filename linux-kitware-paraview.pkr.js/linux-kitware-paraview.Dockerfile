ARG UBUNTU_24_04="ubuntu@sha256:e21f810fa78c09944446ec02048605eb3ab1e4e2e261c387ecc7456b38400d79"
FROM ${UBUNTU_24_04}

ENV TIPI_DISTRO_MODE=default
ENV TIPI_INSTALL_LEGACY_PACKAGES=OFF

RUN apt-get update && apt-get install -y git cmake build-essential libgl1-mesa-dev libxt-dev libqt5x11extras5-dev libqt5help5 qttools5-dev qtxmlpatterns5-dev-tools libqt5svg5-dev python3-dev python3-numpy libopenmpi-dev libtbb-dev ninja-build qtbase5-dev qtchooser qt5-qmake qtbase5-dev-tools mesa-common-dev mesa-utils freeglut3-dev curl sudo clang clang-format clang-tidy lldb lld
RUN curl -fsSL https://raw.githubusercontent.com/tipi-build/cli/bf984045460fb3cb1730d58056ac32437f0b2a01/install/container/ubuntu.sh -o ubuntu.sh && /bin/bash ubuntu.sh && chmod 777 /usr/local/share/.tipi/.distro.mode && chmod -R 777 /usr/local/share/.tipi
USER tipi
WORKDIR /home/tipi
EXPOSE 22
