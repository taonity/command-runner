#!/bin/bash

log() {
  echo "$(date +"%Y-%m-%d %H:%M:%S") $1"
}

log "Start command running for $COMMAND_RUNNER_GROUP group"

GROUP_LABEL_KEY="command-runner.group"
LABEL_FILTER="label=$GROUP_LABEL_KEY=$COMMAND_RUNNER_GROUP"

COMMAND_LABEL_KEY="command-runner.command"
COMMAND_LABEL_FORMAT="{{ index .Config.Labels \"$COMMAND_LABEL_KEY\" }}"

SHELL_LABEL_KEY="command-runner.shell"
SHELL_LABEL_FORMAT="{{ index .Config.Labels \"$SHELL_LABEL_KEY\" }}"

USER_LABEL_KEY="command-runner.user"
USER_LABEL_FORMAT="{{ index .Config.Labels \"$USER_LABEL_KEY\" }}"

BEFORE_ALL_FILE_PATH="/etc/runner/scripts/shared/before-all.sh"
AFTER_ALL_FILE_PATH="/etc/runner/scripts/shared/after-all.sh"

if [ -f "$BEFORE_ALL_FILE_PATH" ]; then
    log "Found before-all.sh file. Start execution"
    bash "$BEFORE_ALL_FILE_PATH" "$@"
    log "Finish execution of before-all.sh"
else
    log "There is no before-all.sh file"
fi

for CONTAINER_ID in $(docker ps -q -f "$LABEL_FILTER"); do
    log "Found $CONTAINER_ID container"

    COMMAND=$(docker inspect --format "$COMMAND_LABEL_FORMAT" "$CONTAINER_ID")
    SHELL=$(docker inspect --format "$SHELL_LABEL_FORMAT" "$CONTAINER_ID")

    if [ -z "$COMMAND" ]; then
        log "Can't find command label for $CONTAINER_ID container"
        exit 1
    fi

    if [ -z "$SHELL" ]; then
        log "Can't find shell label for $CONTAINER_ID container"
        exit 1
    fi

    USER=$(docker inspect --format "$USER_LABEL_FORMAT" "$CONTAINER_ID")
    
    if [ -z "$SHELL" ]; then
        USER=root
    fi

    log "Start execution"
    docker exec -u "$USER" "$CONTAINER_ID" $SHELL "$COMMAND"
    log "Finish execution"

done

if [ -f "$AFTER_ALL_FILE_PATH" ]; then
    log "Found after-all.sh file. Start execution"
    bash "$AFTER_ALL_FILE_PATH" "$@"
    log "Finish execution of after-all.sh"
else
    log "There is no after-all.sh file"
fi