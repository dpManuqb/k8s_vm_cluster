#!/bin/sh

for i in $(seq 1 $(echo "$VARIABLES," | tr -dc ',' | wc -c)); do
    export $(echo $VARIABLES | cut -d, -f$i)
done

echo "\nProvisioning $HOSTNAME in background..."

chmod +x /home/vagrant/provision/$PROVISION_FILE
nohup /home/vagrant/provision/$PROVISION_FILE >provision.log 2>&1 &