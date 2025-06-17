#!/bin/bash

# Create a VPC with a specified CIDR block
VPC_ID=$(aws ec2 create-vpc \
--cidr-block "172.32.0.0/16" \
--tag-specifications 'ResourceType=vpc,Tags=[{Key=Name,Value=solution-arch},{Key=use-case,Value=solution-arch}]' \
--region us-west-2 \
--query 'Vpc.VpcId' \
--output text)

echo "vpc_id is: $VPC_ID "

# Create an Internet Gateway and attach it to the VPC
IGW_ID=$(aws ec2 create-internet-gateway \
--tag-specifications 'ResourceType=internet-gateway,Tags=[{Key=Name,Value=solution-arch},{Key=use-case,Value=solution-arch}]' \
--region us-west-2 \
--query 'InternetGateway.InternetGatewayId' \
--output text)

echo "Internet Gateway ID is: $IGW_ID"

# Attach the Internet Gateway to the VPC
aws ec2 attach-internet-gateway \
--internet-gateway-id "$IGW_ID" \
--vpc-id "$VPC_ID" \
--region us-west-2  
