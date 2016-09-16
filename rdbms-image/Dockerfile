FROM frolvlad/alpine-oraclejdk8

MAINTAINER devicehive

ENV DH_VERSION="2.1.0-SNAPSHOT"
ENV MAVEN_VERSION="3.3.3"

RUN apk update && apk upgrade && \
    apk add --no-cache bash git openssh curl

RUN mkdir -p /opt/devicehive

RUN cd /usr/share \
 && wget http://archive.apache.org/dist/maven/maven-3/$MAVEN_VERSION/binaries/apache-maven-$MAVEN_VERSION-bin.tar.gz -O - | tar xzf - \
 && mv /usr/share/apache-maven-$MAVEN_VERSION /usr/share/maven \
 && ln -s /usr/share/maven/bin/mvn /usr/bin/mvn

ENV MAVEN_HOME /usr/share/maven

# download devicehive and build .jar
RUN git clone -b development https://github.com/devicehive/devicehive-java-server.git /opt/devicehive && \
    cd /opt/devicehive && \
    mvn clean package -Pbooted-rdbms,undertow,!booted-riak -DskipTests && \
    mv /opt/devicehive/devicehive-services/target/devicehive-services-${DH_VERSION}-boot.jar /opt/devicehive/

#start script
ADD devicehive-start.sh /opt/devicehive/

VOLUME ["/var/log/devicehive"]

WORKDIR /opt/devicehive/

ENTRYPOINT ["/bin/sh"]

CMD ["./devicehive-start.sh"]

EXPOSE 8080
