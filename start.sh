#!/usr/bin/env bash

if command -v docker >/dev/null 2>&1; then
  docker run --interactive --tty --rm --name hades --env TZ hades:latest
elif command -v podman >/dev/null 2>&1; then
  podman run --interactive --tty --rm --name hades --env TZ hades:latest
else
  print "no container manager installed"
fi
