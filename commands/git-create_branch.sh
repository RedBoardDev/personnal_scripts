#!/bin/bash

remote="origin"

branch=$(git symbolic-ref --short HEAD)
default_branch=$(git remote show $remote | sed -n '/HEAD branch/s/.*: //p')

if [[ $branch != $default_branch ]]; then
    echo -n "Do you want to go to the default branch? ($default_branch) [y/N] "
    read go_to_default_br

    if [[ $go_to_default_br == "y" || $go_to_default_br == "Y" ]]; then
        git checkout $default_branch
    fi
fi

repo_url=$(git config --get remote.$remote.url)
branch_on_remote=$(git ls-remote --heads $repo_url $branch | wc -l)

if [[ $branch_on_remote -eq 1 ]]; then
    echo -e "\033[1;34mPulling $branch...\033[0m"
    git pull $remote $branch
fi

git checkout -b "$1"
