#!/bin/bash

source ./set_env.sh
echo "Create vpc: ${VPC_NAME}"
gcloud compute networks create $VPC_NAME --subnet-mode custom

echo "Create subnet: ${IP_RANGE}"

gcloud compute networks subnets create $SUB_NET_NAME \
  --network $VPC_NAME \
  --range $IP_RANGE
