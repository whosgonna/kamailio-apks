#!/bin/sh

ALPINE_VERSION=${1}
KAM_TARGET_VERSION=${2}

echo "\n\nALPINE VERSION IS ${ALPINE_VERSION}\n\n"

docker build \
    --build-arg ALPINE_VERSION=${ALPINE_VERSION} \
    -t apk_builder:alpine-${ALPINE_VERSION} \
    .







