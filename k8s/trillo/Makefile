include ../app.Makefile
include ../crd.Makefile
include ../gcloud.Makefile
include ../var.Makefile

TAG ?= 51

$(info ---- TAG = $(TAG))

APP_DEPLOYER_IMAGE ?= $(REGISTRY)/trillo-rt/deployer:$(TAG)
NAME ?= trillo-rt-1
TRILLO_RT_TAG_DOCKERHUB = 1.0.0-BUILD-SNAPSHOT_495
TRILLO_DATA_SERVICE_TAG_DOCKERHUB = 0.5.0-BUILD-SNAPSHOT_285


ifdef IMAGE_SAMPLE_APP
  IMAGE_SAMPLE_APP_FIELD = , "IMAGE_SAMPLE_APP": "$(IMAGE_SAMPLE_APP)"
endif

ifdef SAMPLE_APP_PARAMETER1
  SAMPLE_APP_PARAMETER1_FIELD = , "SAMPLE_APP_PARAMETER1": "$(SAMPLE_APP_PARAMETER1)"
endif

APP_PARAMETERS ?= { \
  "APP_INSTANCE_NAME": "$(NAME)", \
  "NAMESPACE": "$(NAMESPACE)" \
  $(IMAGE_SAMPLE_APP_FIELD) \
  $(SAMPLE_APP_PARAMETER1_FIELD) \
}

TESTER_IMAGE ?= $(REGISTRY)/trillo-rt/tester:$(TAG)


app/build:: .build/trillo-rt/deployer \
            .build/trillo-rt/trillo-rt \
            .build/trillo-rt/tester


.build/trillo-rt: | .build
	mkdir -p "$@"


.build/trillo-rt/deployer: deployer/* \
                       manifest/* \
                       schema.yaml \
                       .build/var/APP_DEPLOYER_IMAGE \
                       .build/var/MARKETPLACE_TOOLS_TAG \
                       .build/var/REGISTRY \
                       .build/var/TAG \
                       | .build/trillo-rt
	docker build \
	    --build-arg REGISTRY="$(REGISTRY)/trillo-rt" \
	    --build-arg TAG="$(TAG)" \
	    --build-arg MARKETPLACE_TOOLS_TAG="$(MARKETPLACE_TOOLS_TAG)" \
	    --tag "$(APP_DEPLOYER_IMAGE)" \
	    -f deployer/Dockerfile \
	    .
	docker push "$(APP_DEPLOYER_IMAGE)"
	@touch "$@"


.build/trillo-rt/trillo-rt: .build/var/REGISTRY \
                              .build/var/TAG \
                              | .build/trillo-rt

	docker pull trillo/trillo-data-service:$(TRILLO_DATA_SERVICE_TAG_DOCKERHUB)
	docker tag trillo/trillo-data-service:$(TRILLO_DATA_SERVICE_TAG_DOCKERHUB) \
	    "$(REGISTRY)/trillo-rt/trillo-data-service:$(TAG)"
	docker push "$(REGISTRY)/trillo-rt/trillo-data-service:$(TAG)"

	docker pull trillo/trillo-rt:$(TRILLO_RT_TAG_DOCKERHUB)
	docker tag trillo/trillo-rt:$(TRILLO_RT_TAG_DOCKERHUB) \
	    "$(REGISTRY)/trillo-rt:$(TAG)"
	docker push "$(REGISTRY)/trillo-rt:$(TAG)"


.build/trillo-rt/tester: .build/var/TESTER_IMAGE \
                          $(shell find apptest -type f) \
                          | .build/trillo-rt
	$(call print_target,$@)
	cd apptest/tester \
	    && docker build --tag "$(TESTER_IMAGE)" .
	docker push "$(TESTER_IMAGE)"
	@touch "$@"
