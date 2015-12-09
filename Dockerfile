FROM develar/java:8u45

MAINTAINER devicehive

ENV DH_VERSION="2.0.11"

RUN mkdir -p /opt/devicehive

ADD https://github.com/devicehive/devicehive-java-server/releases/download/${DH_VERSION}/devicehive-${DH_VERSION}-boot.jar /opt/devicehive/

#start script
ADD devicehive-start.sh /opt/devicehive/

VOLUME ["/var/log/devicehive"]

WORKDIR /opt/devicehive/

ENTRYPOINT ["/bin/sh"]

CMD ["./devicehive-start.sh"]

EXPOSE 80
