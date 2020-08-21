#!/bin/bash

source ./set_env.sh
echo "Create IP"

gcloud compute addresses create kubernetes-the-hard-way \
  --region $(gcloud config get-value compute/region)

gcloud compute addresses list --filter="name=('kubernetes-the-hard-way')"
