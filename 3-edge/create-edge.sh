#!/usr/bin/env bash

FILENAME=$(basename $0)
COMPLETED=./$FILENAME.done

if [ -f "$COMPLETED" ]; then
    echo "$FILENAME is completed"
    exit 0
fi


. ../env-global.sh

TRILLO_SSH_PUB=`cat ../0-setup/trillo-ssh.pub`


if [ "$CREATE_SFTP_EDGE" = "no" ]
then
  echo "creating edge is disabled"
  export EDGE_INSTANCE=-na-
  export EDGE_INTERNAL_IP=-na-
  export EDGE_PUBLIC_IP=-na-

  # update vars
  envsubst < ./env_edge.sh.template > ./env_edge.sh
  exit 0
fi

export EDGE_INSTANCE=trillo-gcs-edge-01

gcloud beta compute --project=${PROJECT_ID} instances create ${EDGE_INSTANCE} --zone=$ZONE --machine-type=${SFTP_MACHINE_TYPE} --subnet=$SUBNETWORK --network-tier=PREMIUM --metadata="startup-script=/opt/trillo/start-edge.sh ${BUCKET_NAME},ssh-keys=sadmin:$TRILLO_SSH_PUB" --maintenance-policy=MIGRATE --service-account=$SA_EMAIL --scopes=https://www.googleapis.com/auth/cloud-platform --image=${EDGE_IMAGE} --image-project=project-trillort --boot-disk-size=100GB --boot-disk-type=pd-standard --boot-disk-device-name=trillo-gcs-edge --no-shielded-secure-boot --shielded-vtpm --shielded-integrity-monitoring --reservation-affinity=any

export EDGE_PUBLIC_IP=$(gcloud --format="value(networkInterfaces[0].accessConfigs[0].natIP)" compute instances list --filter="name=(${EDGE_INSTANCE})")

gcloud compute addresses create trillo-sftp-ip --addresses ${EDGE_PUBLIC_IP} --region ${REGION}

export EDGE_INTERNAL_IP=$(gcloud --format="value(networkInterfaces[0].networkIP)" compute instances list --filter="name=(${EDGE_INSTANCE})")

# update vars
envsubst < ./env_edge.sh.template > ./env_edge.sh

touch $COMPLETED
