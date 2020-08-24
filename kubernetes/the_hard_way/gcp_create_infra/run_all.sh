#!/bin/bash

./gcp_create_vpc.sh

./gcp_create_fw.sh

./gcp_create_ip.sh

./gcp_create_instance.sh
