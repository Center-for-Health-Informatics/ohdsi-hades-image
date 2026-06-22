#!/usr/bin/env bash

NAME=hades
VERSION=`date +%Y.%m.%d.%H.%M`
if command -v docker >/dev/null 2>&1; then
  docker build --pull --tag $NAME:$VERSION --tag $NAME:latest .
elif command -v podman >/dev/null 2>&1; then
  podman build --pull=newer --tag $NAME:$VERSION --tag $NAME:latest .
else
  print "no container manager installed"
fi
