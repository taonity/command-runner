#!/bin/bash

set -e

cd "$(dirname $0)"


if [[ $runner_exec_logs != *"Hello World !"* ]]; then
  fail "Failed to run before-all."
fi

if [[ $runner_exec_logs != *"testuser"* ]]; then
  fail "Failed to run script in container."
fi

if [[ $runner_exec_logs != *"Bye World!"* ]]; then
  fail "Failed to run after-all."
fi