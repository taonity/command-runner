#!/bin/bash

echo "Hello" "$@" "!"
docker exec run-scripts-on-containers-alpine-1 adduser -D testuser