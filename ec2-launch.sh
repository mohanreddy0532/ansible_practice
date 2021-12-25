#!/bin/bash

if [ -z "$1" ]; then
  echo "Input is Missing"
  exit 1
fi

COMPONENT=$1

TEMP_ID="lt-0371737b9b36fe546"
TEMP_VER=1


aws ec2 describe-instances --filters "Name=tag:Name,Values=${COMPONENT}" | jq .Reservations[].Instances[].State.Name | sed 's/"//g' | grep -E 'running|stopped' &>/dev/null
if [ $? -eq 0 ]; then
  echo "Instance Already there,please check"
  exit
fi

#First instance
#aws ec2 run-instances --launch-template LaunchTemplateId=${TEMP_ID},Version=${TEMP_VER} | jq
#instance with Tag Name
aws ec2 run-instances --launch-template LaunchTemplateId=${TEMP_ID},Version=${TEMP_VER} --tag-specifications "ResourceType=instance,Tags=[{Key=Name,Value=${COMPONENT}]"| jq