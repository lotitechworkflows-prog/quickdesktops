#!/bin/sh
set -e

USER_NAME="${DESKTOP_USER:-admin}"

# No password set? Generate one and print it in the deploy logs.
if [ -z "$DESKTOP_PASSWORD" ]; then
  DESKTOP_PASSWORD="$(head -c 48 /dev/urandom | base64 | tr -dc 'A-Za-z0-9' | head -c 16)"
  echo "=================================================="
  echo " DESKTOP_PASSWORD not set - generated one for you:"
  echo "   username: $USER_NAME"
  echo "   password: $DESKTOP_PASSWORD"
  echo " (it changes on every restart; set DESKTOP_PASSWORD"
  echo "  in Variables to keep a fixed one)"
  echo "=================================================="
fi

# nginx login file
printf '%s:%s\n' "$USER_NAME" "$(printf '%s' "$DESKTOP_PASSWORD" | openssl passwd -apr1 -stdin)" > /tmp/htpasswd

# nginx config (listens on the vendor's $PORT)
envsubst '${PORT}' < /etc/nginx/nginx.conf.template > /etc/nginx/nginx.conf

# home / volume
mkdir -p /home/desk /tmp/.X11-unix
chmod 1777 /tmp/.X11-unix
chown desk:desk /home/desk

# file browser (auth is handled by nginx)
rm -f /tmp/filebrowser.db
su-exec desk filebrowser -d /tmp/filebrowser.db config init \
  --auth.method=noauth --baseurl /files --root /home/desk \
  --address 127.0.0.1 --port 8081 >/dev/null

exec supervisord -c /etc/supervisord.conf
