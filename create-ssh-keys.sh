#!/bin/sh

mkdir -p ssh
touch provision/master_primary/authorized_keys

for i in $(seq 1 $KUBERNETES_NUM_OF_WORKERS)
do
    mkdir -p ssh/worker_$i
    ssh-keygen -t rsa -f ssh/worker_$i/id_rsa -C "worker-$i" -N ""
    cat ssh/worker_$i/id_rsa.pub >> provision/master_primary/authorized_keys
done

for i in $(seq 2 $KUBERNETES_NUM_OF_MASTERS)
do
    mkdir -p ssh/master_$i
    ssh-keygen -t rsa -f ssh/master_$i/id_rsa -C "master-$i" -N ""
    cat ssh/master_$i/id_rsa.pub >> provision/master_primary/authorized_keys
done