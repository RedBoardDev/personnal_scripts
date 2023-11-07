#!/bin/bash

if [ -z "$1" ]; then
    echo "Error: no argument provided."
    exit 1
fi

URL=$1
PROJET_NAME=$(echo $URL | awk -F'/' '{split($NF, a, "-"); split(a[7], b, "."); print b[1]}')


if [ -z "$PROJET_NAME" ]; then
    echo "Error: unable to determine project name, simple clone active."
    git clone "$1" .
fi

git clone "$1" "$PROJET_NAME"
