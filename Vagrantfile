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
MASTER_SCHEDULE_PODS = ENV["MASTER_SCHEDULE_PODS"]
MASTER_MEM = ENV["MASTER_MEM"].to_i
MASTER_CPU = ENV["MASTER_CPU"].to_i

NUM_OF_WORKERS = ENV["NUM_OF_WORKERS"].to_i
WORKER_VMNAME_BASE = ENV["WORKER_VMNAME_BASE"]
WORKER_HOSTNAME_BASE = ENV["WORKER_HOSTNAME_BASE"]
WORKER_MEM = ENV["WORKER_MEM"].to_i
WORKER_CPU = ENV["WORKER_CPU"].to_i

CLUSTER_IP = NODE_IP_START
CLUSTER_PORT = 6443
MASTER_PORT = CLUSTER_PORT
if NUM_OF_MASTERS == 1 then
  MASTER_IP = CLUSTER_IP
  LB_IP = "null"
  NUM_OF_LBS = 0
else
  if NUM_OF_LBS == 1 then
    LB_IP = CLUSTER_IP
    MASTER_IP = LB_IP + NUM_OF_LBS
  elsif NUM_OF_LBS > 1 then
    LB_IP = CLUSTER_IP + 1
    MASTER_IP = LB_IP + NUM_OF_LBS
  else
    LB_IP = "null"
    MASTER_IP = CLUSTER_IP + 1
    MASTER_PORT = 8443
  end
end

if NUM_OF_WORKERS == 0 then
  MASTER_SCHEDULE_PODS = "yes"
end

VAGRANT_DISABLE_VBOXSYMLINKCREATE=1

Vagrant.configure("2") do |config|
  config.ssh.insert_key = false
  config.vm.synced_folder ".", "/vagrant", disabled: true
  
  (0..(NUM_OF_LBS-1)).each do |i|
    config.vm.define "#{LB_VMNAME_BASE}-#{i}" do |loadbalancer|
      loadbalancer.vm.box = IMAGE_NAME
      IP = "#{NODE_NETWORK_BASE}#{LB_IP + i}"
      loadbalancer.vm.network "public_network", ip: IP, bridge: BRIDGE_INTERFACE
      loadbalancer.vm.hostname = "#{LB_HOSTNAME_BASE}-0"
      loadbalancer.vm.provider "virtualbox" do |v|
        v.memory = LB_MEM
        v.cpus = LB_CPU
      end
      loadbalancer.vm.provision "file", source: "./ssh/lb_#{i}", destination: "/home/vagrant"
      loadbalancer.vm.provision "file", source: "./provision/loadbalancer", destination: "/home/vagrant"
      loadbalancer.vm.provision "shell" do |provision|
        provision.privileged = false
        provision.env = {
        "VARIABLES" => "NODE_IP=#{IP},CLUSTER_IP=#{NODE_NETWORK_BASE}#{CLUSTER_IP},CLUSTER_PORT=#{CLUSTER_PORT},LB_IP=#{NODE_NETWORK_BASE}#{LB_IP},MASTER_IP=#{NODE_NETWORK_BASE}#{MASTER_IP},MASTER_PORT=#{MASTER_PORT},HOSTNAME=#{loadbalancer.vm.hostname},NUM_OF_LBS=#{NUM_OF_LBS},NUM_OF_MASTERS=#{NUM_OF_MASTERS},NUM_OF_WORKERS=#{NUM_OF_WORKERS}"
        }
        provision.path = "provision/loadbalancer/background.sh"
      end
    end
  end

  config.vm.define "#{MASTER_VMNAME_BASE}-0" do |master|
    master.vm.box = IMAGE_NAME
    IP = "#{NODE_NETWORK_BASE}#{MASTER_IP}"
    master.vm.network "public_network", ip: IP, bridge: BRIDGE_INTERFACE
    master.vm.hostname = "#{MASTER_HOSTNAME_BASE}-0"
    master.vm.provider "virtualbox" do |v|
      v.memory = MASTER_MEM
      v.cpus = MASTER_CPU
    end

    if NUM_OF_MASTERS > 1 && NUM_OF_LBS == 0 then
      master.vm.provision "file", source: "./provision/loadbalancer/config", destination: "/home/vagrant/config"
    end

    master.vm.provision "file", source: "./ssh/master_0", destination: "/home/vagrant"
    master.vm.provision "file", source: "./provision/node/master", destination: "/home/vagrant"
    master.vm.provision "shell" do |provision|
      provision.privileged = false
      provision.env = {
        "VARIABLES" => "NODE_IP=#{IP},CLUSTER_IP=#{NODE_NETWORK_BASE}#{CLUSTER_IP},CLUSTER_PORT=#{CLUSTER_PORT},LB_IP=#{NODE_NETWORK_BASE}#{LB_IP},MASTER_IP=#{NODE_NETWORK_BASE}#{MASTER_IP},MASTER_PORT=#{MASTER_PORT},HOSTNAME=#{master.vm.hostname},NUM_OF_LBS=#{NUM_OF_LBS},NUM_OF_MASTERS=#{NUM_OF_MASTERS},NUM_OF_WORKERS=#{NUM_OF_WORKERS},MASTER_SCHEDULE_PODS=#{MASTER_SCHEDULE_PODS},POD_NETWORK=#{POD_NETWORK},POD_NETWORK_MANAGER=#{POD_NETWORK_MANAGER}"
      }
      provision.path = "provision/node/master/background.sh"
    end
  end

  (1..(NUM_OF_MASTERS-1)).each do |i|      
    config.vm.define "#{MASTER_VMNAME_BASE}-#{i}" do |master|
      master.vm.box = IMAGE_NAME
      IP = "#{NODE_NETWORK_BASE}#{MASTER_IP + i}"
      master.vm.network "public_network", ip: IP, bridge: BRIDGE_INTERFACE
      master.vm.hostname = "#{MASTER_HOSTNAME_BASE}-#{i}"
      master.vm.provider "virtualbox" do |v|
        v.memory = MASTER_MEM
        v.cpus = MASTER_CPU
      end

      if NUM_OF_MASTERS > 1 && NUM_OF_LBS == 0 then
        master.vm.provision "file", source: "./provision/loadbalancer/config", destination: "/home/vagrant/config"
      end

      master.vm.provision "file", source: "./ssh/master_#{i}", destination: "/home/vagrant"
      master.vm.provision "file", source: "./provision/node/master", destination: "/home/vagrant"
      master.vm.provision "shell" do |provision|
        provision.privileged = false
        provision.env = {
          "VARIABLES" => "NODE_IP=#{IP},CLUSTER_IP=#{NODE_NETWORK_BASE}#{CLUSTER_IP},CLUSTER_PORT=#{CLUSTER_PORT},LB_IP=#{NODE_NETWORK_BASE}#{LB_IP},MASTER_IP=#{NODE_NETWORK_BASE}#{MASTER_IP},MASTER_PORT=#{MASTER_PORT},HOSTNAME=#{master.vm.hostname},NUM_OF_LBS=#{NUM_OF_LBS},NUM_OF_MASTERS=#{NUM_OF_MASTERS},NUM_OF_WORKERS=#{NUM_OF_WORKERS},MASTER_SCHEDULE_PODS=#{MASTER_SCHEDULE_PODS}"
        }
        provision.path = "provision/node/master/background.sh"
      end
    end
  end

  (0..(NUM_OF_WORKERS-1)).each do |i|      
    config.vm.define "#{WORKER_VMNAME_BASE}-#{i}" do |worker|
      worker.vm.box = IMAGE_NAME
      IP = "#{NODE_NETWORK_BASE}#{MASTER_IP + NUM_OF_MASTERS + i}"
      worker.vm.network "public_network", ip: IP, bridge: BRIDGE_INTERFACE
      worker.vm.hostname = "#{WORKER_HOSTNAME_BASE}-#{i}"
      worker.vm.provider "virtualbox" do |v|
        v.memory = WORKER_MEM
        v.cpus = WORKER_CPU
      end

      worker.vm.provision "file", source: "./ssh/worker_#{i}", destination: "/home/vagrant"
      worker.vm.provision "file", source: "./provision/node/worker", destination: "/home/vagrant"
      worker.vm.provision "shell" do |provision|
        provision.privileged = false
        provision.env = {
          "VARIABLES"=> "NODE_IP=#{IP},HOSTNAME=#{worker.vm.hostname},MASTER_IP=#{NODE_NETWORK_BASE}#{MASTER_IP}"
        }
        provision.path = "provision/node/worker/background.sh"
      end
    end
  end
end
