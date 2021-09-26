# -*- mode: ruby -*-
# vi: set ft=ruby :

VAGRANT_EXPERIMENTAL="disks"
#VAGRANT_DISABLE_VBOXSYMLINKCREATE=1

Vagrant.configure("2") do |config|
  #config.ssh.insert_key = false
  config.vm.synced_folder ".", "/vagrant", disabled: true

  config.vm.define "master" do |master|
    master.vm.box = "bento/ubuntu-20.04"
    master.vm.hostname = "k8s-master"
    master.vm.network "public_network", ip: "192.168.1.10", bridge: "Intel(R) Wireless-AC 9560"
    #master.vm.network "public_network", ip: "192.168.0.10", bridge: "TP-Link Wireless USB Adapter"

    master.vm.provider "virtualbox" do |vb|
      vb.memory = 2048
      vb.cpus = 2
    end
    master.vm.disk :disk, size: "15GB", primary: true

    master.vm.provision "shell" do |provision|
      provision.privileged = false
      provision.path = "provisioning.master.sh"
    end
  end

  config.vm.define "worker" do |worker|
    worker.vm.box = "bento/ubuntu-20.04"
    worker.vm.hostname = "k8s-worker"
    worker.vm.network "public_network", ip: "192.168.1.11", bridge: "Intel(R) Wireless-AC 9560"
    #worker.vm.network "public_network", ip: "192.168.0.11", bridge: "TP-Link Wireless USB Adapter"

    worker.vm.provider "virtualbox" do |vb|
      vb.memory = 2048
      vb.cpus = 2
    end
    worker.vm.disk :disk, size: "15GB", primary: true

    worker.vm.provision "shell" do |provision|
      provision.privileged = false
      provision.path = "provisioning.worker.sh"
    end
  end
end
