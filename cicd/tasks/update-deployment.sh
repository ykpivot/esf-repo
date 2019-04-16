#!/bin/bash

set -ex

echo "Updating deployment"

VERSION=$(cat bump/version)

sed -e "s|${IMAGE_NAME}:.*|${IMAGE_NAME}:${VERSION}|g" source/pks/deployment.yml > out/deployment.yml

cd out
ls

git config --global user.email "esf@ci.cd"
git config --global user.name "esf cicd"

git add .
git commit -m "Updates by Concourse"

exit 0
