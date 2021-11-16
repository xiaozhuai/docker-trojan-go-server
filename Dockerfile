FROM alpine:latest

RUN set -xe \
    && apk add --no-cache curl nginx \
    && mkdir /tmp/downloads \
    && cd /tmp/downloads \
    && wget "https://github.com/ochinchina/supervisord/releases/download/v0.7.3/supervisord_0.7.3_Linux_64-bit.tar.gz" \
    && tar -xzf supervisord_0.7.3_Linux_64-bit.tar.gz \
    && cp supervisord_0.7.3_Linux_64-bit/supervisord_static /usr/local/bin/supervisord \
    && wget "https://github.com/go-acme/lego/releases/download/v4.5.3/lego_v4.5.3_linux_amd64.tar.gz" \
    && tar -xzf lego_v4.5.3_linux_amd64.tar.gz \
    && cp lego /usr/local/bin/lego \
    && wget "https://github.com/p4gefau1t/trojan-go/releases/download/v0.10.6/trojan-go-linux-amd64.zip" \
    && unzip trojan-go-linux-amd64.zip \
    && cp trojan-go /usr/local/bin/trojan-go \
    && mkdir /usr/share/trojan-go \
    && mv geo*.dat /usr/share/trojan-go/ \
    && cd / \
    && rm -rf /tmp/downloads \
    && chmod 755 /usr/local/bin/supervisord \
    && chmod 755 /usr/local/bin/lego \
    && chmod 755 /usr/local/bin/trojan-go

COPY root/ /

RUN set -xe \
    && chmod 755 /entrypoint.sh \
    && chmod 755 /generate_trojan_config.sh \
    && chmod 755 /restart_trojan_server.sh

ENV ACME_EMAIL=""
ENV TROJAN_DOMAIN=""
ENV TROJAN_PASSWORD=""
ENV TROJAN_WS_PATH=""

EXPOSE 80
EXPOSE 443

ENTRYPOINT ["/entrypoint.sh"]
