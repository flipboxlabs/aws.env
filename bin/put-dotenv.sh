#!/bin/bash
#Currently this uses AWS PARAMETER STORE but this could change
#You can restrict access to the parameters by specifying the app/env path 
# in you instance profile or user policies. See policy examples below command

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
source "${DIR}/.parse-options.sh"

OUTPUT_TEMP_FILEPATH=/tmp/dotenv.out

OUTPUT=$(get_dotenv 2> /dev/null)
INPUT=$(cat $DOT_ENV_FILE)
if [ "" != "$OUTPUT" ]; then
    debug ".env exists. Comparing new and old."
    if [ "$OUTPUT" != "$INPUT" ]; then
        echo "$OUTPUT" > $OUTPUT_TEMP_FILEPATH
        diff -U1 --label "OLD .env" --label "NEW .env" $OUTPUT_TEMP_FILEPATH $DOT_ENV_FILE | sed "s/^-.*/`printf \"%s\" $FG_RED`&`printf \"%s\" $RESET`/;s/^+.*/`printf \"%s\" $FG_GREEN`&`printf \"%s\" $RESET`/;"
        echo "${FG_YELLOW}Are you sure you want to put this change? ${BOLD}(y|n)${RESET}"
        read -s PUSH;
        OVERWRITE=$(contains "${YES[@]}" "${PUSH}")
        if [ "$OVERWRITE" == "NO" ]; then
            echo "Okay, cool. Exiting."
            exit 0;
        else
            echo "Overwriting .env"
        fi
    else
        debug "New and old dot envs are the same."
        echo "${FG_YELLOW}No changes found. No need to put. Exiting"
        exit 0;
    fi
fi

put_dotenv

