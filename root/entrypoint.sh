#!/bin/sh
set -e

if [ "${ACME_EMAIL}" = '' ]; then
  echo "ACME_EMAIL not set"
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
  /usr/local/bin/lego -a --email "${ACME_EMAIL}" --domains "${TROJAN_DOMAIN}" --http run --run-hook="/generate_trojan_config.sh"

  echo "- Add renew certificate cron job"
  echo "# min   hour    day     month   weekday command" > /etc/crontabs/root
  echo "0       2       *       *       *       cd /root && /usr/local/bin/lego -a --email \"${ACME_EMAIL}\" --domains \"${TROJAN_DOMAIN}\" --http renew --days 3 --renew-hook=\"/restart_trojan_server.sh\"" >> /etc/crontabs/root

  cd -
fi

echo "- Starting services"
/usr/local/bin/supervisord -c /etc/supervisord.conf
