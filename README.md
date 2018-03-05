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
DeviceHive can be installed on Kubernetes with provided [Helm chart](k8s/). This chart also installs PostgreSQL chart and Kafka chart from [Kubeapps](https://kubeapps.com) repositories. External installations of PostgreSQL and Kafka are not supported at the moment.

Previous installation method on Kubernetes using a `kubectl` utility and a plain YAML files are deprecated now. Please [issue a ticket](https://github.com/devicehive/devicehive-docker/issues/new) in our [GitHub repository](https://github.com/devicehive/devicehive-docker/) if you have questions about mirgating such environment to the one deployed with Helm chart.

## Installation on Docker for Windows or Docker for Mac
If you like to try DeviceHive using Docker for Windows or Docker for Mac, please note that this software runs Docker in special Virtual Machine (that got automaticaly created for you by installer). By default these Virtual Machines with much lower parameters that required for DeviceHive, 2GB of RAM and 2 vCPU. Here is example of how to change parameters in Docker for Windows, on Macs this should be similar:

1. Right-click on Docker icon in system tray and choose 'Settings...'.
2. Open 'Advanced' settings and increase CPUs and Memory parameters to recommended values.
3. Click 'Apply' button. VM will be restarted with new parameters.

