#This is simple wrapper script but not perfect.
#Better copy paste the commands manually.
#

gcloud compute instances create my-kube-master --image-family ubuntu-1804-lts --image-project gce-uefi-images --custom-cpu 2 --custom-memory 4096MB
gcloud compute instances create my-kube-worker-01 --image-family ubuntu-1804-lts --image-project gce-uefi-images --custom-cpu 2 --custom-memory 4096MB
gcloud compute instances create jenkins-server --image-family ubuntu-1804-lts --image-project gce-uefi-images --custom-cpu 1 --custom-memory 1024MB

gcloud compute instances list

gcloud compute ssh my-kube-master -- 'sudo apt-get update && apt-get install -y sudo apt-transport-https curl' 
gcloud compute ssh my-kube-master -- 'sudo curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add -'
gcloud compute ssh my-kube-master -- 'sudo echo "deb https://apt.kubernetes.io/ kubernetes-xenial main" >> /etc/apt/sources.list.d/kubernetes.list'
gcloud compute ssh my-kube-master -- 'sudo apt-get update'
gcloud compute ssh my-kube-master -- 'sudo apt-get install -y kubelet kubeadm kubectl'
gcloud compute ssh my-kube-master -- 'sudo apt-mark hold kubelet kubeadm kubectl'
gcloud compute ssh my-kube-master -- 'sudo apt install docker.io'
gcloud compute ssh my-kube-master -- 'sudo systemctl enable docker.service'

gcloud compute ssh my-kube-worker-01 -- 'sudo apt-get update && apt-get install -y sudo apt-transport-https curl' 
gcloud compute ssh my-kube-worker-01 -- 'sudo curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add -'
gcloud compute ssh my-kube-worker-01 -- 'sudo echo "deb https://apt.kubernetes.io/ kubernetes-xenial main" >> /etc/apt/sources.list.d/kubernetes.list'
gcloud compute ssh my-kube-worker-01 -- 'sudo apt-get update'
gcloud compute ssh my-kube-worker-01 -- 'sudo apt-get install -y kubelet kubeadm kubectl'
gcloud compute ssh my-kube-worker-01 -- 'sudo apt-mark hold kubelet kubeadm kubectl'
gcloud compute ssh my-kube-worker-01 -- 'sudo apt install docker.io'
gcloud compute ssh my-kube-worker-01 -- 'sudo systemctl enable docker.service'

gcloud compute ssh jenkins-server -- 'sudo apt update'
gcloud compute ssh jenkins-server -- 'sudo apt install openjdk-8-jdk'
gcloud compute ssh jenkins-server -- 'sudo wget -q -O - https://pkg.jenkins.io/debian/jenkins.io.key | sudo apt-key add -'
gcloud compute ssh jenkins-server -- 'sudo sh -c 'echo deb http://pkg.jenkins.io/debian-stable binary/ > /etc/apt/sources.list.d/jenkins.list''
gcloud compute ssh jenkins-server -- 'sudo apt update'
gcloud compute ssh jenkins-server -- 'sudo apt install jenkins'
gcloud compute ssh jenkins-server -- 'sudo systemctl status jenkins'

gcloud compute firewall-rules create firewall-for-jenkins --allow tcp:8080 --source-tags=jenkins-server --source-ranges=0.0.0.0/0 --description="Open Port 8080"

gcloud compute ssh my-kube-master -- 'sudo kubeadm init'

gcloud compute ssh my-kube-master -- 'mkdir -p $HOME/.kube'
gcloud compute ssh my-kube-master -- 'sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config'
gcloud compute ssh my-kube-master -- 'sudo chown $(id -u):$(id -g) $HOME/.kube/config'

#Please manually do node join
#kubeadm join 10.128.0.12:6443 --token d3b8pe.0kefb6irf3ay7hhu --discovery-token-ca-cert-hash sha256:63d15b92538a11a134a3387c772b569a7e1aa0ba006c8502753ab5ea0f6eb720

gcloud compute ssh my-kube-master -- 'kubectl apply -f https://raw.githubusercontent.com/coreos/flannel/master/Documentation/kube-flannel.yml'

gcloud compute ssh jenkins-server -- 'sudo cat /var/lib/jenkins/secrets/initialAdminPassword'
gcloud compute ssh jenkins-server -- 'curl ipinfo.io' #to get public ip

gcloud compute ssh my-kube-master -- 'kubectl create ns development'

gcloud compute ssh my-kube-master -- 'kubectl -n kube-system create serviceaccount tiller'
gcloud compute ssh my-kube-master -- 'kubectl create clusterrolebinding tiller --clusterrole cluster-admin --serviceaccount=kube-system:tiller'
gcloud compute ssh my-kube-master -- 'helm init --service-account tiller'
gcloud compute ssh my-kube-master -- 'kubectl get pods --namespace kube-system'
gcloud compute ssh my-kube-master -- 'helm install stable/traefik --name my-traefik --namespace kube-system'
gcloud compute ssh my-kube-master -- 'kubectl edit svc my-traefik --namespace kube-system'

gcloud compute ssh my-kube-master -- 'git@github.com:sreejith-vu/level2.git'
gcloud compute ssh my-kube-master -- 'cd level2 && helm create my-app'

gcloud compute ssh my-kube-master -- 'cp level2/deployments/web-domain-ingress.yaml level2/my-app/templates/ingress.yaml'
gcloud compute ssh my-kube-master -- 'cp level2/deployments/email-app-deployment.yaml level2/my-app/templates/deployment.yaml'
gcloud compute ssh my-kube-master -- 'cp level2/deployments/email-app-service.yaml level2/my-app/templates/service.yaml'

gcloud compute ssh my-kube-master -- 'helm install  --name my-email-app-deploy level2/my-app/ --namespace development --dry-run --debug'

gcloud compute ssh my-kube-master -- 'kubectl create ns monitoring'

gcloud compute ssh my-kube-master -- 'helm install --name prometheus charts-master/stable/prometheus --namespace monitoring'

gcloud compute ssh my-kube-master -- 'kubectl apply -f level2/grafana/config.yaml'

gcloud compute ssh my-kube-master -- 'helm install level2/stable/grafana -f level2/grafana/values.yaml --namespace monitoring --name grafana'

gcloud compute ssh my-kube-master -- 'kubectl get secret --namespace monitoring grafana -o jsonpath="{.data.admin-password}" | base64 --decode ; echo'

#gcloud compute ssh my-kube-master -- 'kubectl patch svc "grafana" --namespace "monitoring" -p '{"spec": {"type": "LoadBalancer"}}''
#or 
#kubectl edit svc grafana -n monitoring
#And update ClusterIP to NodePort
#gcloud compute firewall-rules create firewall-grafana --allow tcp:30024 --source-tags=my-kube-master --source-ranges=0.0.0.0/0 --description="Open Port 30024 for grafana"
 
gcloud compute ssh my-kube-master -- 'helm repo add akomljen-charts https://raw.githubusercontent.com/komljen/helm-charts/master/charts/'

gcloud compute ssh my-kube-master -- 'helm install --name es-operator --namespace monitoring akomljen-charts/elasticsearch-operator'
  
gcloud compute ssh my-kube-master -- 'helm install --name efk --namespace monitoring akomljen-charts/efk'

#Edit Kibana service and change to NodePort to get the UI.

