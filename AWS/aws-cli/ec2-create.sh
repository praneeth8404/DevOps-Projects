#!/bin/bash

# Variables
AMI_ID=$1     
INSTANCE_TYPE=$2               
KEY_NAME=$3                 
SECURITY_GROUP_ID=$4
SUBNET_ID=$5   
INSTANCE_NAME=$6
COUNT=$7

# Create EC2 instance
aws ec2 run-instances \
    --image-id "$AMI_ID" \
    --count $COUNT \
    --instance-type "$INSTANCE_TYPE" \
    --key-name "$KEY_NAME" \
    --security-group-ids "$SECURITY_GROUP_ID" \
    --subnet-id "$SUBNET_ID" \
    --tag-specifications "ResourceType=instance,Tags=[{Key=Name,Value=$INSTANCE_NAME}]" \
    --output json

# Print confirmation message
echo "EC2 instance creation initiated."


