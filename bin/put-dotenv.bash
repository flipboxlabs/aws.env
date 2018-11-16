#!/bin/bash
#Currently this uses AWS PARAMETER STORE but this could change
#You can restrict access to the parameters by specifying the app/env path 
# in you instance profile or user policies. See policy examples below command

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
source "${DIR}/.dotenv-help.bash"
source "${DIR}/.parse-options.bash"

DOT_ENV_FILE=$POSITIONAL

debug "Using this dotenv: ${DOT_ENV_FILE}"

put_parameters_by_dotenv $DOT_ENV_FILE
