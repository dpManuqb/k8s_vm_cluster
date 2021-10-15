#!/bin/sh

chmod 600 /home/vagrant/.ssh/id_rsa

sudo apt-get update
sudo apt-get upgrade -y

sudo apt-get install -y haproxy

cat config/haproxy.cfg | sudo tee -a /etc/haproxy/haproxy.cfg

if [ $NUM_OF_LBS -gt 1 ]
then
    sudo apt-get install -y keepalived 

	sudo mv config/check_apiserver.sh /etc/keepalived/check_apiserver.sh
    sudo mv config/keepalived.conf /etc/keepalived/keepalived.conf
    
    sudo systemctl enable --now keepalived
fi

sudo systemctl enable haproxy && sudo systemctl restart haproxy

echo "LoadbalancerReady"