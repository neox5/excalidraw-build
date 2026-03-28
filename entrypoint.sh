#!/bin/sh
set -e

BUNDLE=$(find /srv/assets -name 'index-*.js' | head -n 1)

if [ -z "$BUNDLE" ]; then
  echo "ERROR: No JS bundle found in /srv/assets/" >&2
  exit 1
fi

if [ -n "$COLLAB_SERVER_URL" ]; then
  echo "Injecting COLLAB_SERVER_URL: $COLLAB_SERVER_URL"
  sed -i "s|__COLLAB_SERVER_URL__|${COLLAB_SERVER_URL}|g" "$BUNDLE"
else
  echo "COLLAB_SERVER_URL not set - collaboration disabled"
fi

exec caddy run --config /etc/caddy/Caddyfile
