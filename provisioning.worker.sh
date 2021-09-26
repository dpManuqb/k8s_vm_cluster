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


