FROM frolvlad/alpine-oraclejdk8

MAINTAINER devicehive

ENV DH_VERSION="3.0.0-SNAPSHOT"
ENV MAVEN_VERSION="3.3.3"
ENV MAVEN_HOME /usr/share/maven/

# Builds .jar from source code and removes unnecessary dependencies.
RUN apk update \
    && apk upgrade \
    && apk add --no-cache bash netcat-openbsd \
    && apk add --virtual .build-dependencies ca-certificates curl git openssh openssl make \
    && mkdir /usr/share/maven \
    && cd /usr/share/maven \
    && curl -O http://archive.apache.org/dist/maven/maven-3/$MAVEN_VERSION/binaries/apache-maven-$MAVEN_VERSION-bin.tar.gz \
    && tar -xf apache-maven-$MAVEN_VERSION-bin.tar.gz \
    && mv apache-maven-$MAVEN_VERSION/* /usr/share/maven \
    && ln -s /usr/share/maven/bin/mvn /usr/bin/mvn \
    && mkdir -p /opt/devicehive \
    && git clone -b master https://github.com/devicehive/devicehive-java-server.git /opt/devicehive/source \
    && cd /opt/devicehive/source \
    && mvn clean package -Pbooted-riak,shim-kafka,!booted-rdbms -DskipTests \
    && mv /opt/devicehive/source/devicehive-frontend/target/devicehive-frontend-${DH_VERSION}-boot.jar /opt/devicehive/ \
    && rm -rf /opt/devicehive/source \
    && rm -rf /usr/share/maven/ \
    && apk del .build-dependencies

#start script
ADD devicehive-start.sh /opt/devicehive/

VOLUME ["/var/log/devicehive"]

WORKDIR /opt/devicehive/

ENTRYPOINT ["/bin/sh"]

CMD ["./devicehive-start.sh"]

EXPOSE 8080
