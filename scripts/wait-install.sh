#!/bin/sh

MASTER_IP=$NODE_NETWORK_BASE$(($NODE_IP_START + $NUM_OF_LBS))

echo "Waiting Cluster to be ready..."
READY=$(ssh -oStrictHostKeyChecking=no $USER@$MASTER_IP 'grep ClusterReady /home/vagrant/provision.log | head -1')
while [ "$READY" != "ClusterReady" ]
do
  echo $(ssh -oStrictHostKeyChecking=no $USER@$MASTER_IP 'tail -10')
  sleep 10
  READY=$(ssh $USER@$MASTER_IP 'grep ClusterReady /home/vagrant/provision.log | head -1')
done


