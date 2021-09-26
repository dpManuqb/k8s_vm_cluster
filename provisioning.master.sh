#!/bin/sh

sudo apt-get update
sudo apt-get upgrade -y
sudo apt-get install -y net-tools

sudo apt-get install -y docker.io
cat <<EOF | sudo tee /etc/docker/daemon.json
{
  "exec-opts": ["native.cgroupdriver=systemd"]
}
EOF
sudo systemctl restart docker

sudo apt-get install -y apt-transport-https curl
curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add -
cat <<EOF | sudo tee /etc/apt/sources.list.d/kubernetes.list
deb https://apt.kubernetes.io/ kubernetes-xenial main
EOF
sudo swapoff -a

sudo apt-get update
sudo apt-get install -y kubelet kubeadm kubectl

sudo echo 'ExecStartPre=/bin/sh -c "swapoff -a"' >> /etc/systemd/system/kubelet.service.d/10-kubeadm.conf
sudo systemctl daemon-reload

sudo kubeadm config images pull

#sudo kubeadm init --control-plane-endpoint 192.168.0.10:6443 --apiserver-advertise-address 192.168.0.10 --pod-network-cidr 10.0.0.0/23
sudo kubeadm init --control-plane-endpoint 192.168.1.10:6443 --apiserver-advertise-address 192.168.1.10 --pod-network-cidr 10.0.0.0/23

mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config

kubectl apply -f "https://cloud.weave.works/k8s/net?k8s-version=$(kubectl version | base64 | tr -d '\n')&env.IPALLOC_RANGE=10.0.0.0/23"
