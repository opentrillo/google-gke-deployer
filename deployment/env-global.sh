#!/usr/bin/env bash

set -xeou pipefail

# for your workbench, decide the full server name along with domain
##################################################################
export WORKBENCH_SERVER_NAME=WORKBENCH_DNS_SERVER_NAME_WITH_DOMAIN
##################################################################

export APPSERVER_UI_NAME=$WORKBENCH_SERVER_NAME
export APPSERVER_NAME=api.$WORKBENCH_SERVER_NAME

export PROJECT_ID=$(gcloud config list --format 'value(core.project)')
export SERVICE_ACCOUNT_ID=trillort-sa
export SA_EMAIL=$SERVICE_ACCOUNT_ID@$PROJECT_ID.iam.gserviceaccount.com

# Network settings
################################
# Be very careful when shared networks are used
export REGION=us-central1
export ZONE=us-central1-c
export ZONE2=us-central1-b

export NETWORK_SHORT=default
export SUBNETWORK_SHORT=default

export OTHER_NETWORK_PROJECT=$PROJECT_ID
export NETWORK=projects/$OTHER_NETWORK_PROJECT/global/networks/$NETWORK_SHORT
export SUBNETWORK=projects/$OTHER_NETWORK_PROJECT/regions/$REGION/subnetworks/$SUBNETWORK_SHORT


# Trillo UI Deploy (yes/no) and Replics (1/0)
export TRILLO_UI_DEPLOY=yes
export TRILLO_UI_REPLICAS=1

#Bucket
export BUCKET_NAME=trillo-$PROJECT_ID
export BUCKET_REGION=$REGION

#Edge Node (SFTP/MISC UTILS) (yes/no)
#default: no
export CREATE_SFTP_EDGE=no
export EDGE_IMAGE=trillo-sftp-edge-04
export EDGE_INSTANCE=trillo-gcs-edge
export EDGE_INSTANCE_2=trillo-gcs-edge-2
#------------------------------------

#MYSQL settings
export CREATE_MYSQL=yes
export MYSQL_INSTANCE_NAME=trillo-mysql8

#------------------------------------
#CLOUD NAT
export CLOUD_NAT_ROUTER=default-cloud-nat-router
export CLOUD_NAT_ROUTER_CONFIG=default-cloud-nat-config

#------------------------------------
#GKE Cluster
export CREATE_CLUSTER=yes
export CLUSTER=trillo-gke
#------------------------------------

#Application default namespace
export CLUSTER_NAMESPACE=trillo

#GKE App (marketplace/trillo)
#------------------------------------
export TRILLO_APPS_INSTALL_SOURCE=trillo
#------------------------------------

#Send email notifications (yes/no)
export MAIL_ENABLED=yes
export FROM_ADDRESS=no-reply@$APPSERVER_NAME

#Packaged Application (read-only)
export TRILLO_PACKAGED_ORG_NAME=cloud
export DEFAULT_APP=main

#Machine Types
#Standard SFTP, GKE and DB machine types
#Minimum recommended
export SFTP_MACHINE_TYPE=n1-standard-2
export DB_MACHINE_TYPE=db-n1-standard-2
export GKE_MACHINE_TYPE=n2-standard-4

#GKE nodes are created in two zones
export GKE_NODES_PER_ZONE=1

export DEPLOYMENTIP=$(curl ifconfig.me)

#Trillo Repo Location
export TRILLO_REPO_LOCATION=project-trillort

#Trillo UI and App Version
export TRILLO_UI_VERSION=5.0.610
export TRILLO_APP_VERSION=5.0.610

#Container repository location
export TRILLO_UI_IMAGE=gcr.io/$TRILLO_REPO_LOCATION/trillo-apps/saas/v1
export TRILLO_RT_CONTAINER_REPOSITORY=gcr.io/$TRILLO_REPO_LOCATION/trillo-rt
export TRILLO_DS_CONTAINER_REPOSITORY=gcr.io/$TRILLO_REPO_LOCATION/trillo-rt/trillo-data-service

#Application service environment
export SERVICE_ENVIRONMENT=prod

#Authentication plug-in enablement
export USE_GKE_GCLOUD_AUTH_PLUGIN=True

#redis in the cloud memory store is enabled by default so provide the size in gigabytes
export CLOUD_MEMSTORE_SIZE=1

# every deployment should have least two licenses installed
export TRILLO_LICENSE_COUNT=2

#####################################
gcloud config set disable_prompts true
gcloud config set project $PROJECT_ID
#####################################
