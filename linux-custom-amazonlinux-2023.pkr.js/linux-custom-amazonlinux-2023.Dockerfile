ARG AMAZONLINUX_2023="almalinux@sha256:eb5359d566df2b34cb58be63c2d0fa1476e7654833d4d3af307b930a8fac6446"
FROM ${AMAZONLINUX_2023}

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