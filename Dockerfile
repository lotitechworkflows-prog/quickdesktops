FROM filebrowser/filebrowser:v2 AS fb

FROM alpine:3.20

RUN apk add --no-cache \
      nginx supervisor openssl gettext su-exec \
      xvfb x11vnc openbox tint2 xterm \
      novnc websockify \
      epiphany dbus font-dejavu \
 && adduser -D -u 1000 -s /bin/sh desk

COPY --from=fb /bin/filebrowser /usr/local/bin/filebrowser
COPY nginx.conf.template /etc/nginx/nginx.conf.template
COPY supervisord.conf /etc/supervisord.conf
COPY openbox/ /etc/xdg/openbox/
COPY browser /usr/local/bin/browser
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh /usr/local/bin/browser /etc/xdg/openbox/autostart

ENV DISPLAY=:1 \
    HOME=/home/desk \
    PORT=8080

EXPOSE 8080
CMD ["/entrypoint.sh"]
