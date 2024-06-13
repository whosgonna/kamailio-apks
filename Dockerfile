ARG ALPINE_VERSION=${ALPINE_VERSION:-latest}

FROM whosgonna/kamailio-apk-base-builder:alpine_${ALPINE_VERSION}

RUN    gem update --system \
    && gem install package_cloud




