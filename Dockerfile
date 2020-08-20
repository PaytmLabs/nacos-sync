FROM alpine:3.10

RUN apk update \
    && apk add openjdk8-jre wget bash

ENV JAVA_HOME="/usr/lib/jvm/java-1.8-openjdk" \
    NACOS_SYNC_VERSION="0.4.0"

RUN wget https://github.com/nacos-group/nacos-sync/releases/download/${NACOS_SYNC_VERSION}/nacosSync.${NACOS_SYNC_VERSION}.tar.gz -P /home
RUN tar -zxvf /home/nacosSync.${NACOS_SYNC_VERSION}.tar.gz -C /home \
    && rm -rf /home/nacosSync.${NACOS_SYNC_VERSION}.tar.gz /home/nacos/conf/*.properties /home/nacos/bin/nacosSync.sql /home/nacos/bin/startup.sh

WORKDIR /home/nacosSync

RUN touch logs/nacossync_start.out && \
    ln -sf /proc/1/fd/1 logs/nacossync_start.out

ADD nacossync-distribution/bin/startup.sh bin/
ADD nacossync-distribution/conf/application.properties conf/

RUN chmod +x bin/startup.sh

EXPOSE 8080
ENTRYPOINT ["/home/nacosSync/bin/startup.sh"]