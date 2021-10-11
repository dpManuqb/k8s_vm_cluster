#!/bin/sh

sed 's/$LB_IP/'"$NODE_NETWORK_BASE$NODE_IP_START"'/' ./provision/loadbalancer/haproxy-template.cfg > ./provision/loadbalancer/haproxy.cfg

for i in $(seq 0 $(($NUM_OF_MASTERS - 1)))
do
    echo "    server $MASTER_HOSTNAME_BASE-$i $NODE_NETWORK_BASE$(($NODE_IP_START + $i + 1)):6443 check fall 3 rise 2" >> ./provision/loadbalancer/haproxy.cfg
done