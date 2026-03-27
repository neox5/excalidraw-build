FROM docker.io/node:22-bookworm-slim AS build

ARG EXCALIDRAW_REF=v0.18.0
ARG VITE_APP_WS_SERVER_URL

ENV DEBIAN_FRONTEND=noninteractive
ENV NODE_ENV=production

RUN apt-get update \
 && apt-get install -y --no-install-recommends \
      ca-certificates \
      git \
 && rm -rf /var/lib/apt/lists/*

WORKDIR /src

RUN git clone https://github.com/excalidraw/excalidraw.git . \
 && git checkout "${EXCALIDRAW_REF}"

RUN corepack enable \
 && corepack prepare yarn@1.22.22 --activate

ENV VITE_APP_WS_SERVER_URL="${VITE_APP_WS_SERVER_URL}"
ENV VITE_APP_DISABLE_SENTRY=true
ENV VITE_APP_DISABLE_TRACKING=true

RUN yarn install --frozen-lockfile --network-timeout 600000
RUN yarn build:app:docker

FROM docker.io/caddy:2.8-alpine

COPY --from=build /src/excalidraw-app/build /srv

EXPOSE 80
