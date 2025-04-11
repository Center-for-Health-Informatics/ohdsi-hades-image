#!/usr/bin/env bash

NAME=hades
VERSION=`date +%Y.%m.%d.%H.%M`
docker build --pull --tag $NAME:$VERSION --tag $NAME:latest .
