FROM frolvlad/alpine-oraclejdk8

MAINTAINER devicehive

ENV DH_VERSION="3.0.0-SNAPSHOT"
ENV MAVEN_VERSION="3.3.3"

RUN apk update \
    && apk upgrade \
    && apk add ca-certificates wget \
    && update-ca-certificates \
    && apk add --no-cache bash git openssh netcat-openbsd openssl

RUN cd /usr/share \
    && wget http://archive.apache.org/dist/maven/maven-3/$MAVEN_VERSION/binaries/apache-maven-$MAVEN_VERSION-bin.tar.gz -O - | tar xzf - \
    && mv /usr/share/apache-maven-$MAVEN_VERSION /usr/share/maven \
    && ln -s /usr/share/maven/bin/mvn /usr/bin/mvn

ENV MAVEN_HOME /usr/share/maven

RUN mkdir -p /opt/devicehive

# download devicehive and build .jar
RUN git clone -b master https://github.com/devicehive/devicehive-java-server.git /opt/devicehive \
    && cd /opt/devicehive \
    && mvn clean package -Pbooted-riak,shim-kafka,!booted-rdbms -DskipTests \
    && mv /opt/devicehive/devicehive-frontend/target/devicehive-frontend-${DH_VERSION}-boot.jar /opt/devicehive/

#start script
ADD devicehive-start.sh /opt/devicehive/

VOLUME ["/var/log/devicehive"]

WORKDIR /opt/devicehive/

ENTRYPOINT ["/bin/sh"]

CMD ["./devicehive-start.sh"]

EXPOSE 8080
