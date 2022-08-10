#!/bin/sh
KAM_TARGET_VERSION=${1:-master}
DOCKER_REG=registry.nexvortex-cpe.com/engineering/sandbox/kamailio_builds

docker build -f Dockerfile.build-kamailio-apks \
             -t ${DOCKER_REG}:${KAM_TARGET_VERSION} \
             --build-arg KAM_TARGET_VERSION=${KAM_TARGET_VERSION} .

docker push ${DOCKER_REG}:${KAM_TARGET_VERSION}

