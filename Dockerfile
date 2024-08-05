ARG ALPINE_VERSION=${ALPINE_VERSION:-latest}

FROM whosgonna/kamailio-apk-base-builder:alpine_${ALPINE_VERSION}

USER root

RUN    gem update --system \
    && gem install package_cloud

USER builder

COPY abuild /home/builder/.abuild

#ENTRYPOINT /home/builder/bin/build-apks.sh


