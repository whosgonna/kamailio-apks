#!/bin/sh
KAM_TARGET_VERSION=${1}

ALPINE_VERSION=${2:-"latest"}

DOCKER_REG_USER=whosgonna

if [ -z "${KAM_TARGET_VERSION}" ]
then
    echo "Need a Kamailio version (must be commit tag or id, etc.)";
    exit 1;
fi

DOCKER_BASE_REG=${DOCKER_REG_USER}/kamailio-apk-base-builder
DOCKER_BASE_IMG=${DOCKER_BASE_REG}:alpine${ALPINE_VERSION}

echo "Building ${DOCKER_BASE_IMG}\n";

docker build -t $DOCKER_BASE_IMG \
             --build-arg ALPINE_VERSION=${ALPINE_VERSION} \
             -f base.Dockerfile \
             .

DOCKER_REG=${DOCKER_REG_USER}/kamailio-apks
DOCKER_TAG="alpine-${ALPINE_VERSION}_kamailio-${KAM_TARGET_VERSION}"

OUT_DIR=./docs/${KAM_TARGET_VERSION}/v${ALPINE_VERSION}

#cp ./abuild/*.pub ./apk

if [ ! -d $OUT_DIR ]
then
    mkdir -p $OUT_DIR
fi

echo "Building ${DOCKER_REG}:${DOCKER_TAG}\n";
docker build -t ${DOCKER_REG}:${DOCKER_TAG} \
             --build-arg KAM_TARGET_VERSION=${KAM_TARGET_VERSION} \
             --build-arg ALPINE_VERSION=${ALPINE_VERSION} \
             .

#             --output=${OUT_DIR} --target=binaries .

docker push ${DOCKER_REG}:${DOCKER_TAG}

