#!/bin/bash

# Variables
BUCKET_NAME=$1
REGION=$2

# Create the S3 bucket
aws s3api create-bucket \
    --bucket $BUCKET_NAME \
    --region $REGION \
    --create-bucket-configuration LocationConstraint=$REGION \
    --output json

# Print confirmation message
echo "S3 bucket $BUCKET_NAME created in region $REGION."
