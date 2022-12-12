# trojan-go-server

Automatically obtain/renew ssl certificate and deploy a trojan go server with docker.

## simple

```shell
docker run -d \
    --name trojan-go-server \
    -p 80:80 \
    -p 443:443 \
    -e LEGO_EMAIL="my@example.com" \
    -e TROJAN_DOMAIN="demo.example.com" \
    -e TROJAN_PASSWORD="your_password" \
    xiaozhuai/trojan-go-server:latest
```

## websocket support

```shell
docker run -d \
    --name trojan-go-server \
    -p 80:80 \
    -p 443:443 \
    -e LEGO_EMAIL="my@example.com" \
    -e TROJAN_DOMAIN="demo.example.com" \
    -e TROJAN_PASSWORD="your_password" \
    -e TROJAN_WS_PATH="/ws" \
    xiaozhuai/trojan-go-server:latest
```

## dns challenge

```shell
docker run -d \
    --name trojan-go-server \
    -p 80:80 \
    -p 443:443 \
    -e ALICLOUD_ACCESS_KEY="xxxxxx" \
    -e ALICLOUD_SECRET_KEY="xxxxxx" \
    -e LEGO_EMAIL="my@example.com" \
    -e LEGO_CHALLENGE_OPTIONS="--dns alidns" \
    -e TROJAN_DOMAIN="demo.example.com" \
    -e TROJAN_PASSWORD="your_password" \
    -e TROJAN_WS_PATH="/ws" \
    xiaozhuai/trojan-go-server:latest
```

