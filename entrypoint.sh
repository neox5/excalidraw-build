#!/bin/sh
set -e

if [ -n "$COLLAB_SERVER_URL" ]; then
  BUNDLE=$(grep -rl "VITE_APP_WS_SERVER_URL" /srv/assets/ | head -n 1)

  if [ -z "$BUNDLE" ]; then
    echo "ERROR: No file containing VITE_APP_WS_SERVER_URL found in /srv/assets/" >&2
    exit 1
  fi

  echo "Injecting COLLAB_SERVER_URL into: $BUNDLE"
  sed -i "s|__COLLAB_SERVER_URL__|${COLLAB_SERVER_URL}|g" "$BUNDLE"

  VERIFY=$(grep -o "VITE_APP_WS_SERVER_URL:\"${COLLAB_SERVER_URL}\"" "$BUNDLE" || true)
  if [ -n "$VERIFY" ]; then
    echo "Injection verified: $VERIFY"
  else
    echo "ERROR: Injection verification failed" >&2
    exit 1
  fi
else
  echo "COLLAB_SERVER_URL not set - collaboration disabled"
fi

exec caddy run --config /etc/caddy/Caddyfile
