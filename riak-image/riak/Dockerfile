FROM basho/riak-ts:1.4.0
MAINTAINER devicehive

RUN apt-get -y install git --fix-missing
RUN git clone -b development https://github.com/devicehive/devicehive-java-server.git /etc/devicehive-java-server/
RUN mkdir /etc/riak/dh-mr/ /etc/riak/dh-mr/ebin/
RUN /usr/lib/riak/$(ls /usr/lib/riak/ | grep erts)/bin/erlc -o /etc/riak/dh-mr/ebin /etc/devicehive-java-server/devicehive-riak-dao/src/main/resources/map-reduce/*.erl
RUN echo '[{riak_kv, [{add_paths, ["/etc/riak/dh-mr/ebin"]}]}].' > /etc/riak/advanced.config
