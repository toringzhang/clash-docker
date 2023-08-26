FROM alpine:latest

LABEL org.opencontainers.image.authors="Toring"

ADD clash /usr/bin/clash
ADD ./clash-dashboard/ /clash-dashboard/
ADD ./Country.mmdb /.config/clash/Country.mmdb
CMD ["/usr/bin/clash"]
