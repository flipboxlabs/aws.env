#!/bin/bash


DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
source "${DIR}/.dotenv-help.bash"
source "${DIR}/.parse-options.bash"

DOT_ENV_FILE=$POSITIONAL

#run the command
OUTPUT=$(get_dotenv)

if [ ! -z "${DOT_ENV_FILE}" ]; then
    echo "$OUTPUT" > ${DOT_ENV_FILE}
    echo $FG_CYAN"DOT ENV FILE SAVED:"
    echo '----------------------------------------'$RESET;
    echo $FG_GREEN
    cat ${DOT_ENV_FILE}
    echo $RESET
    echo $FG_CYAN'----------------------------------------'$RESET;
else
    echo $FG_GREEN
    echo "${OUTPUT}"
    echo $RESET
fi
