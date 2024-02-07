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

if [ "$CREATE_MYSQL" = "yes" ]; then

#  gcloud services enable servicenetworking.googleapis.com
#  gcloud compute addresses create trillo-services-network --global --purpose=VPC_PEERING --prefix-length=16 --network=$NETWORK
#  echo "Waiting for Cloud SQL services network to be connected..."
#  sleep 180
#  gcloud services vpc-peerings connect --service=servicenetworking.googleapis.com --ranges=trillo-services-network --network=$NETWORK_SHORT

  # These are the database versions: MYSQL_5_6, MYSQL_5_7, MYSQL_8_0

  gcloud sql instances create $MYSQL_INSTANCE_NAME --tier=${DB_MACHINE_TYPE} --activation-policy=ALWAYS --zone=$ZONE --insights-config-query-insights-enabled --no-assign-ip --database-version=MYSQL_8_0 --network=$NETWORK --backup --retained-backups-count=90 --root-password=${ROOT_PASSWORD} --storage-auto-increase

  gcloud sql instances patch $MYSQL_INSTANCE_NAME --database-flags=max_allowed_packet=134217728

fi


gcloud sql users create $MYSQL_USERNAME --instance $MYSQL_INSTANCE_NAME --password $MYSQL_PASSWORD --host=%

export MYSQL_IP_ADDRESS=$(gcloud sql instances describe $MYSQL_INSTANCE_NAME --format='value(ipAddresses.ipAddress)')

gcloud secrets create MY_SQL_USER
gcloud secrets create MY_SQL_PASSWORD

printf "$MYSQL_USERNAME" | gcloud secrets versions add MY_SQL_USER --data-file=-
printf "$MYSQL_PASSWORD" | gcloud secrets versions add MY_SQL_PASSWORD --data-file=-

# update vars
envsubst < ./env_mysql.sh.template > ./env_mysql.sh

touch $COMPLETED
