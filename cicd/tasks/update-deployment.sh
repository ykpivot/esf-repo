#!/bin/bash

set -ex

echo "Updating deployment"

git clone source out

VERSION=$(cat bump/version)

sed -e "s|${IMAGE_NAME}:.*|${IMAGE_NAME}:${VERSION}|g" source/pks/deployment.yml > out/pks/deployment.yml

cd out

git config --global user.email "esf@ci.cd"
git config --global user.name "esf cicd"

git add .
git commit -m "Updates by Concourse"
