# DeviceHive installation with Docker-compose
[DeviceHive](https://github.com/devicehive/devicehive-java-server) Docker containers accept many environment variables which configure persistent storage in PostgreSQL and message bus support through Apache Kafka.

Docker Compose puts all containers together and provides a way to tweak configuration for your environment.

## Before you start
DeviceHive can be started without any additional configuration, `docker-compose.yml` file contains all neccesary parameters set to safe defaults. Though there is one parameter that could and should be changed due to security reasons - JWT secret.
DeviceHive ecosystem uses JWT tokens for authentication. JWT secret is used for signing JWT tokens and is generated at startup of DeviceHive and stored in the database. You can change it by exporting the JWT_SECRET environment variable or by adding `JWT_SECRET=<your value>` line in the `.env` file inside current directory.

## Run
In order to run DeviceHive stack on top of Docker containers, define environment variables as per your requirements and run:
```
sudo docker-compose up -d
```
You can now access your DeviceHive microservices via endpoints decribed in the next section.

### Security credentials

Default DeviceHive admin user has name `dhadmin` and password `dhadmin_#911`.

### Service endpoints
Table below lists endpoints where you can find various DeviceHive services. Replace *hostname* with actual hostname of the docker daemon and start observing DeviceHive capabilities.

| Service              | URL                               | Notes                        |
|----------------------|-----------------------------------|------------------------------|
| Admin Console        | http://*hostname*/admin          |                              |
| Frontend service API | http://*hostname*/api/rest       |                              |
| Auth service API     | http://*hostname*/auth/rest      |                              |
| Plugin service API   | http://*hostname*/plugin/rest    | If enabled, see [Run with DeviceHive Plugin Service](#run-with-devicehive-plugin-service) section below |
| Frontend Swagger     | http://*hostname*/api/swagger    |                              |
| Auth Swagger         | http://*hostname*/auth/swagger   |                              |
| Plugin Swagger       | http://*hostname*/plugin/swagger | If Plugin service is enabled |
| Grafana              | http://*hostname*/grafana        | If enabled, see [DeviceHive Grafana Datasource](#devicehive-grafana-datasource) section below |
| MQTT brokers         | *hostname*:1883                  | If MQTT brokers are enabled, see [MQTT brokers](#mqtt-brokers) section below |

### Exposed ports
| Port    | Service          | Notes                         |
|    ---: |------------------|-------------------------------|
| 80, 443 | Nginx proxy      | Primary port for all services |
|    1883 | MQTT brokers     | If enabled                    |
|    2181 | Zookeeper        |                               |
|    5432 | PostgreSQL DB    |                               |
|    5701 | Hazelcast        |                               |
|    7071 | Kafka metrics    | If enabled, see [Kafka metrics](#kafka-metrics) section below |
|    8080 | Frontend service |                               |
|    8090 | Auth service     |                               |
|    8110 | Plugin service   | If enabled                    |
|    9092 | Kafka            |                               |
|    9395 | cAdvisor         | If enabled, see [cAdvisor metrics](#cadvisor-metrics) section below |

### Run with DeviceHive Plugin service
To enable optional DeviceHive Plugin service run DeviceHive with the following command:
```
sudo docker-compose -f docker-compose.yml -f dh_plugin.yml up -d
```
Or add line `COMPOSE_FILE=docker-compose.yml:dh_plugin.yml` in `.env` file.

This also starts *devicehive-ws-proxy* instance for external connections from plugins. It's available at http://*hostname*/plugin/proxy.
When new plugin is registered, Plugin service returns JSON with "proxyEndpoint" address, something like this:
```json
{
  "accessToken": "eyJhbGci...",
  "refreshToken": "eyJhbGci...",
  "proxyEndpoint": "ws://localhost/plugin/proxy",
  "topicName": "plugin_topic_e59104d3-66d4-4fbd-9430-32bec981887a"
}
```
To configure this `proxyEndpoint` address for your environment, add `DH_PROXY_PLUGIN_CONNECT=ws://fully-qualified-host-name/plugin/proxy` in `.env` file.

## Development run
In order to run only DeviceHive 3d-party dependencies in Docker containers, simply run:

### For PROXY version of Devicehive services:
```
sudo docker-compose -f dev-proxy.yml up -d
```

### For RPC version of Devicehive services:
```
sudo docker-compose -f dev-rpc.yml up -d
```
Then you'd be able to start all DeviceHive java services (backend, frontend, auth, plugin manager) by running ```java -jar devicehive-...-boot.jar```

## Configuration
All containers are configured via environment variables and Docker Compose can pass variables from its environment to containers or read them from [.env](https://docs.docker.com/compose/compose-file/#env_file) file. To make persistent configuration changes we will add parameters in the `.env` file in the current directory.

### JWT secret
* `JWT_SECRET` - changes the randomly generated JWT signing secret.

### DeviceHive image tags
Released versions of devicehive-docker use stable DeviceHive images from [DeviceHive Docker Hub repository](https://hub.docker.com/u/devicehive/). But if you want follow DeviceHive development add following parameters:

* `DH_TAG` - tag for DeviceHive [Frontend](https://hub.docker.com/r/devicehive/devicehive-frontend/), [Backend](https://hub.docker.com/r/devicehive/devicehive-backend/) and [Hazelcast](https://hub.docker.com/r/devicehive/devicehive-hazelcast/) images. Can be set to `development` to track development version of DeviceHive.
* `DH_PROXY_TAG` - tag for [DeviceHive Proxy](https://hub.docker.com/r/devicehive/devicehive-proxy/) image, which serves as API gateway for services and hosts Admin console application. Can be set to `development` to track development version of DeviceHive Proxy.
* `DH_WS_PROXY_TAG` - tag for [DeviceHive WS Proxy](https://hub.docker.com/r/devicehive/devicehive-ws-proxy/) image. This is a WebSocket proxy to message broker (Kafka). Can be set to `development` to track development version of DeviceHive WS Proxy.

### PostgreSQL
These variables are used by Frontend, Backend and PostgreSQL containers.
* `DH_POSTGRES_ADDRESS` - Address of PostgreSQL server instance. Defaults to `postgres`, which is address of internal PostgreSQL container.
* `DH_POSTGRES_PORT` - Port of PostgreSQL server instance, defaults to `5432` if undefined.
* `DH_POSTGRES_DB` - PostgreSQL database name for DeviceHive metadata. It is assumed that database already exists and either blank or has been initialized by DeviceHive. Defaults to `postgres`.
* `DH_POSTGRES_USERNAME` and `DH_POSTGRES_PASSWORD` - login/password for DeviceHive user in PostgreSQL that have full access to `DH_POSTGRES_DB`. Defaults are `postgres` and `mysecretpassword`.

### Kafka
To enable DeviceHive to communicate over Apache Kafka message bus to scale out and interoperate with other componets, such us Apache Spark, or to enable support of Apache Cassandra for fast and scalable storage of device messages define the following environment variables:
* `DH_ZH_ADDRESS` - Comma-separated list of addressed of ZooKeeper instances. Defaults to `zookeeper`, which is address of internal Zookeeper container.
* `DH_ZK_PORT` - Port of ZooKeeper instances, defaults to `2181` if undefined.
* `DH_KAFKA_BOOTSTRAP_SERVERS` -  Comma separated list of Kafka servers, i.e. `host1:9092,host2:9092,host3:9092`. This parameter or `DH_KAFKA_ADDRESS` is required to be set.
* `DH_KAFKA_ADDRESS` - Address of Apache Kafka broker node. Mutually exclusive with `DH_KAFKA_BOOTSTRAP_SERVERS` parameter.
* `DH_KAFKA_PORT` - Port of Apache Kafka broker node, defaults to `9092` if undefined. Ignored if `DH_KAFKA_ADDRESS` is undefined.
* `DH_RPC_SERVER_REQ_CONS_THREADS` - Kafka request consumer threads in the Backend, defaults to `3` if undefined.
* `DH_RPC_SERVER_WORKER_THREADS` - Server worker threads in the Backend, defaults to `3` if undefined. On machine with many CPU cores and high load this value must be raised. For example on machine with 8 core it must be set to `6`.
* `DH_RPC_CLIENT_RES_CONS_THREADS` - Kafka response consumer threads in the Frontend, defaults to `3`.
* `DH_AUTH_SPRING_PROFILES_ACTIVE`, `DH_FE_SPRING_PROFILES_ACTIVE`, `DH_BE_SPRING_PROFILES_ACTIVE` and `DH_PLUGIN_SPRING_PROFILES_ACTIVE` - Changes which Spring profile use for Auth, Frontend, Backend and Plugin sevices respectively. Defaults to `ws-kafka-proxy-frontend` for Frontend, `ws-kafka-proxy-backend` for Backend and `ws-kafka-proxy` for Auth/Plugin. Can be changed to `rpc-client` for Auth/Frontend/Plugin and `rpc-server` for Backend to use direct connection to Kafka instead of devicehive-ws-proxy service.

### MQTT brokers
The [devicehive-mqtt plugin][dh-mqtt-url] is a MQTT transport layer between MQTT clients and DeviceHive server. The broker uses WebSocket sessions to communicate with DeviceHive Server and Redis server for persistence functionality.

To enable optional DeviceHive MQTT brokers run DeviceHive with the following command. This will start MQTT brokers on port 1883 and internal Redis container:

```
sudo docker-compose -f docker-compose.yml -f mqtt-brokers.yml
```

Or add line `COMPOSE_FILE=docker-compose.yml:mqtt-brokers.yml` in `.env` file.

[dh-mqtt-url]: https://github.com/devicehive/devicehive-mqtt

### Logging
By default DeviceHive writes minimum logs for better performance. Two configuration parameters are supported:
* `DH_LOG_LEVEL` - log verbosity for DeviceHive Java classes. Defaults to `INFO` for both devicehive-frontend and devicehive-backend.
* `ROOT_LOG_LEVEL` - log verbosity for external dependencies. Defaults to `WARN` for devicehive-frontend and `INFO` for devicehive-backend.

Possible values are: `TRACE`, `DEBUG`, `INFO`, `WARN`, `ERROR`.

You can find more configurable parameters in [frontend][fe-script-url] and [backend][be-script-url] startup scripts.

[fe-script-url]: https://github.com/devicehive/devicehive-java-server/blob/master/dockerfiles/devicehive-frontend/devicehive-start.sh
[be-script-url]: https://github.com/devicehive/devicehive-java-server/blob/master/dockerfiles/devicehive-backend/devicehive-start.sh

## HTTPS configuration (TLS)
TLS support in DeviceHive Proxy can be enable by providing you own certificate files. See instructions below.

### Using custom certificate
For Docker Compose installation we will use Compose feature to read configuration from [multiple Compose files](https://docs.docker.com/compose/extends/#multiple-compose-files). Second Compose file will start devicehive-proxy container with custom certificate.
To configure DeviceHive Proxy to use your own certificate follow next steps:
1. Generate key and certificate signing request for your domain, sign CSR with Certificate Authority. Resulting certificate and key files must be in the PEM format.
2. Create `ssl` directory outside of `devicehive-docker` directory, on the same directory level.
3. Generate dhparam file for nginx:
```
openssl dhparam -out ssl/dhparam.pem 2048
```
4. Copy SSL certificate to `ssl` directory. File must be named `ssl_certificate`.
5. Copy SSL certificate key to `ssl` directory. File must be named `ssl_certificate_key`.
6. Run DeviceHive with the following command:
```
sudo docker-compose -f docker-compose.yml -f dh_proxy_custom_certificate.yml up -d
```

Or add line `COMPOSE_FILE=docker-compose.yml:dh_proxy_custom_certificate.yml` in `.env` file.

You can now access your DeviceHive API at https://devicehive-host-url/api and Admin Console at https://devicehive-host-url/admin.

## Monitoring
### cAdvisor metrics
We provide Compose file with cAdvisor service which exports various container-related metrics. It's exposed on port 9395.

Run DeviceHive with the following command:

```
sudo docker-compose -f docker-compose.yml -f cadvisor.yml
```

Or add line `COMPOSE_FILE=docker-compose.yml:cadvisor.yml` in `.env` file.

### Kafka metrics
You can start Kafka service with additional Prometheus metrics exporter. Necessary parameters for Kafka container are already configured in `devicehive-metrics.yml` file. It will launch JMX exporter on tcp port 7071.

Run DeviceHive with the following command:

```
sudo docker-compose -f docker-compose.yml -f devicehive-metrics.yml
```

Or add line `COMPOSE_FILE=docker-compose.yml:devicehive-metrics.yml` in `.env` file.

Related Prometheus config for this exporter and link to Grafana Dashboard is in the [Monitoring Kafka with Prometheus](https://www.robustperception.io/monitoring-kafka-with-prometheus/) blog post by Prometheus developer.

### Grafana
We provide optional bundle of monitoring services for Docker Compose installation with cAdvisor, Prometheus and Grafana included. This bundle is provided for evaluation purposes only.

To enable it run DeviceHive with the following command:
```
sudo docker-compose -f docker-compose.yml -f monitoring.yml up -d
```
Or add line `COMPOSE_FILE=docker-compose.yml:monitoring.yml` in `.env` file.

Grafana will be available at `http://<devicehive-host>/grafana` with [default Grafana credentials][grafana-conf-security].

> Please note that this bundle of monitoring services is for testing purposes only. For production environment install separatetly managed Grafana instance. We don't provide support for this bundle.
> And don't forget to change Grafana `admin` password.

[datasource-github-repo]: https://github.com/devicehive/devicehive-grafana-datasource
[datasource-in-plugin-registry]: https://grafana.com/plugins/devicehive-devicehive-datasource
[grafana-conf-security]: http://docs.grafana.org/installation/configuration/#security

#### DeviceHive Grafana Datasource
DeviceHive project provides official [datasource plugin for Grafana][datasource-github-repo] which is also published in [Grafana plugin registry][datasource-in-plugin-registry]. For the means of testing this plugin, we included it Grafana Docker image in monitoring.yml bundle.

> Please note that this image is for testing purposes only. If you want to use datasource plugin in production environment, install plugin in separately managed Grafana instance. We don't provide support for this image.

## DeviceHive Backend Node
[DeviceHive NodeJS backend][devicehive-backend-node] project provides alternative implementation of Backend service written in JavaScript. Feature wise it should be on a par with devicehive-java-server implementation and is being continuously tested using the same set of integration tests.

To use NodeJS backend implementation add following line in `.env` file:

```
COMPOSE_FILE=docker-compose-node.yml
```

When run with docker-compose this service accepts following parameters via environment variable or `.env` file:
* DH_BACKEND_NODE_LOGGER_LEVEL - Application logging level. Possible values are "debug", "info", "warn" and "error", default is "info".

[devicehive-backend-node]: https://github.com/devicehive/devicehive-backend-node

## Development environment
### Using CI images
Continuous Integration system uploads images built from every branch to [devicehiveci](https://hub.docker.com/r/devicehiveci/) repository on Docker Hub.
To use these images add `ci-images.yml` to `COMPOSE_FILE` parameter in `.env` file. If you don't have this parameter in `.env` file, add it like that:
```
COMPOSE_FILE=docker-compose.yml:ci-images.yml
```

### Debugging
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

### Hazelcast Management Center
You can launch Management Center to monitor Hazelcast usage and health. TCP port 9980 must be open on a firewall.

1. Add `hazelcast-management-center.yml` to `COMPOSE_FILE` parameter in `.env` file. If you don't have this parameter in `.env` file, add it like that:
```
COMPOSE_FILE=docker-compose.yml:hazelcast-management-center.yml
```

2. Run DeviceHive as usual.
3. Open Hazelcast Management Center in browser via http://devicehive-server:9980/mancenter. You'll be required to configure authentication on the first launch.

## Backup and restore
### Backup PostgreSQL database
To backup database use following command:
```
sudo docker-compose exec postgres sh -c 'pg_dump --no-owner -c -U ${POSTGRES_USER} ${POSTGRES_DB}' > dump_`date +%d-%m-%Y"_"%H_%M_%S`.sql
```
This will create dump\_\*.sql file in the current directory.

### Restore PostgreSQL database
To restore database from SQL dump file delete existing database (if any), start only postgres container and pass dump file contents to psql utility in container:
```
sudo docker-compose down
sudo docker volume ls -q|grep devicehive-db| xargs sudo docker volume rm
sudo docker-compose up -d postgres
cat dump_*.sql | sudo docker exec -i rdbmsimage_postgres_1 sh -c 'psql -U ${POSTGRES_USER} ${POSTGRES_DB}'
sudo docker-compose up -d
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
