#!/bin/sh

chmod 600 /home/vagrant/.ssh/id_rsa

sudo apt-get update
sudo apt-get upgrade -y

sudo apt-get install -y haproxy

cat haproxy.cfg | sudo tee -a /etc/haproxy/haproxy.cfg

sudo systemctl restart haproxy

echo "LoadbalancerReady"