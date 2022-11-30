FROM ubuntu:20.04

ARG DEBIAN_FRONTEND=noninteractive
ARG CLI_VERSION="14.5.2"
ARG GENERIC_AARCH64_VERSION="2.107.13"
ARG GENERIC_AMD64_VERSION="2.105.2"

ENV TZ=Etc/UTC
ENV PATH /app/balena-cli:$PATH

WORKDIR /app

RUN apt-get update && \
    apt-get install -y \
    dnsmasq \
    ovmf \
    qemu-system-aarch64 \
    qemu-system-x86 \
    socat \
    unzip \
    wget && \
    rm -rf /var/lib/apt/lists/*

# Fetch OS image and configure as qcow2
RUN if [ $(uname -p) = "aarch64" ] ; then \
    wget -O balena.zip "https://api.balena-cloud.com/download?deviceType=generic-aarch64&version=$GENERIC_AARCH64_VERSION&fileType=.zip&developmentMode=true"; \
    else \
    wget -O balena.zip "https://api.balena-cloud.com/download?deviceType=generic-amd64&version=$GENERIC_AMD64_VERSION&fileType=.zip&developmentMode=true"; \
    fi && \
    unzip balena.zip && \
    rm balena.zip && \
    mv *.img balena.img && \
    qemu-img convert -f raw -O qcow2 balena.img balena-source.qcow2 && \
    qemu-img create -f qcow2 -F qcow2 -b balena-source.qcow2 balena.qcow2 8G && \
    rm balena.img

RUN wget -O balena-cli.zip "https://github.com/balena-io/balena-cli/releases/download/v$CLI_VERSION/balena-cli-v$CLI_VERSION-linux-x64-standalone.zip" && \
    unzip balena-cli.zip && \
    rm balena-cli.zip

COPY dnsmasq.conf .
COPY entrypoint.sh .
COPY start.sh .

RUN chmod +x entrypoint.sh start.sh

ENTRYPOINT [ "/app/entrypoint.sh" ]

CMD ["/app/start.sh"]
