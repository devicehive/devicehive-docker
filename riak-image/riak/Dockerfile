FROM basho/riak-ts:1.4.0
MAINTAINER devicehive

RUN apt-get -y install subversion
RUN svn checkout https://github.com/devicehive/devicehive-java-server.git/branches/redesign/riak-dao/devicehive-riak-dao/src/main/resources/map-reduce /etc/riak/dh-mr/src/
RUN mkdir /etc/riak/dh-mr/ebin/
RUN /usr/lib/riak/$(ls /usr/lib/riak/ | grep erts)/bin/erlc -o /etc/riak/dh-mr/ebin /etc/riak/dh-mr/src/*.erl
RUN echo '[{riak_kv, [{add_paths, ["/etc/riak/dh-mr/ebin"]}]}].' > /etc/riak/advanced.config
