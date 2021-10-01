#!/bin/sh
KUBERNETES_NUM_OF_WORKERS=2

mkdir -p ssh
touch ssh/authorized_keys

for i in $(seq 1 $KUBERNETES_NUM_OF_WORKERS )
do
    mkdir -p ssh/$i
    ssh-keygen -t rsa -f ssh/$i/id_rsa -C "worker-$i" -N ""
    cat ssh/$i/id_rsa.pub >> ssh/authorized_keys
done