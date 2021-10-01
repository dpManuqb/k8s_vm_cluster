# -*- mode: ruby -*-
# vi: set ft=ruby :

KUBERNETES_NUM_OF_MASTERS=1
KUBERNETES_MASTER_VMNAME_BASE="master"
KUBERNETES_MASTER_HOSTNAME_BASE="k8s-master"
KUBERNETES_MASTER_CPU=2
KUBERNETES_MASTER_MEM=2048

KUBERNETES_NUM_OF_WORKERS=0
KUBERNETES_WORKER_VMNAME_BASE="worker"
KUBERNETES_WORKER_HOSTNAME_BASE="k8s-worker"
KUBERNETES_WORKER_CPU=3
KUBERNETES_WORKER_MEM=4096

KUBERNETES_NODE_NETWORK="192.168.0.0/24"
KUBERNETES_NODE_IP_START=10

KUBERNETES_POD_NETWORK="10.0.0.0/23"

IMAGE_NAME="bento/ubuntu-20.04"
PASSWORD="vagrant"

Vagrant.configure("2") do |config|

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
      master.vm.provision "file", source: "./provision/", destination: "/home/vagrant/"
      master.vm.provision "shell" do |provision|
        provision.privileged = false
        provision.env = {
          "VARIABLES" => "NODE_IP=#{IP},HOSTNAME=#{master.vm.hostname},POD_NETWORK=#{KUBERNETES_POD_NETWORK},PROVISION_FILE=provision.master.sh"
        }
        provision.path = "provision/parallel.provision.sh"
      end
    end
  end

  MASTER_IP = "#{KUBERNETES_NODE_NETWORK.split(".")[0,3].join(".")}.#{KUBERNETES_NODE_IP_START}"

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
      worker.vm.provision "file", source: "./provision/", destination: "/home/vagrant/"
      worker.vm.provision "shell" do |provision|
        provision.privileged = false
        provision.env = {
          "VARIABLES"=> "NODE_IP=#{IP},HOSTNAME=#{worker.vm.hostname},MASTER_IP=#{MASTER_IP},PASSWORD=#{PASSWORD},PROVISION_FILE=provision.worker.sh"
        }
        provision.path = "provision/parallel.provision.sh"
      end
    end
  end
end