#!/usr/bin/env bash

help(){
    {
        echo "USAGE: $SCRIPT_NAME [options] <dot env file>"; \
            echo "OPTIONS:"; \
            echo "      -a --app"; \
            echo "              Application Name or Elastic Beanstalk Application Name"; \
            echo "              Required with --env unless you specify --path"; \
            echo "      -e --env"; \
            echo "              Environment Name or Elastic Beanstalk Environment Name"; \
            echo "              Required with --app unless you specify --path"; \
            echo "      --path"; \
            echo "              AWS parameter path before the variable names (ie, /App/Env/.env)"; \
            echo "              Required unless you specify --app and --env"; \
            echo "      -p --profile"; \
            echo "              AWS profile name to authenticate with"; \
            echo "      -r --region"; \
            echo "              AWS region name"; \
            echo "      -o --output"; \
            echo "              Options: default|export|dockerfile"; \
            echo "              - default: bash variable"; \
            echo "              - export: bash variable prefixed with export"; \
            echo "              - dockerfile: Dockerfile format (ie, ENV NAME 'VALUE') "; \
            echo "      -d --debug"; \
            echo "              Show debug messaging"; \
            echo "      -h --help"; \
            echo "              Show this message"; \
    }
    EXIT_CODE=$1

    if [ -z "$EXIT_CODE" ]; then
        EXIT_CODE=0
    fi

    exit $EXIT_CODE;
}
