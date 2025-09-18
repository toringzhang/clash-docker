FROM alpine:latest as builder
ARG CLASH_VERSION

RUN apk add --no-cache gzip wget ca-certificates unzip && \
    mkdir -p /mihomo-config && \
    wget -O /mihomo-config/geoip.metadb https://fastly.jsdelivr.net/gh/MetaCubeX/meta-rules-dat@release/geoip.metadb && \
    wget -O /mihomo-config/geosite.dat https://fastly.jsdelivr.net/gh/MetaCubeX/meta-rules-dat@release/geosite.dat && \
    wget -O /mihomo-config/geoip.dat https://fastly.jsdelivr.net/gh/MetaCubeX/meta-rules-dat@release/geoip.dat

WORKDIR /mihomo
ARG TARGETPLATFORM
RUN case "${TARGETPLATFORM}" in \
        "linux/amd64") dp="linux-amd64" ;; \
        "linux/arm64") dp="linux-arm64" ;; \
        "linux/arm/v7") dp="linux-armv7" ;; \
        *) dp="linux-amd64" ;; \
    esac && \
    echo "Using resolved DEVICE_PLATFORM=${dp}" && \
    wget -O /mihomo/mihomo.gz "https://github.com/MetaCubeX/mihomo/releases/download/${CLASH_VERSION}/mihomo-${dp}-${CLASH_VERSION}.gz" && \
    gzip -d mihomo.gz && chmod +x mihomo

RUN wget -O dist.zip https://github.com/Zephyruso/zashboard/releases/latest/download/dist.zip && \
        unzip dist.zip && rm -rf dist.zip
FROM alpine:latest
LABEL org.opencontainers.image.authors="Toring"

ENV SKIP_SAFE_PATH_CHECK=true
RUN apk add --no-cache curl ca-certificates tzdata iptables
COPY --from=builder /mihomo-config/ /root/.config/mihomo/
COPY --from=builder /mihomo/mihomo /usr/bin/mihomo
COPY --from=builder /mihomo/dist/ /clash-dashboard/
ENTRYPOINT ["/usr/bin/mihomo"]
