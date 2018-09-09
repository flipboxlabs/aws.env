#!/bin/bash

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
source "${DIR}/.parameter-value-help.bash"
source "${DIR}/.parse-options.bash"

ENV_NAME=${POSITIONAL[0]};
ENV_VALUE=${POSITIONAL[1]};

debug "Saving ${ENV_NAME}"

put_parameter $ENV_NAME $ENV_VALUE
