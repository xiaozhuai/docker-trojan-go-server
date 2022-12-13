#!/bin/sh
set -e

if [ -z "${LEGO_EMAIL}" ]; then
  echo "LEGO_EMAIL not set"
  exit 1
fi

if [ -z "${TROJAN_DOMAIN}" ]; then
  echo "TROJAN_DOMAIN not set"
  exit 1
fi

if [ -z "${TROJAN_PASSWORD}" ]; then
  echo "TROJAN_PASSWORD not set"
  exit 1
fi

if [ ! -e "${LEGO_PATH}/certificates/${TROJAN_DOMAIN}.crt" ]; then
  echo "- Obtain ssl certificate"
  nginx
  /my_lego.sh run --run-hook="/trojan_generate_config.sh"

  echo "- Add renew certificate cron job"
  echo "# min   hour    day     month   weekday command" > /etc/crontabs/root
  echo "0       2       *       *       *       /my_lego.sh renew --days 3 --renew-hook=\"/trojan_restart_server.sh\"" >> /etc/crontabs/root
else
  echo "- Renew ssl certificate"
  nginx
  /my_lego.sh renew --days 3 --renew-hook="/trojan_generate_config.sh"
fi

echo "- Starting services"
killall nginx
/usr/bin/supervisord -c /etc/supervisord.conf
