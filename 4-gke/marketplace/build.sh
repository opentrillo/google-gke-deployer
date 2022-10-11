#!/bin/bash

set -x

export PROJECT_ID=trillo-k8s-public
export REGISTRY=gcr.io/$PROJECT_ID
export APP_NAME=trillo-rt
export TAG=3.11.24
export RELEASE_TAG=3.11

docker build --no-cache --tag $REGISTRY/$APP_NAME/deployer:$TAG .
docker push $REGISTRY/$APP_NAME/deployer:$TAG

gcloud container images --quiet add-tag $REGISTRY/$APP_NAME/deployer:$TAG $REGISTRY/$APP_NAME/deployer:$RELEASE_TAG
