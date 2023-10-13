# command-runner
[generaltao725/command-runner](https://hub.docker.com/repository/docker/generaltao725/command-runner/general) is the tool for running commands in docker containers. It is useful for container maintenance operations.

### Usage
The easiest way of running the tool is using docker-compose. Here is an [example](test\run-scripts-on-containers\docker-compose.yml) of the tool usage.

### Configuration
You have to add an environment variable in command-runner service - `COMMAND_RUNNER_GROUP`. It configures the group of containers the service will be working with. It can be populated
with any string in kebab-case style.
Target services are configured using labels with a root path `command-runner.`. Here are the labels:
| Label                  | Required | Description                                                    |
| ---------------------- | -------- | -------------------------------------------------------------- |                           
| command-runner.group   | yes      | A group name that command-runner service will be working with  |
| command-runner.user    | no       | A user that will run the command                               |
| command-runner.shell   | yes      | A command shell path and parameters the command will run in    |
| command-runner.command | yes      | A command that will be executed in a service                   |

You can also define `after-all.sh` and `before-all.sh` bash and mount them into `/etc/runner/scripts/shared` directory in command-runner container. The scripts allow you to 
run bash scripts before and after running commands. The scripts will be running in the host. Both scripts are optional and are useful for some preparations and cleanup.

### Run
You can run the configured commands and scripts using docker-compose:
```bash
docker compose exec command-runner runner [arguments]
```
The `runner` command can take any amount of arguments, which will be passed to the `after-all.sh` and `before-all.sh` scripts.

### Used in
 - [taonity/java-discord-help-tree-bot](https://github.com/taonity/java-discord-help-tree-bot)
 - [taonity/prodenv](https://github.com/taonity/prodenv)
