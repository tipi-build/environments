ARG AMAZONLINUX_2="almalinux@sha256:d9b9601f736ab1993b9465e1b4aa3104dc0e8137fb321dd349df7dd91f7110d6"
FROM ${AMAZONLINUX_2}

# Install tipi and cmake-re
ENV TIPI_DISTRO_MODE=default
ENV TIPI_INSTALL_LEGACY_PACKAGES=OFF
ENV SUDO_GROUP=wheel
ENV TIPI_INSTALL_SOURCE=file:///tipi-linux-x86_64.zip
COPY --from=tipi /tipi-linux-x86_64.zip .
RUN curl -fsSL https://raw.githubusercontent.com/tipi-build/cli/2f7d8734e05c0cb6dd23bbdd27234c75676bac1e/install/container/centos.sh -o centos.sh && /bin/bash centos.sh

USER tipi
WORKDIR /home/tipi
EXPOSE 22