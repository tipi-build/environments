ARG UBUNTU_16_04="ubuntu@sha256:a3785f78ab8547ae2710c89e627783cfa7ee7824d3468cae6835c9f4eae23ff7"
FROM ${UBUNTU_16_04}

ENV TIPI_DISTRO_MODE=all
ENV TIPI_INSTALL_LEGACY_PACKAGES=ON
COPY --from=tipi /tipi-linux-x86_64.zip .
ENV TIPI_INSTALL_SOURCE=file:///tipi-linux-x86_64.zip

ARG DEBIAN_FRONTEND=noninteractive # avoid tzdata asking for configuration
# Install tipi and cmake-re

# Update su
RUN  rm /etc/pam.conf && rm  /etc/pam.d/su 
COPY ./pam-config/pam.conf /etc/
COPY ./pam-config/pam.d/su /etc/pam.d/
COPY ./pam-config/pam.d/su-l /etc/pam.d/

RUN apt update -y && apt install -y curl gettext
RUN curl -fsSL https://raw.githubusercontent.com/tipi-build/cli/4d3116738b96de360fb5cd7653472b041bca3de1/install/container/ubuntu.sh -o ubuntu.sh && /bin/bash ubuntu.sh
EXPOSE 22