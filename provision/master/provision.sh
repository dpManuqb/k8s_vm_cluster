#!/bin/sh

sudo kubeadm init --control-plane-endpoint $NODE_IP:6443 --apiserver-advertise-address $NODE_IP --pod-network-cidr $POD_NETWORK

mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config

if [ $POD_NETWORK_MANAGER = "weave" ]
then
	kubectl apply -f "https://cloud.weave.works/k8s/net?k8s-version=$(kubectl version | base64 | tr -d '\n')&env.IPALLOC_RANGE=$POD_NETWORK"
else 
  if [ $POD_NETWORK_MANAGER = "calico" ]
  then
    curl https://docs.projectcalico.org/manifests/calico.yaml | sed 's/policy\/v1beta1/policy\/v1/' >> calico.yaml
    kubectl apply -f calico.yaml
  fi
fi

sudo kubeadm token create $(sudo kubeadm token generate) --print-join-command --ttl=12h >> worker-join.sh

echo "MasterReady"

JSONPATH='{range .items[*]}{@.metadata.name}:{range @.status.conditions[*]}{@.type}={@.status};{end}{end}'
TOTAL_NODES=`expr $NUM_OF_MASTERS + $NUM_OF_WORKERS`
READY_NODES=$(kubectl get nodes -o jsonpath="$JSONPATH" | grep -o "Ready=True" | wc -l)
while [ "$READY_NODES" != "$TOTAL_NODES" ]
do
  sleep 10
  READY_NODES=$(kubectl get nodes -o jsonpath="$JSONPATH" | grep -o "Ready=True" | wc -l)
done

echo "ClusterReady"

rm -f pre.sh common.sh provision.sh worker-join.sh authorized_keys calico.yaml