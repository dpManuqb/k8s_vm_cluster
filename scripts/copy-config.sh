#!/bin/sh

echo "Retrieving cluster config from master"
ssh -oStrictHostKeyChecking=no vagrant@$NODE_NETWORK_BASE$(($MASTER_IP)) "sudo cat /etc/kubernetes/admin.conf" > kubeconfig
#ssh -oStrictHostKeyChecking=no vagrant@$NODE_NETWORK_BASE$(($MASTER_IP)) "sudo cat /etc/kubernetes/admin.conf" > ~/.kube/config
echo "Done!"