#!/usr/bin/env bash

FILENAME=$(basename $0)
COMPLETED=./$FILENAME.done

if [ -f "$COMPLETED" ]; then
    echo "$FILENAME is completed"
    exit 0
fi

function parse_yaml {
   local prefix=$2
   local s='[[:space:]]*' w='[a-zA-Z0-9_]*' fs=$(echo @|tr @ '\034')
   sed -ne "s|^\($s\):|\1|" \
        -e "s|^\($s\)\($w\)$s:$s[\"']\(.*\)[\"']$s\$|\1$fs\2$fs\3|p" \
        -e "s|^\($s\)\($w\)$s:$s\(.*\)$s\$|\1$fs\2$fs\3|p"  $1 |
   awk -F$fs '{
      indent = length($1)/2;
      vname[indent] = $2;
      for (i in vname) {if (i > indent) {delete vname[i]}}
      if (length($3) > 0) {
         vn=""; for (i=0; i<indent; i++) {vn=(vn)(vname[i])("_")}
         printf("%s%s%s=\"%s\"\n", "'$prefix'",vn, $2, $3);
      }
   }'
}

source ../env-global.sh
source ../0-setup/env_appserver.sh
source ../0-setup/env_uiappserver.sh
source ../0-setup/env_versions.sh
source ../2-mysql/env_mysql.sh
source ../3-edge/env_edge.sh
source ../2b-redis/env_redis.sh

if [ "$MAIL_ENABLED" = "yes" ]
then
  export MAIL_ENABLED=true
else
  export MAIL_ENABLED=false
fi

eval $(parse_yaml ./license.yaml "TRILLO_LICENSE_")
export TRILLO_LICENSE=${TRILLO_LICENSE_metadata_name}

if [ "$TRILLO_LICENSE" = "trillo-platform-1-license" ]
then
  echo "License is set as evaluation"
  export TRILLO_LICENSE_COUNT=0
fi

  # update vars
envsubst < ./values.yaml.template > ./trillort/values.yaml


touch $COMPLETED

