# -*- mode: ruby -*-
# vi: set ft=ruby :

#VAGRANT_DISABLE_VBOXSYMLINKCREATE=1

Vagrant.configure("2") do |config|
  #config.ssh.insert_key = false
  config.vm.synced_folder ".", "/vagrant", disabled: true
  
  config.vm.define "master" do |master|
    master.vm.box = "bento/ubuntu-20.04"
    master.vm.hostname = "k8s-master"
    master.vm.network "public_network", ip: "192.168.0.10", bridge: "TP-Link Wireless USB Adapter"

    master.vm.provider "virtualbox" do |vb|
      vb.memory = 2048
      vb.cpus = 2
    end
    
    master.vm.provision "file", source: "./.env", destination: "/home/vagrant/"
    master.vm.provision "file", source: "./weavenet.yaml", destination: "/home/vagrant/"
    master.vm.provision "shell", path: "provisioning.master.sh"
  end
end
