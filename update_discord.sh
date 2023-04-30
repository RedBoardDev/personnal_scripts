#!/bin/bash

headers=$(curl -sIL "https://discord.com/api/download?platform=linux&format=tar.gz")
latest_version=$(echo "$headers" | grep -oP 'location: https://dl\.discordapp\.net/apps/linux/\K[\d\.]+(?=/discord)' | tr -d '\r')

build_info=$(cat /usr/lib64/discord/resources/build_info.json)
current_version=$(echo "$build_info" | grep -oP '"version":\s*"\K[\d\.]+(?=")')

if [ "$latest_version" == "$current_version" ]; then
    exit 0
fi

if [ -d "/tmp/discord_temp" ]; then
    rm -rf /tmp/discord_temp
fi
killall /usr/lib64/discord/Discord
wget -O /tmp/discord.tar.gz "https://discord.com/api/download?platform=linux&format=tar.gz" &>/dev/null
mkdir -p /tmp/discord_temp
tar -xzf /tmp/discord.tar.gz -C /tmp/discord_temp
sudo cp -r /tmp/discord_temp/Discord/* /usr/lib64/discord/
nohup /usr/lib64/discord/Discord &>/dev/null &
