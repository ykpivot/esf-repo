#!/bin/bash

set -x

echo "Updating deployment"

VERSION=$(cat bump/version)

sed -e "s|${IMAGE_NAME}:.*|${IMAGE_NAME}:${VERSION}|g" source/pks/deployment.yml \
	> source/pks/deployment-new.yml

cat source/pks/depoyment-new.yml

mv source/pks/deployment-new.yml source/pks/deployment.yml
