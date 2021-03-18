# go-k8s-server
Playing with k8s and golang

## Cluster Creation
```sh
kind create cluster --config .kube/kind.yaml
kubectl apply -k .kube/control/
kubectl config set-context --current --namespace=dev
```

## Nginx DNS
```sh
kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/master/deploy/static/provider/kind/deploy.yaml
kubectl wait --namespace ingress-nginx --for=condition=ready pod --selector=app.kubernetes.io/component=controller --timeout=90s
docker container inspect test-control-plane --format '{{ .NetworkSettings.Networks.kind.IPAddress }}'  
sudo vim /etc/hosts
```

## App Deployment
```sh
kubectl apply -k .kube/worker/
curl localhost/ping -H "Host: k8s.demo.local"
```