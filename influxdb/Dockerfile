ARG BUILD_FROM=ghcr.io/hassio-addons/debian-base/amd64:6.2.7
# hadolint ignore=DL3006
FROM ${BUILD_FROM}

# Set shell
SHELL ["/bin/bash", "-o", "pipefail", "-c"]

# Setup base system
ARG BUILD_ARCH=amd64
ARG INFLUXDB_VERSION="2.7.1"
ARG INFLUXCLI_VERSION="2.7.3"
ARG TRAEFIK_VERSION="2.10.4"

RUN \
    apt-get update \
    && apt-get install -y --no-install-recommends \
        luarocks=2.4.2+dfsg-1.1 \
        procps=2:3.3.17-5 \
    \
    && luarocks install lua-resty-http 0.15-0 \
    \
    && ARCH="${BUILD_ARCH}" \
    && if [ "${BUILD_ARCH}" = "aarch64" ]; then ARCH="arm64"; fi \
    && if [ "${BUILD_ARCH}" = "armv7" ]; then ARCH="armhf"; fi \
    \

    && curl -J -L -o /tmp/influxdb.deb \
        "https://dl.influxdata.com/influxdb/releases/influxdb2-${INFLUXDB_VERSION}-${ARCH}.deb" \
    \
    && curl -J -L -o /tmp/influxcli.tar.gz \
        "https://dl.influxdata.com/influxdb/releases/influxdb2-client-${INFLUXCLI_VERSION}-linux-${ARCH}.tar.gz" \
    \
    && curl -J -L -o /tmp/traefik.tar.gz \
        "https://github.com/traefik/traefik/releases/download/v${TRAEFIK_VERSION}/traefik_v${TRAEFIK_VERSION}_linux_${ARCH}.tar.gz" \
    \
    && dpkg --install /tmp/influxdb.deb \
    && tar xvzf /tmp/influxcli.tar.gz -C /tmp \
    && cp /tmp/influx /usr/local/bin/ \
    && tar xvzf /tmp/traefik.tar.gz -C /tmp \
    && cp /tmp/traefik /usr/local/bin/ \
    \
    && rm -fr \
        /tmp/* \
        /etc/nginx \
        /var/{cache,log}/* \
        /var/lib/apt/lists/* \
    \
    && mkdir -p /var/log/nginx \
    && touch /var/log/nginx/error.log

RUN mkdir -p /data/influxdb
RUN chmod 0750 /etc/influxdb \
    && chmod 0750 /data/influxdb

# Copy root filesystem
COPY rootfs /

# Set WORKDIR to automatically detect config.
WORKDIR /etc/influxdb

# Environment variables
ENV INFLUXD_CONFIG_PATH=/etc/influxdb
ENV INFLUXD_ENGINE_PATH=/data/influxdb
ENV INFLUXD_BOLT_PATH=/data/influxdb/influxd.bolt
ENV INFLUXD_HTTP_BIND_ADDRESS=0.0.0.0:8086
ENV INFLUXD_LOG_LEVEL=info

# Build arguments
ARG BUILD_ARCH
ARG BUILD_DATE
ARG BUILD_DESCRIPTION
ARG BUILD_NAME
ARG BUILD_REF
ARG BUILD_REPOSITORY
ARG BUILD_VERSION

# Labels
LABEL \
    io.hass.name="${BUILD_NAME}" \
    io.hass.description="${BUILD_DESCRIPTION}" \
    io.hass.arch="${BUILD_ARCH}" \
    io.hass.type="addon" \
    io.hass.version=${BUILD_VERSION} \
    maintainer="Daniel Oldberg <contact@danieloldberg.se>" \
    org.opencontainers.image.title="${BUILD_NAME}" \
    org.opencontainers.image.description="${BUILD_DESCRIPTION}" \
    org.opencontainers.image.vendor="" \
    org.opencontainers.image.authors="Daniel Oldberg <contact@danieloldberg.se>" \
    org.opencontainers.image.licenses="MIT" \
    org.opencontainers.image.url="https://github.com/danieloldberg/addon-influxdbv2" \
    org.opencontainers.image.source="https://github.com/${BUILD_REPOSITORY}" \
    org.opencontainers.image.documentation="https://github.com/${BUILD_REPOSITORY}/blob/main/README.md" \
    org.opencontainers.image.created=${BUILD_DATE} \
    org.opencontainers.image.revision=${BUILD_REF} \
    org.opencontainers.image.version=${BUILD_VERSION}
