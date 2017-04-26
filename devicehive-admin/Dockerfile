FROM nginx:alpine

MAINTAINER devicehive

RUN mkdir -p /opt/devicehive/admin

#add start script
ADD admin-start.sh /opt/devicehive/

#installing devicehive admin console
ADD https://github.com/devicehive/devicehive-admin-console/archive/stable.tar.gz /tmp
RUN tar -C /tmp -xzf /tmp/stable.tar.gz \
    && mv -v /tmp/devicehive-admin-console-stable/* /opt/devicehive/admin/ \
    && sed -i -e 's/restEndpoint.*/restEndpoint: location.origin +  \"\/api\/rest\"\,/' /opt/devicehive/admin/scripts/config.js \
    && rm -f /tmp/stable.tar.gz

COPY nginx.conf /etc/nginx/nginx.conf

WORKDIR /opt/devicehive/

ENTRYPOINT ["/bin/sh"]

CMD ["./admin-start.sh"]
