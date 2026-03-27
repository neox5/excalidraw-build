# excalidraw-build

Builds and publishes a self-hosted Excalidraw frontend with a custom collaboration server endpoint.

## Overview

- Frontend is built from source with `VITE_APP_WS_SERVER_URL`
- Each deployment target = one git branch
- Each branch produces one container image
- Images are tagged as:

```
<excalidraw_ref>-<normalized_collab_host>
```

Example:

```
v0.18.0-excalidraw-room_zion_local
```

## Repository Model

- `main` → template (not built)
- `target branches` → one per deployment (contain real values in `Makefile`)

Each target branch defines:

- `EXCALIDRAW_REF`
- `VITE_APP_WS_SERVER_URL`
- derived `IMAGE_TAG`

## Build (local)

```
make build
```

Run locally:

```
make run
```

## Push

```
make push
```

## CI/CD

- Push to a target branch → builds and publishes image to GHCR
- Pull requests → build only (no push)
- Manual runs → rebuild any branch via GitHub Actions UI

## Notes

- Collab URL is embedded at build time (Vite static build)
- Changing collab endpoint requires rebuilding the image
- `.local` domains require internal DNS / internal CA (no public ACME)

## Related Components

- `excalidraw-room` must be deployed separately
- Caddy is used as reverse proxy in front of both services
