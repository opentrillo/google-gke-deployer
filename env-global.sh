#!/usr/bin/env bash

set -xeou pipefail

# if you are setting up for another project then grab its ID
export PROJECT_ID=$(gcloud config list --format 'value(core.project)')
export SERVICE_ACCOUNT_ID=trillort-sa
export SA_EMAIL=$SERVICE_ACCOUNT_ID@$PROJECT_ID.iam.gserviceaccount.com

# Network settings
# Be very careful when shared networks are used
export ZONE=us-central1-c
export REGION=us-central1
export NETWORK_SHORT=default
export SUBNETWORK_SHORT=default
export OTHER_NETWORK_PROJECT=$PROJECT_ID
#for shared-network then allow this machine to use its networks
export NETWORK=projects/$OTHER_NETWORK_PROJECT/global/networks/$NETWORK_SHORT
export SUBNETWORK=projects/$OTHER_NETWORK_PROJECT/regions/$REGION/subnetworks/$SUBNETWORK_SHORT

#Application server name
#**** Must Provide Yours AppServer's full DNS NAME *****
export APPSERVER_NAME=
#you must add the A-record once this installer is finished.

#Bucket
export BUCKET_NAME=trillo-$PROJECT_ID
export BUCKET_REGION=$REGION

#--select one from below---------------
#1 no SFTP (default)
export CREATE_SFTP_EDGE=no

#2 SFTP
#export CREATE_SFTP_EDGE=yes
#export EDGE_IMAGE=trillo-sftp-edge
#export EDGE_INSTANCE=trillo-gcs-edge-01
#------------------------------------

#MYSQL settings
#--enable one setting---------------
export CREATE_MYSQL=yes
export MYSQL_INSTANCE_NAME=trillo-mysql-$PROJECT_ID

#export CREATE_MYSQL=no
#export MYSQL_INSTANCE_NAME=provide-name
#------------------------------------
#CLOUD NAT
export CLOUD_NAT_ROUTER=default-cloud-nat-router
export CLOUD_NAT_ROUTER_CONFIG=default-cloud-nat-config

#------------------------------------
#GKE Cluster
#--enable one setting---------------
export CREATE_CLUSTER=yes
export CLUSTER=trillo-gke

#export CREATE_CLUSTER=no
#export CLUSTER=provide-name
#------------------------------------

#Application default namespace
export CLUSTER_NAMESPACE=trillo

#GKE App
#------------------------------------
export TRILLO_APPS_INSTALL_SOURCE=marketplace
#export TRILLO_APPS_INSTALL_SOURCE=trillo
#------------------------------------

#Send email notifications (yes/no)
export MAIL_ENABLED=yes
export FROM_ADDRESS=no-reply@$APPSERVER_NAME

#Packaged Application (read-only)
export TRILLO_PACKAGED_ORG_NAME=cloud
export DEFAULT_APP=main

#Machine Types
#SFTP
export SFTP_MACHINE_TYPE=n1-standard-2
export DB_MACHINE_TYPE=db-n1-standard-2
export GKE_MACHINE_TYPE=n2-standard-4
export GKE_NODES=2

export DEPLOYMENTIP=$(curl ifconfig.me)

#Trillo GKE Marketplace license
#export TRILLO_LICENSE_MODE=evaluation
export TRILLO_LICENSE_ID=trillo-platform-1-license

#####################################
gcloud config set project $PROJECT_ID
#####################################
