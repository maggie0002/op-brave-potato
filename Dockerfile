FROM ubuntu:20.04 AS extract-image

ARG IMAGE_URL="https://github.com/maggie0002/op-brave-potato/releases/download/0.0.3/generic_amd64_2.108.0.qcow2.zip"

RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    ca-certificates \
    unzip \
    wget && \
    rm -rf /var/lib/apt/lists/*

RUN wget -O balena-image.zip $IMAGE_URL && \
    unzip balena-image.zip && \
    mv *.qcow2 balena-source.qcow2 && \
    rm balena-image.zip


FROM ubuntu:20.04

ARG DEBIAN_FRONTEND=noninteractive
ENV TZ=Etc/UTC

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

COPY --from=extract-image balena.qcow2 .
COPY dnsmasq.conf .
COPY entrypoint.sh .
COPY start.sh .

RUN chmod +x entrypoint.sh start.sh

ENTRYPOINT [ "/app/entrypoint.sh" ]

CMD ["/app/start.sh"]
