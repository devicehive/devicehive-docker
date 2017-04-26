FROM basho/riak-ts:1.4.0
MAINTAINER devicehive

RUN apt-get update \
    && apt-get -y install subversion \
    && svn export https://github.com/devicehive/devicehive-java-server.git/branches/master/devicehive-riak-dao/src/main/resources/map-reduce /etc/riak/dh-mr/src/ \
    && mkdir /etc/riak/dh-mr/ebin/ \
    && /usr/lib/riak/$(ls /usr/lib/riak/ | grep erts)/bin/erlc -o /etc/riak/dh-mr/ebin /etc/riak/dh-mr/src/*.erl \
    && echo '[{riak_kv, [{add_paths, ["/etc/riak/dh-mr/ebin"]}]}].' > /etc/riak/advanced.config \
    && apt-get -y remove --purge subversion
