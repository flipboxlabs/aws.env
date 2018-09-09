#!/bin/bash

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
source "${DIR}/.parameter-value-help.bash"
source "${DIR}/.parse-options.bash"

ENV_NAME=${POSITIONAL[0]};
ENV_VALUE=${POSITIONAL[1]};

debug "Saving ${ENV_NAME}"

if [ "" == "${ENV_VALUE}" ]; then
    read -sp "${FG_CYAN}Parameter Value: ${RESET}" ENV_VALUE
fi

debug "$ENV_VALUE"

put_parameter "$ENV_NAME" "$ENV_VALUE"
