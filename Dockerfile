FROM golang:alpine AS builder

ENV GO111MODULE on
ENV CGO_ENABLED 0

RUN apk --no-cache add make git wget

RUN set -ex \
    && mkdir /usr/share/trojan-go \
    && wget https://github.com/v2fly/domain-list-community/raw/release/dlc.dat -O /usr/share/trojan-go/geosite.dat \
    && wget https://github.com/v2fly/geoip/raw/release/geoip.dat -O /usr/share/trojan-go/geoip.dat \
    && wget https://github.com/v2fly/geoip/raw/release/geoip-only-cn-private.dat -O /usr/share/trojan-go/geoip-only-cn-private.dat \
    && mkdir /code \
    && cd /code \
    && git clone https://github.com/p4gefau1t/trojan-go \
    && cd /code/trojan-go \
    && go mod download

RUN set -ex \
    && cd /code/trojan-go \
    && make

FROM xiaozhuai/supervisord-go-alpine:latest

COPY --from=builder /code/trojan-go/build/trojan-go /usr/bin/trojan-go
COPY --from=builder /usr/share/trojan-go /usr/share/trojan-go
COPY --from=goacme/lego:latest /usr/bin/lego /usr/bin/lego
COPY root/ /

RUN set -ex \
    && apk --no-cache add ca-certificates tzdata curl nginx \
    && update-ca-certificates \
    && mkdir /etc/trojan-go

ENV LEGO_EMAIL=""
ENV LEGO_CHALLENGE_OPTIONS="--http"
ENV TROJAN_DOMAIN=""
ENV TROJAN_PASSWORD=""
ENV TROJAN_WS_PATH=""

EXPOSE 80
EXPOSE 443

ENTRYPOINT ["/entrypoint.sh"]
