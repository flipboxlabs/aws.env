#!/bin/bash
#Currently this uses AWS PARAMETER STORE but this could change
#You can restrict access to the parameters by specifying the app/env path 
# in you instance profile or user policies. See policy examples below command

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
source "${DIR}/.dotenv-help.bash"
source "${DIR}/.parse-options.bash"

DOT_ENV_FILE=$POSITIONAL

OUTPUT_TEMP_FILEPATH=/tmp/dotenv.out

OUTPUT=$(get_dotenv 2> /dev/null)
INPUT=$(cat $DOT_ENV_FILE)


# cache the parameters and pull them down into a local variable
get_parameters

#Line by line loop thru the dot env file
while IFS='' read -r LINE || [[ -n "$LINE" ]]; do

    #skip the comments and clean up any spaces at the begining
    CLEAN_LINE="$(echo -e "${LINE}" | sed -e 's/^[[:space:]]*//' | sed '/#/s/^#.*//g')"

    #Is the line empty? If not continue
    if [ "" != "$CLEAN_LINE" ]; then

        #There should be an env variable at this point
        #Split it on the `=` sign
        IFS='=' read -r -a NAME_VALUE <<< "$CLEAN_LINE"

        #Clean them up and set them
        NAME=$(clean_parameter "${NAME_VALUE[0]}")
        VALUE=$(clean_parameter "${NAME_VALUE[1]}")

        #Grab the old value
        OLD_VALUE=$(get_parameter_from_local $NAME)

        #If the values are the same, don't push
        if [ "${OLD_VALUE}" != "${VALUE}" ] ; then
            debug "Updating ${NAME}=${VALUE}"
            debug "OLD: ${OLD_VALUE}"
            debug "NEW: ${VALUE}"

            if [ "${VALUE}" == "" ]; then
                #Delete it if the value's empty
                debug "'$NAME' value is empty, deleting"
                delete_parameter "$NAME"
            else
                #Put it
                put_parameter "$NAME" "$VALUE"
            fi
        fi
    fi
done < "$DOT_ENV_FILE"

