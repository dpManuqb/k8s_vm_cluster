# -*- mode: ruby -*-
# vi: set ft=ruby :

IMAGE_NAME = ENV["IMAGE_NAME"]
BRIDGE_INTERFACE = ENV["BRIDGE_INTERFACE"]

NODE_NETWORK_BASE = ENV["NODE_NETWORK_BASE"]
NODE_IP_START = ENV["NODE_IP_START"].to_i

POD_NETWORK = ENV["POD_NETWORK"]
POD_NETWORK_MANAGER = ENV["POD_NETWORK_MANAGER"]

NUM_OF_LBS = ENV["NUM_OF_LBS"].to_i
LB_VMNAME_BASE = ENV["LB_VMNAME_BASE"]
LB_HOSTNAME_BASE = ENV["LB_HOSTNAME_BASE"]
LB_MEM = ENV["LB_MEM"].to_i
LB_CPU = ENV["LB_CPU"].to_i

NUM_OF_MASTERS = ENV["NUM_OF_MASTERS"].to_i
MASTER_VMNAME_BASE = ENV["MASTER_VMNAME_BASE"]
MASTER_HOSTNAME_BASE = ENV["MASTER_HOSTNAME_BASE"]
MASTER_MEM = ENV["MASTER_MEM"].to_i
MASTER_CPU = ENV["MASTER_CPU"].to_i

NUM_OF_WORKERS = ENV["NUM_OF_WORKERS"].to_i
WORKER_VMNAME_BASE = ENV["WORKER_VMNAME_BASE"]
WORKER_HOSTNAME_BASE = ENV["WORKER_HOSTNAME_BASE"]
WORKER_MEM = ENV["WORKER_MEM"].to_i
WORKER_CPU = ENV["WORKER_CPU"].to_i

CLUSTER_IP = "#{NODE_NETWORK_BASE}#{NODE_IP_START}"
MASTER_IP = "#{NODE_NETWORK_BASE}#{NODE_IP_START+1}"

VAGRANT_DISABLE_VBOXSYMLINKCREATE=1

Vagrant.configure("2") do |config|
  config.ssh.insert_key = false
  config.vm.synced_folder ".", "/vagrant", disabled: true
  
  config.vm.define "#{LB_VMNAME_BASE}-0" do |loadbalancer|
    loadbalancer.vm.box = IMAGE_NAME
    loadbalancer.vm.network "public_network", ip: "#{NODE_NETWORK_BASE}#{NODE_IP_START}", bridge: BRIDGE_INTERFACE
    loadbalancer.vm.hostname = "#{LB_HOSTNAME_BASE}-0"
    loadbalancer.vm.provider "virtualbox" do |v|
      v.gui = true
      v.memory = LB_MEM
      v.cpus = LB_CPU
    end
    loadbalancer.vm.provision "file", source: "./ssh/authorized_keys", destination: "/home/vagrant/.ssh/authorized_keys"
    loadbalancer.vm.provision "file", source: "./ssh/lb_0", destination: "/home/vagrant/.ssh"
    loadbalancer.vm.provision "file", source: "./provision/loadbalancer", destination: "/home/vagrant"
    loadbalancer.vm.provision "shell" do |provision|
      provision.privileged = false
      provision.path = "provision/loadbalancer/background.sh"
    end
  end

  config.vm.define "#{MASTER_VMNAME_BASE}-0" do |master|
    master.vm.box = IMAGE_NAME
    master.vm.network "public_network", ip: MASTER_IP, bridge: BRIDGE_INTERFACE
    master.vm.hostname = "#{MASTER_HOSTNAME_BASE}-0"
    master.vm.provider "virtualbox" do |v|
      v.gui = true
      v.memory = MASTER_MEM
      v.cpus = MASTER_CPU
    end
    master.vm.provision "file", source: "./ssh/authorized_keys", destination: "/home/vagrant/.ssh/authorized_keys"
    master.vm.provision "file", source: "./ssh/master_0", destination: "/home/vagrant/.ssh"
    master.vm.provision "file", source: "./provision/node/master_prime.sh", destination: "/home/vagrant/provision.sh"    
    master.vm.provision "file", source: "./provision/node/common.sh", destination: "/home/vagrant/common.sh"
    master.vm.provision "shell" do |provision|
      provision.privileged = false
      provision.env = {
        "VARIABLES" => "NODE_IP=#{MASTER_IP},CLUSTER_IP=#{CLUSTER_IP},HOSTNAME=#{master.vm.hostname},POD_NETWORK=#{POD_NETWORK},POD_NETWORK_MANAGER=#{POD_NETWORK_MANAGER},NUM_OF_MASTERS=#{NUM_OF_MASTERS},NUM_OF_WORKERS=#{NUM_OF_WORKERS}"
      }
      provision.path = "provision/node/background.sh"
    end
  end

  (1..(NUM_OF_MASTERS-1)).each do |i|      
    config.vm.define "#{MASTER_VMNAME_BASE}-#{i}" do |master|
      master.vm.box = IMAGE_NAME
      IP = "#{NODE_NETWORK_BASE}#{NODE_IP_START + 1 + i}"
      master.vm.network "public_network", ip: IP, bridge: BRIDGE_INTERFACE
      master.vm.hostname = "#{MASTER_HOSTNAME_BASE}-#{i}"
      master.vm.provider "virtualbox" do |v|
        v.gui = true
        v.memory = MASTER_MEM
        v.cpus = MASTER_CPU
      end
      master.vm.provision "file", source: "./ssh/authorized_keys", destination: "/home/vagrant/.ssh/authorized_keys"
      master.vm.provision "file", source: "./ssh/master_#{i}", destination: "/home/vagrant/.ssh"
      master.vm.provision "file", source: "./provision/node/master.sh", destination: "/home/vagrant/provision.sh"
      master.vm.provision "file", source: "./provision/node/common.sh", destination: "/home/vagrant/common.sh"
      master.vm.provision "shell" do |provision|
        provision.privileged = false
        provision.env = {
          "VARIABLES" => "NODE_IP=#{IP},HOSTNAME=#{master.vm.hostname},MASTER_IP=#{MASTER_IP}"
        }
        provision.path = "provision/node/background.sh"
      end
    end
  end

  (0..(NUM_OF_WORKERS-1)).each do |i|      
    config.vm.define "#{WORKER_VMNAME_BASE}-#{i}" do |worker|
      worker.vm.box = IMAGE_NAME
      IP =  "#{NODE_NETWORK_BASE}#{NODE_IP_START + NUM_OF_MASTERS + i + 1}"
      worker.vm.network "public_network", ip: IP, bridge: BRIDGE_INTERFACE
      worker.vm.hostname = "#{WORKER_HOSTNAME_BASE}-#{i}"
      worker.vm.provider "virtualbox" do |v|
        v.gui = true
        v.memory = WORKER_MEM
        v.cpus = WORKER_CPU
      end
      worker.vm.provision "file", source: "./ssh/worker_#{i}", destination: "/home/vagrant/.ssh"
      worker.vm.provision "file", source: "./provision/node/worker.sh", destination: "/home/vagrant/provision.sh"
      worker.vm.provision "file", source: "./provision/node/common.sh", destination: "/home/vagrant/common.sh"
      worker.vm.provision "shell" do |provision|
        provision.privileged = false
        provision.env = {
          "VARIABLES"=> "NODE_IP=#{IP},HOSTNAME=#{worker.vm.hostname},MASTER_IP=#{MASTER_IP}"
        }
        provision.path = "provision/node/background.sh"
      end
    end
  end
end
