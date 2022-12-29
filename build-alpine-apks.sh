#!/bin/sh
KAM_TARGET_VERSION=${1}

if [ -z "${KAM_TARGET_VERSION}" ] 
then
    echo "Need a Kamailio version (must be commit tag or id, etc.)";
    exit 1;
fi


DOCKER_REG=whosgonna/kamailio-apks

docker build -t ${DOCKER_REG}:${KAM_TARGET_VERSION} \
             --build-arg KAM_TARGET_VERSION=${KAM_TARGET_VERSION} .

docker push ${DOCKER_REG}:${KAM_TARGET_VERSION}

