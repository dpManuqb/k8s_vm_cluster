.EXPORT_ALL_VARIABLES:

IMAGE_NAME = bento/ubuntu-20.04
BRIDGE_INTERFACE = Intel(R) Wireless-AC 9560
#BRIDGE_INTERFACE = TP-Link Wireless USB Adapter

NODE_NETWORK_BASE = 192.168.1.
NODE_IP_START = 10

POD_NETWORK = 10.0.0.0/23
POD_NETWORK_MANAGER = weave #weave/calico

NUM_OF_LBS = 1
LB_VMNAME_BASE = loadbalancer
LB_HOSTNAME_BASE = loadbalancer
LB_CPU = 1
LB_MEM = 512

NUM_OF_MASTERS = 2
MASTER_VMNAME_BASE = master
MASTER_HOSTNAME_BASE = k8s-master
MASTER_CPU = 2
MASTER_MEM = 2048

NUM_OF_WORKERS = 1
WORKER_VMNAME_BASE = worker
WORKER_HOSTNAME_BASE = k8s-worker
WORKER_CPU = 1
WORKER_MEM = 512

create-ssh-keys:
	scripts/create-ssh-keys.sh

haproxy-conf:
	scripts/create-haproxy-conf.sh

wait-install:
	scripts/wait-install.sh

install: create-ssh-keys haproxy-conf run wait-install config

run:
	vagrant up

config: 
	scripts/copy-config.sh

halt:
	vagrant halt

delete:
	vagrant destroy -f && rm -f -r .vagrant ssh config provision/loadbalancer/haproxy.cfg
