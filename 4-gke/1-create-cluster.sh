#!/usr/bin/env bash

FILENAME=$(basename $0)
COMPLETED=./$FILENAME.done

if [ -f "$COMPLETED" ]; then
    echo "$FILENAME is completed"
    exit 0
fi


source ../env-global.sh

if [ "$CREATE_CLUSTER" = "no" ]
then
  echo "creating cluster is disabled"
  exit 0
fi


gcloud beta container clusters create ${CLUSTER} --zone ${ZONE} --cluster-version "latest" --machine-type "${GKE_MACHINE_TYPE}" --network "${NETWORK}" --num-nodes "${GKE_NODES}" --enable-autoscaling --min-nodes "${GKE_NODES}" --max-nodes "${GKE_NODES}" --addons HorizontalPodAutoscaling,HttpLoadBalancing --enable-ip-alias --scopes storage-rw --image-type "COS" --no-enable-autoupgrade

touch $COMPLETED
