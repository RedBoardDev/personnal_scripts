#!/bin/bash

remote="origin"

repo_url=$(git config --get remote.$remote.url)
branch=$(git symbolic-ref --short HEAD)
branch_on_remote=$(git ls-remote --heads $repo_url $branch | wc -l)
default_branch=$(git remote show $remote | sed -n '/HEAD branch/s/.*: //p')

staged_files=$(git diff --name-only --cached | wc -l)
# gitignore=$(find .gitignore | wc -l)

# if [[ $gitignore -eq 0 ]]; then
#     exit 84;
# fi

if [[ $staged_files -eq 0 ]]; then
    echo -e "\033[1;34mAdding all files...\033[0m"
    git add -A
fi
echo -e "\033[1;36mStaged files:\033[0m"
git status -s
echo

git commit -m "$@"

if [[ $branch_on_remote -eq 1 ]]; then
    echo -e "\033[1;34mPulling $branch...\033[0m"
    git pull $remote $branch
fi
var=$?

if [[ $var -eq 0 ]]; then
    if [[ $branch_on_remote -eq 1 ]]; then
        echo -e "\033[1;34mPushing...\033[0m"
        git push $remote $branch
    else
        echo -e "\033[1;34mCreating upstream branch...\033[0m"
        git push -u $remote $branch
    fi
fi
