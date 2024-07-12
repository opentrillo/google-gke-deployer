#!/usr/bin/env bash

FILENAME=$(basename $0)
COMPLETED=./$FILENAME.done

if [ -f "$COMPLETED" ]; then
    echo "$FILENAME is completed"
    exit 0
fi


source ../env-global.sh

gcloud container clusters get-credentials ${CLUSTER} --region ${REGION}

kubectl apply -f ./license.yaml --namespace=${CLUSTER_NAMESPACE}

echo "*** Enable the Licensing agent in RT and DS containers ***"

touch $COMPLETED
