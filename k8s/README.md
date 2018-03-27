# DeviceHive Helm Chart
[DeviceHive](https://devicehive.com), Open Source IoT Data Platform with the wide range of integration options.

## TL;DR;

``` console
$ helm install ./devicehive
```

## Introduction

This chart installs [DeviceHive](https://devicehive.com/) on a [Kubernetes](http://kubernetes.io) cluster using the [Helm](https://helm.sh) package manager.

## Prerequisites

- Kubernetes 1.7+

This chart probably will work on Kubernetes older that 1.7, but it wasn't tested in such environment.

## Installing the Chart

To install the chart with release name `my-release`:

``` console
$ helm install --name my-release ./devicehive
```

The command deploys DeviceHive on the Kubernetes cluster in the default configuration. The [configuration](#configuration) section lists the parameters that can be configured during installation.

> **Tip**: List all releases using `helm list`

## Accessing DeviceHive

### Security credentials

Default DeviceHive admin user has name `dhadmin` and password `dhadmin_#911`.

### Service endpoints
Table below lists endpoints where you can find various DeviceHive services. If `proxy.ingress` set to `true`, replace *localhost* with hostname(s) used in `proxy.ingress.hosts` parameter.

| Service              | URL                               | Notes                        |
|----------------------|-----------------------------------|------------------------------|
| Admin Console        | http://*localhost*/admin          |                              |
| Frontend service API | http://*localhost*/api/rest       |                              |
| Auth service API     | http://*localhost*/auth/rest      |                              |
| Plugin service API   | http://*localhost*/plugin/rest    | If enabled, see [Run with DeviceHive Plugin Service](#run-with-devicehive-plugin-service) section below |
| Frontend Swagger     | http://*localhost*/api/swagger    |                              |
| Auth Swagger         | http://*localhost*/auth/swagger   |                              |
| Plugin Swagger       | http://*localhost*/plugin/swagger | If Plugin service is enabled |

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
`javaServer.repository` | DockerHub user or organization with all devicehive-java-server images | `devicehive`
`javaServer.tag` | Common image tag of devicehive-java-server images | `3.4.5`
`javaServer.pullPolicy` | Common image pull policy for devicehive-java-server images | `IfNotPresent`
`javaServer.auth.replicaCount` | Desired number of Auth service pods | `1`
`javaServer.auth.resources` | Auth service resource requests and limits | `{}`
`javaServer.auth.dhLogLevel` | Log verbosity for DeviceHive Java classes | `INFO`
`javaServer.auth.rootLogLevel` | Log verbosity for external dependencies | `WARN`
`javaServer.backend.replicaCount` | Desired number of Backend service pods | `1`
`javaServer.backend.resources` | Backend service resource requests and limits | `{}`
`javaServer.backend.dhLogLevel` | Log verbosity for DeviceHive Java classes | `INFO`
`javaServer.backend.rootLogLevel` | Log verbosity for external dependencies | `INFO`
`javaServer.frontend.replicaCount` | Desired number of Frontend service pods | `1`
`javaServer.frontend.resources` | Frontend service resource requests and limits  | `{}`
`javaServer.frontend.dhLogLevel` | Log verbosity for DeviceHive Java classes | `INFO`
`javaServer.frontend.rootLogLevel` | Log verbosity for external dependencies | `WARN`
`javaServer.hazelcast.replicaCount` | Desired number of DeviceHive Hazelcast service pods | `1`
`javaServer.hazelcast.resources` | DeviceHive Hazelcast service resource requests and limits  | `{}`
`javaServer.plugin.enabled` | If true, DH Plugin service will be deployed | `false`
`javaServer.plugin.pluginConnectUrl` | Sets URL for Plugin to connect via WebSocket protocol. Plugin service sends this URL to external plugins after registering. Defaults to 'ws://localhost/plugin/proxy' | `""`
`javaServer.plugin.replicaCount` | Desired number of Plugin service pods | `1`
`javaServer.plugin.resources` | Plugin service resource requests and limits  | `{}`
`javaServer.plugin.dhLogLevel` | Log verbosity for DeviceHive Java classes | `INFO`
`javaServer.plugin.rootLogLevel` | Log verbosity for external dependencies | `WARN`
`javaServer.bus` | Message bus access method, WS Proxy by default. Other option is `rpc` | `wsproxy`
`javaServer.jwtSecret` | JWT secret for signing JWT tokens. If empty (default) Helm generates random 16 characters string | `""`
`mqttBroker.enabled` | If true, DH MQTT broker will be deployed | `false`
`mqttBroker.appLogLevel` | Application logger level (levels: debug, info, warn, error) | `info`
`mqttBroker.image` | MQTT broker image and tag | `devicehive/devicehive-mqtt:1.1.0`
`mqttBroker.pullPolicy`| MQTT broker image pull policy | `IfNotPresent`
`mqttBroker.service.type` | Type of MQTT broker service to create | `ClusterIP`
`mqttBroker.service.port` | MQTT broker service port | `1883`
`mqttBroker.wsServerUrl` | | URL of Frontend Web Socket server. Defaults to "ws://localhost:8080/api/websocket" if empty | `""`
`proxy.image` | DH Proxy image name and tag | `devicehive/devicehive-proxy:3.4.5`
`proxy.pullPolicy` | DH Proxy image pull policy | `IfNotPresent`
`proxy.replicaCount` | Desired number DH Proxy pods | `1`
`proxy.resources` | DH Proxy service resource requests and limits | `{}`
`proxy.ingress.enabled` |If true, DH Proxy Ingress will be created | `false`
`proxy.ingress.annotations` | DH Proxy Ingress annotations | `{}` ###  kubernetes.io/ingress.class: nginx
`proxy.ingress.hosts` | DH Proxy server Ingress hostnames | `[]`
`wsProxy.image` | DH WS Proxy image name and tag | `devicehive/devicehive-ws-proxy:1.1.0`
`wsProxy.pullPolicy` | DH WS Proxy image pull policy | `IfNotPresent`
`wsProxy.internal.replicaCount` | Desired number of internal WS Proxy service pods | `1`
`wsProxy.internal.resources` | Internal WS Proxy service resource requests and limits  | `{}`
`wsProxy.external.enabled` | If true, External WS Proxy deployment will be created. Requires `javaServer.plugin.enabled` set to `true` | `false`
`wsProxy.external.replicaCount` | Desired number of external WS Proxy service pods | `1`
`wsProxy.external.resources` | External WS Proxy service resource requests and limits | `{}`
`rbac.create` | If true, create & use RBAC resources | `true`
`rbac.serviceAccountName` | Service account name to use (ignored if rbac.create=true) | `default`
`kafka.enabled` | If true, installs Kafka chart. Required | `true`
`postgresql.enabled` | If true, installs PostgreSQL chart. Required | `true`
`postgresql.postgresDatabase` | Database name. Used by both PostgreSQL and DeviceHive charts | `devicehivedb`
`postgresql.postgresUser` | Database user. Used by both PostgreSQL and DeviceHive charts | `devicehive`
`postgresql.postgresPassword` | Database password. Used by both PostgreSQL and DeviceHive charts | `devicehivepassword`
`postgresql.persistence.enabled` | Use a PVC to persist database | `true`
`postgresql.persistence.size` | Size of data volume | `1Gi`
`postgresql.imageTag` | `postgresql` chart image tag, if `postgresql.enabled` is `true` | `10`
`redis.enabled` | If true, installs Redis chart, which is requred by MQTT broker. Requires `mqttBroker.enabled` set to `true` | `true`

Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`. For example,

```console
$ helm install ./devicehive --name my-release \
    --set javaServer.frontend.replicaCount=3
```

Alternatively, a YAML file that specifies the values for the above parameters can be provided while installing the chart. For example,

```console
$ helm install ./devicehive --name my-release -f values.yaml
```

> **Tip**: You can use the default [values.yaml](devicehive/values.yaml)

### RBAC Configuration
Roles and RoleBindings resources will be created automatically for each service

To manually setup RBAC you need to set the parameter rbac.create=false and specify the service account to be used in rbac.serviceAccountName.

### Ingress TLS
Ingress TLS doesn't supported yet by this Helm chart.
