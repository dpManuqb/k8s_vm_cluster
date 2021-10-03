#!/bin/sh

mkdir -p ssh
touch provision/master/authorized_keys

for i in $(seq 1 $KUBERNETES_NUM_OF_WORKERS)
do
    mkdir -p ssh/$i
    ssh-keygen -t rsa -f ssh/$i/id_rsa -C "worker-$i" -N ""
    cat ssh/$i/id_rsa.pub >> provision/master/authorized_keys
done