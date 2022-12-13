#!/bin/sh

/usr/bin/lego -a --path "${LEGO_PATH}" --email "${LEGO_EMAIL}" ${LEGO_CHALLENGE_OPTIONS} --domains "${TROJAN_DOMAIN}" "$@"

