# KinD and Working K8s Locally

https://kind.sigs.k8s.io/

KinD is a tool for running local Kubernetes clusters using Docker container “nodes”. kind was primarily designed for testing Kubernetes itself, but may be used for local development or CI.

<img src="https://d33wubrfki0l68.cloudfront.net/d0c94836ab5b896f29728f3c4798054539303799/9f948/logo/logo.png" width="300">

## Requirements
- Docker Desktop https://docs.docker.com/desktop/
- Hub Docker account https://hub.docker.com/

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


