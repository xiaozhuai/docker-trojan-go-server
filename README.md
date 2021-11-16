# trojan-go-server

Automatically obtain/renew ssl certificate and deploy a trojan go server with docker.

start without websocket support

```
docker run -d \
    --name trojan-go-server \
    -p 80:80 \
    -p 443:443 \
    -e ACME_EMAIL="my@example.com" \
    -e TROJAN_DOMAIN="demo.example.com" \
    -e TROJAN_PASSWORD="your_password" \
    xiaozhuai/trojan-go-server:latest
```


start with websocket support

```
docker run -d \
    --name trojan-go-server \
    -p 80:80 \
    -p 443:443 \
    -e ACME_EMAIL="my@example.com" \
    -e TROJAN_DOMAIN="demo.example.com" \
    -e TROJAN_PASSWORD="your_password" \
    -e TROJAN_WS_PATH="/ws" \
    xiaozhuai/trojan-go-server:latest
```

