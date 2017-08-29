#!/usr/bin/env sh

sed -i "s/\${HOST}/${HOST}/g" /etc/nginx/conf.d/default.conf

exec nginx
