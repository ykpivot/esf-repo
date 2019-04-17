#!/bin/bash

set +ex

echo "Provisioning the cluster"

# pks get-credentials $PKS_CLUSTER

pwsh /usr/local/bin/get-pks-k8s-config.ps1 $PKS_URL $PKS_CLUSTER $PKS_USER $PKS_PASSWORD

kubectl apply -f deployment-source/pks/deployment.yml
