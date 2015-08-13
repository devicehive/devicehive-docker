# Description
DeviceHive is an Open Source IoT Data Platform which helps to connect devices to the cloud in minutes allowing to stream device data and send commands. DevieHivce is highly extensible through containerization. You can run a standalone container for experimentation, then add persistent relational storage for device and user meta-data using PostgreSQL, then scale up by adding Kafka and ZooKeeper message bus and finally attach Apache Spark analytics to Apache Kafka. 

# Installation
DeviceHive docker container accepts the following environment variables which enable persistent storage in PostgreSQL, message bus support through Apache Kafka and scalable storage of device messages using Apache Cassandra.

## Configure 
### PostgreSQL
* ```${DH_POSTGRES_ADDRESS}``` — Address of PostgreSQL server instance. If no address is defined DeviceHive will run with file-based storage. 
* ```${DH_POSTGRES_PORT}``` — Port of PostgreSQL server instance. Default: 5432. Igonred if ```${DH_POSTGRES_ADDRESS}``` is undefined.
* ```${DH_POSTGRES_DB}``` — PostgreSQL database name for DeviceHive meta data. It is assumed that it already exists and either blank or has been initialized by DeviceHive. Ignored if ```${DH_POSTGRES_ADDRESS}``` is undefined.
* ```${DH_POSTGRES_USERNAME}``` and ```${DH_POSTGRES_PASSWORD}``` — login/password for DeviceHive user in PostgreSQL that have full access to ```${DH_POSTGRES_DB}```. Igonred if  ```${DH_POSTGRES_ADDRESS}``` is undefined.

### Kafka
To enable DeviceHive to communicate over Apache Kafka message bus to scale out and interoperate with other componets, such us Apache Spark, or to enable support of Apache Cassandra for fast and scalable storage of device messages define the following environment variables:
* ```${DH_KAFKA_ADDRESS}``` — Address of Apache Kafka broker node. If no address is defined DeviceHive will run in standalone mode.
* ```${DH_KAFKA_PORT}``` — Port of Apache Kafka broker node. Igonred if ```${DH_KAFKA_ADDRESS}``` is undefined.
```${DK_ZK_ADDRESS}``` — Comma-separated list of addressed of ZooKeeper instances. Igonred if ```${DH_KAFKA_ADDRESS}``` is undefined.
* ```${DK_ZK_PORT}``` — Port of ZooKeeper instances. Igonred if ```${DH_KAFKA_ADDRESS}``` is undefined.
* ```${DH_KAFKA_THREADS_COUNT}``` — Number of Kafka threads, defaults to ```3```. 

## Run
In order to run DeviceHive from docker container, define environment variables as per your requirements and run:
```
docker run --name my-devicehive -p 80:80 astaff/devicehive
```
you can access your DeviceHive API http://devicehive-host-url/api. Additionally you can install DeviceHive admin console and supply DeviceHive API URL in ```$DH_API_URL```:
```
docker run --name my-devicehive-admin -p 80:8080 astaff/devicehive-admin
```
this will open DeviceHive admin console and make it accessible at http://device_hive_host_url:8080/admin

## Mesos
DeviceHive can also be started in Mesos using Marathin. In order to do this DeviceHive docker container provides devicehive-start-marathon.sh script which uses Mesos Marathon to discover connection parameters for ZK, Kafka and Postgres. In order to run this script you should run docker as follows:
```
docker -e "MARATHON_MASTER_ADDRESS=<address>" -e "MARATHON_MASTER_PORT=<port>" -e "ZK_ADDRESS=address" -e "ZK_PORT=port" --name my-devicehive -p 80:80 astaff/devicehive ./devicehive-start-marathon.sh
```
You can also use upper case -P instead of -p to auto-generate ports for DeviceHive API and optional Admin Console.

Enjoy!




