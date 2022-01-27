#!/usr/bin/env bash

FILENAME=$(basename $0)
COMPLETED=./$FILENAME.done

if [ -f "$COMPLETED" ]; then
    echo "$FILENAME is completed"
    exit 0
fi

source ../env-global.sh

gcloud iam service-accounts create $SERVICE_ACCOUNT_ID --display-name "Trillo Platform"

#this role is moved to the specific
#gcloud projects add-iam-policy-binding $PROJECT_ID --member serviceAccount:$SA_EMAIL --role "roles/storage.objectAdmin"

gcloud projects add-iam-policy-binding $PROJECT_ID --member serviceAccount:$SA_EMAIL --role "roles/pubsub.subscriber"

gcloud projects add-iam-policy-binding $PROJECT_ID --member serviceAccount:$SA_EMAIL --role "roles/monitoring.metricWriter"

gcloud projects add-iam-policy-binding $PROJECT_ID --member serviceAccount:$SA_EMAIL --role "roles/logging.logWriter"


gcloud iam service-accounts keys create $SERVICE_ACCOUNT_ID.json --iam-account $SA_EMAIL

touch $COMPLETED
