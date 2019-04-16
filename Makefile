TAG ?= latest

# crd.Makefile provides targets to install Application CRD.
include ./marketplace-tools/crd.Makefile

# gcloud.Makefile provides default values for
# REGISTRY and NAMESPACE derived from local
# gcloud and kubectl environments.
include ./marketplace-tools/gcloud.Makefile

# marketplace.Makefile provides targets such as
# ".build/marketplace/deployer/envsubst" to build the base
# deployer images locally.
#include ./marketplace-tools/marketplace.Makefile


include ./marketplace-tools/var.Makefile

# app.Makefile provides the main targets for installing the
# application.
# It requires several APP_* variables defined as followed.
include ./marketplace-tools/app.Makefile

APP_DEPLOYER_IMAGE ?= $(REGISTRY)/trillo-k8s-public/deployer:$(TAG)
NAME ?= trillo-cluster-1
APP_PARAMETERS ?= { \
  "name": "$(NAME)", \
  "namespace": "$(NAMESPACE)" \
}




