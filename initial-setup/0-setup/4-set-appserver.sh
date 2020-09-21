#!/usr/bin/env bash

FILENAME=$(basename $0)
COMPLETED=./$FILENAME.done

if [ -f "$COMPLETED" ]; then
    echo "$FILENAME is completed"
    exit 0
fi

source ../env-global.sh

export APPSERVER_DNS_NAME=${APPSERVER_NAME}
export APPBUILDER_DNS_NAME=
export APPSERVER_IP=

#Set the default admin password for the appserver
export APPSERVER_DEFAULT_PASSWORD=$(openssl rand -base64 12)

# update vars
envsubst < ./env_appserver.sh.template > ./env_appserver.sh

touch $COMPLETED