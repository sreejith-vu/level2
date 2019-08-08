# level2
GCP | Kubernetes | Kubeadm | CI/CD | Prometheus


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


Troubleshooting
sudo kubeadm reset
iptables -F && iptables -t nat -F && iptables -t mangle -F && iptables -X
