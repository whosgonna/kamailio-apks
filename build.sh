#!/bin/sh

ALPINE_VERSION=${1}
KAM_TARGET_VERSION=${2}

echo "ALPINE VERSION IS ${ALPINE_VERSION}"
echo "Building apk_builder:alpine-${ALPINE_VERSION}"

docker build \
    --build-arg ALPINE_VERSION=${ALPINE_VERSION} \
    -t apk_builder:alpine-${ALPINE_VERSION} \
    .

CONATINER_NAME="kam-apk-alp${ALPINE_VERSION}-kam${KAM_TARGET_VERSION}"

docker run --rm \
    --env-file .env \
    -v ./abuild:/home/builder/.abuild \
    --name ${CONTAINER_NAME} \
    apk_builder:alpine-${ALPINE_VERSION} \
    build-apks.sh ${KAM_TARGET_VERSION} \




