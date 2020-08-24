#!/bin/bash

source ./set_env.sh

echo "Creating internal FW rule: $FW_NAME_INT"
gcloud compute firewall-rules create $FW_NAME_INT \
  --allow tcp,udp,icmp \
  --network $VPC_NAME \
  --source-ranges ${IP_RANGE},10.200.0.0/16

echo "Creating external FW rule: $FW_NAME_EXT"
gcloud compute firewall-rules create $FW_NAME_EXT \
  --allow tcp:22,tcp:6443,icmp \
  --network $VPC_NAME \
  --source-ranges 0.0.0.0/0

echo "Done"

gcloud compute firewall-rules list --filter="network:$VPC_NAME"
