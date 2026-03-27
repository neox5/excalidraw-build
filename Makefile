IMAGE_NAME := ghcr.io/neox5/excalidraw

EXCALIDRAW_REF := v0.18.0
VITE_APP_WS_SERVER_URL := https://excalidraw-room.<DOMAIN>

COLLAB_HOST := <DOMAIN with _ instead of .>
IMAGE_TAG := $(EXCALIDRAW_REF)-$(COLLAB_HOST)
IMAGE := $(IMAGE_NAME):$(IMAGE_TAG)

PODMAN ?= podman

.PHONY: build
build:
	$(PODMAN) build \
		-f Containerfile \
		--build-arg EXCALIDRAW_REF=$(EXCALIDRAW_REF) \
		--build-arg VITE_APP_WS_SERVER_URL=$(VITE_APP_WS_SERVER_URL) \
		-t $(IMAGE) \
		.

.PHONY: push
push:
	$(PODMAN) push $(IMAGE)

.PHONY: print
print:
	@printf 'IMAGE=%s\n' '$(IMAGE)'
	@printf 'EXCALIDRAW_REF=%s\n' '$(EXCALIDRAW_REF)'
	@printf 'VITE_APP_WS_SERVER_URL=%s\n' '$(VITE_APP_WS_SERVER_URL)'
