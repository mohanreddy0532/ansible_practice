#!/bin/bash
ids=$(aws ec2 describe-instances | jq .Reservations[].Instances[].InstanceId| sed 's/"//g')

aws ec2 terminate-instances --instance-ids $ids

#aws ec2 terminate-instances --instance-ids i-5203422c