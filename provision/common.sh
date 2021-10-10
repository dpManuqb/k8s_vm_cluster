#!/bin/sh

sudo apt-get update
sudo apt-get upgrade -y

sudo ufw disable

sudo modprobe br_netfilter
sudo modprobe overlay

cat <<EOF | sudo tee /etc/modules-load.d/k8s.conf
br_netfilter
overlay
EOF

cat <<EOF | sudo tee /etc/sysctl.d/k8s.conf
net.bridge.bridge-nf-call-iptables = 1
net.bridge.bridge-nf-call-ip6tables = 1
net.ipv4.ip_forward = 1
net.ipv6.ip_forward
EOF
sudo sysctl --system

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

sudo sed -i '/swap/d' /etc/fstab  
sudo swapoff -a

sudo apt-get update
sudo apt-get install -y kubelet kubeadm kubectl

sudo sed -i '/^\[Service\].*/a Environment="KUBELET_EXTRA_ARGS=--node-ip '$NODE_IP'"' /etc/systemd/system/kubelet.service.d/10-kubeadm.conf
sudo sed -i '0,/ExecStart=/s//ExecStartPre=\/bin\/sh -c "sudo swapoff -a"\n&/' /etc/systemd/system/kubelet.service.d/10-kubeadm.conf
sudo systemctl daemon-reload

sudo kubeadm config images pull