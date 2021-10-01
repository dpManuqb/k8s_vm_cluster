#!/bin/sh
start=`date +%s`

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

sudo sed -i '3 i Environment="KUBELET_EXTRA_ARGS=--node-ip '$NODE_IP'"' /etc/systemd/system/kubelet.service.d/10-kubeadm.conf
sudo su
echo 'ExecStartPre=/bin/sh -c "swapoff -a"' >> /etc/systemd/system/kubelet.service.d/10-kubeadm.conf
exit
sudo systemctl daemon-reload

sudo kubeadm config images pull

sudo apt-get install sshpass

while [ "$READY" != "MasterReady" ]
do
  sleep 10
  READY=$(sshpass -p $PASSWORD ssh -oStrictHostKeyChecking=no $USER@$MASTER_IP 'tail -1 /home/vagrant/provision.log')
  echo "Waiting Master to be ready..."
done

sshpass -p $PASSWORD scp -oStrictHostKeyChecking=no $USER@$MASTER_IP:/home/vagrant/worker-join.sh .
chmod +x worker-join.sh
sudo ./worker-join.sh

end=`date +%s`
echo "$HOSTNAME provisioning ended in $((end-start))s"
