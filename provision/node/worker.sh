#!/bin/sh

echo "Waiting Master to be ready..."
READY=$(ssh -oStrictHostKeyChecking=no $USER@$MASTER_IP 'grep AllMasterReady /home/vagrant/provision.log | head -1')
while [ "$READY" != "AllMasterReady" ]
do
  sleep 10
  READY=$(ssh $USER@$MASTER_IP 'grep AllMasterReady /home/vagrant/provision.log | head -1')
done

scp $USER@$MASTER_IP:/home/vagrant/worker-join.sh .
chmod +x worker-join.sh
sudo ./worker-join.sh

#rm -f pre.sh common.sh provision.sh worker-join.sh