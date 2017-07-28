FROM alpine:3.6

# download caddy
ADD https://caddyserver.com/download/linux/amd64 /app/caddy
RUN cp /app/caddy/caddy /usr/bin/caddy

# configure caddy
COPY Caddyfile /src/Caddyfile
ENV TLS=off
WORKDIR /src
CMD caddy
EXPOSE 8080
