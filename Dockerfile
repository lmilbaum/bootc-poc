### 1.0.0

FROM quay.io/fedora/fedora-bootc:44

LABEL org.opencontainers.image.source="https://github.com/lmilbaum/bootc-poc"

### 2.0.0

ARG RKE2_CHANNEL=stable
ARG RKE2_VERSION=v1.34.9+rke2r1

ENV INSTALL_RKE2_TYPE=server
ENV INSTALL_RKE2_CHANNEL=${RKE2_CHANNEL}
ENV INSTALL_RKE2_VERSION=${RKE2_VERSION}
ENV INSTALL_RKE2_METHOD=rpm

COPY files/config.yaml /etc/rancher/rke2/config.yaml

RUN dnf -y update && \
    dnf -y install \
        curl \
        jq \
        git \
        iproute \
        iptables \
        conntrack-tools \
        openssl \
        hostname && \
    dnf clean all && \
    curl -sfL https://get.rke2.io | sh - && \
    mkdir -p /etc/rancher/rke2 && \
    systemctl enable rke2-server.service

CMD ["/sbin/init"]
