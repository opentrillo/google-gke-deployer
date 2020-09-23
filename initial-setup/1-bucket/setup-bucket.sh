#!/usr/bin/env bash

FILENAME=$(basename $0)
COMPLETED=./$FILENAME.done

if [ -f "$COMPLETED" ]; then
    echo "$FILENAME is completed"
    exit 0
fi

source ../env-global.sh
source ../0-setup/env_appserver.sh

envsubst < ./cors.json.template > ./cors.json

TOPIC_NAME=trillo-gcs-topic
SUBSCRIPTION_NAME=trillo-gcs-sub
TRILLO_GA_SCRIPTS="gs://trillo-public/fm/ga/scripts/*"

function createBucket() {
  BUCKET_NAME_1=$1

  echo creating bucket - ${BUCKET_NAME_1}

  if gsutil mb -l $BUCKET_REGION gs://${BUCKET_NAME_1}/ ; then
    echo "Bucket does not exist therefore creating a new one:  $BUCKET_NAME_1"
    gsutil versioning set on gs://${BUCKET_NAME_1}/
    gsutil -m cp -r ./groups gs://${BUCKET_NAME_1}/
    gsutil -m cp -r ./users gs://${BUCKET_NAME_1}/
    gsutil -m cp -r ${TRILLO_GA_SCRIPTS} gs://${BUCKET_NAME_1}/system

    gsutil cors set ./cors.json gs://${BUCKET_NAME_1}
    gsutil cors get gs://${BUCKET_NAME_1}

    gsutil iam ch serviceAccount:$SA_EMAIL:objectAdmin gs://$BUCKET_NAME_1

    gcloud pubsub topics create ${TOPIC_NAME}
    gcloud pubsub subscriptions create ${SUBSCRIPTION_NAME} --topic ${TOPIC_NAME}
    gsutil notification create -t ${TOPIC_NAME} -f json gs://${BUCKET_NAME_1}
  else
    echo "Bucket already exists therefore making some adjustments"
    gsutil cors set ./cors.json gs://${BUCKET_NAME_1}
    gsutil cors get gs://${BUCKET_NAME_1}
  fi
}

createBucket ${BUCKET_NAME}

touch $COMPLETED
