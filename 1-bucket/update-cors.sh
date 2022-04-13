#!/bin/bash

# use this file to update the policy on the bucket otherwise the server will not be able to upload/download from cloud storage bucket
BUCKET_NAME=trillo-talent-match-342921
CORS_FILE=/tmp/$BUCKET_NAME.cors.json

gsutil cors get gs://$BUCKET_NAME > $CORS_FILE

echo Update the CORS configuration
nano $CORS_FILE

gsutil cors set $CORS_FILE gs://$BUCKET_NAME


