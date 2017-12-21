# DeviceHive on Kubernetes
We provide two variants of deployment: minicube and Google Container Engine (GKE). They are different in the way Zookeeper and Kafka are deployed -- single node or clustered.

## Minikube installation
### Requirements
- Kubernetes version 1.5 (due to issues in later version described below).
- Minikube version 0.18.0
- 4GB RAM in Minikube VM for full DeviceHive stack.

Kubernetes 1.6.4 in Minikube has issue with [pod trying to access itself via Service IP](https://kubernetes.io/docs/tasks/debug-application-cluster/debug-service/#a-pod-cannot-reach-itself-via-service-ip). So we stick to Kubernetes 1.5.3 in Minikube.

Also the latest version of Minikube (0.19.1 at the moment) uses advanced syntax for deploying DNS addon, which is not supported in Kubernetes 1.5. For details see related section of [Kubernetes changelog](https://github.com/kubernetes/kubernetes/blob/master/CHANGELOG.md#configmap) and [PR #39981](https://github.com/kubernetes/kubernetes/pull/39981). This new functionality is used since Minikube 0.19 in [kube-dns deployment](https://github.com/kubernetes/minikube/blob/v0.19.0/deploy/addons/kube-dns/kube-dns-controller.yaml#L44). Minikube version 0.18.0 works fine with Kubernetes 1.5.3.

1. Install [Minikube 0.18.0](https://github.com/kubernetes/minikube/releases/tag/v0.18.0) and [Kubectl](https://kubernetes.io/docs/tasks/tools/install-kubectl/).

2. Configure Minikube:
```
minikube config set kubernetes-version v1.5.3
minikube config set memory 4096
```

3. Start Minikube
```
minikube start
```

### DeviceHive Installation in Minikube
1. Install PostgreSQL:
```
kubectl apply -f postgresql-ephemeral.yaml
```

2. Install Zookeeper and Kafka:
```
kubectl apply -f kafka-zk-ephemeral.yaml
```

3. Install DeviceHive services:
```
kubectl apply -f devicehive.yaml
```

4. Create service for Admin console:
In Minikube service can be exposed to outer world only be NodePort.
```
kubectl apply -f dh-proxy-svc-nodeport.yaml
```

### Accessing DeviceHive
1. Get Minikube address for `dh-proxy` service:
```
$ minikube service dh-proxy --url
http://192.168.99.106:31360
```

2. Open Admin Console in browser:

http://192.168.99.106:31360/admin

## Google Container Engine (GKE)
### Requirements
- Kubernetes version >=1.6
- [Helm](https://helm.sh/) package mananger
- Zookeeper (from incubator/kafka Helm Chart) requests at least 4Gi memory per cluster node. You should create cluster with at least n1-standard-2 machines.

### DeviceHive Installation in GKE

1. Create kubernetes cluster:
```
gcloud container clusters create "devicehive-cluster-1" \
  --zone "us-central1-a" \
  --machine-type "n1-standard-2" \
  --image-type "COS" \
  --num-nodes "3" \
  --network "default"
```

2. Install Kafka to cluster:
```
helm init
helm repo update
helm repo add incubator https://kubernetes-charts-incubator.storage.googleapis.com
helm install \
  --name dh-bus \
  --version 0.2.5 \
  --set storage=20Gi \
  --set resources.requests.cpu=200m \
  --set resources.requests.memory=1024Mi \
  --set resources.limits.cpu=500m \
  --set resources.limits.memory=1536Mi \
  incubator/kafka
```

3. Install PostgreSQL to cluster:
```
helm install \
  --name dh-db \
  --version 0.8.4 \
  --set imageTag=10 \
  --set postgresUser=devicehive \
  --set postgresPassword=devicehivepassword \
  --set postgresDatabase=devicehivedb \
  --set persistence.size=1Gi \
  stable/postgresql
```

4. Deploy DeviceHive:
```
kubectl apply -f devicehive.yaml
```

5. Create service for Admin console:
In GKE we export service using load balancer:
```
kubectl apply -f dh-proxy-svc-loadbalancer.yaml
```

### Verifying installation
To verify if all services are started, check that current number of replicas in deployments is equal to desired:
```
kubectl get deploy
NAME                  DESIRED   CURRENT   UP-TO-DATE   AVAILABLE   AGE
dh-proxy              1         1         1            1           37m
dh-backend            1         1         1            1           37m
dh-frontend           1         1         1            1           37m
```

### Accessing DeviceHive
1. Get external IP for `dh-proxy` service:
```
kubectl get svc dh-proxy
NAME       CLUSTER-IP      EXTERNAL-IP      PORT(S)        AGE
dh-proxy   10.79.242.246   104.155.147.92   80:32211/TCP   32m
```

2. Open it in browser:

http://104.155.147.92/admin
