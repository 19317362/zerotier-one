#!/usr/bin/env bash
set -e
if [ "$1" = 'zerotier-one' ]; then
    if [ ! "${ZT_NETWORKID}" = "" ]; then
        touch /var/lib/zerotier-one/networks.d/${ZT_NETWORKID}.conf
    fi
fi
exec "$@"