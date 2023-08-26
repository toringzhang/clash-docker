FROM alpine:latest

LABEL org.opencontainers.image.authors="Toring"

ADD clash /usr/bin/clash
ADD ./clash-dashboard/ /clash-dashboard/
ADD ./Country.mmdb /root/.config/clash/Country.mmdb
RUN  apk add curl
CMD ["/usr/bin/clash"]
