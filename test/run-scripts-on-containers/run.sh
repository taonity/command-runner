#!/bin/bash

set -e

cd "$(dirname $0)"

. ../util.sh

docker compose up -d --quiet-pull

runner_exec_logs=$(docker compose exec command-runner runner World)

if [[ $runner_exec_logs != *"Hello World !"* ]]; then
  fail "Failed to run before-all."
fi

if [[ $runner_exec_logs != *"testuser"* ]]; then
  fail "Failed to run script in container."
fi

if [[ $runner_exec_logs != *"Bye World!"* ]]; then
  fail "Failed to run after-all."
fi