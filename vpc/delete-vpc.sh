#!/bin/bash

vpc_id=$1
vpc_region=$2

# Ask for dry-run mode
read -p "Do you want to run in dry-run mode? [y/N]: " dry
DRY_RUN=false
[[ "$dry" =~ ^[Yy]$ ]] && DRY_RUN=true
dry_flag=$([ "$DRY_RUN" = true ] && echo "--dry-run")

# Step 1: Get VPC ID if not passed
if [ -z "$vpc_id" ]; then
  read -p "Enter the VPC ID to delete (or press Enter to list existing VPCs): " vpc_id
fi

if [ -z "$vpc_id" ]; then
  aws ec2 describe-vpcs --query 'Vpcs[*].{ID:VpcId, CIDR:CidrBlock, Tags:Tags}' --output table
  read -p "Enter the VPC ID to delete: " vpc_id
fi

if [ -z "$vpc_id" ]; then
  echo "No VPC ID provided. Exiting."
  exit 1
fi

# Step 2: Get Region if not passed
if [ -z "$vpc_region" ]; then
  read -p "Enter the AWS region for the VPC (or press Enter to list regions with VPCs): " vpc_region
fi

if [ -z "$vpc_region" ]; then
  REGIONS=$(aws ec2 describe-regions --query 'Regions[*].RegionName' --output text)
  echo -e "Region\t\tVPC ID\t\t\tCIDR Block"
  for region in $REGIONS; do
    vpcs=$(aws ec2 describe-vpcs --region "$region" --query 'Vpcs[*].{ID:VpcId, CIDR:CidrBlock}' --output text)
    if [ -n "$vpcs" ]; then
      echo -e "$region\t$vpcs"
    fi
  done
  read -p "Enter the AWS region for the VPC: " vpc_region
fi

if [ -z "$vpc_region" ]; then
  echo "No region provided. Exiting."
  exit 1
fi

# Step 3: Check for attached IGW
vpc_igw=$(aws ec2 describe-internet-gateways \
  --region "$vpc_region" \
  --filters "Name=attachment.vpc-id,Values=$vpc_id" \
  --query "InternetGateways[*].InternetGatewayId" \
  --output text)

if [ -n "$vpc_igw" ]; then
  echo "Internet Gateway attached to this VPC:"
  aws ec2 describe-internet-gateways \
    --region "$vpc_region" \
    --filters "Name=attachment.vpc-id,Values=$vpc_id" \
    --query "InternetGateways[*].{ID:InternetGatewayId, VPCs:Attachments, Tags:Tags, Owner:OwnerId}" \
    --output table

  read -p "Do you want to delete or detach the Internet Gateway? [Y=delete / n=detach]: " de_igw
fi

# Step 4: Delete or detach IGW
if [[ -n "$vpc_igw" && "$de_igw" =~ ^[Yy]$ ]]; then
  aws ec2 delete-internet-gateway \
    --internet-gateway-id "$vpc_igw" \
    --region "$vpc_region" \
    $dry_flag
  echo "Internet Gateway $vpc_igw deleted from VPC $vpc_id."
elif [[ -n "$vpc_igw" && (-z "$de_igw" || "$de_igw" =~ ^[Nn]$) ]]; then
  aws ec2 detach-internet-gateway \
    --internet-gateway-id "$vpc_igw" \
    --vpc-id "$vpc_id" \
    --region "$vpc_region" \
    $dry_flag
  echo "Internet Gateway $vpc_igw detached from VPC $vpc_id."
fi

# Step 5: Delete the VPC
aws ec2 delete-vpc --vpc-id "$vpc_id" --region "$vpc_region" $dry_flag

if [ "$DRY_RUN" = true ]; then
  echo "Dry-run complete. No resources were deleted."
else
  echo "✅ VPC $vpc_id successfully deleted from region $vpc_region."
fi
