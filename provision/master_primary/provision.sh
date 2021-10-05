#!/bin/sh

sudo kubeadm init --control-plane-endpoint $CLUSTER_IP:6443 --apiserver-advertise-address $NODE_IP --pod-network-cidr $POD_NETWORK

mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config

kubectl apply -f "https://cloud.weave.works/k8s/net?k8s-version=$(kubectl version | base64 | tr -d '\n')&env.IPALLOC_RANGE=$POD_NETWORK"

sudo kubeadm token create $(sudo kubeadm token generate) --print-join-command --certificate-key $(sudo kubeadm init phase upload-certs --upload-certs | tail -n 1) --ttl=0 >> master-join.sh
sudo kubeadm token create $(sudo kubeadm token generate) --print-join-command --ttl=0 >> worker-join.sh

echo "MasterReady"

JSONPATH='{range .items[*]}{@.metadata.name}:{range @.status.conditions[*]}{@.type}={@.status};{end}{end}'
READY_NODES=$(kubectl get nodes -o jsonpath="$JSONPATH" | grep -o "Ready=True" | wc -l)
while [ "$READY_NODES" != "$MASTER_NUM_NODES" ]
do
  sleep 15
  READY_NODES=$(kubectl get nodes -o jsonpath="$JSONPATH" | grep -o "Ready=True" | wc -l)
done

echo "AllMasterReady"

TOTAL_NODES=`expr $MASTER_NUM_NODES + $WORKER_NUM_NODES`
READY_NODES=$(kubectl get nodes -o jsonpath="$JSONPATH" | grep -o "Ready=True" | wc -l)
while [ "$READY_NODES" != "$TOTAL_NODES" ]
do
  sleep 30
  READY_NODES=$(kubectl get nodes -o jsonpath="$JSONPATH" | grep -o "Ready=True" | wc -l)
done

echo "ClusterReady"

#rm pre.sh common.sh provision.sh master-join.sh worker-join.sh authorized_keys