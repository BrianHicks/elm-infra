FROM alpine:3.6

RUN apk add --no-cache ca-certificates

# download caddy
ADD https://caddyserver.com/download/linux/amd64 /app/caddy
RUN cp /app/caddy/caddy /usr/bin/caddy

# configure caddy
COPY Caddyfile /src/Caddyfile
ENV TLS=off
ENV ADDR=http://localhost:80

# runtime information
WORKDIR /src
CMD caddy
EXPOSE 80
EXPOSE 443
