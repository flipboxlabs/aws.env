#!/bin/bash


DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
source "${DIR}/.dotenv-help.bash"
source "${DIR}/.parse-options.bash"

POSITIONAL_COPY=$POSITIONAL
POSITIONAL=''
DOT_ENV=$(get_dotenv)
TMP_FILE="/tmp/.tmp.env"

#default to vim
EDITOR=${EDITOR:vim}

EDIT_CMD="${EDITOR}"

#remove if there's one there
rm -f $TMP_FILE
echo "${DOT_ENV}" > $TMP_FILE

# no swap file for vim
if [ "$EDITOR" = "vim" ]; then
    EDIT_CMD="${EDIT_CMD} -n"
fi

#open for edit
EDIT_CMD="${EDIT_CMD} ${TMP_FILE}"

eval $EDIT_CMD

NEW_DOT_ENV=$(cat $TMP_FILE);

#any changes?
if [ "$DOT_ENV" != "$NEW_DOT_ENV" ]; then

    #run fancy diff
    diff -U1 --label "OLD .env" --label "NEW .env" <(echo "$DOT_ENV") <(echo "$NEW_DOT_ENV") \
        | sed "s/^-.*/`printf \"%s\" $FG_RED`&`printf \"%s\" $RESET`/;s/^+.*/`printf \"%s\" $FG_GREEN`&`printf \"%s\" $RESET`/;"

    echo "Want to push these changes? [yes]"
    read PUSH;
    PUSH=${PUSH:yes}
    OVERWRITE=$(contains "${YES[@]}" "${PUSH}")
    if [ "$OVERWRITE" == "NO" ]; then
        echo "Okay, cool. Exiting."

        rm -f $TMP_FILE
        exit 0;
    else
        echo "Overwriting .env"
    fi

    #push the new parameters
    put_parameters_by_dotenv $TMP_FILE
else
    #do nothing
    echo "The .env hasn't changed. Doing nothing."
    rm -f $TMP_FILE
    exit 0;
fi


