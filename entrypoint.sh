#!/bin/sh
set -e

# Substitute env vars
envsubst '$ACTIVE_POOL' < /etc/nginx/nginx.conf.template > /etc/nginx/nginx.conf

# Select upstream file
if [ "$ACTIVE_POOL" = "green" ]; then
    cp /etc/nginx/upstreams_green.conf /etc/nginx/upstreams.conf
else
    cp /etc/nginx/upstreams_blue.conf /etc/nginx/upstreams.conf
fi

# Start Nginx
exec nginx -g 'daemon off;''