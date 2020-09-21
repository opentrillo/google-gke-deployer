#!/usr/bin/env bash

FILENAME=$(basename $0)
COMPLETED=./$FILENAME.done

if [ -f "$COMPLETED" ]; then
    echo "$FILENAME is completed"
    exit 0
fi

source ../env-global.sh

APPBUILDER_REQUIRED=no
AUTO_CREATE_DNS_RECORD=no


if [ "$APPBUILDER_REQUIRED" = "yes" ]
then
  gcloud compute addresses create trillodt-ip --global
  export APPBUILDER_IP=$(gcloud compute addresses describe trillodt-ip --global --format="value(address)")
fi

export APPSERVER_DNS_NAME=${APPSERVER_NAME}
export APPBUILDER_DNS_NAME=

if [ "$AUTO_CREATE_DNS_RECORD" = "yes" ]
then

  gcloud compute addresses create trillort-ip --global
  export APPSERVER_IP=$(gcloud compute addresses describe trillort-ip --global --format="value(address)")

  keyFile=./trillo/dns-record-creator.json
  unzip -P aZ6eCFydvoJiyh4UatTG ./trillo/trillo.zip -d ./trillo

  gcloud auth activate-service-account --key-file=${keyFile}

  gcloud dns --project=project-trillort record-sets transaction start --zone=trilloapps-zone

  gcloud dns --project=project-trillort record-sets transaction add ${APPSERVER_IP} --name=${APPSERVER_DNS_NAME}. --ttl=300 --type=A --zone=trilloapps-zone

  gcloud dns --project=project-trillort record-sets transaction add ${APPSERVER_IP} --name=www.${APPSERVER_DNS_NAME}. --ttl=300 --type=A --zone=trilloapps-zone

  if [ "$APPBUILDER_REQUIRED" = "yes" ]
  then

    export APPBUILDER_DNS_NAME=${APPBUILDER_NAME}

    gcloud dns --project=project-trillort record-sets transaction add ${APPBUILDER_IP} --name=${APPBUILDER_DNS_NAME}. --ttl=300 --type=A --zone=trilloapps-zone

    gcloud dns --project=project-trillort record-sets transaction add ${APPBUILDER_IP} --name=www.${APPBUILDER_DNS_NAME}. --ttl=300 --type=A --zone=trilloapps-zone
  fi

  gcloud dns --project=project-trillort record-sets transaction execute --zone=trilloapps-zone
  sleep 5

  gcloud auth revoke trilloapps-dns-record-creator@project-trillort.iam.gserviceaccount.com

  rm $keyFile
else
  echo "Skip create DNS records"
  export APPSERVER_IP=$(gcloud compute addresses describe trillort-ip --global --format="value(address)")

fi

#Set the default admin password for the appserver
export APPSERVER_DEFAULT_PASSWORD=$(openssl rand -base64 12)

# update vars
envsubst < ./env_appserver.sh.template > ./env_appserver.sh

rm -f ./trillo/dns-record-creator.json
rm -f ./trillo/trillo.zip

touch $COMPLETED