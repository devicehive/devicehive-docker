# Installation
[DeviceHive](https://github.com/devicehive/devicehive-java-server) Docker containers accept the following environment variables which enable persistent storage in Riak TS, message bus support through Apache Kafka and scalable storage of device messages using Apache Cassandra.

## Configure 
### Riak TS
* ```${DH_RIAK_HOST}``` — Address of Riak TS server instance. 
* ```${DH_RIAK_PORT}``` — Port of Riak TS server instance.

### Kafka
To enable DeviceHive to communicate over Apache Kafka message bus to scale out and interoperate with other componets, such us Apache Spark, or to enable support of Apache Cassandra for fast and scalable storage of device messages define the following environment variables:
* ```${DH_KAFKA_ADDRESS}``` — Address of Apache Kafka broker node. If no address is defined DeviceHive will run in standalone mode.
* ```${DH_KAFKA_PORT}``` — Port of Apache Kafka broker node. Igonred if ```${DH_KAFKA_ADDRESS}``` is undefined.
* ```${DK_ZH_ADDRESS}``` — Comma-separated list of addressed of ZooKeeper instances. Igonred if ```${DH_KAFKA_ADDRESS}``` is undefined.
* ```${DK_ZK_PORT}``` — Port of ZooKeeper instances. Igonred if ```${DH_KAFKA_ADDRESS}``` is undefined.
* ```${DH_RPC_SERVER_REQ_CONS_THREADS}``` — Kafka request consumer threads, defaults to ```1```.
* ```${DH_RPC_SERVER_WORKER_THREADS}``` — Server worker threads, defaults to ```1```.
* ```${DH_RPC_SERVER_DISR_WAIT_STRATEGY}``` — Disruptor wait strategy, defaults to ```blocking```. Available options are: ```sleeping```, ```yielding```, ```busy-spin```.
* ```${DH_RPC_CLIENT_RES_CONS_THREADS}``` — Kafka response consumer threads, defaults to ```1```.

More configurable parameters at [devicehive-start.sh](devicehive-frontend/devicehive-start.sh) and [devicehive-start.sh](devicehive-backend/devicehive-start.sh).

## Run
In order to run DeviceHive stack in Docker containers, define environment variables as per your requirements and run:
```
docker-compose up
```
you can access your DeviceHive API http://devicehive-host-url/api. 


## Logging
By default DeviceHive writes minimum logs for better performance. You can see default [logback.xml](https://github.com/devicehive/devicehive-java-server/blob/development/src/main/resources/logback.xml).
It is possible to override logging without rebuilding jar file or docker file. Given you have log config `config.xml` in the current folder as include parameters as follows:
```
docker run -p 80:80 -v ./config.xml:/opt/devicehive/config.xml -e _JAVA_OPTIONS="-Dlogging.config=file:/opt/devicehive/config.xml" devicehive/devicehive
```

## Docker-Compose

Below is an example of linking containers with services using [docker-compose](https://docs.docker.com/compose/compose-file/#version-3).
```
version: "3"
services:
  zookeeper:
    image: wurstmeister/zookeeper
    ports:
      - "2181:2181"
  kafka:
    image: devicehive/devicehive-kafka
    ports:
      - "9092:9092"
    links:
      - "zookeeper"
    environment:
      KAFKA_ZOOKEEPER_CONNECT: zookeeper:2181
      DH_ZK_ADDRESS: zookeeper
      DH_ZK_PORT: 2181
    volumes:
      - /var/run/docker.sock:/var/run/docker.sock
 
  coordinator:
    image: devicehive/devicehive-riakts
    ports:
      - "8087:8087"
      - "8098:8098"
    environment:
      - CLUSTER_NAME=riakts
    labels:
      - "com.basho.riak.cluster.name=riakts"
  member:
    image: devicehive/devicehive-riakts
    ports:
      - "8087"
      - "8098"
    command: bash -c "sleep 30; /usr/lib/riak/riak-cluster.sh" # wait until coordinator starts and activates datatype
    labels:  
      - "com.basho.riak.cluster.name=riakts"
    links:
      - "coordinator"
    depends_on:
      - "coordinator"
    environment:
      - CLUSTER_NAME=riakts
      - COORDINATOR_NODE=coordinator
  
  dh_admin:
    image: devicehive/admin-console
    ports:
      - "80:8080"
    depends_on:
      - "dh_frontend"
    environment:
      DH_HOST: dh_frontend
      DH_PORT: 8080

  dh_frontend:
    image: devicehive/devicehive-frontend-riak
    ports:
      - "8080:8080"
    depends_on:
      - "zookeeper"
      - "kafka"
      - "coordinator"
      - "member"
    environment:
      DH_ZK_ADDRESS: zookeeper
      DH_ZK_PORT: 2181
      DH_KAFKA_ADDRESS: kafka
      DH_KAFKA_PORT: 9092
      DH_RIAK_HOST: coordinator
      DH_RIAK_PORT: 8087
      DH_RIAK_HTTP_PORT: 8098
      DH_BACKEND_ADDRESS: dh_backend
      DH_BACKEND_HAZELCAST_PORT: 5701

  dh_backend:
    image: devicehive/devicehive-backend-riak
    depends_on:
      - "zookeeper"
      - "kafka"
      - "coordinator"
      - "member"
    environment:
      DH_ZK_ADDRESS: zookeeper
      DH_ZK_PORT: 2181
      DH_KAFKA_ADDRESS: kafka
      DH_KAFKA_PORT: 9092
      DH_RIAK_HOST: coordinator
      DH_RIAK_PORT: 8087
      DH_RIAK_HTTP_PORT: 8098
      DH_RIAK_HOST_MEMBER: member

volumes:
  schemas:
    external: false
```

Enjoy!

