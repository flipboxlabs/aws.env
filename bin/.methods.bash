#get file from the param store
#deprecated
get_dotenv() {
    get_parameters
    for row in $(echo "${PARAMETERS}" | jq -r '.Parameters[] | @base64'); do
        _jq() {
         echo ${row} | base64 --decode | jq -r ${1}
        }

    echo $(path_to_name "$(_jq '.Name')")=\"$(_jq '.Value')\"
    done
}

#put entire file
#deprecated
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
    printf "${FG_YELLOW}%s [debug] %s \n${RESET}" "`date +'%Y-%m-%d %H:%M:%S'`" "$1"
}
