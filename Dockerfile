FROM lsiobase/alpine:3.11

ARG BUILD_DATE
ARG VERSION
LABEL build_version="Linuxserver.io version:- ${VERSION} Build-date:- ${BUILD_DATE}"
LABEL maintainer=""

ENV VERSION 0.8.46

ENV S6_BEHAVIOUR_IF_STAGE2_FAILS 2

WORKDIR    /opt/cronicle/

RUN \
echo "**** install runtime packages ****" && \
apk add -U --no-cache curl npm tzdata python2 py2-pip && \
echo "**** install pip packages ****" && \
pip install --no-cache-dir -U pip && \
pip install --no-cache-dir -U requests && \
echo "**** install Cronicle ****" && \
LOCATION=$(curl -s https://api.github.com/repos/jhuckaby/Cronicle/releases/latest | grep "tag_name" | awk '{print "https://github.com/jhuckaby/Cronicle/archive/" substr($2, 2, length($2)-3) ".tar.gz"}') && curl -L $LOCATION | tar zxvf - --strip-components 1 && \
npm install && \
node bin/build.js dist && \
echo "**** clean up ****" && \
rm -rf \
    /root/.cache \
    /tmp/*

COPY root/ /

EXPOSE 3012

VOLUME ["/opt/cronicle/data", "/opt/cronicle/logs"]
