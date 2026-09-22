#!/bin/sh
set -e

envsubst '${BACKEND_HOST} ${BACKEND_PORT}' \
  < /etc/nginx/templates/default.conf.template \
  > /tmp/default.conf

exec nginx -c /etc/nginx/nginx.conf -g 'daemon off;'
