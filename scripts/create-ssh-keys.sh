#!/bin/sh

mkdir -p ssh

for i in $(seq 0 $(($NUM_OF_LBS - 1)))
do
    mkdir -p ssh/lb_$i
    ssh-keygen -t rsa -q -f ssh/lb_$i/id_rsa -C "lb-$i" -N ""
    cat ssh/lb_$i/id_rsa.pub >> ssh/authorized_keys
done
for i in $(seq 0 $(($NUM_OF_MASTERS - 1)))
do
    mkdir -p ssh/master_$i
    ssh-keygen -t rsa -q -f ssh/master_$i/id_rsa -C "master-$i" -N ""
    cat ssh/master_$i/id_rsa.pub >> ssh/authorized_keys
done
for i in $(seq 0 $(($NUM_OF_WORKERS - 1)))
do
    mkdir -p ssh/worker_$i
    ssh-keygen -t rsa -q -f ssh/worker_$i/id_rsa -C "worker-$i" -N ""
    cat ssh/worker_$i/id_rsa.pub >> ssh/authorized_keys
done
echo "n" | ssh-keygen -t rsa -f $HOME/.ssh/id_rsa -N ""
cat $HOME/.ssh/id_rsa.pub >> ssh/authorized_keys

for i in $(seq 0 $(($NUM_OF_LBS - 1)))
do
    cp ssh/authorized_keys ssh/lb_$i/authorized_keys
done
for i in $(seq 0 $(($NUM_OF_MASTERS - 1)))
do
    cp ssh/authorized_keys ssh/master_$i/authorized_keys
done
for i in $(seq 0 $(($NUM_OF_WORKERS - 1)))
do
    cp ssh/authorized_keys ssh/worker_$i/authorized_keys
done