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
kubectl create -f postgresql-ephemeral.yaml
```

2. Install Zookeeper and Kafka:
```
kubectl create -f kafka-zk-ephemeral.yaml
```

3. Install DeviceHive services:
```
kubectl create -f devicehive.yaml
```

4. Create service for Admin console:
In Minikube service can be exposed to outer world only be NodePort.
```
kubectl create -f admin-console-svc-nodeport.yaml
```

### Accessing DeviceHive
1. Get Minikube address for `dh-admin` service:
```
$ minikube service dh-admin --url
http://192.168.99.106:31360
```

2. Open Admin Console in browser:

http://192.168.99.106:31360/admin

## Google Container Engine (GKE)
### Requirements
- Kubernetes version >=1.6
- [Helm](https://helm.sh/) package mananger
- Zookeeper (from incubator/kafka Helm Chart) requests at least 4Gi memory per cluster node. You should create cluster with at least n1-standard-2 machines.

### DeviceHive Installation in Minikube

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
helm repo add incubator http://storage.googleapis.com/kubernetes-charts-incubator
helm install --name kafka incubator/kafka
```

3. Install PostgreSQL to cluster:
```
helm install --name postgres \
  --set imageTag=9.6,postgresUser=devicehive,postgresPassword=devicehivepassword,postgresDatabase=devicehivedb \
  stable/postgresql
```

4. Deploy DeviceHive:
```
kubectl create -f devicehive.yaml
```

5. Create service for Admin console:
In GKE we export service using load balancer:
```
kubectl create -f admin-console-svc-loadbalancer.yaml
```

### Verifying installation
To verify if all services are started, check that current number of replicas in deployments is equal to desired:
```
kubectl get deploy
NAME                  DESIRED   CURRENT   UP-TO-DATE   AVAILABLE   AGE
dh-admin              1         1         1            1           37m
dh-backend            3         3         3            3           37m
dh-frontend           3         3         3            3           37m
```

### Accessing DeviceHive
1. Get external IP for `dh-admin` service:
```
kubectl get svc dh-admin
NAME       CLUSTER-IP      EXTERNAL-IP      PORT(S)        AGE
dh-admin   10.79.242.246   104.155.147.92   80:32211/TCP   32m
```

2. Open it in browser:

http://104.155.147.92/admin
