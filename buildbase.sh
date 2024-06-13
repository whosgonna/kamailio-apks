#!/usr/bin/env sh

ALPINE_VERSION=${1:-"latest"}

DOCKER_REG_USER=${DOCKER_USER:-"whosgonna"}

docker buildx build \
    --platform=linux/amd64,linux/arm64 \
    -t ${DOCKER_REG_USER}/kamailio-apk-base-builder:alpine_${ALPINE_VERSION} \
    --build-arg ALPINE_VERSION=${ALPINE_VERSION} \
    -f base.Dockerfile \
    --push \
    .
