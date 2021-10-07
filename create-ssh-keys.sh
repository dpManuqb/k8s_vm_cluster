#!/bin/sh

mkdir -p ssh

for i in $(seq 0 `expr $NUM_OF_WORKERS - 1`)
do
    mkdir -p ssh/worker_$i
    ssh-keygen -t rsa -q -f ssh/worker_$i/id_rsa -C "worker-$i" -N ""
    cat ssh/worker_$i/id_rsa.pub >> provision/master/authorized_keys
done