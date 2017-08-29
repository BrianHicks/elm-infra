FROM alpine:3.6

RUN apk add --no-cache nginx

# set logs to stdout and stderr
RUN sed -i 's|/var/log/nginx/access.log|/dev/stdout|g' /etc/nginx/nginx.conf
RUN sed -i 's|/var/log/nginx/error.log|/dev/stderr|g' /etc/nginx/nginx.conf

# run in the foreground
RUN echo 'daemon off;' >> /etc/nginx/nginx.conf
RUN echo 'pid /tmp/nginx.pid;' >> /etc/nginx/nginx.conf

COPY nginx.conf /etc/nginx/conf.d/default.conf
COPY entrypoint.sh /entrypoint.sh

ENV HOST=elm-lang.org
CMD /entrypoint.sh
