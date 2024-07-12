#!/bin/bash

set -e

# use this file to update the policy on the bucket otherwise the server will not be able to upload/download from cloud storage bucket. You can paste the following lines in the cloud console. provide the correct name of the bucket.

EDITOR_NAME="nano" #use vi as the alternative
BUCKET_NAME=${1:-"Unknown"}
echo "Editing the CORS policy on the bucket $BUCKET_NAME"

CORS_FILE=/tmp/$BUCKET_NAME.cors.json

if [ "$BUCKET_NAME" == "Unknown" ]; then
    echo "Bucket is not known, please provide a bucket name"
    exit 0
fi

gsutil cors get gs://$BUCKET_NAME | python -m json.tool > $CORS_FILE

echo Update the CORS configuration
$EDITOR_NAME $CORS_FILE

gsutil cors set $CORS_FILE gs://$BUCKET_NAME

echo Updating the CORS configuration...
gsutil cors get gs://$BUCKET_NAME | python -m json.tool
