#!/bin/bash

set +ex

echo "Provisioning the cluster"

pks

kubectl

pks login -a $PKS_URL -u $PKS_USER -p $PKS_PASSWORD --skip-ssl-validation

pks get-credentials $PKS_CLUSTER

kubectl apply -f source/pks/deployment.yml
