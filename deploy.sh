#!/bin/bash

PASS_PWD=$(pwd)

PROJECT_DIR=$PASS_PWD/
WEBSITE_ROOT="$PROJECT_DIR/website/"
releases_dir="$PROJECT_DIR/releases"
current_dir="$releases_dir/current"


# Update the project
if [ ! -d "$PROJECT_DIR" ]; then
    echo "Error: The project directory was not found."
    exit 1
fi
cd $PROJECT_DIR
git pull

# Install dependencies for the website
if [ ! -d "$WEBSITE_ROOT" ]; then
    echo "Error: The website directory in the project was not found."
    exit 1
fi

cd $WEBSITE_ROOT
npm install

# Build the website
npm run build

# Create a new release directory
mkdir -p $releases_dir

new_release_dir="$releases_dir/release-$(date +'%Y%m%d%H%M%S')"

mkdir -p $new_release_dir
cp -r $WEBSITE_ROOT/build/* $new_release_dir

# Update the current directory to the new release
ln -sfn $new_release_dir $current_dir


echo "The website has been successfully deployed."
