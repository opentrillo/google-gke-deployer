#!/usr/bin/env bash

FILENAME=$(basename $0)
COMPLETED=./$FILENAME.done

if [ -f "$COMPLETED" ]; then
    echo "$FILENAME is completed"
    exit 0
fi

source ../env-global.sh
source ./env_appserver.sh
source ./env_uiappserver.sh

DNS_RECORD_ALREADY_CONFIRMED=yes


if [ "$DNS_RECORD_ALREADY_CONFIRMED" = "no" ]; then
  echo "Please add following type-A record in your DNS account"
  echo "$APPSERVER_DNS_NAME  $APPSERVER_IP"
  echo ""
  echo "Once added, the confirm with following command and look for $APPSERVER_IP"
  echo "dig $APPSERVER_DNS_NAME"
  echo ""
  echo "Once Confirmed then set following value to 'yes' in ../env-global.sh"
  echo "export DNS_RECORD_CONFIRMED=yes"
  echo ""
  echo "To continue installation, re-run runall.sh"
  exit 1
fi

touch $COMPLETED
