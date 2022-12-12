#!/bin/sh
set -e

if [ "${LEGO_EMAIL}" = '' ]; then
  echo "LEGO_EMAIL not set"
  exit 1
fi

if [ "${TROJAN_DOMAIN}" = '' ]; then
  echo "TROJAN_DOMAIN not set"
  exit 1
fi

if [ "${TROJAN_PASSWORD}" = '' ]; then
  echo "TROJAN_PASSWORD not set"
  exit 1
fi

if [ ! -e /root/.lego/certificates/${TROJAN_DOMAIN}.crt ]; then
  cd /root

  echo "- Obtain ssl certificate"
  nginx
  /usr/bin/lego -a --email "${LEGO_EMAIL}" --domains "${TROJAN_DOMAIN}" ${LEGO_CHALLENGE_OPTIONS} run --run-hook="/trojan_generate_config.sh"

  echo "- Add renew certificate cron job"
  echo "# min   hour    day     month   weekday command" > /etc/crontabs/root
  echo "0       2       *       *       *       cd /root && /usr/bin/lego -a --email \"${LEGO_EMAIL}\" --domains \"${TROJAN_DOMAIN}\" ${LEGO_CHALLENGE_OPTIONS} renew --days 3 --renew-hook=\"/trojan_restart_server.sh\"" >> /etc/crontabs/root

  cd -
fi

echo "- Starting services"
killall nginx
/usr/bin/supervisord -c /etc/supervisord.conf
