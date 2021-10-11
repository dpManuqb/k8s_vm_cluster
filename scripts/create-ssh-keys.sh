#!/bin/sh

mkdir -p ssh

for i in $(seq 0 $(($NUM_OF_WORKERS - 1)))
do
    mkdir -p ssh/worker_$i
    ssh-keygen -t rsa -q -f ssh/worker_$i/id_rsa -C "worker-$i" -N ""
    cat ssh/worker_$i/id_rsa.pub >> provision/node/master/authorized_keys
done

for i in $(seq 0 $(($NUM_OF_MASTERS - 1)))
do
    mkdir -p ssh/master_$i
    ssh-keygen -t rsa -q -f ssh/master_$i/id_rsa -C "master-$i" -N ""
    cat ssh/master_$i/id_rsa.pub >> provision/node/master/authorized_keys
done

cp provision/node/master/authorized_keys provision/loadbalancer/authorized_keys