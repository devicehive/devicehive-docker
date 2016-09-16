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

#installing devicehive admin console
RUN mkdir -p /opt/devicehive/admin
ADD https://github.com/devicehive/devicehive-admin-console/archive/2.0.4.tar.gz /tmp
RUN tar -C /tmp -xzf /tmp/2.0.4.tar.gz
RUN cp -r /tmp/devicehive-admin-console-2.0.4/* /opt/devicehive/admin/
RUN sed -i -e 's/restEndpoint.*/restEndpoint: location.origin + \"\/api\/rest\"\,/' /opt/devicehive/admin/scripts/config.js

#nginx
RUN apk update && apk add nginx
RUN mkdir -p /run/nginx
COPY nginx.conf /etc/nginx/nginx.conf
VOLUME ["/tmp/nginx"]

WORKDIR /opt/devicehive/

ENTRYPOINT ["/bin/sh"]

CMD ["./devicehive-start.sh"]

EXPOSE 80
