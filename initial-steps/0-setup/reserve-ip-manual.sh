#!/usr/bin/env bash

source ../env-global.sh

gcloud compute addresses create trillort-ip --global

APPSERVER_IP=$(gcloud compute addresses describe trillort-ip --global --format="value(address)")
echo $APPSERVER_IP

