FROM ubuntu:20.04 AS extract-image

RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    unzip && \
    rm -rf /var/lib/apt/lists/*

COPY img/*.zip balena-image.zip

RUN unzip balena-image.zip && \
    mv *.qcow2 balena.qcow2 && \
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
