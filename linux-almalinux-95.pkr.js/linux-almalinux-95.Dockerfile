ARG ALMALINUX_9_5="almalinux@sha256:91387bd5b12c2626c9b01a8062e6dd02cdf3a9d4b9ba705631c01597f9e3ae06"
FROM ${ALMALINUX_9_5}

# Install tipi and cmake-re
ENV TIPI_DISTRO_MODE=all
ENV TIPI_INSTALL_LEGACY_PACKAGES=ON
ENV SUDO_GROUP=wheel
ENV TIPI_INSTALL_SOURCE=file:///tipi-linux-x86_64.zip
COPY /tipi-linux-x86_64.zip .
RUN curl -fsSL https://raw.githubusercontent.com/tipi-build/cli/21682211bb4353d740ad1c1ffd682d68b6747029/install/container/centos.sh -o centos.sh && /bin/bash centos.sh

USER tipi
WORKDIR /home/tipi
EXPOSE 22