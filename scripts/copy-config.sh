#!/bin/sh

MASTER_IP=$NODE_NETWORK_BASE$(($NODE_IP_START + $NUM_OF_LBS))

#ssh -oStrictHostKeyChecking=no vagrant@$MASTER_IP "sudo cat /etc/kubernetes/admin.conf" > kubeconfig
ssh -oStrictHostKeyChecking=no vagrant@$MASTER_IP "sudo cat /etc/kubernetes/admin.conf" > ~/.kube/config
