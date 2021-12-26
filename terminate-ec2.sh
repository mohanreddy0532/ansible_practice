#!/bin/bash
#ids=$(aws ec2 describe-instances | jq .Reservations[].Instances[].InstanceId| sed 's/"//g')



#aws ec2 terminate-instances --instance-ids i-5203422c


IPADDRESS=$(aws ec2 describe-instances --filters "Name=tag:Name,Values=${COMPONENT}" | jq .Reservations[].Instances[].PrivateIpAddress | sed 's/"//g' | grep -v null)

  # Update the DNS record
  sed -e "s/IPADDRESS/${IPADDRESS}/" -e "s/COMPONENT/${COMPONENT}/" record_delete.json >/tmp/record_delete.json
  aws route53 change-resource-record-sets --hosted-zone-id ${ZONE_ID} --change-batch file:///tmp/record_delete.json | jq

  sleep 20

  #aws ec2 terminate-instances --instance-ids $ids