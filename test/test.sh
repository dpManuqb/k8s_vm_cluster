#!/bin/sh

#kubectl proxy

curl http://localhost:8001/api/v1/namespaces/default/services/nginx-service/proxy > output.html