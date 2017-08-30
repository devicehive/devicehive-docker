# DeviceHive installation with Docker-compose
[DeviceHive](https://github.com/devicehive/devicehive-java-server) Docker containers accept many environment variables which configure persistent storage in PostgreSQL, message bus support through Apache Kafka and scalable storage of device messages using Apache Cassandra.

Docker Compose puts all containers together and provides a way to tweak configuration for your environment.

## Configuration
DeviceHive service stack will start without any configuration. All containers are configured via environment variables and Docker Compose can pass variables from its environment to containers and read them from [.env](https://docs.docker.com/compose/compose-file/#env_file) file. To make persistent configuration changes we will add parameters in the `.env` file in current directory.

### PostgreSQL
These variables are used by Frontend, Backend and PostgreSQL containers.
* `DH_POSTGRES_ADDRESS` - Address of PostgreSQL server instance. Defaults to `postgres`, which is address of internal PostgreSQL container.
* `DH_POSTGRES_PORT` - Port of PostgreSQL server instance, defaults to `5432` if undefined.
* `DH_POSTGRES_DB` - PostgreSQL database name for DeviceHive metadata. It is assumed that database already exists and either blank or has been initialized by DeviceHive. Defaults to `postgres`.
* `DH_POSTGRES_USERNAME` and `DH_POSTGRES_PASSWORD` - login/password for DeviceHive user in PostgreSQL that have full access to `DH_POSTGRES_DB`. Defaults are `postgres` and `mysecretpassword`.

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

## HTTPS configuration
DeviceHive Frontend service doesn't provides connection encryption and relies on external service for that.

For Docker Compose installation we will use Compose feature to read configuration from [multiple Compose files](https://docs.docker.com/compose/extends/#multiple-compose-files). Second Compose file will start nginx reverse proxy with HTTPS support.

To configure secured HTTPS access to DeviceHive follow these steps.
1. Generate key and certificate signing request for your domain, sign CSR with Certificate Authority. Resulting certificate and key files must be in the PEM format.
2. Create `ssl` directory inside this directory and copy certificate and key files in it.
3. Generate dhparam file for nginx:
```
openssl dhparam -out ssl/dhparam.pem 2048
```

4. Create nginx config file named `nginx-ssl-proxy.conf`. You can use provided example and edit certificate and key filenames:
```
cp nginx-ssl-proxy.conf.example nginx-ssl-proxy.conf
vi nginx-ssl-proxy.conf
```
Note that ./ssl directory is mounted to /etc/ssl in container. So you need to edit only last part of path in `ssl_certificate` and `ssl_certificate_key` parameters.

5. Run DeviceHive with the following command:
```
sudo docker-compose -f docker-compose.yml -f nginx-ssl-proxy.yml up -d
```

Or add line `COMPOSE_FILE=docker-compose.yml:nginx-ssl-proxy.yml` in `.env` file.

You can now access your DeviceHive API at https://devicehive-host-url/api and Admin Console at https://devicehive-host-url/admin.

## Monitoring
### Kafka metrics
You can start Kafka service with additional Prometheus metrics exporter. Necessary parameters for Kafka container are already configured in `devicehive-metrics.yml` file. It will launch JMX exporter on tcp port 7071.

Run DeviceHive with the following command:

```
sudo docker-compose -f docker-compose.yml -f devicehive-metrics.yml
```

Or add line `COMPOSE_FILE=docker-compose.yml:devicehive-metrics.yml` in `.env` file.

Related Prometheus config for this exporter and link to Grafana Dashboard is in the [Monitoring Kafka with Prometheus](https://www.robustperception.io/monitoring-kafka-with-prometheus/) blog post by Prometheus developer.

## Logging
By default DeviceHive writes minimum logs for better performance. You can see default [logback.xml](https://github.com/devicehive/devicehive-java-server/blob/development/src/main/resources/logback.xml).
It is possible to override logging without rebuilding jar file or docker file. Given you have log config `config.xml` in the current folder as include parameters as follows:
```
docker run -p 80:80 -v ./config.xml:/opt/devicehive/config.xml -e _JAVA_OPTIONS="-Dlogging.config=file:/opt/devicehive/config.xml" devicehive/devicehive
```

## Debugging
DeviceHive Frontend and Backend services can be run with remote JMX connection enabled. TCP ports 9999-10002 must be open on a firewall.

1. Create `jmxremote.password` and `jmxremote.access` file in the current directory. `jmxremote.password` must be readable by owner only. For example, if you want to grant JMX access for user 'developer' with password 'devpass', create these files like that:
```
echo "developer devpass" > jmxremote.password
echo "developer readwrite" > jmxremote.access

chmod 0400 jmxremote.password
```

2. Open `jmx-remote.yml` file and replace `<external hostname>` in _JAVA_OPTIONS env vars with actual hostname of DeviceHive server.
3. Run DeviceHive with the following command:
```
sudo docker-compose -f docker-compose.yml -f jmx-remote.yml
```

Or add line `COMPOSE_FILE=docker-compose.yml:jmx-remote.yml` in `.env` file.

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
