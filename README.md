## DESCRIPTION

Creating docker images to build an Alpine Linux based images containing 
Kamailio APKs. These images can then be mounted for installing Kamailio
resulting in small container sizes - about 35MB for the basic Kamailio 
image, and less than 40 MB for Kamailio plus DB support.

## Base Image
The base image contains all of the build tools, etc. for compiling Kamailio
and creating the APKs.  These pre-requisites should change very litte between
Kamailio releases, and should only need to be rebuilt periodically for security
fixes, etc.

It's build like this:

```
docker build -f base.Dockerfile -t whosgonna/kamailio-apk-base-builder:latest .
```

## Building Kamailio APKs
This can be done by passing a `--build-arg` of the desired Kamailio branch/tag
for `KAM_TARGET_VERSION` to the build command:

```
docker build -t whosgonna/kamailio-apks:5.5.4 --build-arg KAM_TARGET_VERSION=5.5.4 .
```


## Using the image and the APKs
The APKs are installable against the base `alpine` Linux image with a
Dockerfile like this (uses Docker buildkit):

```
FROM whosgonna/kamailio-apks:5.5.4 AS apks

FROM alpine

RUN --mount=type=bind,from=apks,source=/home/builder,target=/builder \
       cp builder/.abuild/-62633096.rsa.pub /etc/apk/keys/ \
    && echo '/builder/packages/kamailio/' >> /etc/apk/repositories \
    &&  apk add --no-cache kamailio kamailio-tls kamailio-postgres kamailio-redis \
        kamailio-json kamailio-jansson kamailio-extras sngrep
```

Just specify the APKs needed.
