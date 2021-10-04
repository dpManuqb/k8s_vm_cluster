#!/bin/sh

echo "Waiting Master to be ready..."
READY=$(ssh -oStrictHostKeyChecking=no $USER@$MASTER_IP 'tail -1 /home/vagrant/provision.log')
while [ "$READY" != "MasterReady" ]
do
  sleep 15
  READY=$(ssh $USER@$MASTER_IP 'tail -1 /home/vagrant/provision.log')
done

scp $USER@$MASTER_IP:/home/vagrant/master-join.sh .
chmod +x master-join.sh
sudo ./master-join.sh

rm pre.sh common.sh provision.sh master-join.sh