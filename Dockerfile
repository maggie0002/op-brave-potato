FROM ubuntu:20.04 as image-builder

ARG GENERIC_AMD64_VERSION="2.105.2"

ENV TZ=Etc/UTC

WORKDIR /app

RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    ca-certificates \
    qemu-utils \
    unzip \
    wget

RUN wget -O balena.zip "https://api.balena-cloud.com/download?deviceType=generic-amd64&version=$GENERIC_AMD64_VERSION&fileType=.zip&developmentMode=true" && \
    unzip balena.zip && \
    mv *.img balena.img && \
    rm balena.zip

RUN qemu-img convert -f raw -O qcow2 balena.img balena-source.qcow2


FROM ubuntu:20.04

ARG DEBIAN_FRONTEND=noninteractive

ENV TZ=Etc/UTC
ENV PATH /app/balena-cli:$PATH

WORKDIR /app

RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    ca-certificates \
    dnsmasq \
    ovmf \
    qemu-system-x86 \
    qemu-utils \
    socat && \
    rm -rf /var/lib/apt/lists/*

COPY --from=image-builder /app/balena-source.qcow2 .

COPY dnsmasq.conf .
COPY entrypoint.sh .
COPY start.sh .

RUN chmod +x entrypoint.sh start.sh

ENTRYPOINT [ "/app/entrypoint.sh" ]

CMD ["/app/start.sh"]
