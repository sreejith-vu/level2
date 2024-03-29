#!/bin/bash

TAG=$(cat .env  |grep TAG |awk -F= '{print $NF}')
BACKEND_APP=$(cat .env |grep BACKEND_APP |awk -F= '{print $NF}')
DOCKER_REPO=$(cat .env |grep DOCKER_REPO |awk -F= '{print $NF}')
DOCKERHUB_USER=$(cat .env |grep DOCKERHUB_USER |awk -F= '{print $NF}')

docker tag $BACKEND_APP:$TAG $DOCKERHUB_USER/$DOCKER_REPO:$TAG
docker push $DOCKERHUB_USER/$DOCKER_REPO:$TAG


sed -i "s/TAG/$TAG/g" deployments/email-app-deployment.yaml
sed -i "s/DOCKER_REPO/$DOCKER_REPO/g" deployments/email-app-deployment.yaml
sed -i "s/DOCKERHUB_USER/$DOCKERHUB_USER/g" deployments/email-app-deployment.yaml

cp deployments/web-domain-ingress.yaml my-app/templates/ingress.yaml
cp deployments/email-app-deployment.yaml my-app/templates/deployment.yaml
cp deployments/email-app-service.yaml my-app/templates/service.yaml

