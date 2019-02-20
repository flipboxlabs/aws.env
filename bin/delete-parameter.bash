#!/usr/bin/env bash

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
source "${DIR}/.parameter-name-help.bash"
source "${DIR}/.parse-options.bash"

ENV_NAME=$POSITIONAL;

delete_parameter "$ENV_NAME"
