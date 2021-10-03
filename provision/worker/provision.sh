#!/bin/sh

echo "Waiting Master to be ready..."
READY=$(ssh -oStrictHostKeyChecking=no $USER@$MASTER_IP 'tail -1 /home/vagrant/provision.log')
while [ "$READY" != "MasterReady" ]
do
  sleep 15
  READY=$(ssh -oStrictHostKeyChecking=no $USER@$MASTER_IP 'tail -1 /home/vagrant/provision.log')
done

scp -oStrictHostKeyChecking=no $USER@$MASTER_IP:/home/vagrant/worker-join.sh .
chmod +x worker-join.sh
sudo ./worker-join.sh
