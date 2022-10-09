FROM whosgonna/kamailio-apk-base-builder:latest 

USER builder

COPY ./APKBUILD /APKBUILD

ARG KAM_TARGET_VERSION=master

RUN    cd ~/kamailio_src \
    && git fetch \
    && git checkout ${KAM_TARGET_VERSION} \
    && git pull origin ${KAM_TARGET_VERSION} \
    && cp /APKBUILD ~/kamailio_src/pkg/kamailio/alpine/APKBUILD \
    && cd ~/kamailio_src/pkg/kamailio \
    && make cfg \
    && make apk \
    && cd ~/kamailio_src/pkg/kamailio/alpine \
    && abuild -r


