#!/usr/bin/env bash

source ../env-global.sh

gcloud container clusters get-credentials ${CLUSTER} --region ${REGION}

kubectl config set-context --current --namespace=trillo

./helmrt.sh --set ds.replicaCount=0 --set rt.replicaCount=0

sleep 5

./helmrt.sh --set ds.replicaCount=1 --set rt.replicaCount=1

