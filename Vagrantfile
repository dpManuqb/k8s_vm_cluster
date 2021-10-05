# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|
  config.ssh.insert_key = false
  config.vm.synced_folder ".", "/vagrant", disabled: true
  
  if ENV["KUBERNETES_NUM_OF_MASTERS"].to_i > 1
    MASTER_IP = "#{ENV["KUBERNETES_NODE_NETWORK"].split(".")[0,3].join(".")}.#{ENV["KUBERNETES_NODE_IP_START"].to_i+1}"
    CLUSTER_IP = "#{ENV["KUBERNETES_NODE_NETWORK"].split(".")[0,3].join(".")}.#{ENV["KUBERNETES_NODE_IP_START"].to_i}"
  else
    MASTER_IP = "#{ENV["KUBERNETES_NODE_NETWORK"].split(".")[0,3].join(".")}.#{ENV["KUBERNETES_NODE_IP_START"].to_i}"
    CLUSTER_IP = MASTER_IP
  end

  config.vm.define "#{ENV["KUBERNETES_MASTER_VMNAME_BASE"]}-0" do |master|
    master.vm.box = ENV["IMAGE_NAME"]
    master.vm.network "public_network", ip: MASTER_IP, bridge: ENV["BRIDGE_INTERFACE"]
    master.vm.hostname = "#{ENV["KUBERNETES_MASTER_HOSTNAME_BASE"]}-0"
    master.vm.provider "virtualbox" do |v|
      v.gui = true
      v.memory = ENV["KUBERNETES_MASTER_MEM"].to_i
      v.cpus = ENV["KUBERNETES_MASTER_CPU"].to_i
    end
    master.vm.provision "file", source: "./provision/master_primary", destination: "/home/vagrant"
    master.vm.provision "file", source: "./provision/common.sh", destination: "/home/vagrant/common.sh"
    master.vm.provision "shell" do |provision|
      provision.privileged = false
      provision.env = {
        "VARIABLES" => "NODE_IP=#{MASTER_IP},HOSTNAME=#{master.vm.hostname},CLUSTER_IP=#{MASTER_IP},POD_NETWORK=#{ENV["KUBERNETES_POD_NETWORK"]},MASTER_NUM_NODES=#{ENV["KUBERNETES_NUM_OF_MASTERS"]},WORKER_NUM_NODES=#{ENV["KUBERNETES_NUM_OF_WORKERS"]}"
      }
      provision.path = "provision/parallel.provision.sh"
    end
  end

  if ENV["KUBERNETES_NUM_OF_MASTERS"].to_i > 1
    (1..(ENV["KUBERNETES_NUM_OF_MASTERS"].to_i-1)).each do |i|      
      config.vm.define "#{ENV["KUBERNETES_MASTER_VMNAME_BASE"]}-#{i}" do |master|
        master.vm.box = ENV["IMAGE_NAME"]
        IP = "#{ENV["KUBERNETES_NODE_NETWORK"].split(".")[0,3].join(".")}.#{i+1 + ENV["KUBERNETES_NODE_IP_START"].to_i}"
        master.vm.network "public_network", ip: IP, bridge: ENV["BRIDGE_INTERFACE"]
        master.vm.hostname = "#{ENV["KUBERNETES_MASTER_HOSTNAME_BASE"]}-#{i}"
        master.vm.provider "virtualbox" do |v|
          v.gui = true
          v.memory = ENV["KUBERNETES_MASTER_MEM"].to_i
          v.cpus = ENV["KUBERNETES_MASTER_CPU"].to_i
        end
        master.vm.provision "file", source: "./provision/master", destination: "/home/vagrant"
        master.vm.provision "file", source: "./provision/common.sh", destination: "/home/vagrant/common.sh"
        master.vm.provision "file", source: "./ssh/master_#{i}/id_rsa", destination: "/home/vagrant/.ssh/id_rsa"
        master.vm.provision "file", source: "./ssh/master_#{i}/id_rsa.pub", destination: "/home/vagrant/.ssh/id_rsa.pub"
        master.vm.provision "shell" do |provision|
          provision.privileged = false
          provision.env = {
            "VARIABLES" => "NODE_IP=#{IP},HOSTNAME=#{master.vm.hostname},MASTER_IP=#{MASTER_IP}"
          }
          provision.path = "provision/parallel.provision.sh"
        end
      end
    end
  end

  (0..(ENV["KUBERNETES_NUM_OF_WORKERS"].to_i-1)).each do |i|      
    config.vm.define "#{ENV["KUBERNETES_WORKER_VMNAME_BASE"]}-#{i}" do |worker|
      worker.vm.box = ENV["IMAGE_NAME"]
      IP = "#{ENV["KUBERNETES_NODE_NETWORK"].split(".")[0,3].join(".")}.#{MASTER_IP.split(".")[3].to_i+ENV["KUBERNETES_NUM_OF_MASTERS"].to_i + i}"
      worker.vm.network "public_network", ip: IP, bridge: ENV["BRIDGE_INTERFACE"]
      worker.vm.hostname = "#{ENV["KUBERNETES_WORKER_HOSTNAME_BASE"]}-#{i}"
      worker.vm.provider "virtualbox" do |v|
        v.gui = true
        v.memory = ENV["KUBERNETES_WORKER_MEM"].to_i
        v.cpus = ENV["KUBERNETES_WORKER_CPU"].to_i
      end
      worker.vm.provision "file", source: "./provision/worker", destination: "/home/vagrant"
      worker.vm.provision "file", source: "./provision/common.sh", destination: "/home/vagrant/common.sh"
      worker.vm.provision "file", source: "./ssh/worker_#{i}/id_rsa", destination: "/home/vagrant/.ssh/id_rsa"
      worker.vm.provision "file", source: "./ssh/worker_#{i}/id_rsa.pub", destination: "/home/vagrant/.ssh/id_rsa.pub"
      worker.vm.provision "shell" do |provision|
        provision.privileged = false
        provision.env = {
          "VARIABLES"=> "NODE_IP=#{IP},HOSTNAME=#{worker.vm.hostname},MASTER_IP=#{MASTER_IP}"
        }
        provision.path = "provision/parallel.provision.sh"
      end
    end
  end
end