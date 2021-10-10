#!/bin/sh

CLUSTER_IP=$NODE_NETWORK_BASE$NODE_IP_START

#ssh -oStrictHostKeyChecking=no vagrant@$CLUSTER_IP "sudo cat /etc/kubernetes/admin.conf" >> kubeconfig
ssh -oStrictHostKeyChecking=no vagrant@$CLUSTER_IP "sudo cat /etc/kubernetes/admin.conf" > ~/.kube/config
