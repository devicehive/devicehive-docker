#!/bin/bash -e

set -x

echo "Starting DeviceHive"
java -server -Xmx512m -XX:MaxRAMFraction=1 -XX:+UseConcMarkSweepGC -XX:+CMSParallelRemarkEnabled -XX:+UseCMSInitiatingOccupancyOnly -XX:CMSInitiatingOccupancyFraction=70 -XX:+ScavengeBeforeFullGC -XX:+CMSScavengeBeforeRemark -jar \
-Dspring.datasource.url=jdbc:postgresql://${DH_POSTGRES_ADDRESS}:${DH_POSTGRES_PORT}/${DH_POSTGRES_DB} \
-Dspring.datasource.username="${DH_POSTGRES_USERNAME}" \
-Dspring.datasource.password="${DH_POSTGRES_PASSWORD}" \
-Dbootstrap.servers=${DH_KAFKA_ADDRESS}:${DH_KAFKA_PORT} \
-Dzookeeper.connect=${DH_ZK_ADDRESS}:${DH_ZK_PORT} \
-Dthreads.count=${DH_KAFKA_THREADS_COUNT:-3} \
-Dhazelcast.port=${DH_HAZELCAST_PORT:-5701} \
-Dserver.context-path=/api \
-Dserver.port=8080 \
./devicehive-services-${DH_VERSION}-boot.jar

set +x
