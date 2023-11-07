#!/bin/bash

docker ps -q | xargs -r docker kill
docker container prune -f
