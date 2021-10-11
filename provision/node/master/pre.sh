#!/bin/sh

chmod 600 /home/vagrant/.ssh/id_rsa
cat /home/vagrant/authorized_keys >> /home/vagrant/.ssh/authorized_keys