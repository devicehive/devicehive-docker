# Installation
[DeviceHive](https://github.com/devicehive/devicehive-java-server) docker container accepts the following environment variables which enable persistent storage in PostgreSQL, message bus support through Apache Kafka and scalable storage of device messages using Apache Cassandra.

## Configure 
### PostgreSQL
* ```${DH_POSTGRES_ADDRESS}``` — Address of PostgreSQL server instance. 
* ```${DH_POSTGRES_PORT}``` — Port of PostgreSQL server instance. Default: 5432. Igonred if ```${DH_POSTGRES_ADDRESS}``` is undefined.
* ```${DH_POSTGRES_DB}``` — PostgreSQL database name for DeviceHive meta data. It is assumed that it already exists and either blank or has been initialized by DeviceHive. Ignored if ```${DH_POSTGRES_ADDRESS}``` is undefined.
* ```${DH_POSTGRES_USERNAME}``` and ```${DH_POSTGRES_PASSWORD}``` — login/password for DeviceHive user in PostgreSQL that have full access to ```${DH_POSTGRES_DB}```. Igonred if  ```${DH_POSTGRES_ADDRESS}``` is undefined.

### Kafka
To enable DeviceHive to communicate over Apache Kafka message bus to scale out and interoperate with other componets, such us Apache Spark, or to enable support of Apache Cassandra for fast and scalable storage of device messages define the following environment variables:
* ```${DH_KAFKA_ADDRESS}``` — Address of Apache Kafka broker node. If no address is defined DeviceHive will run in standalone mode.
* ```${DH_KAFKA_PORT}``` — Port of Apache Kafka broker node. Igonred if ```${DH_KAFKA_ADDRESS}``` is undefined.
* ```${DK_ZH_ADDRESS}``` — Comma-separated list of addressed of ZooKeeper instances. Igonred if ```${DH_KAFKA_ADDRESS}``` is undefined.
* ```${DK_ZK_PORT}``` — Port of ZooKeeper instances. Igonred if ```${DH_KAFKA_ADDRESS}``` is undefined.
* ```${DH_KAFKA_THREADS_COUNT}``` — Number of Kafka threads, defaults to ```3```.
 
More configurable parameters at [devicehive-start.sh](devicehive-start.sh).

## Run
In order to run DeviceHive from docker container, define environment variables as per your requirements and run:
```
docker run --name my-devicehive -p 80:80 devicehive/devicehive
```
you can access your DeviceHive API http://devicehive-host-url/api. 


## Logging
By default DeviceHive writes minimum logs for better performance. You can see default [logback.xml](https://github.com/devicehive/devicehive-java-server/blob/development/src/main/resources/logback.xml).
It is possible to override logging without rebuilding jar file or docker file. Given you have log config `config.xml` in the current folder as include parameters as follows:
```
docker run -p 80:80 -v ./config.xml:/opt/devicehive/config.xml -e _JAVA_OPTIONS="-Dlogging.config=file:/opt/devicehive/config.xml" devicehive/devicehive
```

## Docker-Compose

Below is an example of linking containers with services using [docker-compose](https://docs.docker.com/compose/compose-file/#version-2).
```
version: "2"
services:
  zookeeper:
    image: wurstmeister/zookeeper
    ports:
      - "2181:2181"
  kafka:
    image: wurstmeister/kafka:0.9.0.1
    ports:
      - "9092:9092"
    depends_on:
      - "zookeeper"
    environment:
      KAFKA_ADVERTISED_HOST_NAME: 192.168.99.100
      KAFKA_ZOOKEEPER_CONNECT: zookeeper:2181
    volumes:
      - /var/run/docker.sock:/var/run/docker.sock

  postgres:
    image: postgres:9.4.4
    ports:
      - "5432:5432"
 
  dh_admin:
    build: ../devicehive-admin
    ports: 
      - "80:80"
    depends_on:
      - "dh"
    environment:
      DH_HOST: dh
      DH_PORT: 8080 

  dh:
    build: .
    ports:
      - "8080:8080"
    depends_on:
      - "postgres"
      - "kafka"
      - "zookeeper"
    environment:
      DH_ZK_ADDRESS: zookeeper
      DH_ZK_PORT: 2181
      DH_KAFKA_ADDRESS: kafka
      DH_KAFKA_PORT: 9092
      DH_POSTGRES_ADDRESS: postgres
      DH_POSTGRES_PORT: 5432
      DH_POSTGRES_USERNAME: "postgres"
      DH_POSTGRES_PASSWORD: "mysecretpassword"
```

Enjoy!




