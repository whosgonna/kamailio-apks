ARG ALPINE_VERSION=latest

FROM alpine:${ALPINE_VERSION}

RUN apk add --no-cache build-base linux-headers bison flex pkgconf abuild wget \
    alpine-sdk apk-tools doas gawk git musl-dev gpg

RUN    adduser --disabled-password builder \
    && addgroup builder wheel \
    && addgroup builder abuild \
    && echo "permit nopass :wheel" > /etc/doas.d/builder > /etc/doas.d/builder.conf

RUN apk add --no-cache bison db-dev flex freeradius-client-dev expat-dev \
        lksctp-tools-dev perl-dev postgresql-dev  python3-dev \
        pcre-dev pcre2-dev mariadb-dev libxml2-dev curl-dev unixodbc-dev \
        confuse-dev ncurses-dev sqlite-dev lua-dev openldap-dev openssl-dev \
        net-snmp-dev libuuid libev-dev jansson-dev json-c-dev libevent-dev \
        linux-headers libmemcached-dev rabbitmq-c-dev hiredis-dev \
        ruby-dev libmaxminddb-dev libunistring-dev mongo-c-driver-dev \
        libwebsockets-dev mosquitto-dev librdkafka-dev wolfssl-dev libjwt-dev

#RUN <<INSTALL_SECSIPIDX
#    ## Add my packgecloud directory so that we can use secsipidx
#    wget -O /etc/apk/keys/whosgonna_`uname -m`.rsa.pub https://packagecloud.io/whosgonna/`uname -m`/rsakey
#    ALPINE_MAJMIN=$(cat /etc/os-release | grep VERSION_ID | sed -e 's/VERSION_ID=\(\d*\.\d*\).*/v\1/')
#    echo "https://packagecloud.io/whosgonna/`uname -m`/alpine/${ALPINE_MAJMIN}/main" >> /etc/apk/repositories
#
#    apk add --no-cache secsipidx
#INSTALL_SECSIPIDX


USER builder
RUN git clone https://github.com/kamailio/kamailio.git /home/builder/kamailio_src
WORKDIR /home/builder/kamailio_src

ENV PATH="$PATH:/home/builder/bin"

COPY --chown=builder:builder scripts/build-apks.sh /home/builder/bin/build-apks.sh
COPY --chown=builder:builder APKBUILDS /home/builder/APKBUILDS

