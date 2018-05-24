# DeviceHive Cassandra Plugin
[DeviceHive Cassandra storage plugin](https://github.com/devicehive/devicehive-plugin-cassandra-node), NodeJS implementation.

## Introduction

This chart installs [DeviceHive Cassandra storage plugin](https://github.com/devicehive/devicehive-plugin-cassandra-node) on a [Kubernetes](http://kubernetes.io) cluster using the [Helm](https://helm.sh) package manager.

## Prerequisites

- Kubernetes 1.8+
- Cassandra cluster
- DeviceHive with Plugin service and external WebSocket proxy enabled

## Installing the Chart

This chart requires some configuration values to be set for successful installation. These values dependend on your environment.

1. Create new user and keyspace in Cassandra. Record credentials and keyspace name
2. Register new plugin in DeviceHive. Record "proxyEndpoint" and "topicName" values
3. Use recorded values when installing chart

To install the chart with release name `my-release`:

``` console
$ helm install --name devicehive-cassandra-plugin ./devicehive-cassandra-plugin
```

The command deploys DeviceHive on the Kubernetes cluster in the default configuration. The [configuration](#configuration) section lists the parameters that can be configured during installation.

> **Tip**: List all releases using `helm list`

### Example installation with Cassandra cluster installed via Helm

1. Install Cassandra via Helm
``` console
$ kubectl create namespace cassandra

$ helm install \
     --name cassandra \
     --namespace cassandra \
     --set config.cluster_name=cassandra \
     --set persistence.enabled=true \
     --set persistence.size=20Gi \
     --version 0.4.0 \
     incubator/cassandra$

```
This will install 3 node Cassandra cluster in a new 'cassandra' namespace.
You can check cluster status with:
``` console
$ kubectl exec -it --namespace cassandra $(kubectl get pods --namespace cassandra -l app=cassandra,release=cassandra -o jsonpath='{.items[0].metadata.name}') nodetool status
```

2. After you have all three nodes up, connect to one of the nodes:
``` console
$ kubectl exec -it --namespace cassandra $(kubectl get pods --namespace cassandra -l app=cassandra,release=cassandra -o jsonpath='{.items[0].metadata.name}') -- /usr/bin/cqlsh -u cassandra -p cassandra

Connected to cassandra at 127.0.0.1:9042.
[cqlsh 5.0.1 | Cassandra 3.11.2 | CQL spec 3.4.4 | Native protocol v4]
Use HELP for help.
cassandra@cqlsh>
```
And create keyspace:
``` console
cassandra@cqlsh> CREATE KEYSPACE devicehive WITH REPLICATION = {'class': 'SimpleStrategy', 'replication_factor': 2};
```

3. Register new plugin in DeviceHive.
First login to DeviceHive server and get JWT token:
``` console
$ TOKEN=$(curl -X POST \
  --header "Content-Type: application/json" \
  --header "Accept: application/json" \
  -d '{"login": "username", "password": "password"}'\
  "http://devicehive.local/auth/rest/token" | jq -r ".accessToken")

$ echo $TOKEN
```

Register plugin new using this token:
``` console
$ curl -s -X POST --header "Content-Type: application/json" \
  --header "Accept: application/json" \
  --header "Authorization: Bearer $TOKEN" \
  -d '{"name": "cassandra_plugin", "description": "cassandra_plugin", "parameters": { "test": "true"}}' \
  "http://devicehive.local/plugin/rest/plugin?returnCommands=true&returnUpdatedCommands=true&returnNotifications=true"
```
Record "proxyEndpoint" and "topicName" values from server response.

> Please note that all three request parameters in URI are set to true: `returnCommands=true`, `returnUpdatedCommands=true`, `returnNotifications=true`. By default only commands will be passed to plugin.

4. Use recorded values when installing chart:
``` console
helm install \
    --name devicehive-cassandra-plugin \
    --namespace cassandra \
    --set connection.username=cassandra \
    --set connection.password=cassandra \
    --set connection.keyspace=devicehive \
    --set connection.contactPoints=cassandra \
    --set plugin.topic="plugin_topic_<...>" \
    --set plugin.devicehiveAuthServiceApiUrl=http://devicehive.local/auth/rest \
    --set plugin.devicehivePluginWsEndpoint=ws://devicehive.local/plugin/proxy \
    devicehive-cassandra-plugin
```

### Checking that device notifications and commands are exported from DeviceHive to Cassadra:
In Cassandra shell switch to devicehive keyspace and check existing tables:
``` console
cassandra@cqlsh> use devicehive;
cassandra@cqlsh:devicehive> describe tables;

commands  notifications_by_timestamp  notifications_by_deviceid  command_updates
```

Register new device in DeviceHive, send notifications and commands, check that they are stored to respective tables:
``` console
cassandra@cqlsh:devicehive> select * from notifications_by_deviceid;
```

``` console
cassandra@cqlsh:devicehive> select * from commands;
```

## Uninstalling the Chart

To uninstall/delete the `my-release` deployment:

``` console
$ helm delete my-release
```

The command removes all the Kubernetes components associated with the chart and deletes the release.

## Configuration

The following tables lists the configurable parameters of the DeviceHive chart and their default values.

Parameter | Description | Default
--------- | ----------- | -------
`image.repository` | DeviceHive Cassandra Plugin image repository | `devicehive/devicehive-plugin-cassandra-node`
`image.tag` | DeviceHive Cassandra Plugin image tag | `1.0.0`
`image.pullPolicy` | Image pull policy | `IfNotPresent`
`connection.contactPoints` | Address of Cassandra cluster | `cassandra`
`connection.username` | Cassandra username | `cassandra`
`connection.password` | Cassandra password | `cassandra`
`connection.keyspace` | Cassandra keyspace name | `devicehive`
`plugin.topic` | DeviceHive plugin topic name | `""`
`plugin.devicehiveAuthServiceApiUrl` | DeviceHive Auth API URL | `http://devicehive/auth/rest`
`plugin.devicehivePluginWsEndpoint` | DeviceHive external WebSocket proxy endpoint | `ws://devicehive/plugin/proxy`
`replicaCount`` | Desired number DeviceHive Cassandra Plugin pods | `1`
`resources` | DeviceHive Cassandra Plugin resource requests and limits | `{}`
`nodeSelector` | Node labels for DeviceHive CassandraPlugin pods assignment | `{}`
`tolerations` | | `[]`
`affinity` | | `{}`

Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`. For example,

```console
$ helm install ./devicehive --name my-release \
    --set replicaCount=3
```

Alternatively, a YAML file that specifies the values for the above parameters can be provided while installing the chart. For example,

```console
$ helm install ./devicehive --name my-release -f values.yaml
```

> **Tip**: You can use the default [values.yaml](values.yaml)
