#!/bin/bash

# crontab: 0,30 * * * * /usr/bin/sh /root/bandwidth.sh

tx=$(vnstat --json m | jq ".interfaces[0].traffic.months[] | select(.date.year==$(date +%Y) and .date.month==$(date +%m))" | jq ".tx")
gb=$(expr $tx / 1000000)
limit=50

rm -f /root/nginx-is-*
/usr/sbin/nginx -t 2> /dev/null

if [ $gb -ge $limit ]; then
    /usr/bin/systemctl is-active --quiet nginx && /usr/bin/systemctl stop nginx;
    echo "$(date) larger" > /root/nginx-is-stop;
    exit;
else
    /usr/bin/systemctl is-active --quiet nginx || /usr/bin/systemctl start nginx;
    echo "$(date) smaller" > /root/nginx-is-running;
    exit;
fi
