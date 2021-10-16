#!/bin/sh

echo "n" | ssh-keygen -t rsa -f $HOME/.ssh/id_rsa -N "\n"
cat $HOME/.ssh/id_rsa.pub | ssh -oStrictHostKeyChecking=no vagrant@$NODE_NETWORK_BASE$(($MASTER_IP)) "cat >> /home/vagrant/.ssh/authorized_keys"

echo "\nWaiting Cluster to be ready..."
READY=$(ssh vagrant@$NODE_NETWORK_BASE$(($MASTER_IP)) 'grep ClusterReady /home/vagrant/provision.log | head -1')
while [ "$READY" != "ClusterReady" ]
do
    sleep 10
    READY=$(ssh vagrant@$NODE_NETWORK_BASE$(($MASTER_IP)) 'grep ClusterReady /home/vagrant/provision.log | head -1')
done