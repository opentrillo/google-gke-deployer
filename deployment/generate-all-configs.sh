#!/usr/bin/env bash

FILENAME=$(basename $0)
COMPLETED=./$FILENAME.done

if [ -f "$COMPLETED" ]; then
    echo "$FILENAME is completed"
    exit 0
fi

source ./env-global.sh

if [ "$TRILLO_APPS_INSTALL_SOURCE" = "marketplace" ]
then
  cat ./0-setup/env_versions.sh \
    ./0-setup/env_appserver.sh  \
    ./0-setup/env_uiappserver.sh \
    ./2-mysql/env_mysql.sh \
    ./3-edge/env_edge.sh \
    ./4-gke/env_predeploy.sh \
    ./4-gke/marketplace-configs.txt | tee -a ./all-configs.txt > /dev/null
else
  cat ./0-setup/env_versions.sh \
    ./0-setup/env_appserver.sh  \
    ./0-setup/env_uiappserver.sh \
    ./2-mysql/env_mysql.sh \
    ./3-edge/env_edge.sh \
    ./4-gke/env_predeploy.sh | tee -a ./all-configs.txt > /dev/null
fi

gsutil -m cp -r ../deployment gs://${BUCKET_NAME}/misc/deployment

touch $COMPLETED