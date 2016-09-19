FROM nginx:alpine

MAINTAINER devicehive

RUN mkdir -p /opt/devicehive/admin

#add start script
ADD admin-start.sh /opt/devicehive/

#installing devicehive admin console
ADD https://github.com/devicehive/devicehive-admin-console/archive/2.0.4.tar.gz /tmp
RUN tar -C /tmp -xzf /tmp/2.0.4.tar.gz
RUN cp -r /tmp/devicehive-admin-console-2.0.4/* /opt/devicehive/admin/
RUN sed -i -e 's/restEndpoint.*/restEndpoint: location.origin +  \"\/api\/rest\"\,/' /opt/devicehive/admin/scripts/config.js

COPY nginx.conf /etc/nginx/nginx.conf

WORKDIR /opt/devicehive/

ENTRYPOINT ["/bin/sh"]

CMD ["./admin-start.sh"]
