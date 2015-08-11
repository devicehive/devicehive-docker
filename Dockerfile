FROM ubuntu:14.04
ENV DEBIAN_FRONTEND noninteractive

MAINTAINER astaff 

ENV DH_VERSION="2.0.3"

# install java8 & postgres
RUN apt-get update && \ 
    apt-get install -y unzip curl software-properties-common jq && \
    /bin/echo debconf shared/accepted-oracle-license-v1-1 select true | /usr/bin/debconf-set-selections && \
    /bin/echo debconf shared/accepted-oracle-license-v1-1 seen true | /usr/bin/debconf-set-selections && \
    add-apt-repository ppa:webupd8team/java  && \
    apt-get update  && \
    apt-get install -y oracle-java8-installer && \
    apt-get clean autoclean && \
    apt-get autoremove -y && \
    rm -rf /var/lib/{apt,dpkg,cache,log}/

RUN rm -rf /opt/devicehive*
RUN mkdir /opt/devicehive-${DH_VERSION}

ADD https://github.com/devicehive/devicehive-java-server/releases/download/${DH_VERSION}/devicehive-${DH_VERSION}-boot.jar /opt/devicehive-${DH_VERSION}/

#start script
ADD devicehive-start.sh /opt/devicehive-${DH_VERSION}/

#start script for Mesos
ADD devicehive-start-marathon.sh /opt/devicehive-${DH_VERSION}/

#installing devicehive server
ADD devicehive-server.properties /opt/devicehive-${DH_VERSION}/

VOLUME ["/var/log/devicehive"]

WORKDIR /opt/devicehive-${DH_VERSION}/

CMD ["./devicehive-start.sh"]

EXPOSE 80