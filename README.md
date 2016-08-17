# Description
DeviceHive is an Open Source IoT Data Platform which helps to connect devices to the cloud in minutes allowing to stream device data and send commands. DevieHivce is highly extensible through containerization. You can run a standalone container for experimentation, then add persistent relational storage for device and user meta-data using PostgreSQL or Riak TS, then scale up by adding Kafka and ZooKeeper message bus and finally attach Apache Spark analytics to Apache Kafka. 

# Installation
For now DeviceHive supports two types of data storage:
* [Postgres](rdbms-image/)
* [Riak TS](riak-image/)

More details in the appropriate subdirectories. 