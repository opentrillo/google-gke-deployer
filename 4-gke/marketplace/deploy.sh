#!/usr/bin/env bash

set -x

# Set Project
export PROJECT_ID=$(gcloud config get-value project | tr ':' '/')
export REGISTRY=gcr.io/$PROJECT_ID
export APP_NAME=trillo-rt
export TAG=3.11.16

export TEST_PROJECT_ID=smooth-cycling-290323
export mysqlAddress=10.63.0.3
export edgeIpaddress=-na-
export server=aappserver-$TEST_PROJECT_ID.trilloapps.com
export bucket=trillo-$TEST_PROJECT_ID

#gcloud config set project $PROJECT_ID

gcloud container clusters get-credentials trillo-gke --zone us-central1-c --project $TEST_PROJECT_ID
kubectl create clusterrolebinding cluster-admin-binding --clusterrole cluster-admin --user $(gcloud config get-value account)

kubectl apply -f "https://raw.githubusercontent.com/GoogleCloudPlatform/marketplace-k8s-app-tools/master/crd/app-crd.yaml"

#
#mpdev doctor
#cd ./deployer/trillo
#make clean
#make app/build
#mpdev verify --deployer=gcr.io/trillo-internal/trillo-rt/deployer:3.12  --parameters='{"name": "appgke", "namespace": "default", "trilloDSImage": “gcr.io/trillo-internal/trillo-rt/trillo-data-service:3.0.674", "trilloRTImage": "gcr.io/trillo-internal/trillo-rt:3.0.674", "reportingSecret": "trillo-reporting-secret"}'


mpdev install --deployer=$REGISTRY/$APP_NAME/deployer:$TAG --parameters='{"name": "trillo-rt", "namespace": "trillo",  "mysql.address": "'"$mysqlAddress"'", "edge.ipaddress": "'"$edgeIpaddress"'", "server":"'"$server"'", "bucket":"'"$bucket"'"}'

