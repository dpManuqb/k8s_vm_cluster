#!/bin/sh
touch provision.log

echo $(date)": Updating..." >> provision.log
sudo apt-get update
sudo apt-get upgrade -y
sudo apt-get install -y net-tools
echo $(date)": End updating!" >> provision.log


echo $(date)": Installing kubernetes..." >> provision.log
sudo apt-get install -y apt-transport-https curl
sudo swapoff -a

sudo apt-get install -y kubelet kubeadm kubectl >> provision.log

sudo su
sudo sed -i '3 i Environment="KUBELET_EXTRA_ARGS=--node-ip '$NODE_IP'"' /etc/systemd/system/kubelet.service.d/10-kubeadm.conf >> provision.log
sudo echo 'ExecStartPre=/bin/sh -c "swapoff -a"' >> /etc/systemd/system/kubelet.service.d/10-kubeadm.conf
sudo systemctl daemon-reload >> provision.log
exit

sudo kubeadm config images pull >> provision.log
echo $(date)": Kubernetes installed!" >> provision.log

# echo $(date)": Initiating $HOSTNAME" >> provision.log
# sudo kubeadm init --control-plane-endpoint $NODE_IP:6443 --apiserver-advertise-address $NODE_IP --pod-network-cidr $POD_NETWORK >> provision.log

# mkdir -p $HOME/.kube >> provision.log
# sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config >> provision.log
# sudo chown $(id -u):$(id -g) $HOME/.kube/config >> provision.log

# kubectl apply -f "https://cloud.weave.works/k8s/net?k8s-version=$(kubectl version | base64 | tr -d '\n')&env.IPALLOC_RANGE=$POD_NETWORK" >> provision.log

# sudo kubeadm token create $(sudo kubeadm token generate) --print-join-command --ttl=0 >> worker-join.sh
# echo $(date)": $HOSTNAME initiated!" >> provision.log