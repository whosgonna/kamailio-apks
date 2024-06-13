ARG ALPINE_VERSION=${ALPINE_VERSION:-latest}

FROM whosgonna/kamailio-apk-base-builder:alpine_${ALPINE_VERSION}

USER root

RUN    gem update --system \
    && gem install package_cloud

USER builder


