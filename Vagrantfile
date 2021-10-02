# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|
  config.ssh.insert_key = false

  (1..ENV["KUBERNETES_NUM_OF_MASTERS"].to_i).each do |i|      
    config.vm.define "#{ENV["KUBERNETES_MASTER_VMNAME_BASE"]}-#{i-1}" do |master|
      master.vm.box = ENV["IMAGE_NAME"]
      IP = "#{ENV["KUBERNETES_NODE_NETWORK"].split(".")[0,3].join(".")}.#{i-1 + ENV["KUBERNETES_NODE_IP_START"].to_i}"
      master.vm.network "public_network", ip: IP, bridge: "TP-Link Wireless USB Adapter"
      master.vm.hostname = "#{ENV["KUBERNETES_MASTER_HOSTNAME_BASE"]}-#{i-1}"
      master.vm.provider "virtualbox" do |v|
        v.memory = ENV["KUBERNETES_MASTER_MEM"].to_i
        v.cpus = ENV["KUBERNETES_MASTER_CPU"].to_i
      end
      master.vm.provision "file", source: "./provision/provision.master.sh", destination: "/home/vagrant/provision.master.sh"
      master.vm.provision "file", source: "./ssh/authorized_keys", destination: "/home/vagrant/.ssh/authorized_keys"
      master.vm.provision "shell" do |provision|
        provision.privileged = false
        provision.env = {
          "VARIABLES" => "NODE_IP=#{IP},HOSTNAME=#{master.vm.hostname},POD_NETWORK=#{ENV["KUBERNETES_POD_NETWORK"]},PROVISION_FILE=provision.master.sh"
        }
        provision.path = "provision/parallel.provision.sh"
      end
    end
  end

  MASTER_IP = "#{ENV["KUBERNETES_NODE_NETWORK"].split(".")[0,3].join(".")}.#{ENV["KUBERNETES_NODE_IP_START"].to_i}"

  (1..ENV["KUBERNETES_NUM_OF_WORKERS"].to_i).each do |i|      
    config.vm.define "#{ENV["KUBERNETES_WORKER_VMNAME_BASE"]}-#{i-1}" do |worker|
      worker.vm.box = ENV["IMAGE_NAME"]
      IP = "#{ENV["KUBERNETES_NODE_NETWORK"].split(".")[0,3].join(".")}.#{i-1 + ENV["KUBERNETES_NODE_IP_START"].to_i + ENV["KUBERNETES_NUM_OF_MASTERS"].to_i}"
      worker.vm.network "public_network", ip: IP, bridge: "TP-Link Wireless USB Adapter"
      worker.vm.hostname = "#{ENV["KUBERNETES_WORKER_HOSTNAME_BASE"]}-#{i-1}"
      worker.vm.provider "virtualbox" do |v|
        v.memory = ENV["KUBERNETES_WORKER_MEM"].to_i
        v.cpus = ENV["KUBERNETES_WORKER_CPU"].to_i
      end
      worker.vm.provision "file", source: "./provision/provision.worker.sh", destination: "/home/vagrant/provision.worker.sh"
      worker.vm.provision "file", source: "./ssh/#{i}/id_rsa", destination: "/home/vagrant/.ssh/id_rsa"
      worker.vm.provision "file", source: "./ssh/#{i}/id_rsa.pub", destination: "/home/vagrant/.ssh/id_rsa.pub"
      worker.vm.provision "shell" do |provision|
        provision.privileged = false
        provision.env = {
          "VARIABLES"=> "NODE_IP=#{IP},HOSTNAME=#{worker.vm.hostname},MASTER_IP=#{MASTER_IP},PROVISION_FILE=provision.worker.sh"
        }
        provision.path = "provision/parallel.provision.sh"
      end
    end
  end
end