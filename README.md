# Description
DeviceHive is an Open Source IoT Data Platform which helps to connect devices to the cloud in minutes allowing to stream device data and send commands. DeviceHive is highly scalable through containerization. You can run a DeviceHive stack with single instance of each component, then scale up by adding additional Frontend, Backend, Kafka and ZooKeeper instances. And finally attach Apache Spark analytics to Apache Kafka.

# Installation
## Docker-compose installation
The easiest way to try DeviceHive locally or in your development datacenter is to deploy it using [Docker Compose](https://docs.docker.com/compose/).

This will start complete DeviceHive service stack running:

* DeviceHive Frontend
* DeviceHive Backend
* Hazelcast IMDG
* Zookeeper
* Kafka
* PostreSQL
* Admin console

More details in the [rdbms-image](rdbms-image/) subdirectory.

## System requirements for docker-compose installation
* 4 CPU cores
* 8 GB of RAM
* At least 16 GB of disk space for OS and Docker data (images, volumes, etc). On CentOS 7 it better to have additional 10 GB disk for Docker data.
* Linux distribution that fully support containers. Like CentOS 7, Fedora 24 and newer, Ubuntu 14.04 and later
* Docker version 1.13 and later
* Docker-compose version 1.12 and later

Installation was tested on machine with CentOS 7 distribution.

## Kubernetes installation
DeviceHive also has experimental support for [installation on Kubernetes cluster](dh-rdbms-k8s/) with PostgreSQL storage.
