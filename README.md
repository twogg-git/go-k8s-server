# go-k8s-server
Playing with k8s and golang

## Create the cluster
```sh
kind create cluster --config .kube/kind.yaml
kubectl apply -f .kube/control/namespace.yaml 
kubectl config set-context --current --namespace=dev
```

## Hub Docker Secret
```sh
kubectl create secret docker-registry twogg-registry \
  --docker-server=https://repo.team.birchbox.com:8080 \
  --docker-username=<docker_username> \
  --docker-password=<docker_password>

kubectl create secret docker-registry --dry-run=client twogg-registry \
--docker-server=<DOCKER_REGISTRY_SERVER> \
--docker-username=<DOCKER_USER> \
--docker-password=<DOCKER_PASSWORD> \
--docker-email=<DOCKER_EMAIL> -o yaml > docker-secret.yaml

```

## Nginx DNS Config
```sh
kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/master/deploy/static/provider/kind/deploy.yaml
kubectl wait --namespace ingress-nginx --for=condition=ready pod --selector=app.kubernetes.io/component=controller --timeout=90s
```

kubectl apply -f cluster/worker/deployment.yaml
kubectl apply -f cluster/worker/service.yaml
kubectl apply -f cluster/worker/ingress.yaml 
kubectl port-forward server-86685d97c9-jdx9k 8080:8080 
curl 127.0.0.1:8080

curl localhost/server -H "Host: testing.twogg.com"