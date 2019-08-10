# level2
GCP | Kubernetes | Kubeadm | Jenkins | CI/CD | Prometheus | Grafana

Creating Kubernete Cluster - Master and Worker Node
```
gcloud compute instances create my-kube-master --image-family ubuntu-1804-lts --image-project gce-uefi-images --custom-cpu 2 --custom-memory 4096MB
gcloud compute instances create my-kube-worker-01 --image-family ubuntu-1804-lts --image-project gce-uefi-images --custom-cpu 2 --custom-memory 4096MB

gcloud compute instances list
```
Installing requirements in both Instances
```
apt-get update && apt-get install -y apt-transport-https curl 
curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add -
cat <<EOF >/etc/apt/sources.list.d/kubernetes.list 
deb https://apt.kubernetes.io/ kubernetes-xenial main
EOF
apt-get update
apt-get install -y kubelet kubeadm kubectl
apt-mark hold kubelet kubeadm kubectl

apt install docker.io
systemctl enable docker.service

kubeadm init

mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config

kubeadm join 10.128.0.12:6443 --token d3b8pe.0kefb6irf3ay7hhu --discovery-token-ca-cert-hash sha256:63d15b92538a11a134a3387c772b569a7e1aa0ba006c8502753ab5ea0f6eb720

kubectl apply -f https://raw.githubusercontent.com/coreos/flannel/master/Documentation/kube-flannel.yml
```

Troubleshooting - In between ran into some issues so done reset on clusters
```
sudo kubeadm reset
iptables -F && iptables -t nat -F && iptables -t mangle -F && iptables -X
```

####################################################################################################

2. Creating VM for Jenkins and Setting up Environment
```
gcloud compute instances create jenkins-server --image-family ubuntu-1804-lts --image-project gce-uefi-images --custom-cpu 1 --custom-memory 1024MB

gcloud compute ssh jenkins-server

sudo apt update
sudo apt install openjdk-8-jdk
wget -q -O - https://pkg.jenkins.io/debian/jenkins.io.key | sudo apt-key add -
sudo sh -c 'echo deb http://pkg.jenkins.io/debian-stable binary/ > /etc/apt/sources.list.d/jenkins.list'
sudo apt update
sudo apt install jenkins
systemctl status jenkins
```

Enabling port for Jenkins
```
gcloud compute firewall-rules create firewall-for-jenkins --allow tcp:8080 --source-tags=jenkins-server --source-ranges=0.0.0.0/0 --description="Open Port 8080"
````
Successfully configured Jenkins
```
http://35.238.43.16:8080
sudo cat /var/lib/jenkins/secrets/initialAdminPassword
Install suggested plugins
Jenkins is Ready
```

3. Created development namespace
```
kubectl create ns development
```

4. Deployed app using pipeline in jenkins
```
Created Pipeline and verified its working fine.
Logs are there in the files:

```

5. Configured Helm and Tiller and Installed Traefik 
```
kubectl -n kube-system create serviceaccount tiller
kubectl create clusterrolebinding tiller --clusterrole cluster-admin --serviceaccount=kube-system:tiller
helm init --service-account tiller
kubectl get pods --namespace kube-system
helm install stable/traefik --name my-traefik --namespace kube-system
kubectl edit svc my-traefik --namespace kube-system
```

6. Configured Helm to deploy from CI server to Cluster
Created my helm repo in root directory
```
helm create my-app

cp deployments/web-domain-ingress.yaml my-app/templates/ingress.yaml
cp deployments/email-app-deployment.yaml my-app/templates/deployment.yaml
cp deployments/email-app-service.yaml my-app/templates/service.yaml

helm install  --name my-email-app-deploy my-app/ --namespace development --dry-run --debug

helm upgrade my-email-app-deploy my-app/ --namespace development
```

7. Created name space monitoring
```
kubectl create ns monitoring
```

8. Deploying prometheus in monitoring namespace
```
helm upgrade prometheus charts-master/stable/prometheus --namespace monitoring

kubectl apply -f grafana-config.yaml

helm install stable/grafana -f grafana-values.yaml --namespace monitoring --name grafana

kubectl get secret --namespace monitoring grafana -o jsonpath="{.data.admin-password}" | base64 --decode ; echo

kubectl patch svc "grafana" --namespace "monitoring" -p '{"spec": {"type": "LoadBalancer"}}'
```
 
9 visualize grafana


10 EFK
```
helm repo add akomljen-charts https://raw.githubusercontent.com/komljen/helm-charts/master/charts/

helm install --name es-operator --namespace monitoring akomljen-charts/elasticsearch-operator
  
helm install --name efk --namespace monitoring akomljen-charts/efk
```


