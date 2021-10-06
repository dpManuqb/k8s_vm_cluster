#!/bin/sh

sed 's/$CLUSTER_IP/'"$KUBERNETES_NODE_NETWORK_BASE$KUBERNETES_NODE_IP_START"'/' ./provision/loadbalancer/haproxy-template.cfg >> ./provision/loadbalancer/haproxy.cfg

for i in $(seq 0 `expr $KUBERNETES_NUM_OF_MASTERS - 1`)
do
    echo "    server $KUBERNETES_MASTER_HOSTNAME_BASE-$i $KUBERNETES_NODE_NETWORK_BASE`expr $KUBERNETES_NODE_IP_START + $i + 1`:6443 check fall 3 rise 2" >> ./provision/loadbalancer/haproxy.cfg
done