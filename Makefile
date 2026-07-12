SHELL := /bin/bash

################################################################################
# Load .env
################################################################################

ifneq (,$(wildcard .env))
include .env
export
endif

################################################################################
# Variables
################################################################################

DOCKER := docker

IMAGE := ghcr.io/$(GH_USERNAME)/$(IMAGE_NAME)

################################################################################
# Targets
################################################################################

.PHONY: \
	help \
	login logout \
	build push publish \
	inspect shell run \
	clean

.DEFAULT_GOAL := help

################################################################################
# Help
################################################################################

help:
	@echo ""
	@echo "bootc-poc"
	@echo ""
	@echo "Image"
	@echo "  make build      Build the bootc image"
	@echo "  make push       Push the image to GHCR"
	@echo "  make publish    Build and push"
	@echo ""
	@echo "Registry"
	@echo "  make login      Login to GHCR"
	@echo "  make logout     Logout from GHCR"
	@echo ""
	@echo "Development"
	@echo "  make shell      Open a shell inside the image"
	@echo "  make run        Run the image"
	@echo "  make inspect    Inspect the image"
	@echo "  make clean      Remove the local image"
	@echo ""

################################################################################
# Registry
################################################################################

login:
	@echo "$(GH_PAT)" | $(DOCKER) login ghcr.io \
		-u $(GH_USERNAME) \
		--password-stdin

logout:
	$(DOCKER) logout ghcr.io

################################################################################
# Image
################################################################################

build:
	$(DOCKER) build \
		--build-arg FEDORA_VERSION=$(FEDORA_VERSION) \
		--build-arg RKE2_CHANNEL=$(RKE2_CHANNEL) \
		--build-arg RKE2_VERSION=$(RKE2_VERSION) \
		-t $(IMAGE):$(TAG) .

push: login
	$(DOCKER) push $(IMAGE):$(TAG)

publish: build push

################################################################################
# Development
################################################################################

shell:
	$(DOCKER) run \
		--rm \
		-it \
		--privileged \
		--entrypoint /bin/bash \
		$(IMAGE):$(TAG)

run:
	$(DOCKER) run \
		--rm \
		-it \
		--privileged \
		$(IMAGE):$(TAG)

inspect:
	$(DOCKER) image inspect $(IMAGE):$(TAG)

clean:
	-$(DOCKER) image rm $(IMAGE):$(TAG)