#!/usr/bin/env bash

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
source "${DIR}/.text-decoration.sh"
source "${DIR}/.methods.sh"

POSITIONAL=()
SCRIPT_NAME=`basename "$0"`

#env output dockerfile options
ENV_OUTPUT_DOCKERFILE="dockerfile"
ENV_OUTPUT_BASH_EXPORT="export"
ENV_OUTPUT_DEFAULT="default"

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
    --path)
    export PARAMETER_PATH="$2"
    shift # past argument
    shift # past value
    ;;
    -r|--region)
    export AWS_DEFAULT_REGION="$2"
    shift # past argument
    shift # past value
    ;;
    -o|--output)
    ENV_OUTPUT="${2:-default}"
    shift # past argument
    shift # past value
    ;;
    -d|--debug)
    DEBUG="YES"
    shift # past argument
    ;;
    *)    # unknown option
    POSITIONAL+=("$1") # save it in an array for later. This should be the .env file.
    shift # past argument
    ;;
esac
done
set -- "${POSITIONAL[@]}" # restore positional parameters

if [ "$HELP" == "YES" ]; then
    help 0;
fi

if [ -z "${APP}" ] && [ -z "${PARAMETER_PATH}" ]; then
    required_options
    exit 1;
fi

if [ -z "${ENV}" ] && [ -z "${PARAMETER_PATH}" ]; then
    required_options
    exit 1;
fi

if [ -z "$PARAMETER_PATH" ]; then
    PARAMETER_PATH="/${APP}/${ENV}/.env"
fi

YES=("YES" "Y" "yes" "y")
NO=("NO" "N" "no" "n")

ENV_OUTPUT_OPTIONS=($ENV_OUTPUT_DEFAULT $ENV_OUTPUT_BASH_EXPORT $ENV_OUTPUT_DOCKERFILE)

if [ -z "${ENV_OUTPUT}" ]; then
    ENV_OUTPUT="default"
fi

if [ "${DEBUG}" == "YES" ]; then
    debug "Parameter path: ${PARAMETER_PATH}"
fi
