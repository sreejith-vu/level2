#!/bin/bash

TAG=$(cat .env  |grep TAG |awk -F= '{print $NF}')
BACKEND_APP=$(cat .env |grep BACKEND_APP |awk -F= '{print $NF}')
DOCKER_REPO=$(cat .env |grep DOCKER_REPO |awk -F= '{print $NF}')
DOCKERHUB_USER=$(cat .env |grep DOCKERHUB_USER |awk -F= '{print $NF}')

docker tag $BACKEND_APP:$TAG $DOCKERHUB_USER/$DOCKER_REPO:$TAG
docker push $DOCKERHUB_USER/$DOCKER_REPO:$TAG
