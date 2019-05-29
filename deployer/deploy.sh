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

set -eo pipefail

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

###Install Trillo ###
kubectl apply -f "/data/manifest-expanded/ubbagent-config.yaml"
kubectl apply -f "/data/manifest-expanded/deploy-pvc.yaml"
kubectl apply -f "/data/manifest-expanded/deploy-nfs.yaml"
kubectl apply -f "/data/manifest-expanded/deploy-mysql.yaml"
kubectl apply -f "/data/manifest-expanded/deploy-ds.yaml"
kubectl apply -f "/data/manifest-expanded/deploy-redis.yaml"
kubectl apply -f "/data/manifest-expanded/deploy-rt.yaml"
kubectl apply -f "/data/manifest-expanded/rt-service-account.yaml"
kubectl apply -f "/data/manifest-expanded/rt-ingress.yaml"

#check status and test the health
while [[ "$(kubectl -n $NAMESPACE get ingress $NAME-ingress -o jsonpath='{.status.loadBalancer.ingress[0].ip}')" = '' ]]; do sleep 10; done
INGRESS_IP=$(kubectl -n $NAMESPACE get ingress $NAME-ingress -o jsonpath='{.status.loadBalancer.ingress[0].ip}' | sed 's/"//g')
echo "External IP: $INGRESS_IP"

echo "Testing platform readiness..."
while :; do (curl -k -sS --fail -o /dev/null "https://$INGRESS_IP") && break;sleep 10; done
echo "Trillo Platform is installed and running at https://$INGRESS_IP"

patch_assembly_phase.sh --status="Success"

clean_iam_resources.sh

trap - EXIT
