# KinD and Working K8s Locally

https://kind.sigs.k8s.io/

KinD is a tool for running local Kubernetes clusters using Docker container “nodes”. kind was primarily designed for testing Kubernetes itself, but may be used for local development or CI.

<img src="https://d33wubrfki0l68.cloudfront.net/d0c94836ab5b896f29728f3c4798054539303799/9f948/logo/logo.png" width="300">

## Requirements
- Docker Desktop https://docs.docker.com/desktop/
- Hub Docker account https://hub.docker.com/


## Kubernetes 101
- Pod: The smallest and simplest unit that you create or deploy in Kubernetes. A pod encapsulates one or more containers, storage resources, a unique network IP address, and options that govern how the containers should run.

- Deployment: Can be viewed as an application encapsulating pods. It can contain one or more pods. Each pod has the same role, and the system automatically distributes requests to the pods of a Deployment.

- Service: Used for pod access. With a fixed IP address, a Service forwards access traffic to pods and performs load balancing for these pods.

- Ingress: Services forward requests based on Layer 4 TCP and UDP protocols. Ingresses can forward requests based on Layer 7 HTTPS and HTTPS protocols and make forwarding more targeted by domain names and paths.

<img src="https://raw.githubusercontent.com/twogg-git/talks/master/resources/kubernetes_objects.png" width="800">

## Describing a Kubernetes object
Here's an example .yaml file that shows the required fields and object spec for a Kubernetes Deployment:

```sh
apiVersion: extensions/v1beta1
kind: Pod
metadata:
  name: k8slatest
spec:
  replicas: 1
  template:  
    metadata:  
      labels:  
        env: k8slatest
    spec:
      containers:
        - image: twogghub/k8s-workshop:1.1-rolling
          imagePullPolicy: Always
          name: k8slatest
          ports:
          - name: http
            containerPort: 8080
```

```sh
apiVersion: extensions/v1beta1
kind: Deployment
metadata:
  name: k8sprod
spec:
  replicas: 2
  strategy:
    type: RollingUpdate
    rollingUpdate:
      maxSurge: 1
      maxUnavailable: 1
  template:  
    metadata:  
      labels:  
        env: prod
    spec:
      containers:
        - image: twogghub/k8s-workshop:1.2-yaml
          name: k8sprod
          ports:
          - name: http
            containerPort: 8080
```

## Cluster Creation
```sh
kind create cluster --config k8s/kind.yaml
kubectl apply -k k8s/control/
kubectl config set-context --current --namespace=dev
```

## Nginx DNS
```sh
kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/master/deploy/static/provider/kind/deploy.yaml
kubectl wait --namespace ingress-nginx --for=condition=ready pod --selector=app.kubernetes.io/component=controller --timeout=90s
```

## App Deployment
```sh
kubectl apply -k k8s/worker/
curl localhost/ping -H "Host: k8s.demo.local"
```

## Working with Golang
```sh
go run main.go
curl 127.0.0.1:8080/test
```

## Testing in Docker
```sh
docker build . -t twogghub/goserver:v1.2
docker run --name server -d -p 8080:8080 twogghub/goserver:v1.2
curl 127.0.0.1:8080/test
docker rm -f server
docker push twogghub/goserver:v1.2
```

## Deploying into the Cluster
```sh
kubectl apply -f k8s/deployment.yaml 
curl localhost/test -H "Host: k8s.demo.local"
```


