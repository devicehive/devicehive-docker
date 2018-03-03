Before releasing new devicehive-docker version, Kubernetes installation procedure via Helm is tested in following configurations:

1. New installation without specifying parameters
2. Upgrade from the previous Chart release
3. New installation with external Kafka/ZK and PostgreSQL
4. Upgrade of the previous installation with external Kafka/ZK and PostgreSQL

## Installation of third party dependencies on Kubernetes with Helm
### Init Helm in new cluster
``` console
helm init
helm repo update
helm repo add incubator https://kubernetes-charts-incubator.storage.googleapis.com
```

### Install Kafka to cluster:
``` console
helm install \
  --name dh-bus \
  --version 0.2.13 \
  --set storage=20Gi \
  --set resources.requests.cpu=200m \
  --set resources.requests.memory=1024Mi \
  --set resources.limits.cpu=500m \
  --set resources.limits.memory=1536Mi \
  incubator/kafka
```

### Install PostgreSQL to cluster:
``` console
helm install \
  --name dh-db \
  --version 0.8.12 \
  --set imageTag=10 \
  --set postgresUser=devicehive \
  --set postgresPassword=devicehivepassword \
  --set postgresDatabase=devicehivedb \
  --set persistence.size=1Gi \
  stable/postgresql
```
