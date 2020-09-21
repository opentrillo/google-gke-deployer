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
#Example:
#export APPSERVER_NAME=appserver-$PROJECT_ID.trilloapps.com
export APPSERVER_NAME=


#Bucket
export BUCKET_NAME=trillo-$PROJECT_ID
export BUCKET_REGION=$REGION

#--select one from below---------------
#1 no SFTP (default)
export CREATE_SFTP_EDGE=no

#2 SFTP
#export CREATE_SFTP_EDGE=yes
#export EDGE_IMAGE=trillo-sftp-edge
#------------------------------------

#MYSQL settings
#--enable one setting---------------
export CREATE_MYSQL=yes
export MYSQL_INSTANCE_NAME=trillo-mysql-$PROJECT_ID

#export CREATE_MYSQL=no
#export MYSQL_INSTANCE_NAME=provide-name
#------------------------------------

#GKE Cluster
#--enable one setting---------------
export CREATE_CLUSTER=yes
export CLUSTER=trillo-gke

#export CREATE_CLUSTER=no
#export CLUSTER=provide-name
#------------------------------------

#GKE App
#------------------------------------
export TRILLO_APPS_INSTALL_SOURCE=marketplace
#------------------------------------

#Send email notifications (yes/no)
export MAIL_ENABLED=yes

#Application default namespace
export CLUSTER_NAMESPACE=trillo

#Packaged Application
export TRILLO_PACKAGED_ORG_NAME=cloud

#####################################
gcloud config set project $PROJECT_ID
#####################################