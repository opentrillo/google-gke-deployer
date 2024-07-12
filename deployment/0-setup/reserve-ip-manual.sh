#!/usr/bin/env bash

source ../env-global.sh

gcloud compute addresses create trillort-ip --global
echo "Workbench API IP address: $(gcloud compute addresses describe trillort-ip --global --format="value(address)")"

gcloud compute addresses create trilloui-ip --global
echo "Workbench  Front-end IP address: $(gcloud compute addresses describe trilloui-ip --global --format="value(address)")"