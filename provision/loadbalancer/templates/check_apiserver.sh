#!/bin/sh

errorExit() {
  echo "*** $@" 1>&2
  exit 1
}

curl --silent --max-time 2 --insecure https://localhost:$CLUSTER_PORT/ -o /dev/null || errorExit "Error GET https://localhost:$CLUSTER_PORT/"
if ip addr | grep -q $CLUSTER_IP; then
  curl --silent --max-time 2 --insecure https://$CLUSTER_IP:$CLUSTER_PORT/ -o /dev/null || errorExit "Error GET https://$CLUSTER_IP:$CLUSTER_PORT/"
fi
