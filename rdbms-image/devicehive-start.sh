#!/bin/bash -e

set -x

# If a ZooKeeper container is linked with the alias `zookeeper`, use it.
# You MUST set DH_ZK_ADDRESS and DH_ZK_PORT in env otherwise.
[ -n "$ZOOKEEPER_PORT_2181_TCP_ADDR" ] && DH_ZK_ADDRESS=$ZOOKEEPER_PORT_2181_TCP_ADDR
[ -n "$ZOOKEEPER_PORT_2181_TCP_PORT" ] && DH_ZK_PORT=$ZOOKEEPER_PORT_2181_TCP_PORT

# If a Kafka container is linked with the alias `kafka`, use it.
# You MUST set DH_KAFKA_ADDRESS and DH_KAFKA_PORT in env otherwise.
[ -n "$KAFKA_PORT_9092_TCP_ADDR" ] && DH_KAFKA_ADDRESS=$KAFKA_PORT_9092_TCP_ADDR
[ -n "$KAFKA_PORT_9092_TCP_PORT" ] && DH_KAFKA_PORT=$KAFKA_PORT_9092_TCP_PORT

# If a Postgres container is linked with the alias `postgres`, use it.
# You MUST set DH_POSTGRES_ADDRESS and DH_POSTGRES_PORT in env otherwise.
[ -n "$POSTGRES_PORT_5432_TCP_ADDR" ] && DH_POSTGRES_ADDRESS=$POSTGRES_PORT_5432_TCP_ADDR
[ -n "$POSTGRES_PORT_5432_TCP_PORT" ] && DH_POSTGRES_PORT=$POSTGRES_PORT_5432_TCP_PORT

[ -n "$POSTGRES_ENV_POSTGRES_DB" ] && DH_POSTGRES_DB=$POSTGRES_ENV_POSTGRES_DB
[ -n "$POSTGRES_ENV_POSTGRES_USERNAME" ] && DH_POSTGRES_USERNAME=$POSTGRES_ENV_POSTGRES_USERNAME
[ -n "$POSTGRES_ENV_POSTGRES_PASSWORD" ] && DH_POSTGRES_PASSWORD=$POSTGRES_ENV_POSTGRES_PASSWORD

echo "Starting DeviceHive"
java -server -Xmx512m -XX:MaxRAMFraction=1 -XX:+UseConcMarkSweepGC -XX:+CMSParallelRemarkEnabled -XX:+UseCMSInitiatingOccupancyOnly -XX:CMSInitiatingOccupancyFraction=70 -XX:+ScavengeBeforeFullGC -XX:+CMSScavengeBeforeRemark -jar \
-Dspring.datasource.url=jdbc:postgresql://${DH_POSTGRES_ADDRESS}:${DH_POSTGRES_PORT}/${DH_POSTGRES_DB} \
-Dspring.datasource.username="${DH_POSTGRES_USERNAME}" \
-Dspring.datasource.password="${DH_POSTGRES_PASSWORD}" \
-Dmetadata.broker.list=${DH_KAFKA_ADDRESS}:${DH_KAFKA_PORT} \
-Dzookeeper.connect=${DH_ZK_ADDRESS}:${DH_ZK_PORT} \
-Dthreads.count=${DH_KAFKA_THREADS_COUNT:-3} \
-Dhazelcast.port=${DH_HAZELCAST_PORT:-5701} \
-Dserver.context-path=/api \
-Dserver.port=8080 \
./devicehive-${DH_VERSION}-boot.jar

set +x
