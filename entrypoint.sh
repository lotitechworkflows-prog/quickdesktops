#!/bin/sh
set -e

if [ -z "$DESKTOP_PASSWORD" ]; then
  echo "ERROR: set the DESKTOP_PASSWORD variable" >&2
  exit 1
fi
USER_NAME="${DESKTOP_USER:-admin}"

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
