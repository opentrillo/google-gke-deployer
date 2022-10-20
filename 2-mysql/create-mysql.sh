#!/usr/bin/env bash

FILENAME=$(basename $0)
COMPLETED=./$FILENAME.done

if [ -f "$COMPLETED" ]; then
    echo "$FILENAME is completed"
    exit 0
fi


source ../env-global.sh

export MYSQL_PASSWORD=$(openssl rand -base64 18)
ROOT_PASSWORD=$(openssl rand -base64 18)

export MYSQL_USERNAME=trillo

if [ "$CREATE_MYSQL" = "yes" ]
then
  gcloud compute addresses create trillo-services-network --global --purpose=VPC_PEERING --prefix-length=16 --network=$NETWORK
  gcloud services vpc-peerings connect --service=servicenetworking.googleapis.com --ranges=trillo-services-network --network=$NETWORK_SHORT

  gcloud beta sql instances create $MYSQL_INSTANCE_NAME --tier=${DB_MACHINE_TYPE} --activation-policy=ALWAYS --zone=$ZONE --no-assign-ip --database-version=MYSQL_5_7 --network=$NETWORK --backup --retained-backups-count=90 --root-password=${ROOT_PASSWORD} --storage-auto-increase
fi

gcloud sql users create $MYSQL_USERNAME --instance $MYSQL_INSTANCE_NAME --password $MYSQL_PASSWORD --host=%

export MYSQL_IP_ADDRESS=$(gcloud sql instances describe $MYSQL_INSTANCE_NAME --format='value(ipAddresses.ipAddress)')

# update vars
envsubst < ./env_mysql.sh.template > ./env_mysql.sh

touch $COMPLETED