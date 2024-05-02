#!/bin/sh
KAM_TARGET_VERSION=${1}

ALPINE_VERSION=$(cat /etc/os-release | grep VERSION_ID | sed -e 's/VERSION_ID=\(\d*\.\d*\).*/v\1/')

PACKAGECLOUD_USER=${PACKAGECLOUD_USER:-whosgonna}
PACKAGECLOUD_REPO=${PACKAGECLOUD_REPO:-`uname -m`}
PACKAGECLOUD_FULL=${PACKAGECLOUD_USER}/${PACKAGECLOUD_REPO}/alpine/v${KAM_TARGET_VERSION}

cd ~/kamailio_src
git fetch
git checkout -q ${KAM_TARGET_VERSION}
git pull origin ${KAM_TARGET_VERSION}

cp /home/builder/APKBUILDS/APKBUILD.${KAM_TARGET_VERSION} ~/kamailio_src/pkg/kamailio/alpine/APKBUILD

cd ~/kamailio_src/pkg/kamailio
make cfg
make apk
cd ~/kamailio_src/pkg/kamailio/alpine
abuild -r

if [ -z "$DOT_PACKAGECLOUD" ]; then
    echo $DOT_PACKAGECLOUD > ~/.packagecloud
    echo "\n\nPushing to package cloud repo ${PACKAGECLOUD_FULL}"
    package_cloud push ${PACKAGECLOUD_FULL} ~/packages/kamailio/`uname -m`/*.apk
fi



# package_cloud push whosgonna/x86_64/alpine/v3.19 docs/5.8.0/v3.19/kamailio/x86_64/*.apk



DOCKER_REG_USER=whosgonna

if [ -z "${KAM_TARGET_VERSION}" ]
then
    echo "Need a Kamailio version (must be commit tag or id, etc.)";
    exit 1;
fi

DOCKER_BASE_REG=${DOCKER_REG_USER}/kamailio-apk-base-builder
DOCKER_BASE_IMG=${DOCKER_BASE_REG}:alpine${ALPINE_VERSION}


if [ -z "$(docker images -q ${DOCKER_BASE_IMG} 2> /dev/null)" ]; then
    echo "Missing docker base image ${DOCKER_BASE_IMG}. Building now.\n";

    docker pull alpine:${ALPINE_VERSION};

    docker build -t $DOCKER_BASE_IMG \
             --build-arg ALPINE_VERSION=${ALPINE_VERSION} \
             -f base.Dockerfile \
             .

fi

DOCKER_REG=${DOCKER_REG_USER}/kamailio-apks
DOCKER_TAG="alpine-${ALPINE_VERSION}_kamailio-${KAM_TARGET_VERSION}"

OUT_DIR=./pkgs/${KAM_TARGET_VERSION}/v${ALPINE_VERSION}

#cp ./abuild/*.pub ./apk

echo "Setting output directory to ${OUT_DIR}";
if [ ! -d $OUT_DIR ]
then
    mkdir -p $OUT_DIR
fi


cp /APKBUILD ~/kamailio_src/pkg/kamailio/alpine/APKBUILD
cd ~/kamailio_src/pkg/kamailio
make cfg
make apk
cd ~/kamailio_src/pkg/kamailio/alpine
abuild -r


echo "Building ${DOCKER_REG}:${DOCKER_TAG}\n";
docker build -t ${DOCKER_REG}:${DOCKER_TAG} \
             --build-arg KAM_TARGET_VERSION=${KAM_TARGET_VERSION} \
             --build-arg ALPINE_VERSION=${ALPINE_VERSION} \
             --output=${OUT_DIR} --target=binaries \
             .


#docker push ${DOCKER_REG}:${DOCKER_TAG}

