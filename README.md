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


