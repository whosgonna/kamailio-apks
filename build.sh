#!/bin/sh

ALPINE_VESRION=${1}
KAM_TARGET_VERSION=${2}

docker build \
    --build-arg ALPINE_VERSION=${ALPINE_VERSION} \
    -t apk_builder:alpine-${ALPINE_VESRION} \
    .






