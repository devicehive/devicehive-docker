# Installation
[DeviceHive](https://github.com/devicehive/devicehive-java-server) Docker containers accept the following environment variables which enable persistent storage in PostgreSQL, message bus support through Apache Kafka and scalable storage of device messages using Apache Cassandra.

## Configure 
### PostgreSQL
* `${DH_POSTGRES_ADDRESS}` - Address of PostgreSQL server instance. Required.
* `${DH_POSTGRES_PORT}` - Port of PostgreSQL server instance, defaults to `5432` if undefined.
* `${DH_POSTGRES_DB}` - PostgreSQL database name for DeviceHive meta data. It is assumed that it already exists and either blank or has been initialized by DeviceHive. Required.
* `${DH_POSTGRES_USERNAME}` and `${DH_POSTGRES_PASSWORD}` - login/password for DeviceHive user in PostgreSQL that have full access to `${DH_POSTGRES_DB}`. Required.

### Kafka
To enable DeviceHive to communicate over Apache Kafka message bus to scale out and interoperate with other componets, such us Apache Spark, or to enable support of Apache Cassandra for fast and scalable storage of device messages define the following environment variables:
* `${DH_KAFKA_BOOTSTRAP_SERVERS}` -  Comma separated list of Kafka servers, i.e. `host1:9092,host2:9092,host3:9092`. This parameter or `${DH_KAFKA_ADDRESS}` is required to be set.
* `${DH_KAFKA_ADDRESS}` - Address of Apache Kafka broker node. Mutually exclusive with `${DH_KAFKA_BOOTSTRAP_SERVERS}` parameter.
* `${DH_KAFKA_PORT}` - Port of Apache Kafka broker node, defaults to `9092` if undefined. Ignored if `${DH_KAFKA_ADDRESS}` is undefined.
* `${DK_ZH_ADDRESS}` - Comma-separated list of addressed of ZooKeeper instances. Required.
* `${DK_ZK_PORT}` - Port of ZooKeeper instances, defaults to `2181` if undefined.
* `${DH_RPC_SERVER_REQ_CONS_THREADS}` - Kafka request consumer threads, defaults to `3` if undefined.
* `${DH_RPC_SERVER_WORKER_THREADS}` - Server worker threads, defaults to `3` if undefined.
* `${DH_RPC_CLIENT_RES_CONS_THREADS}` - Kafka response consumer threads, defaults to `3`.

You can find more configurable parameters in [frontend][fe-script-url] and [backend][be-script-url] startup scripts.

[fe-script-url]: https://github.com/devicehive/devicehive-java-server/blob/master/dockerfiles/devicehive-frontend-rdbms/devicehive-start.sh
[be-script-url]: https://github.com/devicehive/devicehive-java-server/blob/master/dockerfiles/devicehive-backend-rdbms/devicehive-start.sh

### DeviceHive image tags
By default docker-compose pulls `latest` images for DeviceHive frontend, backend and admin console.

If you want to use in-development version of DeviceHive, export `DH_TAG=development` and `DH_ADMIN_TAG=development` environment variables. Also you can permanently set them in `.env` file in the same directory with docker-compose.yml. Consult with [env_file](https://docs.docker.com/compose/compose-file/#env_file) and [variable substitution](https://docs.docker.com/compose/compose-file/#variable-substitution) documentation for more details.

### JWT secret
DeviceHive use JWT tokens for authentication of users and devices. Secret value used for signing JWT tokens is generated at first start of DeviceHive and stored in database. You can set it via `JWT_SECRET` environment variable or by adding `JWT_SECRET=<value>` parameter in `.env` file.

## Run
In order to run DeviceHive stack in Docker containers, define environment variables as per your requirements and run:
```
sudo docker-compose up -d
```
You can now access your DeviceHive API at http://devicehive-host-url/api and Admin Console at http://devicehive-host-url/admin.

## Logging
By default DeviceHive writes minimum logs for better performance. You can see default [logback.xml](https://github.com/devicehive/devicehive-java-server/blob/development/src/main/resources/logback.xml).
It is possible to override logging without rebuilding jar file or docker file. Given you have log config `config.xml` in the current folder as include parameters as follows:
```
docker run -p 80:80 -v ./config.xml:/opt/devicehive/config.xml -e _JAVA_OPTIONS="-Dlogging.config=file:/opt/devicehive/config.xml" devicehive/devicehive
```

# Docker Host configuration
Example configuration steps for CentOS 7.3 to became Docker host:

1. Install CentOS 7.3, update it and reboot.
2. Install docker-latest package:
```
sudo yum install -y docker-latest
```
3. Configure Docker to use LVM-direct storage backend. These steps are required for better disk IO performance:

    1. Add new disk with at least 10 GB of disk space. It will be used as physical volume for Docker volume group.
    2. Add following lines to `/etc/sysconfig/docker-latest-storage-setup` files. Change `/dev/xvdb` for you device.
    ```
    VG=docker
    DEVS=/dev/xvdb
    ```
    3. Run storage configuration utility
    ```
    sudo docker-latest-storage-setup
    ```
4. Enable and start Docker service:
```
sudo systemctl enable docker-latest
sudo systemctl start docker-latest
```
5. Install docker-compose:

    1. Install and update python-pip package manager:
    ```
    sudo yum install -y python2-pip
    sudo pip install -U pip
    ```
    2.  Install docker-compose:
    ```
    pip install docker-compose
    ```

Enjoy!
