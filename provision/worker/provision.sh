#!/bin/sh

echo "Waiting Master to be ready..."
READY=$(ssh -oStrictHostKeyChecking=no $USER@$MASTER_IP 'tail -1 /home/vagrant/provision.log')
while [ "$READY" != "MasterReady" ]
do
  sleep 15
  READY=$(ssh $USER@$MASTER_IP 'tail -1 /home/vagrant/provision.log')
done

scp $USER@$MASTER_IP:/home/vagrant/worker-join.sh .
chmod +x worker-join.sh
sudo ./worker-join.sh

rm pre.sh common.sh provision.sh worker-join.sh