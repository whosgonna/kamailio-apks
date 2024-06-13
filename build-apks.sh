#!/bin/sh
KAM_TARGET_VERSION=${1}

ALPINE_VERSION=$(cat /etc/os-release | grep VERSION_ID | sed -e 's/VERSION_ID=\(\d*\.\d*\).*/v\1/')

PACKAGECLOUD_USER=${PACKAGECLOUD_USER:-whosgonna}
PACKAGECLOUD_REPO=${PACKAGECLOUD_REPO:-`uname -m`}
PACKAGECLOUD_FULL=${PACKAGECLOUD_USER}/${PACKAGECLOUD_REPO}/alpine/${ALPINE_VERSION}

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

exit;

if [ ! -z "$DOT_PACKAGECLOUD" ]; then
    echo $DOT_PACKAGECLOUD > ~/.packagecloud
    echo "\n\nPushing to package cloud repo ${PACKAGECLOUD_FULL}"
    # ote that next time you can push directly to alpine/v3.19 by specifying whosgonna/x86_64/alpine/v3.19 on the commandline.
    package_cloud push ${PACKAGECLOUD_FULL} ~/packages/kamailio/`uname -m`/*.apk
fi

exit;

# package_cloud push whosgonna/x86_64/alpine/v3.19 docs/5.8.0/v3.19/kamailio/x86_64/*.apk


