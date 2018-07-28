DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
source "${DIR}/.text-decoration.sh"

POSITIONAL=()
SCRIPT_NAME=`basename "$0"`

while [[ $# -gt 0 ]]
do
key="$1"

case $key in
    -h|--help)
    HELP=YES
    shift # past argument
    shift # past value
    ;;
    -a|--app)
    APP="$2"
    shift # past argument
    shift # past value
    ;;
    -e|--env)
    ENV="$2"
    shift # past argument
    shift # past value
    ;;
    -p|--profile)
    export AWS_PROFILE="$2"
    shift # past argument
    shift # past value
    ;;
    -d|--debug)
    DEBUG="YES"
    shift # past argument
    shift # past value
    ;;
    *)    # unknown option
    POSITIONAL+=("$1") # save it in an array for later. This should be the .env file.
    shift # past argument
    ;;
esac
done
set -- "${POSITIONAL[@]}" # restore positional parameters

DOT_ENV_FILE=$POSITIONAL
PARAMETER_PATH="/${APP}/${ENV}/.env"
YES=("YES" "Y" "yes" "y")
NO=("NO" "N" "no" "n")

#print help
help(){
    {
        echo "USAGE: $SCRIPT_NAME [options] <dot env file>"; \
            echo "OPTIONS:"; \
            echo "      -p --profile"; \
            echo "              AWS profile name to authenticate with"; \
            echo "      -a --app"; \
            echo "              Application Name or Elastic Beanstalk Application Name"; \
            echo "      -e --env"; \
            echo "              Environment Name or Elastic Beanstalk Environment Name"; \
    }
    EXIT_CODE=$1

    if [ -z "$EXIT_CODE" ]; then
        EXIT_CODE=0
    fi

    exit $EXIT_CODE;
}

#get file from the param store
get_dotenv() {
    #run the command
    aws ssm get-parameter --name $PARAMETER_PATH \
        --with-decryption | jq -r .Parameter.Value
}

#put 
put_dotenv() {
    #run the command
    aws ssm put-parameter --name $PARAMETER_PATH \
        --type SecureString --value "`cat ${DOT_ENV_FILE}`" --overwrite
}

required_options() {
    echo ""
    echo 'error: -a|-app parameter is required. Example `--app CraftCMSApp`'
    echo 'error: -e|-env parameter is required. Example `--env CraftCMSApp-Development`'
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

if [ "$HELP" == "YES" ]; then
    help 0;
fi

if [ -z "${APP}" ]; then
    required_options
    exit 1;
fi

if [ -z "${ENV}" ]; then
    required_options
    exit 1;
fi

if [ $DEBUG == "YES" ]; then
    debug "Parameter path: ${PARAMETER_PATH}"
fi
