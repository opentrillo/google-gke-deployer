#!/bin/bash

export PROJECT_ID=$(gcloud config get-value project | tr ':' '/')
# Set the registry to your project GCR repo.
#export REGISTRY=gcr.io/$(gcloud config get-value project | tr ':' '/')
export REGISTRY=gcr.io/$PROJECT_ID
export APP_NAME=trillo-rt
export TAG=3.11

docker build --no-cache --tag $REGISTRY/$APP_NAME/deployer:$TAG .
docker push $REGISTRY/$APP_NAME/deployer:$TAG
