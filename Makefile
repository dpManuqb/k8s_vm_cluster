.EXPORT_ALL_VARIABLES:

KUBERNETES_NUM_OF_MASTERS = 2
KUBERNETES_MASTER_VMNAME_BASE = master
KUBERNETES_MASTER_HOSTNAME_BASE = k8s-master
KUBERNETES_MASTER_CPU = 2
KUBERNETES_MASTER_MEM = 2048

KUBERNETES_NUM_OF_WORKERS = 2
KUBERNETES_WORKER_VMNAME_BASE = worker
KUBERNETES_WORKER_HOSTNAME_BASE = k8s-worker
KUBERNETES_WORKER_CPU = 3
KUBERNETES_WORKER_MEM = 4096

KUBERNETES_NODE_NETWORK = 192.168.0.0/24
KUBERNETES_NODE_IP_START = 10

KUBERNETES_POD_NETWORK = 10.0.0.0/23

IMAGE_NAME = bento/ubuntu-20.04
#BRIDGE_INTERFACE = Intel(R) Wireless-AC 9560
BRIDGE_INTERFACE = TP-Link Wireless USB Adapter

create-ssh-keys:
	create-ssh-keys.sh

install: create-ssh-keys
	vagrant up

run:
	vagrant up

halt:
	vagrant halt

delete:
	vagrant destroy -f && rm -r .vagrant ssh provision/master_primary/authorized_keys