#!/bin/bash

if [ -z "$1" ]; then
    echo "Error: no argument provided."
    exit 1
fi

URL=$1
ORG_NAME=$(dirname $URL | awk -F'/' '{print $NF}')
BASE_NAME=$(basename -s .git $URL)

echo "Organization: $ORG_NAME"
echo "Project: $BASE_NAME"

if [[ $ORG_NAME == *"git@github.com:EpitechPromo"* ]]; then
    PROJET_NAME=$(echo $BASE_NAME | awk -F'/' '{split($NF, a, "-"); split(a[7], b, "."); print b[1]}')
    echo "Epitech repository detected: $PROJET_NAME"
    git clone "$1" "$PROJET_NAME"
    echo "Clone done."
else
    echo "Classic repository detected: $BASE_NAME"
    git clone "$1" "$BASE_NAME"
    echo "Clone done."
fi
