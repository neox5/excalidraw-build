IMAGE_NAME := ghcr.io/neox5/excalidraw
EXCALIDRAW_REF := v0.18.0

IMAGE_TAG := $(subst v,,$(EXCALIDRAW_REF))-self-hosted
IMAGE := $(IMAGE_NAME):$(IMAGE_TAG)
IMAGE_LOCAL := localhost/excalidraw:dev

PODMAN ?= podman

.DEFAULT_GOAL := help

.PHONY: help
help:
	@printf 'Usage: make <target>\n\n'
	@printf 'Targets:\n'
	@printf '  build        Build image for GHCR (%s)\n' '$(IMAGE)'
	@printf '  build-local  Build image for local use (%s)\n' '$(IMAGE_LOCAL)'
	@printf '  run          Run GHCR image (requires COLLAB_SERVER_URL)\n'
	@printf '  run-local    Run local image (COLLAB_SERVER_URL=excalidraw-room.zion.local)\n'
	@printf '  push         Push image to GHCR\n'

.PHONY: build
build:
	$(PODMAN) build \
		-f Containerfile \
		--build-arg EXCALIDRAW_REF=$(EXCALIDRAW_REF) \
		-t $(IMAGE) \
		.

.PHONY: build-local
build-local:
	$(PODMAN) build \
		-f Containerfile \
		--build-arg EXCALIDRAW_REF=$(EXCALIDRAW_REF) \
		-t $(IMAGE_LOCAL) \
		.

.PHONY: run
run:
	$(PODMAN) run --rm -p 8080:80 \
		-e COLLAB_SERVER_URL=$(COLLAB_SERVER_URL) \
		$(IMAGE)

.PHONY: run-local
run-local:
	$(PODMAN) run --rm -p 8080:80 \
		-e COLLAB_SERVER_URL=excalidraw-room.zion.local \
		$(IMAGE_LOCAL)

.PHONY: push
push:
	$(PODMAN) push $(IMAGE)
