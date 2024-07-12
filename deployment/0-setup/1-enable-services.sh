#!/usr/bin/env bash

FILENAME=$(basename $0)
COMPLETED=./$FILENAME.done

if [ -f "$COMPLETED" ]; then
    echo "$FILENAME is completed"
    exit 0
fi

. ../env-global.sh

if [ "$APPSERVER_NAME" == "" ]
then
  echo "Error: You must provide the full dns name of the Workbench"
  exit 1
fi

for x in compute.googleapis.com cloudapis.googleapis.com pubsub.googleapis.com storage-component.googleapis.com \
  servicemanagement.googleapis.com sql-component.googleapis.com sqladmin.googleapis.com iam.googleapis.com \
  container.googleapis.com cloudresourcemanager.googleapis.com servicenetworking.googleapis.com serviceusage.googleapis.com redis.googleapis.com secretmanager.googleapis.com artifactregistry.googleapis.com documentai.googleapis.com aiplatform.googleapis.com contentwarehouse.googleapis.com
do
  gcloud services enable $x
  SERVICE_NAME=$x
  IS_SERVICE_ENABLED=$(gcloud services list --enabled --format="value(config.name)" --filter="config.name:$SERVICE_NAME")
  while [ -z "$IS_SERVICE_ENABLED" ]
  do
      echo "waiting (for 10s) for the $SERVICE_NAME to come up  ....."
      sleep 10
      IS_SERVICE_ENABLED=$(gcloud services list --enabled --format="value(config.name)" --filter="config.name:$SERVICE_NAME")
  done
  echo "$IS_SERVICE_ENABLED is enabled"
  echo ""
done

touch $COMPLETED
