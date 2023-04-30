#!/bin/bash

if [ -z "$1" ]; then
    echo "Error: no argument provided."
    exit 1
fi

PATH_REPO_1=${1#*-}
PATH_REPO_2=${PATH_REPO_1%.*}
PATH_REPO_3=${PATH_REPO_2%-*}
ORGA_NAME=${1%/*}
PROJET_NAME=${PATH_REPO_3##*-}

if [ -z "$PROJET_NAME" ]; then
    echo "Error: unable to determine project name, simple clone active."
    git clone "$1" .
fi

git clone "$1" "$PROJET_NAME"
