#! /bin/bash

machine_name=dh

echo ========  Enabling docker metrics for machine: ${machine_name}==========

docker-machine scp daemon.json ${machine_name}:/tmp/

docker-machine ssh ${machine_name} "sudo cp /tmp/daemon.json /etc/docker/daemon.json"

echo ========  Restart docker daemon ==========

docker-machine ssh ${machine_name} "sudo systemctl restart docker"
