# level2
GCP | Kubernetes | Kubeadm | Jenkins | CI/CD | Prometheus | Grafana

```
gcloud compute instances create my-kube-master --image-family ubuntu-1804-lts --image-project gce-uefi-images --custom-cpu 2 --custom-memory 4096MB
gcloud compute instances create my-kube-worker-01 --image-family ubuntu-1804-lts --image-project gce-uefi-images --custom-cpu 2 --custom-memory 4096MB

gcloud compute instances list

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

kubectl apply -f https://raw.githubusercontent.com/coreos/flannel/master/Documentation/kube-flannel.yml


kubeadm join 10.128.0.12:6443 --token d3b8pe.0kefb6irf3ay7hhu --discovery-token-ca-cert-hash sha256:63d15b92538a11a134a3387c772b569a7e1aa0ba006c8502753ab5ea0f6eb720


kubectl apply -f https://raw.githubusercontent.com/coreos/flannel/master/Documentation/kube-flannel.yml

```
Troubleshooting
```
sudo kubeadm reset
iptables -F && iptables -t nat -F && iptables -t mangle -F && iptables -X
```

####################################################################################################

2. Jenkins
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

gcloud compute firewall-rules create firewall-for-jenkins --allow tcp:8080 --source-tags=jenkins-server --source-ranges=0.0.0.0/0 --description="Open Port 8080"


http://35.238.43.16:8080
sudo cat /var/lib/jenkins/secrets/initialAdminPassword
Install suggested plugins
Jenkins is Ready

Create pipeline and verified the working.
File - Jenkinsfile

```
```
####################################################################################################

3. Created development namespace

kubectl create ns development

####################################################################################################


4. Deployed app using pipeline in jenkins

####################################################################################################

5. Configured Helm

kubectl -n kube-system create serviceaccount tiller
kubectl create clusterrolebinding tiller --clusterrole cluster-admin --serviceaccount=kube-system:tiller
helm init --service-account tiller
kubectl get pods --namespace kube-system

sample

helm install stable/kubernetes-dashboard --name dashboard-demo
helm upgrade dashboard-demo stable/kubernetes-dashboard --set fullnameOverride="dashboard"
helm rollback dashboard-demo 1
helm delete dashboard-demo
helm list --deleted
helm delete dashboard-demo --purge

Create MY Helm
helm create my-app
cp deployments/web-domain-ingress.yaml my-app/templates/ingress.yaml
cp deployments/email-app-deployment.yaml my-app/templates/deployment.yaml
cp deployments/email-app-service.yaml my-app/templates/service.yaml


helm install stable/traefik --name my-traefik --namespace kube-system

kubectl edit svc my-traefik --namespace kube-system


helm install  --name my-email-app-deploy my-app/ --namespace development --dry-run --debug
####################################################################################################

6. Configured Helm to deploy from CI server to Cluster

####################################################################################################

7. Created name space monitoring

kubectl create ns monitoring

####################################################################################################


8. Deploying prometheus in monitoring namespace

helm upgrade prometheus charts-master/stable/prometheus --namespace monitoring
kubectl apply -f grafana-config.yaml

 helm install stable/grafana -f monitoring/grafana/values.yml --namespace monitoring --name grafana
 helm install stable/grafana -f grafana-values.yaml --namespace monitoring --name grafana

kubectl get secret --namespace monitoring grafana -o jsonpath="{.data.admin-password}" | base64 --decode ; echo



kubectl patch svc "grafana" --namespace "monitoring" -p '{"spec": {"type": "LoadBalancer"}}'
 
####################################################################################################
```


