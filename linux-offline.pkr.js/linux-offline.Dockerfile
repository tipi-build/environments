ARG UBUNTU_24_04="ubuntu@sha256:04f510bf1f2528604dc2ff46b517dbdbb85c262d62eacc4aa4d3629783036096"
FROM ${UBUNTU_24_04}

ENV TIPI_DISTRO_MODE=default
ENV TIPI_DISTRO_JSON=http://127.0.0.1:8080/distro.local.json
ENV TIPI_DISTRO_JSON_SHA1=4bcb47d95c3b0fb54d59eb19beeb1e10074566ea
ENV TIPI_INSTALL_SOURCE=http://127.0.0.1:8080/tipi-linux.zip
ENV TIPI_CLIENT_INSTALL_SCRIPT_SOURCE=http://127.0.0.1:8080/084b166ff5c53c743fc634b8942f187abf72a35a-install_for_macos_linux.sh
ENV TIPI_UTIL_LINUX_SOURCES_MIRROR=http://127.0.0.1:8080/util-linux-2.39.tar.gz
ENV TIPI_CONTAINER_INSTALL_SCRIPT=http://127.0.0.1:8080/6283df656126fe2f4bb7fc17a4dc2ba651797476-ubuntu.sh

ARG DEBIAN_FRONTEND=noninteractive # avoid tzdata asking for configuration
# Install tipi and cmake-re
RUN apt update -y && apt install -y curl gettext
RUN curl -fsSL ${TIPI_CONTAINER_INSTALL_SCRIPT} -o cmake-re_container_install.sh && /bin/bash cmake-re_container_install.sh
USER tipi
WORKDIR /home/tipi
EXPOSE 22

