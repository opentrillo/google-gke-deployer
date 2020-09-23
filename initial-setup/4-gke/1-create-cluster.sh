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


gcloud beta container clusters create ${CLUSTER} --zone ${ZONE} --release-channel regular --machine-type "n1-standard-4" --network "${NETWORK}" --num-nodes "2" --enable-autoscaling --min-nodes "1" --max-nodes "2" --addons HorizontalPodAutoscaling,HttpLoadBalancing --enable-ip-alias --scopes storage-rw

touch $COMPLETED
