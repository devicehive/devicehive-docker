# DeviceHive Helm Chart
[DeviceHive](https://devicehive.com), Open Source IoT Data Platform with the wide range of integration options.

## TL;DR;

``` console
$ helm dependency update ./devicehive
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
$ helm dependency update ./devicehive
$ helm install --name my-release ./devicehive
```

The command deploys DeviceHive on the Kubernetes cluster in the default configuration. The [configuration](#configuration) section lists the parameters that can be configured during installation.

> **Tip**: List all releases using `helm list`

## Accessing DeviceHive

### Security credentials

Default DeviceHive admin user has name `dhadmin` and password `dhadmin_#911`.

### Service endpoints
Table below lists endpoints where you can find various DeviceHive services. If `ingress` set to `true`, replace *localhost* with hostname(s) used in `ingress.hosts` parameter.

| Service                       | URL                               | Notes                        |
|-------------------------------|-----------------------------------|------------------------------|
| Admin Console                 | http://*localhost*/admin          |                              |
| Frontend service API          | http://*localhost*/api/rest       |                              |
| Auth service API              | http://*localhost*/auth/rest      |                              |
| Plugin management service API | http://*localhost*/plugin/rest    | If enabled, see [Install with DeviceHive Plugin Management Service](#install-with-devicehive-plugin-management-service) section below |
| External WS Proxy for plugins | http://*localhost*/plugin/proxy   | If Plugin service is enabled |
| Frontend Swagger              | http://*localhost*/api/swagger    |                              |
| Auth Swagger                  | http://*localhost*/auth/swagger   |                              |
| Plugin Swagger                | http://*localhost*/plugin/swagger | If Plugin service is enabled |

## Uninstalling the Chart

To uninstall/delete the `my-release` deployment:

``` console
$ helm delete my-release
```

The command removes all the Kubernetes components associated with the chart and deletes the release.

## Configuration

The following table lists the configurable parameters of the DeviceHive chart and their default values.

Parameter | Description | Default
--------- | ----------- | -------
`javaServer.repository` | DockerHub user or organization with all devicehive-java-server images | `devicehive`
`javaServer.tag` | Common image tag of devicehive-java-server images | `3.5.0`
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
`javaServer.hazelcast.minHeapSize` | Hazelcast minimum heap size | `512m`
`javaServer.hazelcast.maxHeapSize` | Hazelcast maximum heap size | `512m`
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
`ingress.enabled` | If true, ingress will be created | `false`
`ingress.annotations` | Ingress annotations | `{}` ###  kubernetes.io/ingress.class: nginx
`ingress.hosts` | Ingress hostnames | `[]`
`backendNode.enabled` | If true enables devicehive-backend-node backend service and disables devicehive-java-server one | `false`
`backendNode.image` | Node backend image and tag | `devicehive/devicehive-backend-node:development`
`backendNode.pullPolicy` | Node backend image pull policy | `IfNotPresent`
`backendNode.loggerLevel` | Node backend logger level (levels: debug, info, warn, error ) | `info`
`backendNode.replicaCount` | Desired number of Node backend pods | `1`
`backendNode.resources` | Node backend  resource requests and limits | `{}`
`coapProxy.enabled` | If true, CoAP-WebSockets proxy will be deployed | `false`
`coapProxy.image` | CoAP-WebSockets proxy image and tag | `devicehive/devicehive-coap-proxy:1.0.0`
`coapProxy.pullPolicy`| CoAP-WebSockets proxy image pull policy | `IfNotPresent`
`coapProxy.replicaCount` | Desired number of CoAP-WebSockets proxy pods | `1`
`coapProxy.resources` | CoAP-WebSockets proxy deployment resource requests and limits | `{}`
`coapProxy.service.type` | Type of CoAP-WebSockets proxy service to create | `ClusterIP`
`coapProxy.service.port` | CoAP-WebSockets proxy service port | `5683`
`mqttBroker.enabled` | If true, DH MQTT broker will be deployed | `false`
`mqttBroker.appLogLevel` | Application logger level (levels: debug, info, warn, error) | `info`
`mqttBroker.image` | MQTT broker image and tag | `devicehive/devicehive-mqtt:1.1.0`
`mqttBroker.pullPolicy`| MQTT broker image pull policy | `IfNotPresent`
`mqttBroker.replicaCount` | Desired number of MQTT broker pods | `1`
`mqttBroker.resources` | MQTT broker deployment resource requests and limits | `{}`
`mqttBroker.service.type` | Type of MQTT broker service to create | `ClusterIP`
`mqttBroker.service.port` | MQTT broker service port | `1883`
`proxy.image` | DH Proxy image name and tag | `devicehive/devicehive-proxy:3.5.0`
`proxy.pullPolicy` | DH Proxy image pull policy | `IfNotPresent`
`proxy.replicaCount` | Desired number DH Proxy pods | `1`
`proxy.resources` | DH Proxy service resource requests and limits | `{}`
`proxy.ingress.enabled` |If true, DH Proxy Ingress will be created. Deprecated in favour of root 'ingress' values | `false`
`proxy.ingress.annotations` | DH Proxy Ingress annotations | `{}` ###  kubernetes.io/ingress.class: nginx
`proxy.ingress.hosts` | DH Proxy server Ingress hostnames | `[]`
`wsProxy.image` | DH WS Proxy image name and tag | `devicehive/devicehive-ws-proxy:1.1.0`
`wsProxy.pullPolicy` | DH WS Proxy image pull policy | `IfNotPresent`
`wsProxy.internal.replicaCount` | Desired number of internal WS Proxy service pods | `1`
`wsProxy.internal.resources` | Internal WS Proxy service resource requests and limits  | `{}`
`wsProxy.external.replicaCount` | Desired number of external WS Proxy service pods | `1`
`wsProxy.external.resources` | External WS Proxy service resource requests and limits | `{}`
`nodeSelector` | Node labels for DeviceHive pods assignment | `{}`
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

### Install with DeviceHive Plugin Management Service

Plugin management service disabled by default. To enable it you need to pass several values to `helm`.
Change <external_hostname> to hostname pointing to your cluster. For example, if you setup Ingress resource with host 'devicehive.example.com' then pluginConnectUrl will be 'ws://devicehive.example.com/plugin/proxy':
``` console
$ helm install \
  --name my-release
  --set javaServer.plugin.enabled=true \
  --set javaServer.plugin.pluginConnectUrl=ws://<external_hostname>/plugin/proxy \
  ./devicehive
```
or with following parameters in values file:
``` yaml
javaServer:
  plugin:
    enabled: true
    pluginConnectUrl: ws://<external_hostname>/plugin/proxy
```
Enabling Plugin management service automaticaly enables external WebSocket proxy for plugins.

### RBAC Configuration
First, Helm itself requires additional configuration to use on Kubernetes clusters where RBAC enabled. Follow instructions in [Helm documentation](https://docs.helm.sh/using_helm/#role-based-access-control).

DeviceHive Role and RoleBinding resources will be created automatically for each service.

To manually setup RBAC you need to set the parameter rbac.create=false and specify the service account to be used in rbac.serviceAccountName.

### Ingress TLS
Ingress TLS doesn't supported yet by this Helm chart.

### Setting up horizontal autoscaling for services

Autoscaling DeviceHive in Kubernetes relies on Horizontal Pod Authoscaler in your cluster. DeviceHive Helm chart provides ability to set resources for pods and cluster administrator have to create HPA manualy.

When deploying application specify .resource.requests values, see [Configuration section](#configuration) for available values. Here is example from `values.yaml` file used by `helm install --name test ./devicehive -f values.yaml`:
```yaml
javaServer:
  backend:
    resources:
      requests:
        cpu: 2
        memory: 1536Mi
  frontend:
    resources:
      requests:
        cpu: 2
        memory: 1536Mi
```

When resources.requests for pods are set create hpa by issuing follwing commands:
```console
$ kubectl autoscale deployment test-devicehive-backend --cpu-percent=70 --min=1 --max=3
$ kubectl autoscale deployment test-devicehive-frontend --cpu-percent=70 --min=1 --max=3
$ kubectl get hpa
```

> **Note**: resources.requests values and HPA configuration provided above had to be tweaked for your deployment. Please consult [HPA walkthrough](https://kubernetes.io/docs/tasks/run-application/horizontal-pod-autoscale-walkthrough/) in Kubernetes documentation for more details.
