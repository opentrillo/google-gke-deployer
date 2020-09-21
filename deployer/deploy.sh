#!/usr/bin/env bash

set -x

# Set Project
export PROJECT_ID=$(gcloud config get-value project | tr ':' '/')
export REGISTRY=gcr.io/$PROJECT_ID
export APP_NAME=trillo-rt
export TAG=1

export TEST_PROJECT_ID=optimal-buffer-290206
export mysqlAddress=172.20.0.3
export edgeIpaddress=-na-
export server=aappserver-optimal-buffer-290206.trilloapps.com
export bucket=trillo-optimal-buffer-290206

#gcloud config set project $PROJECT_ID

gcloud container clusters get-credentials trillo-gke --zone us-central1-c --project $TEST_PROJECT_ID
kubectl create clusterrolebinding cluster-admin-binding --clusterrole cluster-admin --user $(gcloud config get-value account)

#kubectl create namespace test-ns


#export TAG=3.12
#export REGISTRY=gcr.io/$PROJECT_ID

kubectl apply -f "https://raw.githubusercontent.com/GoogleCloudPlatform/marketplace-k8s-app-tools/master/crd/app-crd.yaml"

#
#mpdev doctor
#cd ./deployer/trillo
#make clean
#make app/build
#mpdev verify --deployer=gcr.io/trillo-internal/trillo-rt/deployer:3.12  --parameters='{"name": "appgke", "namespace": "default", "trilloDSImage": “gcr.io/trillo-internal/trillo-rt/trillo-data-service:3.0.674", "trilloRTImage": "gcr.io/trillo-internal/trillo-rt:3.0.674", "reportingSecret": "trillo-reporting-secret"}'


mpdev install --deployer=$REGISTRY/$APP_NAME/deployer:$TAG --parameters='{"name": "trillo-rt", "namespace": "trillo",  "mysql.address": "'"$mysqlAddress"'", "edge.ipaddress": "'"$edgeIpaddress"'", "server":"'"$server"'", "bucket":"'"$bucket"'"}'

