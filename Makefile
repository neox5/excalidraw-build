IMAGE_NAME := ghcr.io/neox5/excalidraw
EXCALIDRAW_REF := v0.18.0

IMAGE := $(IMAGE_NAME):$(EXCALIDRAW_REF)-self-hosted

PODMAN ?= podman

.PHONY: build
build:
	$(PODMAN) build \
		-f Containerfile \
		--build-arg EXCALIDRAW_REF=$(EXCALIDRAW_REF) \
		-t $(IMAGE) \
		.

.PHONY: push
push:
	$(PODMAN) push $(IMAGE)

.PHONY: print
print:
	@printf 'IMAGE=%s\n' '$(IMAGE)'
	@printf 'EXCALIDRAW_REF=%s\n' '$(EXCALIDRAW_REF)'
