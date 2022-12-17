FROM ubuntu:20.04

ARG DEBIAN_FRONTEND=noninteractive
ENV TZ=Etc/UTC

ENV GENERIC_AMD64_VERSION="2.108.0"

WORKDIR /app

RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    ca-certificates \
    dnsmasq \
    ovmf \
    qemu-system-x86 \
    qemu-utils \
    socat \
    unzip \
    wget && \
    rm -rf /var/lib/apt/lists/*

COPY dnsmasq.conf .
COPY entrypoint.sh .
COPY start.sh .

RUN chmod +x entrypoint.sh start.sh

ENTRYPOINT [ "/app/entrypoint.sh" ]

CMD ["/app/start.sh"]
