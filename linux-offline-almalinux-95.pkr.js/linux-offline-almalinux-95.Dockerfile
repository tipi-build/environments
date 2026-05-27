ARG ALMALINUX_9_5="almalinux@sha256:91387bd5b12c2626c9b01a8062e6dd02cdf3a9d4b9ba705631c01597f9e3ae06"
FROM ${ALMALINUX_9_5}

ENV TIPI_DISTRO_MODE=default
ENV TIPI_DISTRO_JSON=http://127.0.0.1:8080/distro.local.json
ENV TIPI_DISTRO_JSON_SHA1=4bcb47d95c3b0fb54d59eb19beeb1e10074566ea
ENV TIPI_INSTALL_SOURCE=http://127.0.0.1:8080/tipi-linux.zip
ENV TIPI_CLIENT_INSTALL_SCRIPT_SOURCE=http://127.0.0.1:8080/084b166ff5c53c743fc634b8942f187abf72a35a-install_for_macos_linux.sh
ENV TIPI_UTIL_LINUX_SOURCES_MIRROR=http://127.0.0.1:8080/util-linux-2.39.tar.gz
ENV TIPI_CONTAINER_INSTALL_SCRIPT=http://127.0.0.1:8080/62a7d552371c134cc23f302497ddaf4cc481f38c-centos.sh
ENV SUDO_GROUP=wheel

# Install tipi and cmake-re
RUN yum update -y && yum install -y ca-certificates 
RUN curl -fsSL ${TIPI_CONTAINER_INSTALL_SCRIPT} -o cmake-re_container_install.sh && /bin/bash cmake-re_container_install.sh
USER tipi
WORKDIR /home/tipi
EXPOSE 22