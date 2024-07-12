#!/usr/bin/env bash


source ../env-global.sh

if [ "$TRILLO_APPS_INSTALL_SOURCE" = "marketplace" ]
then
  ./capture-mp-configs.sh
  exit 0
fi

if [ "$TRILLO_UI_DEPLOY" = "no" ]
then
  echo "UI APPS are not installed"
  exit 0
fi

# update vars
envsubst < ./values.ui.yaml.template > ./trilloui/values.yaml

gcloud container clusters get-credentials ${CLUSTER} --region ${REGION}
kubectl config set-context --current --namespace=trillo

helm upgrade --install trilloui ./trilloui $*
#helm uninstall trilloui $*

echo "https://console.cloud.google.com/kubernetes/workload?project=$PROJECT_ID"