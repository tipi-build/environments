ARG ALMALINUX_9_5="almalinux@sha256:91387bd5b12c2626c9b01a8062e6dd02cdf3a9d4b9ba705631c01597f9e3ae06"
FROM ${ALMALINUX_9_5}

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