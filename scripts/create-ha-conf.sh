#!/bin/sh

mkdir -p ./provision/loadbalancer/config

if [ $NUM_OF_LBS -gt 1 ]
then
	sed 's/$CLUSTER_IP/*/g' ./provision/loadbalancer/templates/haproxy.cfg > ./provision/loadbalancer/config/haproxy.cfg
fi 
if [ $NUM_OF_LBS -eq 1 ]
then
    sed 's/$CLUSTER_IP/'"$NODE_NETWORK_BASE$(($CLUSTER_IP))"'/g' ./provision/loadbalancer/templates/haproxy.cfg > ./provision/loadbalancer/config/haproxy.cfg
fi
if [ $NUM_OF_LBS -eq 0 ]
then
    sed 's/$CLUSTER_IP/*/g' ./provision/loadbalancer/templates/haproxy.cfg > ./provision/loadbalancer/config/haproxy.cfg
fi

sed -i 's/$CLUSTER_PORT/'"$CLUSTER_PORT"'/g' ./provision/loadbalancer/config/haproxy.cfg
sed 's/$CLUSTER_PORT/'"$CLUSTER_PORT"'/g' ./provision/loadbalancer/templates/haproxy.yaml > ./provision/loadbalancer/config/haproxy.yaml
sed 's/$CLUSTER_IP/'"$NODE_NETWORK_BASE$(($CLUSTER_IP))"'/g; s/$CLUSTER_PORT/'"$CLUSTER_PORT"'/g' ./provision/loadbalancer/templates/check_apiserver.sh > ./provision/loadbalancer/config/check_apiserver.sh
sed 's/$CLUSTER_IP/'"$NODE_NETWORK_BASE$(($CLUSTER_IP))"'/g' ./provision/loadbalancer/templates/keepalived.conf > ./provision/loadbalancer/config/keepalived.conf
cp ./provision/loadbalancer/keepalived.yaml ./provision/loadbalancer/config/keepalived.yaml 

for i in $(seq 0 $(($NUM_OF_MASTERS - 1)))
do
    echo "    server $MASTER_HOSTNAME_BASE-$i $NODE_NETWORK_BASE$(($MASTER_IP + $i)):$MASTER_PORT check fall 3 rise 2" >> ./provision/loadbalancer/config/haproxy.cfg
done