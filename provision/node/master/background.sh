#!/bin/sh

for i in $(seq 1 $(echo "$VARIABLES," | tr -dc ',' | wc -c)); do
    export $(echo $VARIABLES | cut -d, -f$i)
done

NUMBER=$(echo $HOSTNAME | grep -Eo '[0-9]+$')

if [ $NUMBER -eq 0 ]
then
    rm provision.sh
    mv master.sh provision.sh
fi

echo "\nProvisioning $HOSTNAME in background..."
chmod +x /home/vagrant/common.sh /home/vagrant/provision.sh
nohup sh -c '/home/vagrant/common.sh && /home/vagrant/provision.sh' >provision.log 2>&1 &