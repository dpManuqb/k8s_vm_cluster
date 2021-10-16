#!/bin/sh

if [ $NUM_OF_MASTERS -gt 1 ]
then
    if [ $NUM_OF_LBS -eq 0 ]
    then
        sudo mkdir -p /etc/haproxy /etc/keepalived /etc/kubernetes/manifests
        sudo mv config/haproxy.cfg /etc/haproxy/haproxy.cfg
        sudo mv config/keepalived.conf /etc/keepalived/keepalived.conf
        sudo mv config/check_apiserver.sh /etc/keepalived/check_apiserver.sh
        sudo mv config/haproxy.yaml /etc/kubernetes/manifests/haproxy.yaml
        sudo mv config/keepalived.yaml /etc/kubernetes/manifests/keepalived.yaml
    fi
fi

echo "Waiting Master to be ready..."
READY=$(ssh -oStrictHostKeyChecking=no $USER@$MASTER_IP 'grep MasterReady /home/vagrant/provision.log | head -1')
while [ "$READY" != "MasterReady" ]
do
  sleep 10
  READY=$(ssh $USER@$MASTER_IP 'grep MasterReady /home/vagrant/provision.log | head -1')
done

scp $USER@$MASTER_IP:/home/vagrant/master-join.sh .
sed -i '${s/$/ --apiserver-advertise-address '"$NODE_IP"' --apiserver-bind-port '"$MASTER_PORT"' --ignore-preflight-errors=DirAvailable--etc-kubernetes-manifests/}' master-join.sh 
chmod +x master-join.sh
sudo ./master-join.sh