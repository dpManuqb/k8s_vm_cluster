#!/bin/sh

mkdir -p ssh
touch provision/master_primary/authorized_keys

for i in $(seq 0 `expr $KUBERNETES_NUM_OF_WORKERS - 1`)
do
    mkdir -p ssh/worker_$i
    ssh-keygen -t rsa -f ssh/worker_$i/id_rsa -C "worker-$i" -N ""
    cat ssh/worker_$i/id_rsa.pub >> provision/master_primary/authorized_keys
done

for i in $(seq 1 `expr $KUBERNETES_NUM_OF_MASTERS - 1`)
do
    mkdir -p ssh/master_$i
    ssh-keygen -t rsa -f ssh/master_$i/id_rsa -C "master-$i" -N ""
    cat ssh/master_$i/id_rsa.pub >> provision/master_primary/authorized_keys
done