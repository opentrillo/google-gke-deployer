#!/usr/bin/env bash

FILENAME=$(basename $0)
COMPLETED=./$FILENAME.done

if [ -f "$COMPLETED" ]; then
    echo "$FILENAME is completed"
    exit 0
fi


source ../env-global.sh
source ../2-mysql/env_mysql.sh

SETUP_DIR=../0-setup
source $SETUP_DIR/env_appserver.sh
source $SETUP_DIR/env_uiappserver.sh

source ../2b-redis/env_redis.sh

gcloud container clusters get-credentials ${CLUSTER} --region ${REGION}

kubectl create namespace ${CLUSTER_NAMESPACE}

kubectl create secret generic trillort-sa-key --from-file=key.json=${SETUP_DIR}/trillort-sa.json --namespace=${CLUSTER_NAMESPACE}

kubectl create secret generic trillo-ssh-secret --from-file=${SETUP_DIR}/trillo-ssh --from-file=${SETUP_DIR}/trillo-ssh.pub --namespace=${CLUSTER_NAMESPACE}

kubectl create secret generic cloudsql-db-credentials \
    --from-literal username=${MYSQL_USERNAME} \
    --from-literal password=${MYSQL_PASSWORD} --namespace=${CLUSTER_NAMESPACE}

kubectl create secret generic redis-credentials \
    --from-literal password="$REDIS_PASSWORD" --namespace=${CLUSTER_NAMESPACE}

kubectl create secret generic admin-credentials \
    --from-literal password=${APPSERVER_DEFAULT_PASSWORD} --namespace=${CLUSTER_NAMESPACE}

kubectl create secret generic web-token-secret \
    --from-literal secret=${WEB_TOKEN_SECRET} --namespace=${CLUSTER_NAMESPACE}

kubectl apply -f ./license.yaml --namespace=${CLUSTER_NAMESPACE}

# update vars
envsubst < ./env_predeploy.sh.template > ./env_predeploy.sh


touch $COMPLETED
