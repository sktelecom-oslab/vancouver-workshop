#!/bin/bash
set -xe

for IMAGE in $(grep -r ocata$ /home/ubuntu/vancouver-workshop/50-ocata-upgrade | awk '{print $3}' | uniq); do
    sudo docker inspect $IMAGE >/dev/null|| sudo docker pull $IMAGE
done
