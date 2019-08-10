#!/bin/bash

DOCKERHUB_USERNAME
DOCKER_REPO

TAG=$(cat .env  |grep TAG |awk -F= '{print $NF}')

docker tag email-app:$TAG sreejithvu/kube-public-repo:$TAG
