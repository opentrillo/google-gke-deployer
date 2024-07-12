#!/usr/bin/env bash


source ../env-global.sh

if [ "$TRILLO_APPS_INSTALL_SOURCE" = "marketplace" ]
then
  ./capture-mp-configs.sh
  exit 0
fi

gcloud container clusters get-credentials ${CLUSTER} --region ${REGION}
kubectl config set-context --current --namespace=trillo

helm upgrade --install trillort ./trillort $*
#helm uninstall trillort $*

echo "https://console.cloud.google.com/kubernetes/workload?project=$PROJECT_ID"
