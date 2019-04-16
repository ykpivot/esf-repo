#!/bin/bash

set -ex

echo "Updating deployment"

VERSION=$(cat bump/version)

RESULT=$(sed -e "s|${IMAGE_NAME}:.*|${IMAGE_NAME}:${VERSION}|g" source/pks/deployment.yml)

echo $RESULT > deployment.yml

#cat source/pks/depoyment-new.yml

cat deployment.yml

#mv source/pks/deployment-new.yml source/pks/deployment.yml
