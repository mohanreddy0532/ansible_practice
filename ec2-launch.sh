

TEMP_ID="lt-0371737b9b36fe546"
TEMP_VER=1

#First instance
#aws ec2 run-instances --launch-template LaunchTemplateId=${TEMP_ID},Version=${TEMP_VER} | jq

#instance with Tag Name
aws ec2 run-instances --launch-template LaunchTemplateId=${TEMP_ID},Version=${TEMP_VER} --tag-specifications "ResourceType=instance,Tags=[{Key=Name,Value=frontend}]"| jq