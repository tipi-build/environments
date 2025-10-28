ARG AMAZONLINUX_2="almalinux@sha256:d9b9601f736ab1993b9465e1b4aa3104dc0e8137fb321dd349df7dd91f7110d6"
FROM ${AMAZONLINUX_2}

# Install tipi and cmake-re
ENV TIPI_DISTRO_MODE=default
ENV TIPI_INSTALL_LEGACY_PACKAGES=OFF
ENV SUDO_GROUP=wheel
ENV TIPI_INSTALL_SOURCE=file:///tipi-linux-x86_64.zip
COPY --from=tipi /tipi-linux-x86_64.zip .
RUN curl -fsSL https://raw.githubusercontent.com/tipi-build/cli/4d3116738b96de360fb5cd7653472b041bca3de1/install/container/centos.sh -o centos.sh && /bin/bash centos.sh

USER tipi
WORKDIR /home/tipi
EXPOSE 22