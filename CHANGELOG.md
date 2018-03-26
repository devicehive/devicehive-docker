## Development

* k8s: add parameters for log level configuration in Java Server services

## 3.4.5.1 / 2018-03-26

* Update devicehive-proxy image to 3.4.5.1. Fixes absence of 'openssl' binary in image.

## 3.4.5 / 2018-03-20

* Update images to DeviceHive Java Server 3.4.5, DeviceHive Proxy 3.4.5
* k8s: fix external WS Proxy deployment replicaCount value
* Add service to cleanup Kafka topics left by unregistered plugins
* k8s: add RBAC support

## 3.4.4 / 2018-03-06

* Use DeviceHive Java Server 3.4.4, DeviceHive WS Proxy 1.1.0, DeviceHive Proxy 3.4.4, DeviceHive MQTT 1.1.0 images
* First public release of DeviceHive Helm chart for Kubernetes installation
* Documentation updates

## 3.4.3 / 2018-01-22

* Use DeviceHive Java Server 3.4.3, DeviceHive WS Proxy 1.0.0, DeviceHive Proxy 3.4.3 images
* DeviceHive Java Server switched to WS Proxy by default
* Documentation and sample docker-compose file for Grafana with DeviceHive Grafana Plugin
* Sample docker-compose files for starting only third-party services in development environment
* DeviceHive Plugin service starts with WS Proxy for external collections.
* Docker-compose files for DeviceHive MQTT brokers
* In-progress implementation of Helm installation on Kubernetes
* Documentation updates

### Notes
Note that Kubernetes installation in this release is half-broken because of switching to Helm. We expect to have full Helm support in next release of devicehive-docker.

## 3.4.2 / 2017-12-12

* Use DeviceHive 3.4.2 images
* DeviceHive Java server images has new names, \*-rdbms suffix was removed
* Update k8s installation and docs
* Upgrade Kafka to version 1.0.0
* Add dh_proxy service which routes external traffic to DeviceHive containers and service admin-console

## 3.4.1 / 2017-11-22

* Use DeviceHive 3.4.1 images
* Add optional devicehive-plugin service
* Update PostgreSQL container to version 10
* Update jmx_prometheus library used for Kafka monitoring
* Remove Riak support
* Update documentation for Kubernetes installation

### Breaking changes
Due to upgrade of PostgreSQL to version 10 you need to manually migrate existing database. Check [UPDATING.md](rdbms-image/UPDATING.md).

## 3.4.0 / 2017-10-31

* Add Auth service containers in docker-compose and k8s installations
* Rename development-images.yml to ci-images.yml
* Use DeviceHive 3.4.0 images

## 3.3.4 / 2017-10-13

* Use DeviceHive 3.3.4 images

## 3.3.3 / 2017-09-29

* Use DeviceHive 3.3.3 images
* Document releasing process

## 3.3.2 / 2017-09-12

* Use DeviceHive 3.3.2 images
* Much more configuration parameters via .env file
* HTTPS configuration
* Kafka metrics exporter for Prometheus (disabled by default)
* Remote JMX connection for debugging Frontend and Backend (disabled by default)
* Hazelcast Management Center setup (disabled by default)
* Option to use CI images (disabled by default)
* Documented backup and restore procedure
* Updated docs 

## 3.3.1 / 2017-08-23

* Use DeviceHive 3.3.1 images
* Update docs
* Add metrics exporter for Kafka
* Restart containers on failure and reboot in docker-compose installation
* Review and test Kubernetes installation

## 3.3.0 / 2017-08-04

* Use DeviceHive 3.3.0 images
* Update docs
* Use our own Hazelcast image based on official one. No need to mount .jar file with DeviceHive classes, it's included in image.

## 3.2.0 / 2017-06-30

* Use DeviceHive 3.2.0 images
* Separate Hazelcast container
* Experimental installation on Kubernetes cluster

## 3.1.0 / 2017-06-16

* 3.1.0 Release

## 2.0.11 / 2015-12-09

* Changes in this release: https://github.com/devicehive/devicehive-java-server/issues?q=milestone%3A%22Release+2.0.11%22+is%3Aclosed

## 2.0.10 / 2015-10-29

* DH -> 2.0.10

## 2.0.9 / 2015-10-12

* DH -> 2.0.9

## 2.0.6 / 2015-09-29

* Swagger schema update

## 2.0.4 / 2015-09-24

* Updated DH to 2.0.4; Implemented linking

