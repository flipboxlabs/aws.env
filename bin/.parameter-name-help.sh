#!/usr/bin/env bash

#print help
help(){
    {
        echo "USAGE: $SCRIPT_NAME [options] <parameter-name>"; \
            echo "OPTIONS:"; \
            echo "      -a --app"; \
            echo "              Application Name or Elastic Beanstalk Application Name"; \
            echo "      -e --env"; \
            echo "              Environment Name or Elastic Beanstalk Environment Name"; \
            echo "      -p --profile"; \
            echo "              AWS profile name to authenticate with"; \
            echo "      -r --region"; \
            echo "              AWS region name"; \
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
