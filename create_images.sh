#!/usr/bin/env bash

set -eux

VERSION=2020.2.2
DIST_FILE=TeamCity-${VERSION}.tar.gz
if [[ ! -e $DIST_FILE ]]; then
  curl https://download-cf.jetbrains.com/teamcity/${DIST_FILE} -O
fi

rm -rf context/TeamCity
cat $DIST_FILE | (cd context; tar xzf -)

echo TeamCity/webapps > context/.dockerignore
echo TeamCity/devPackage >> context/.dockerignore
echo TeamCity/lib >> context/.dockerignore

docker build -f "context/generated/linux/MinimalAgent/Ubuntu/20.04/Dockerfile" -t teamcity-minimal-agent:2020.2-linux "context"

docker build -f "context/generated/linux/Agent/Ubuntu/20.04/Dockerfile" -t teamcity-agent:2020.2-linux "context"

docker build -f "context/generated/linux/Agent/Ubuntu/20.04-sudo/Dockerfile" -t teamcity-agent:2020.2-linux-sudo "context"

echo TeamCity/buildAgent > context/.dockerignore
echo TeamCity/temp >> context/.dockerignore

docker build -f "context/generated/linux/Server/Ubuntu/20.04/Dockerfile" -t teamcity-server:2020.2-linux "context"
