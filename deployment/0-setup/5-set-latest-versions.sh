#!/usr/bin/env bash

FILENAME=$(basename $0)
COMPLETED=./$FILENAME.done

if [ -f "$COMPLETED" ]; then
    echo "$FILENAME is completed"
    exit 0
fi

source ../env-global.sh

gsutil cp gs://trillo-public/fm/ga/config.json ./versions.json

#export APP_VERSION_RTDS=$(jq -r '.rtdsTag' ./versions.json)
export APP_VERSION_RTDS=$TRILLO_APP_VERSION
export APP_VERSION_PUBSUB=$(jq -r '.pubsubTag' ./versions.json)


# update vars
envsubst < ./env_versions.sh.template > ./env_versions.sh

touch $COMPLETED
