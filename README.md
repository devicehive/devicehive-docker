# Description
DeviceHive is an Open Source IoT Data Platform which helps to connect devices to the cloud in minutes allowing to stream device data and send commands. DevieHivce is highly extensible through containerization. You can run a standalone container for experimentation, then add persistent relational storage for device and user meta-data using PostgreSQL or Riak TS, then scale up by adding Kafka and ZooKeeper message bus and finally attach Apache Spark analytics to Apache Kafka. 

# Installation
## Docker-compose installation
For now DeviceHive can be installed on Docker hosts with docker-compose. Two types of data storage are supported:
* [PostgreSQL](rdbms-image/)
* [Riak TS](riak-image/)

More details in the appropriate subdirectories.

## System requirements for docker-compose installation
* 2 CPU cores
* 4 GB of RAM
* At least 16 GB of disk space for OS and Docker data (images, volumes, etc). On CentOS 7 it better to have additional 10 GB disk for Docker data.
* Linux distribution that fully support containers. Like CentOS 7, Fedora 24 and newer, Ubuntu 14.04 and later
* Docker version 1.13 and later
* Docker-compose version 1.12 and later

Installation was tested on machine with CentOS 7 distribution.

## Kubernetes installation
DeviceHive also has experimental support for [installation on Kubernetes cluster](dh-rdbms-k8s/) with PostgreSQL storage.
