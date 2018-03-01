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
Kubernets 1.8 enables RBAC by default when running on Google Compute platform. Chart doesn't support RBAC yet, so to deploy DeviceHive you need to create cluster with 'Legacy Authorisation" option enabled.

## Installing the Chart

To install the chart wil release name `my-release`:

``` console
$ helm install --name my-release ./devicehive
```

The command deploys DeviceHive on the Kubernetes cluster in the default configuration. The [configuration](#configuration) section lists the parameters that can be configured during installation.

> **Tip**: List all releases using `helm list`

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
`javaServer.image.repository` | DockerHub user or organization with all devicehive-java-server images | `devicehive`
`javaServer.image.tag` | Common image tag of devicehive-java-server images | `3.4.4`
`javaServer.pullPolicy` | Common image pull policy for devicehive-java-server images | `IfNotPresent`
`javaServer.auth.replicaCount` | Desired number of Auth service pods | `1`
`javaServer.auth.resources` | Auth service resource requests and limits | `{}`
`javaServer.backend.replicaCount` | Desired number of Backend service pods | `1`
`javaServer.backend.resources` | Backend service resource requests and limits | `{}`
`javaServer.frontend.replicaCount` | Desired number of Frontend service pods | `1`
`javaServer.frontend.resources` | Frontend service resource requests and limits  | `{}`
`javaServer.hazelcast.replicaCount` | Desired number of DeviceHive Hazelcast service pods | `1`
`javaServer.hazelcast.resources` | DeviceHive Hazelcast service resource requests and limits  | `{}`
`javaServer.plugin.enabled` | If true, DH Plugin service will be deployed | `false`
`javaServer.plugin.pluginConnectUrl` | | `""`
`javaServer.plugin.replicaCount` | Desired number of Plugin service pods | `1`
`javaServer.plugin.resources` | Plugin service resource requests and limits  | `{}`
`javaServer.bus` | Message bus access method, WS Proxy by default. Other option is `rpc` | `wsproxy`
`javaServer.jwtSecret` | JWT secret for signing JWT tokens. By default Helm generates random 16 characters string | `""`
`javaServer.kafka.name` | | `devicehive-bus`
`wsProxy.image` | DH WS Proxy image name and tag | `devicehive/devicehive-ws-proxy:1.1.0`
`wsProxy.pullPolicy` | DH WS Proxy image pull policy | `IfNotPresent`
`wsProxy.internal.replicaCount` | Desired number of internal WS Proxy service pods | `1`
`wsProxy.internal.resources` | Internal WS Proxy service resource requests and limits  | `{}`
`wsProxy.external.enabled` | If true, External WS Proxy deployment will be created. Requires `javaServer.plugin.enabled` set to `true` | `false`
`wsProxy.external.replicaCount` | Desired number of external WS Proxy service pods | `1`
`wsProxy.external.resources` | External WS Proxy service resource requests and limits | `{}`
`proxy.image` | DH Proxy image name and tag | `devicehive/devicehive-proxy:3.4.4`
`proxy.pullPolicy` | DH Proxy image pull policy | `IfNotPresent`
`proxy.resources` | DH Proxy service resource requests and limits | `{}`
`proxy.ingress.enabled` |If true, DH Proxy Ingress will be created | `false`
`proxy.ingress.annotations` | DH Proxy Ingress annotations | `{}` ###  kubernetes.io/ingress.class: nginx
`proxy.ingress.hosts` | DH Proxy server Ingress hostnames | `[]`
`postgresql.enabled` | | `true`
`postgresql.postgresDatabase` | Database name | `devicehivedb`
`postgresql.postgresUser` | Database user | `devicehive`
`postgresql.postgresPassword` | Database password | `devicehivepassword`
`postgresql.persistence.enabled` | Use a PVC to persist database | `true`
`postgresql.persistence.size` | Size of data volume | `1Gi`
`postgresql.imageTag` | `postgresql` chart image tag, if `postgresql.enabled` is `true` | `10`
`kafka.enabled` | | `true`

Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`. For example,

```console
$ helm install ./devicehive --name my-release \
    --set javaServer.frontend.replicaCount=3
```

Alternatively, a YAML file that specifies the values for the above parameters can be provided while installing the chart. For example,

```console
$ helm install ./devicehive --name my-release -f values.yaml
```

> **Tip**: You can use the default [values.yaml](values.yaml)

### RBAC Configuration
RBAC doesn't supported yet by this Helm chart.

### Ingress TLS
Ingress TLS doesn't supported yet by this Helm chart.
