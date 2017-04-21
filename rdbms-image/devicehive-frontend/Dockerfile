FROM picoded/ubuntu-openjdk-8-jdk

MAINTAINER devicehive

ENV DH_VERSION="3.0.0-SNAPSHOT"
ENV MAVEN_VERSION="3.3.3"

RUN apt-get update -y \
    && apt-get install -y \
        netcat \
        wget \
        git \
    && apt-get autoremove -y \
    && apt-get clean

RUN mkdir -p /opt/devicehive

RUN cd /usr/share \
 && wget http://archive.apache.org/dist/maven/maven-3/$MAVEN_VERSION/binaries/apache-maven-$MAVEN_VERSION-bin.tar.gz -O - | tar xzf - \
 && mv /usr/share/apache-maven-$MAVEN_VERSION /usr/share/maven \
 && ln -s /usr/share/maven/bin/mvn /usr/bin/mvn

ENV MAVEN_HOME /usr/share/maven

# download devicehive and build .jar
RUN git clone -b master https://github.com/devicehive/devicehive-java-server.git /opt/devicehive && \
    cd /opt/devicehive && \
    mvn clean package -Pbooted-rdbms,shim-kafka,!booted-riak -DskipTests && \
    mv /opt/devicehive/devicehive-frontend/target/devicehive-frontend-${DH_VERSION}-boot.jar /opt/devicehive/

#start script
ADD devicehive-start.sh /opt/devicehive/

VOLUME ["/var/log/devicehive"]

WORKDIR /opt/devicehive/

ENTRYPOINT ["/bin/sh"]

CMD ["./devicehive-start.sh"]

EXPOSE 80
