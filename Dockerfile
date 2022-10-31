FROM ubuntu:20.04

ARG DEBIAN_FRONTEND=noninteractive
ENV TZ=Etc/UTC

ENV PATH /app/balena-cli:$PATH

WORKDIR /app

RUN apt-get update && \
    apt-get install -y \
    bridge-utils \
    curl \
    dnsmasq \
    git \
    iputils-ping \
    iproute2 \
    nano \
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

# Fetch OS image and configure as qcow2
RUN wget -O balena.zip "https://api.balena-cloud.com/download?deviceType=generic-amd64&version=2.105.2&fileType=.zip&developmentMode=true" && \
    unzip balena.zip && \
    rm balena.zip && \
    mv *.img balena.img && \
    qemu-img convert -f raw -O qcow2 balena.img balena-source.qcow2 && \
    qemu-img create -f qcow2 -F qcow2 -b balena-source.qcow2 balena.qcow2 8G && \
    rm balena.img

# Install the balena-cli
RUN wget -O balena-cli.zip "https://github.com/balena-io/balena-cli/releases/download/v14.5.2/balena-cli-v14.5.2-linux-x64-standalone.zip" && \
    unzip balena-cli.zip && \
    rm balena-cli.zip

RUN mkdir -p /etc/qemu

RUN echo "allow br0" >> /etc/qemu/bridge.conf

COPY guests-x86_64-internal.yml guests.yml
COPY entrypoint.sh .

RUN chmod +x entrypoint

ENTRYPOINT [ "/app/entrypoint.sh" ]

CMD ["sleep", "infinity"]
