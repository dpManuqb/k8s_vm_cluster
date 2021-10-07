# -*- mode: ruby -*-
# vi: set ft=ruby :

VAGRANT_DISABLE_VBOXSYMLINKCREATE=1

Vagrant.configure("2") do |config|
  config.ssh.insert_key = false
  config.vm.synced_folder ".", "/vagrant", disabled: true
    
  config.vm.define "#{ENV["MASTER_VMNAME_BASE"]}-0" do |master|
    master.vm.box = ENV["IMAGE_NAME"]
    MASTER_IP = "#{ENV["NODE_NETWORK_BASE"]}#{ENV["NODE_IP_START"]}"
    master.vm.network "public_network", ip: MASTER_IP, bridge: ENV["BRIDGE_INTERFACE"]
    master.vm.hostname = "#{ENV["MASTER_HOSTNAME_BASE"]}-0"
    master.vm.provider "virtualbox" do |v|
      v.gui = true
      v.memory = ENV["MASTER_MEM"].to_i
      v.cpus = ENV["MASTER_CPU"].to_i
    end
    master.vm.provision "file", source: "./provision/master", destination: "/home/vagrant"
    master.vm.provision "file", source: "./provision/common.sh", destination: "/home/vagrant/common.sh"
    master.vm.provision "shell" do |provision|
      provision.privileged = false
      provision.env = {
        "VARIABLES" => "NODE_IP=#{MASTER_IP},HOSTNAME=#{master.vm.hostname},POD_NETWORK=#{ENV["POD_NETWORK"]},POD_NETWORK_MANAGER=#{ENV["POD_NETWORK_MANAGER"]},NUM_OF_MASTERS=#{ENV["NUM_OF_MASTERS"]},NUM_OF_WORKERS=#{ENV["NUM_OF_WORKERS"]}"
      }
      provision.path = "provision/parallel.provision.sh"
    end
  end

  (0..(ENV["NUM_OF_WORKERS"].to_i-1)).each do |i|      
    config.vm.define "#{ENV["WORKER_VMNAME_BASE"]}-#{i}" do |worker|
      worker.vm.box = ENV["IMAGE_NAME"]
      IP = "#{ENV["NODE_NETWORK_BASE"]}#{ENV["NODE_IP_START"].to_i + ENV["NUM_OF_MASTERS"].to_i + i}"
      worker.vm.network "public_network", ip: IP, bridge: ENV["BRIDGE_INTERFACE"]
      worker.vm.hostname = "#{ENV["WORKER_HOSTNAME_BASE"]}-#{i}"
      worker.vm.provider "virtualbox" do |v|
        v.gui = true
        v.memory = ENV["WORKER_MEM"].to_i
        v.cpus = ENV["WORKER_CPU"].to_i
      end
      worker.vm.provision "file", source: "./provision/worker", destination: "/home/vagrant"
      worker.vm.provision "file", source: "./provision/common.sh", destination: "/home/vagrant/common.sh"
      worker.vm.provision "file", source: "./ssh/worker_#{i}", destination: "/home/vagrant/.ssh"
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