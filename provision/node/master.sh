#!/bin/sh

echo "Waiting Master to be ready..."
READY=$(ssh -oStrictHostKeyChecking=no $USER@$MASTER_IP 'grep MasterReady /home/vagrant/provision.log | head -1')
while [ "$READY" != "MasterReady" ]
do
  sleep 10
  READY=$(ssh $USER@$MASTER_IP 'grep MasterReady /home/vagrant/provision.log | head -1')
done

scp $USER@$MASTER_IP:/home/vagrant/master-join.sh .
sed -i '${s/$/ --apiserver-advertise-address='"$NODE_IP"'/}' master-join.sh 
chmod +x master-join.sh
sudo ./master-join.sh

#rm -f pre.sh common.sh provision.sh master-join.sh