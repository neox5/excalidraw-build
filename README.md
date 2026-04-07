# excalidraw-build

Builds and publishes a self-hosted Excalidraw frontend with a configurable collaboration server endpoint.

## Overview

- Frontend is built from source as a static Vite bundle
- Collaboration server URL is injected at container startup via environment variable
- One image per Excalidraw version, reusable across deployment targets

## Usage

Pull the image:

```
podman pull ghcr.io/neox5/excalidraw:v0.18.0-self-hosted
```

Run with your collaboration server:

```
podman run --rm -p 8080:80 \
  -e COLLAB_SERVER_URL=excalidraw-room.example.com \
  ghcr.io/neox5/excalidraw:v0.18.0-self-hosted
```

Excalidraw is then available at `http://localhost:8080`.

## Configuration

| Variable            | Required | Description                          |
| ------------------- | -------- | ------------------------------------ |
| `COLLAB_SERVER_URL` | yes      | Hostname of the collaboration server |

## Development

```
make build-local   # build localhost/excalidraw:dev
make run-local     # run with excalidraw-room.zion.local
make help          # list all targets
```

## CI/CD

- Push to `main` → builds and publishes image to GHCR
- Pull requests → build only (no push)
- Manual runs → rebuild via GitHub Actions UI

## Notes

- Changing the collab endpoint does not require rebuilding the image
- `.local` domains require internal DNS / internal CA (no public ACME)

## Related Components

- `excalidraw-room` must be deployed separately
- Caddy is used as reverse proxy in front of both services
