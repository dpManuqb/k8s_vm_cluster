.EXPORT_ALL_VARIABLES:

IMAGE_NAME = bento/ubuntu-20.04
#BRIDGE_INTERFACE = Intel(R) Wireless-AC 9560
BRIDGE_INTERFACE = TP-Link Wireless USB Adapter

NODE_NETWORK_BASE = 192.168.0.
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
MASTER_SCHEDULE_PODS = no
MASTER_CPU = 2
MASTER_MEM = 2048

NUM_OF_WORKERS = 0
WORKER_VMNAME_BASE = worker
WORKER_HOSTNAME_BASE = k8s-worker
WORKER_CPU = 1
WORKER_MEM = 1024


CLUSTER_IP = NODE_IP_START
CLUSTER_PORT = 6443
MASTER_PORT = 6443
ifeq ($(NUM_OF_MASTERS),1)
	MASTER_IP = CLUSTER_IP
else 
	ifeq ($(NUM_OF_LBS),1)
		LB_IP = NODE_IP_START
		MASTER_IP = NODE_IP_START + NUM_OF_LBS
	else
		ifeq ($(NUM_OF_LBS),0)
			LB_IP = null
    		MASTER_IP = NODE_IP_START + 1
    		MASTER_PORT = 8443
		else
			LB_IP = NODE_IP_START + 1
			MASTER_IP = NODE_IP_START + NUM_OF_LBS + 1
		endif
	endif
endif

create-ssh-keys:
	scripts/create-ssh-keys.sh

ha-conf:
	scripts/create-ha-conf.sh

install: create-ssh-keys ha-conf run

run:
	vagrant up

config: 
	scripts/copy-config.sh

halt:
	vagrant halt

delete:
	vagrant destroy -f && rm -f -r .vagrant ssh provision/loadbalancer/config