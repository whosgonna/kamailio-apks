# FROM alpine AS prereq
# 
# 
# RUN apk add --no-cache build-base linux-headers bison flex pkgconf abuild wget \
#     alpine-sdk apk-tools doas gawk git
# 
# RUN    adduser --disabled-password builder \
#     && addgroup builder wheel \
#     && addgroup builder abuild \
#     && echo "permit nopass :wheel" > /etc/doas.d/builder > /etc/doas.d/builder.conf
# 
# RUN apk add --no-cache bison db-dev flex freeradius-client-dev expat-dev \
#         lksctp-tools-dev perl-dev postgresql-dev  python3-dev \
#         pcre-dev mariadb-dev libxml2-dev curl-dev unixodbc-dev \
#         confuse-dev ncurses-dev sqlite-dev lua-dev openldap-dev openssl-dev \
#         net-snmp-dev libuuid libev-dev jansson-dev json-c-dev libevent-dev \
#         linux-headers libmemcached-dev rabbitmq-c-dev hiredis-dev \
#         ruby-dev libmaxminddb-dev libunistring-dev mongo-c-driver-dev
# 
# 
# USER builder
# RUN git clone https://github.com/kamailio/kamailio.git ~/kamailio_src
# WORKDIR ~/kamailio_src
# 
# COPY --chown=builder:builder builder/home/builder/.abuild/ /home/builder/.abuild/


FROM whosgonna/kamailio-apk/base:latest 

USER builder


COPY ./APKBUILD /home/builder/APKBUILD

ARG KAM_TARGET_VERSION=master

RUN    cd ~/kamailio_src \
    && git fetch \
    && git checkout ${KAM_TARGET_VERSION} \
    && git pull \
    && cp ~/APKBUILD ~/kamailio_src/pkg/kamailio/alpine/APKBUILD \
    && cd ~/kamailio_src/pkg/kamailio \
    && make cfg \
    && make apk \
    && cd ~/kamailio_src/pkg/kamailio/alpine \
    && abuild -r


