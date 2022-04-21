#!/usr/bin/env bash

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
source "${DIR}/.parameter-name-help.sh"
source "${DIR}/.parse-options.sh"

ENV_NAME=$POSITIONAL;

delete_parameter "$ENV_NAME"
