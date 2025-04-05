FROM alpine:latest as builder
ARG CLASH_VERSION
ARG DEVICE_PLATFORM

RUN apk add --no-cache gzip && \
    mkdir /mihomo-config && \
    wget -O /mihomo-config/geoip.metadb https://fastly.jsdelivr.net/gh/MetaCubeX/meta-rules-dat@release/geoip.metadb && \
    wget -O /mihomo-config/geosite.dat https://fastly.jsdelivr.net/gh/MetaCubeX/meta-rules-dat@release/geosite.dat && \
    wget -O /mihomo-config/geoip.dat https://fastly.jsdelivr.net/gh/MetaCubeX/meta-rules-dat@release/geoip.dat

COPY docker/file-name.sh /mihomo/file-name.sh
WORKDIR /mihomo
RUN wget -O /mihomo/mihomo.gz https://github.com/MetaCubeX/mihomo/releases/download/${CLASH_VERSION}/mihomo-${DEVICE_PLATFORM}-${CLASH_VERSION}.gz && \
    gzip -d mihomo.gz && chmod +x mihomo
RUN wget -O dist.zip https://github.com/Zephyruso/zashboard/releases/latest/download/dist.zip && \
    unzip dist.zip && rm -rf dist.zip
FROM alpine:latest
LABEL org.opencontainers.image.authors="Toring"

RUN apk add --no-cache curl ca-certificates tzdata iptables
COPY --from=builder /mihomo-config/ /root/.config/mihomo/
COPY --from=builder /mihomo/mihomo /usr/bin/mihomo
COPY --from=builder /mihomo/dist/ /clash-dashboard/
ENTRYPOINT ["/usr/bin/mihomo"]
