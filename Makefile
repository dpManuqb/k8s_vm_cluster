.EXPORT_ALL_VARIABLES:

NUM_OF_MASTERS = 1
MASTER_VMNAME_BASE = master
MASTER_HOSTNAME_BASE = k8s-master
MASTER_CPU = 2
MASTER_MEM = 2048

NUM_OF_WORKERS = 1
WORKER_VMNAME_BASE = worker
WORKER_HOSTNAME_BASE = k8s-worker
WORKER_CPU = 1
WORKER_MEM = 1024

NODE_NETWORK_BASE = 192.168.1.
NODE_IP_START = 10

POD_NETWORK = 10.0.0.0/23
POD_NETWORK_MANAGER = calico #weave/calico By now only works weave

IMAGE_NAME = bento/ubuntu-20.04
BRIDGE_INTERFACE = Intel(R) Wireless-AC 9560
#BRIDGE_INTERFACE = TP-Link Wireless USB Adapter

create-ssh-keys:
	create-ssh-keys.sh

install: create-ssh-keys
	vagrant up

run:
	vagrant up

config: 
	copy-config.sh

halt:
	vagrant halt

delete:
	vagrant destroy -f && rm -f -r .vagrant ssh config provision/master/authorized_keys
