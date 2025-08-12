ARG ALPINE_VERSION=${ALPINE_VERSION:-latest}

FROM whosgonna/kamailio-apk-base-builder:alpine_${ALPINE_VERSION}

USER root

RUN <<HEREDOC
    gem update --system
    gem install package_cloud abbrev

HEREDOC

USER builder

COPY abuild /home/builder/.abuild
COPY APKBUILDS /home/builder/APKBUILDS

#ENTRYPOINT /home/builder/bin/build-apks.sh


