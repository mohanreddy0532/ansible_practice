#!/bin/bash

if [ -z "$1" ]; then
  echo -e "\e[1;31mInput is Missing\e[0m"
  exit 1
fi

COMPONENT=$1
ENV=$2

if [ ! -z "$ENV" ]; then
   ENV="-${ENV}"
fi

TEMP_ID="lt-0371737b9b36fe546"
TEMP_VER=1
ZONE_ID=Z079880618UTU9V8KYVX0

CREATE_INSTANCE() {
aws ec2 describe-instances --filters "Name=tag:Name,Values=${COMPONENT}" | jq .Reservations[].Instances[].State.Name | sed 's/"//g' | grep -E 'running|stopped' &>/dev/null
if [ $? -eq 0 ]; then
  echo -e "\e[1;32mInstance Already there,please check\e[0m"
else
#First instance
#aws ec2 run-instances --launch-template LaunchTemplateId=${TEMP_ID},Version=${TEMP_VER} | jq
#instance with Tag Name
aws ec2 run-instances --launch-template LaunchTemplateId=${TEMP_ID},Version=${TEMP_VER} --tag-specifications "ResourceType=instance,Tags=[{Key=Name,Value=${COMPONENT}}]"| jq

fi

sleep 10

#DNS Update
IPADDRESS=$(aws ec2 describe-instances --filters "Name=tag:Name,Values=${COMPONENT}" | jq .Reservations[].Instances[].PrivateIpAddress | sed 's/"//g' | grep -v null)

sed -e "s/IPADDRESS/${IPADDRESS}/" -e "s/COMPONENT/${COMPONENT}/" record.json >/tmp/record.json
aws route53 change-resource-record-sets --hosted-zone-id ${ZONE_ID} --change-batch file:///tmp/record.json | jq
}

if [ "$COMPONENT" == "all" ]; then
  for comp in frontend$ENV mongodb$ENV catalogue$ENV ; do
    COMPONENT=$comp
    CREATE_INSTANCE
  done
else
  COMPONENT=$COMPONENT$ENV
  CREATE_INSTANCE
fi
