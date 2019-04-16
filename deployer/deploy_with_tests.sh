#!/bin/bash
#
# Copyright 2018 Google LLC
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

INGRESS_IP=127_0_0_1

set -eox pipefail

get_domain_name() {
  echo "$NAME.$INGRESS_IP.trillo.io"
}

#create self-signed cert
create_cert(){
  local source=/data/server.config
  local config_file; config_file=$(mktemp)
  cp $source $config_file

  sed -i -e "s#trillo.io#$(get_domain_name)#" "$config_file"

  openssl req -config "$config_file" -new -newkey rsa:2048 -nodes -keyout server.key -out server.csr

  echo "Created server.key"
  echo "Created server.csr"

  openssl x509 -req -days 365 -in server.csr -signkey server.key -out server.crt
  echo "Created server.crt (self-signed)"

  kubectl create secret tls $NAME-tls --cert=server.crt --key=server.key
}

# This is the entry point for the production deployment

# If any command returns with non-zero exit code, set -e will cause the script
# to exit. Prior to exit, set App assembly status to "Failed".
handle_failure() {
  code=$?
  if [[ -z "$NAME" ]] || [[ -z "$NAMESPACE" ]]; then
    # /bin/expand_config.py might have failed.
    # We fall back to the unexpanded params to get the name and namespace.
    NAME="$(/bin/print_config.py --param '{"x-google-marketplace": {"type": "NAME"}}' \
            --values_file /data/values.yaml --values_dir /data/values)"
    NAMESPACE="$(/bin/print_config.py --param '{"x-google-marketplace": {"type": "NAMESPACE"}}' \
                 --values_file /data/values.yaml --values_dir /data/values)"
    export NAME
    export NAMESPACE
  fi
  patch_assembly_phase.sh --status="Failed"
  exit $code
}
trap "handle_failure" EXIT

NAME="$(/bin/print_config.py \
    --xtype NAME \
    --values_mode raw)"
NAMESPACE="$(/bin/print_config.py \
    --xtype NAMESPACE \
    --values_mode raw)"
export NAME
export NAMESPACE

echo "Deploying application \"$NAME\""

app_uid=$(kubectl get "applications.app.k8s.io/$NAME" \
  --namespace="$NAMESPACE" \
  --output=jsonpath='{.metadata.uid}')
app_api_version=$(kubectl get "applications.app.k8s.io/$NAME" \
  --namespace="$NAMESPACE" \
  --output=jsonpath='{.apiVersion}')

/bin/expand_config.py --values_mode raw --app_uid "$app_uid"

create_manifests.sh

# Ensure assembly phase is "Pending", until successful kubectl apply.
#/bin/setassemblyphase.py \
#  --manifest "/data/manifest-expanded/deploy-rt.yaml" \
#  --status "Pending"

###install trillo ###
kubectl apply -f "/data/manifest-expanded/secrets-mysql.yaml"
kubectl apply -f "/data/manifest-expanded/pvpvc-stage1.yaml"
kubectl apply -f "/data/manifest-expanded/deploy-nfs.yaml"
kubectl apply -f "/data/manifest-expanded/pvpvc-stage2.yaml"
kubectl apply -f "/data/manifest-expanded/deploy-mysql.yaml"
kubectl apply -f "/data/manifest-expanded/deploy-ds.yaml"
kubectl apply -f "/data/manifest-expanded/deploy-redis.yaml"
kubectl apply -f "/data/manifest-expanded/deploy-rt.yaml"
kubectl apply -f "/data/manifest-expanded/rt-service-account.yaml"

#generate a self-signed cert
#create_cert

sleep 20

patch_assembly_phase.sh --status="Success"

clean_iam_resources.sh

echo "Trillo Platform is installed and running at https://$(get_domain_name)"

trap - EXIT
