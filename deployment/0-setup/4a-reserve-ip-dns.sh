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

gcloud compute addresses create trillort-ip --global

export APPSERVER_IP=$(gcloud compute addresses describe trillort-ip --global --format="value(address)")

#secret token. This is used during the web authentication
export WEB_TOKEN_SECRET=$(openssl rand -base64 16)


#Set the default admin password for the appserver
export APPSERVER_DEFAULT_PASSWORD=$(openssl rand -base64 12)
export APPSERVER_DEFAULT_USER=admin

gcloud secrets create APPSERVER_DEFAULT_USER
printf "$APPSERVER_DEFAULT_USER" | gcloud secrets versions add APPSERVER_DEFAULT_USER --data-file=-

gcloud secrets create APPSERVER_DEFAULT_PASSWORD
printf "$APPSERVER_DEFAULT_PASSWORD" | gcloud secrets versions add APPSERVER_DEFAULT_PASSWORD --data-file=-

# update vars
envsubst < ./env_appserver.sh.template > ./env_appserver.sh

touch $COMPLETED