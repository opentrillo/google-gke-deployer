#!/usr/bin/env bash

FILENAME=$(basename $0)
COMPLETED=./$FILENAME.done

if [ -f "$COMPLETED" ]; then
    echo "$FILENAME is completed"
    exit 0
fi

source ../env-global.sh

export APPSERVER_UI_DNS_NAME=${APPSERVER_UI_NAME}

gcloud compute addresses create trilloui-ip --global

export APPSERVER_UI_IP=$(gcloud compute addresses describe trilloui-ip --global --format="value(address)")

# update vars
envsubst < ./env_uiappserver.sh.template > ./env_uiappserver.sh

touch $COMPLETED