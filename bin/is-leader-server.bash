#!/bin/bash

#This is for Elastic Beanstalk
#The leader server is defined differently than eb defines it.
#This script chooses a server to be the leader and will exit OK
# the server it's on matches the server designated the leader (designated by
# this script).
# If the servers don't match it will exit 1.
#
# Examples:
# You can use this with a cron:
# `* * * * * sh /path/to/is-leader-server.bash && /usr/local/bin/only-run-this-on-one-server-at-a-time.sh`



if [ -z "$1" ]; then
 echo "Usage is-leader-server.bash <eb-environment-name> <region>";
 exit 0;
fi

if [ -z "$2" ]; then
 echo "Usage is-leader-server.bash <eb-environment-name> <region>";
 exit 0;
fi

ENVIRONMENT=$1
REGION=$2

LEADER_INSTANCE=$(aws --region $REGION ec2 describe-instances --filters "Name=instance-state-name,Values=running" "Name=tag:elasticbeanstalk:environment-name,Values=${ENVIRONMENT}" | jq '[.Reservations[].Instances[0]] | sort_by(.LaunchTime) | .[0].InstanceId' -r)
THIS_INSTANCE=$(curl http://169.254.169.254/latest/meta-data/instance-id)

if [ "$LEADER_INSTANCE" == "$THIS_INSTANCE" ]; then
    #return success
    exit 0;
fi

#return error
exit 1;
