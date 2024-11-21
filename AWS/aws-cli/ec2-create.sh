aws ec2 run-instances \
    --image-id <AMI_ID> \
    --count 1 \
    --instance-type <INSTANCE_TYPE> \
    --key-name <KEY_PAIR_NAME> \
    --security-group-ids <SECURITY_GROUP_ID> \
    --subnet-id <SUBNET_ID> \
    --tag-specifications 'ResourceType=instance,Tags=[{Key=Name,Value=<INSTANCE_NAME>}]'
