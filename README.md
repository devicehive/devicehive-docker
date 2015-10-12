# Description
DeviceHive is an Open Source IoT Data Platform which helps to connect devices to the cloud in minutes allowing to stream device data and send commands. DevieHivce is highly extensible through containerization. You can run a standalone container for experimentation, then add persistent relational storage for device and user meta-data using PostgreSQL, then scale up by adding Kafka and ZooKeeper message bus and finally attach Apache Spark analytics to Apache Kafka. 

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
```${DK_ZH_ADDRESS}``` — Comma-separated list of addressed of ZooKeeper instances. Igonred if ```${DH_KAFKA_ADDRESS}``` is undefined.
* ```${DK_ZK_PORT}``` — Port of ZooKeeper instances. Igonred if ```${DH_KAFKA_ADDRESS}``` is undefined.
* ```${DH_KAFKA_THREADS_COUNT}``` — Number of Kafka threads, defaults to ```3```. 

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

## Linking

[postgres]: https://hub.docker.com/_/postgres/ "postgres"
[ches/kafka]: https://hub.docker.com/r/ches/kafka/ "ches/kafka"
[jplock/zookeeper]: https://hub.docker.com/r/jplock/zookeeper/ "jplock/zookeeper"

This image can be linked with other containers like [postgres], [ches/kafka], [jplock/zookeeper] or any other as soon as the following environment variables are exposed via links:
```
ZOOKEEPER_PORT_2181_TCP_ADDR, ZOOKEEPER_PORT_2181_TCP_PORT
KAFKA_PORT_9092_TCP_ADDR, KAFKA_PORT_9092_TCP_PORT
POSTGRES_PORT_5432_TCP_ADDR, POSTGRES_PORT_5432_TCP_PORT
```

## Docker-Compose

Below is an example of linking using docker-compose.
```
dh: 
  image: devicehive/devicehive
  links:
    - "postgres"
    - "kafka"
    - "zookeeper"
  ports:
    - "80:80"
  environment:
    DH_POSTGRES_USERNAME: "postgres"
    DH_POSTGRES_PASSWORD: "mysecretpassword"
    DH_POSTGRES_DB: "postgres"

zookeeper:
  image: jplock/zookeeper:3.4.6
  expose:
    - "2181"

kafka:
  image: ches/kafka:0.8.2.1
  links:
    - "zookeeper"
  expose:
    - "9092"

postgres: 
  image: postgres:9.4.4
  expose:
    - "5432"
```

Enjoy!




