#!/bin/sh
set -e

/trojan_generate_config.sh

echo "- Restart trojan-go server"
/usr/bin/supervisord ctl restart trojan-go-server
