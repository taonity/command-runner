FROM alpine:3.18.4
WORKDIR /etc/runner
COPY assets /etc/runner/scripts/assets
RUN mv /etc/runner/scripts/assets/runner.sh /usr/local/bin/runner
RUN apk update && apk add --no-cache docker-cli bash

CMD ["/bin/sh", "-c", "tail -f /dev/null"]