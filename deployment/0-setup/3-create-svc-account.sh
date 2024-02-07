#!/usr/bin/env bash

FILENAME=$(basename $0)
COMPLETED=./$FILENAME.done

if [ -f "$COMPLETED" ]; then
    echo "$FILENAME is completed"
    exit 0
fi

source ../env-global.sh

gcloud iam service-accounts create $SERVICE_ACCOUNT_ID --display-name "Trillo Platform"

gcloud projects add-iam-policy-binding $PROJECT_ID --member serviceAccount:$SA_EMAIL --role "roles/pubsub.subscriber"

gcloud projects add-iam-policy-binding $PROJECT_ID --member serviceAccount:$SA_EMAIL --role "roles/monitoring.metricWriter"

gcloud projects add-iam-policy-binding $PROJECT_ID --member serviceAccount:$SA_EMAIL --role "roles/logging.logWriter"

gcloud projects add-iam-policy-binding $PROJECT_ID --member serviceAccount:$SA_EMAIL --role "roles/secretmanager.secretAccessor"

gcloud projects add-iam-policy-binding $PROJECT_ID --member serviceAccount:$SA_EMAIL --role "roles/contentwarehouse.admin"
gcloud projects add-iam-policy-binding $PROJECT_ID --member serviceAccount:$SA_EMAIL --role "roles/contentwarehouse.documentAdmin"
gcloud projects add-iam-policy-binding $PROJECT_ID --member serviceAccount:$SA_EMAIL --role "roles/contentwarehouse.documentCreator"
gcloud projects add-iam-policy-binding $PROJECT_ID --member serviceAccount:$SA_EMAIL --role "roles/documentai.admin"
gcloud projects add-iam-policy-binding $PROJECT_ID --member serviceAccount:$SA_EMAIL --role "roles/aiplatform.admin"
gcloud projects add-iam-policy-binding $PROJECT_ID --member serviceAccount:$SA_EMAIL --role "roles/ml.admin"

gcloud iam service-accounts keys create $SERVICE_ACCOUNT_ID.json --iam-account $SA_EMAIL

touch $COMPLETED
