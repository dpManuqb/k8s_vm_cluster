#!/bin/sh

for i in $(seq 1 $(echo "$VARIABLES," | tr -dc ',' | wc -c)); do
    export $(echo $VARIABLES | cut -d, -f$i)
done

echo $(date)": Intalling docker..." >> provision.log
sudo apt-get install -y docker.io
cat /home/vagrant/provision/daemon.json | sudo tee /etc/docker/daemon.json
sudo systemctl restart docker
echo $(date)": Docker installed!" >> provision.log

curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add -
cat /home/vagrant/provision/kubernetes.list | sudo tee /etc/apt/sources.list.d/kubernetes.list

echo "\nProvisioning $HOSTNAME in background..."

chmod +x /home/vagrant/provision/$PROVISION_FILE
nohup /home/vagrant/provision/$PROVISION_FILE &