FROM scratch

LABEL org.opencontainers.image.authors="Toring"

ADD clash /usr/bin/clash
ADD ./clash-dashboard/ /clash-dashboard/

CMD ["/usr/bin/clash"]
