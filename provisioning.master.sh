#!/bin/sh

export $(grep -v '^#' /home/vagrant/.env | xargs)

apt-get update
apt-get upgrade -y
apt-get install -y net-tools

apt-get install -y docker.io
cat <<EOT >> /etc/docker/daemon.json
{
  "exec-opts": ["native.cgroupdriver=systemd"]
}
EOT
systemctl restart docker

apt-get install -y apt-transport-https curl
curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add -
cat <<EOF | sudo tee /etc/apt/sources.list.d/kubernetes.list
deb https://apt.kubernetes.io/ kubernetes-xenial main
EOF
swapoff -a

apt-get update
apt-get install -y kubelet kubeadm kubectl

echo 'ExecStartPre=/bin/sh -c "swapoff -a"' >> /etc/systemd/system/kubelet.service.d/10-kubeadm.conf
systemctl daemon-reload

kubeadm init --control-plane-endpoint 192.168.0.10:6443 --pod-network-cidr 10.0.0.0/24

export KUBECONFIG=/etc/kubernetes/admin.conf

kubectl apply -f /home/vagrant/weavenet.yaml