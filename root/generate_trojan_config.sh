#!/bin/sh
set -e

echo "- Generate trojan-go config"

if [ "${TROJAN_WS_PATH}" = '' ]; then

tee /etc/trojan-go-server.yaml <<EOF
run-type: server
local-addr: 0.0.0.0
local-port: 443
remote-addr: 127.0.0.1
remote-port: 80
password:
  - "${TROJAN_PASSWORD}"
ssl:
  cert: "${LEGO_CERT_PATH}"
  key: "${LEGO_CERT_KEY_PATH}"
  sni: "${TROJAN_DOMAIN}"
router:
  enabled: true
  block:
    - 'geoip:private'
  geoip: /usr/share/trojan-go/geoip.dat
  geosite: /usr/share/trojan-go/geosite.dat

EOF

else

tee /etc/trojan-go-server.yaml <<EOF
run-type: server
local-addr: 0.0.0.0
local-port: 443
remote-addr: 127.0.0.1
remote-port: 80
password:
  - "${TROJAN_PASSWORD}"
ssl:
  cert: "${LEGO_CERT_PATH}"
  key: "${LEGO_CERT_KEY_PATH}"
  sni: "${TROJAN_DOMAIN}"
websocket:
  enabled: true
  path: "${TROJAN_WS_PATH}"
  hostname: "${TROJAN_DOMAIN}"
router:
  enabled: true
  block:
    - 'geoip:private'
  geoip: /usr/share/trojan-go/geoip.dat
  geosite: /usr/share/trojan-go/geosite.dat

EOF

fi
