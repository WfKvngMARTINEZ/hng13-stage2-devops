#!/bin/sh
set -e

# Debug: Print ACTIVE_POOL value
echo "ACTIVE_POOL is set to: '$ACTIVE_POOL'"

# Set default if unset
: "${ACTIVE_POOL:=blue}"

# Debug: Confirm value after default
echo "ACTIVE_POOL after default: '$ACTIVE_POOL'"

if [ "$ACTIVE_POOL" = "blue" ]; then
  cp /etc/nginx/upstreams_blue.conf /etc/nginx/upstreams.conf
else
  cp /etc/nginx/upstreams_green.conf /etc/nginx/upstreams.conf
fi

# Substitute ACTIVE_POOL
envsubst '$ACTIVE_POOL' < /etc/nginx/nginx.conf.template > /etc/nginx/nginx.conf

# Debug: Show generated nginx.conf
echo "Generated nginx.conf:"
cat /etc/nginx/nginx.conf

exec nginx -g 'daemon off;'