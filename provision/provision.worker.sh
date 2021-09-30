#!/bin/sh
touch provision.log

echo $(date)": Updating..." >> provision.log
sudo apt-get update
sudo apt-get upgrade -y
sudo apt-get install -y net-tools
echo $(date)": End updating!" >> provision.log

echo $(date)": Intalling docker..." >> provision.log
sudo apt-get install -y docker.io
cat /home/vagrant/provision/daemon.json | sudo tee /etc/docker/daemon.json
sudo systemctl restart docker
echo $(date)": Docker installed!" >> provision.log

echo $(date)": Installing kubernetes..." >> provision.log
sudo apt-get install -y apt-transport-https curl
sudo swapoff -a

sudo apt-get update
sudo apt-get install -y kubelet kubeadm kubectl

sudo sed -i '3 i Environment="KUBELET_EXTRA_ARGS=--node-ip '$NODE_IP'"' /etc/systemd/system/kubelet.service.d/10-kubeadm.conf
sudo echo 'ExecStartPre=/bin/sh -c "swapoff -a"' >> /etc/systemd/system/kubelet.service.d/10-kubeadm.conf
sudo systemctl daemon-reload

sudo kubeadm config images pull
echo $(date)": Kubernetes installed!" >> provision.log

echo $(date)": Initiating $HOSTNAME" >> provision.log
sudo apt-get install sshpass
sshpass -p $PASSWORD scp -oStrictHostKeyChecking=no $USER@$MASTER_IP:/home/vagrant/worker-join.sh .
chmod +x worker-join.sh
./worker-join.sh
echo $(date)": $HOSTNAME joined the cluster!" >> provision.log