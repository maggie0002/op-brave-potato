FROM ubuntu:20.04

ARG DEBIAN_FRONTEND=noninteractive
ENV TZ=Etc/UTC

WORKDIR /app

RUN apt-get update && \
    apt-get install -y \
    curl \
    git \
    ovmf \
    qemu-system-x86 \
    unzip \
    wget && \
    rm -rf /var/lib/apt/lists/*

RUN curl -sL https://deb.nodesource.com/setup_16.x | bash - && \
    apt-get install nodejs && \
    rm -rf /var/lib/apt/lists/*

RUN git clone --depth 1 https://github.com/balena-labs-research/balenaVirt.git .

RUN npm install

RUN wget -O balena.zip "https://api.balena-cloud.com/download?deviceType=generic-amd64&version=2.105.2&fileType=.zip&developmentMode=true" && \
    unzip balena.zip && \
    rm balena.zip && \
    mv *.img balena.img && \
    qemu-img convert -f raw -O qcow2 balena.img balena-source.qcow2 && \
    qemu-img create -f qcow2 -F qcow2 -b balena-source.qcow2 balena.qcow2 10G && \
    rm balena.img

COPY guests-x86_64.yml guests.yml
