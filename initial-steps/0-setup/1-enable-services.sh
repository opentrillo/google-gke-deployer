#!/usr/bin/env bash

FILENAME=$(basename $0)
COMPLETED=./$FILENAME.done

if [ -f "$COMPLETED" ]; then
    echo "$FILENAME is completed"
    exit 0
fi

. ../env-global.sh

if [[ ! -v APPSERVER_NAME ]];
then
  echo "Error: Please add your server in DNS records and provide its full name."
  exit 1
fi



gcloud services enable compute.googleapis.com
gcloud services enable cloudapis.googleapis.com
gcloud services enable pubsub.googleapis.com
gcloud services enable storage-component.googleapis.com
gcloud services enable servicemanagement.googleapis.com
gcloud services enable sql-component.googleapis.com
gcloud services enable sqladmin.googleapis.com
gcloud services enable iam.googleapis.com
gcloud services enable container.googleapis.com
gcloud services enable cloudresourcemanager.googleapis.com
gcloud services enable servicenetworking.googleapis.com

touch $COMPLETED
