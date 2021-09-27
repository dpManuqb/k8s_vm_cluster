# -*- mode: ruby -*-
# vi: set ft=ruby :

IMAGE_NAME="bento/ubuntu-20.04"

KUBERNETES_NUM_OF_MASTERS=1
KUBERNETES_MASTER_VMNAME_BASE="master"
KUBERNETES_MASTER_HOSTNAME_BASE="k8s-master"
KUBERNETES_MASTER_CPU=2
KUBERNETES_MASTER_MEM=2048
KUBERNETES_MASTER_DISK="15GB"

KUBERNETES_NUM_OF_WORKERS=1
KUBERNETES_WORKER_VMNAME_BASE="worker"
KUBERNETES_WORKER_HOSTNAME_BASE="k8s-worker"
KUBERNETES_WORKER_CPU=2
KUBERNETES_WORKER_MEM=2048
KUBERNETES_WORKER_DISK="15GB"

KUBERNETES_NODE_NETWORK="192.168.0.0/24"
KUBERNETES_NODE_IP_START=10

KUBERNETES_POD_NETWORK="10.0.0.0/23"

IMAGE_NAME="bento/ubuntu-20.04"
VAGRANT_EXPERIMENTAL="disks"

Vagrant.configure("2") do |config|
  config.ssh.insert_key = false

  (1..KUBERNETES_NUM_OF_MASTERS).each do |i|      
    config.vm.define "#{KUBERNETES_MASTER_VMNAME_BASE}-#{i-1}" do |master|
      master.vm.box = IMAGE_NAME
      IP = "#{KUBERNETES_NODE_NETWORK.split(".")[0,3].join(".")}.#{i-1 + KUBERNETES_NODE_IP_START}"
      master.vm.network "public_network", ip: IP, bridge: "TP-Link Wireless USB Adapter"
      master.vm.hostname = "#{KUBERNETES_MASTER_HOSTNAME_BASE}-#{i-1}"
      master.vm.provider "virtualbox" do |v|
        v.memory = KUBERNETES_MASTER_MEM
        v.cpus = KUBERNETES_MASTER_CPU
      end
      master.vm.disk :disk, size: KUBERNETES_MASTER_DISK, primary: true
      master.vm.provision "shell" do |provision|
        provision.privileged = false
        provision.env = {
          "NODE_IP" => IP,
          "POD_NETWORK" => KUBERNETES_POD_NETWORK,
        }
        if i == 1 then
          provision.path = "provisioning.master.sh"
        end
      end
    end
  end

  (1..KUBERNETES_NUM_OF_WORKERS).each do |i|      
    config.vm.define "#{KUBERNETES_WORKER_VMNAME_BASE}-#{i-1}" do |worker|
      worker.vm.box = IMAGE_NAME
      IP = "#{KUBERNETES_NODE_NETWORK.split(".")[0,3].join(".")}.#{i-1 + KUBERNETES_NODE_IP_START + KUBERNETES_NUM_OF_MASTERS}"
      worker.vm.network "public_network", ip: IP, bridge: "TP-Link Wireless USB Adapter"
      worker.vm.hostname = "#{KUBERNETES_WORKER_HOSTNAME_BASE}-#{i-1}"
      worker.vm.provider "virtualbox" do |v|
        v.memory = KUBERNETES_WORKER_MEM
        v.cpus = KUBERNETES_WORKER_CPU
      end
      worker.vm.disk :disk, size: KUBERNETES_WORKER_DISK, primary: true
      worker.vm.provision "shell" do |provision|
        provision.privileged = false
        provision.env = {"NODE_IP" => IP}
        provision.path = "provisioning.worker.sh"
      end
    end
  end
end