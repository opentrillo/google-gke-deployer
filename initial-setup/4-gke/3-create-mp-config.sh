#!/usr/bin/env bash

source ../env-global.sh
source ../0-setup/env_appserver.sh
source ../2-mysql/env_mysql.sh
source ../3-edge/env_edge.sh

export CLUSTER_NAMESPACE=$CLUSTER_NAMESPACE
export APPSERVER_DNS_NAME=${APPSERVER_DNS_NAME}
export BUCKET_NAME=${BUCKET_NAME}
export MYSQL_IP_ADDRESS=${MYSQL_IP_ADDRESS}
export EDGE_INTERNAL_IP=${EDGE_INTERNAL_IP}

# update vars
envsubst < ./marketplace-configs.txt.template > ./marketplace-configs.txt
