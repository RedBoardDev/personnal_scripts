#!/bin/bash

name="epitechcontent/epitest-docker:latest"

docker image inspect $name > /dev/null
if [[ $? == 1 ]]; then
    docker pull $name
fi

docker run --privileged -it --rm -v $(pwd):/home/project -w /home/project $name /bin/bash
