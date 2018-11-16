FROM lsiobase/alpine.python:3.8

# set version label
ARG BUILD_DATE
ARG VERSION
ARG SICKCHILL_RELEASE
LABEL build_version="Linuxserver.io version:- ${VERSION} Build-date:- ${BUILD_DATE}"
LABEL maintainer="homerr"

# set python to use utf-8 rather than ascii
ENV PYTHONIOENCODING="UTF-8"

RUN \
 echo "**** install packages ****" && \
 apk add --no-cache \
	--repository http://nl.alpinelinux.org/alpine/edge/main \
	nodejs && \
echo "**** install app ****" && \
mkdir -p \
	/app/sickchill && \
 if [ -z ${SICKCHILL_RELEASE+x} ]; then \
 	SICKCHILL_RELEASE=$(curl -sX GET "https://api.github.com/repos/SickChill/SickChill/tags" \
    	|  jq -r '.[0] | .name'); \
 fi && \
 curl -o \
 /tmp/sickchill.tar.gz -L \
	"https://api.github.com/repos/SickChill/SickChill/tarball/{$SICKCHILL_RELEASE}" && \
 tar xf \
 /tmp/sickchill.tar.gz -C \
	/app/sickchill --strip-components=1 && \
 echo "**** cleanup ****" && \
 rm -rf \
	/tmp/*

# copy local files
COPY root/ /

# ports and volumes
EXPOSE 8081
VOLUME /config /downloads /tv
