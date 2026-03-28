FROM docker.io/node:22-bookworm-slim AS build

ARG EXCALIDRAW_REF=v0.18.0

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update \
 && apt-get install -y --no-install-recommends \
      ca-certificates \
      git \
 && rm -rf /var/lib/apt/lists/*

RUN corepack enable \
 && corepack prepare yarn@1.22.22 --activate

WORKDIR /src

RUN git clone https://github.com/excalidraw/excalidraw.git . \
 && git checkout "${EXCALIDRAW_REF}"

RUN yarn install --frozen-lockfile --network-timeout 600000

ENV NODE_ENV=production
ENV VITE_APP_WS_SERVER_URL="__COLLAB_SERVER_URL__"
ENV VITE_APP_DISABLE_SENTRY=true
ENV VITE_APP_DISABLE_TRACKING=true

RUN yarn build:app:docker

FROM docker.io/caddy:2.8-alpine

COPY --from=build /src/excalidraw-app/build /srv
COPY Caddyfile /etc/caddy/Caddyfile
COPY entrypoint.sh /entrypoint.sh

RUN chmod +x /entrypoint.sh

EXPOSE 80

ENTRYPOINT ["/entrypoint.sh"]
