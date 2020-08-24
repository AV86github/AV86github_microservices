#!/bin/bash

./generate_ca_config.sh

./generate_admin_crt.sh

./generate_kublet_crt.sh

./generate_k8s_manager_crt.sh

./generate_k8s_proxy_crt.sh

./generate_k8s_sched_crt.sh

./generate_k8s_api_crt.sh

./generate_k8s_service_acc.sh

./copy_certs.sh

./generate_config.sh

./generate_enc.sh
