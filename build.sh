#!/bin/sh

cd `dirname $0`

docker build ./ -t tkmnet/crowdwalk:latest
docker push tkmnet/crowdwalk
