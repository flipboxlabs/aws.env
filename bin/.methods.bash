
#get file from the param store
get_dotenv() {
    # populates PARAMETERS
    get_parameters
    for row in $(echo "${PARAMETERS}" | jq -r '.Parameters[] | @base64'); do
        _jq() {
         echo ${row} | base64 --decode | jq -r ${1}
        }

        if [ "$ENV_OUTPUT" == "$ENV_OUTPUT_DOCKERFILE" ]; then
            echo ENV $(path_to_name "$(_jq '.Name')") \"$(_jq '.Value')\"
        else
            echo $(path_to_name "$(_jq '.Name')")=\"$(_jq '.Value')\"
        fi
    done
}

#put entire file
put_dotenv() {
    #run the command
    aws ssm put-parameter --name $PARAMETER_PATH \
        --type SecureString --value "`cat ${DOT_ENV_FILE}`" --overwrite
}

#get parameters by path
PARAMETERS=''
get_parameters() {
    PARAMETERS=$(aws ssm get-parameters-by-path --path $PARAMETER_PATH --recursive --with-decryption);
}

#get value from the local variable
get_parameter_from_local() {
    local NAME=$1
    echo $PARAMETERS | jq -r ".Parameters[] | select(.Name==\"${PARAMETER_PATH}/${NAME}\") | .Value"
}

#delete
delete_parameter() {
    local NAME=$1
    debug "Deleting ${PARAMETER_PATH}/${NAME}"
    aws ssm delete-parameter --name "${PARAMETER_PATH}/${NAME}"
}

#clean name and value
clean_parameter() {
    local REGEX="s/^[\"']\(.*\)[\"']$/\1/g"
    echo -e $1 | sed -e $REGEX
}

#pop name off path
path_to_name() {
    echo $1 | sed 's#^.*/\([a-zA-Z0-9_.-]*\)$#\1#'
}

#put
put_parameter() {
    NAME=$1
    VALUE=$2

    if [ "" = "$NAME" ] || [ "" = "$VALUE" ]; then
        debug "Name or value is empty"
        return
    fi

    FULL_NAME=$PARAMETER_PATH/$NAME;

    # debug "Updating ${FULL_NAME}"
    aws ssm put-parameter \
        --cli-input-json '{"Name":"'"${FULL_NAME}"'","Value":"'"${VALUE}"'","Type":"SecureString"}' \
        --overwrite
}

put_parameters_by_dotenv() {

    DOT_ENV_FILE=$1

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
    done < $DOT_ENV_FILE
}

required_options() {
    echo ""
    echo 'error: -a|-app parameter is required. Example `--app App`'
    echo 'error: -e|-env parameter is required. Example `--env App-Development`'
    echo ""
    echo ""
    help 1
}

contains() {
    local n=$#
    local value=${!n}
    for ((i=1;i < $#;i++)) {
        if [ "${!i}" == "${value}" ]; then
            echo "YES"
            return 0
        fi
    }
    echo "NO"
    return 1
}

debug(){
    if [ "${DEBUG}" == "YES" ]; then
        printf "${FG_YELLOW}%s [debug] %s \n${RESET}" "`date +'%Y-%m-%d %H:%M:%S'`" "$1"
    fi
}
