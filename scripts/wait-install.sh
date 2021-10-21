#!/bin/sh

echo "Waiting Cluster to be ready..."
READY=$(ssh vagrant@$NODE_NETWORK_BASE$(($MASTER_IP)) 'tail -1 /home/vagrant/provision.log')
echo $READY
while [ "$(echo $READY | grep ClusterReady -o | head -1)" != "ClusterReady" ]
do
    sleep 10
    READY=$(ssh vagrant@$NODE_NETWORK_BASE$(($MASTER_IP)) 'tail -1 /home/vagrant/provision.log')
    echo $READY
done