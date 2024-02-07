#!/usr/bin/env bash

FILENAME=$(basename $0)
COMPLETED=./$FILENAME.done

 if [ -f "$COMPLETED" ]; then
     echo "$FILENAME is completed"
     exit 0
 fi

source ../env-global.sh

gcloud redis instances create trillo-redis --size=${CLOUD_MEMSTORE_SIZE} --region=${REGION} --zone=${ZONE} --network=${NETWORK} --connect-mode=PRIVATE_SERVICE_ACCESS --enable-auth --tier=BASIC --redis-version=redis_6_x


export REDIS_IP=$(gcloud redis instances describe trillo-redis --region=${REGION} --format="value(host)")
export REDIS_AUTH=$(gcloud redis instances get-auth-string trillo-redis --region=${REGION} --format="value(authString)")

echo - name: REDIS_URL, value: redis://${REDIS_IP}:6379

gcloud secrets create REDIS_CREDENTIALS
printf "$REDIS_AUTH" | gcloud secrets versions add REDIS_CREDENTIALS --data-file=-

# update vars
envsubst < ./env_redis.sh.template > ./env_redis.sh

touch $COMPLETED
