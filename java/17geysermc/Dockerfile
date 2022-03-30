FROM amazoncorretto:17-alpine-jdk

ARG version=17.0.2.8-1
LABEL       author="Luis Vera" maintainer="lvera@tecstim.com"

LABEL       org.opencontainers.image.source="https://github.com/arima0k/yolks"
LABEL       org.opencontainers.image.licenses=MIT

RUN apk update \
    && apk add curl ca-certificates openssl git tar sqlite fontconfig freetype tzdata iproute2 libstdc++6 jq \
    && apk cache clean \
    && adduser -h /home/container -D container

USER        container
ENV         USER=container HOME=/home/container
WORKDIR     /home/container

COPY        ./entrypoint.sh /entrypoint.sh
CMD         [ "/bin/bash", "/entrypoint.sh" ]
