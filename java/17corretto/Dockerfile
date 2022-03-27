FROM        --platform=$TARGETOS/$TARGETARCH amazoncorretto:17

LABEL       author="Luis Vera" maintainer="lvera@tecstim.com"

LABEL       org.opencontainers.image.source="https://github.com/arima0k/yolks"
LABEL       org.opencontainers.image.licenses=MIT

RUN apt-get update -y \
&& apt-get install -y curl ca-certificates openssl git tar sqlite3 fontconfig libfreetype6 tzdata iproute2 libstdc++6 \
&& useradd -d /home/container -m container

USER        container
ENV         USER=container HOME=/home/container
WORKDIR     /home/container

COPY        ./../entrypoint.sh /entrypoint.sh
CMD         [ "/bin/bash", "/entrypoint.sh" ]
