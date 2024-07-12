#!/usr/bin/env bash

FILENAME=$(basename $0)
COMPLETED=./$FILENAME.done

if [ -f "$COMPLETED" ]; then
    echo "$FILENAME is completed"
    exit 0
fi


source ../env-global.sh

if [ "$CREATE_CLUSTER" = "no" ]
then
  echo "creating cluster is disabled"
  exit 0
fi

# Creating Cloud NAT
gcloud compute routers create $CLOUD_NAT_ROUTER --project=${PROJECT_ID} --region=${REGION} --network=default
gcloud compute routers nats create $CLOUD_NAT_ROUTER_CONFIG \
    --router-region ${REGION} \
    --router $CLOUD_NAT_ROUTER \
    --nat-all-subnet-ip-ranges \
    --auto-allocate-nat-external-ips

# Creating GKE Private Cluster
# for production, set master-authorized-networks="${DEPLOYMENTIP}/32

gcloud container clusters create ${CLUSTER} --region ${REGION} --machine-type "${GKE_MACHINE_TYPE}" --network "${NETWORK}" --subnetwork "${SUBNETWORK}" --num-nodes "${GKE_NODES_PER_ZONE}" --addons HorizontalPodAutoscaling,HttpLoadBalancing,GcePersistentDiskCsiDriver --enable-ip-alias --scopes storage-rw --enable-shielded-nodes --enable-private-nodes --master-ipv4-cidr "172.14.0.0/28" --enable-master-authorized-networks --master-authorized-networks="0.0.0.0/0" --node-locations "$ZONE","$ZONE2" --enable-autoupgrade --enable-autorepair


touch $COMPLETED
