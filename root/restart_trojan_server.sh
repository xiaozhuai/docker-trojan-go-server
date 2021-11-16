#!/bin/sh
set -e

/generate_trojan_config.sh


echo "- Restart trojan-go server"
/usr/local/bin/supervisord ctl restart trojan-go-server
