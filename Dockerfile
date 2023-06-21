ARG ALPINE_VERSION=latest
FROM whosgonna/kamailio-apk-base-builder:alpine${ALPINE_VERSION} AS builder

USER builder

ARG KAM_TARGET_VERSION=master

COPY ./APKBUILD.${KAM_TARGET_VERSION} /APKBUILD

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


FROM scratch AS binaries

COPY --from=builder /home/builder/packages /
COPY --from=builder /home/builder/.abuild/*.pub /kamailio/x86_64/

FROM scratch

COPY --from=builder /home/builder/packages /home/builder/packages
COPY --from=builder /home/builder/.abuild /home/builder/.abuild

