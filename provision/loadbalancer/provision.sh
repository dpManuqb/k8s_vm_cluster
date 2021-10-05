#!/bin/sh

sudo apt-get update
sudo apt-get upgrade -y

sudo apt-get install -y haproxy

sudo mv haproxy.cfg /etc/haproxy/haproxy.cfg

systemctl restart haproxy