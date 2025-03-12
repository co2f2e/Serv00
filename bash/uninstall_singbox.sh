#!/bin/bash

YELLOW='\033[33m'
RESET='\033[0m'

red() {
	echo -e "${RED}${1}${RESET}"
}

yellow() {
	echo -e "${YELLOW}${1}${RESET}"
}
USERNAME=$(whoami)
HOSTNAME=$(hostname)
PROCESS_NAME="singbox"
[[ "$HOSTNAME" == "s1.ct8.pl" ]] && WORKDIR="domains/${USERNAME}.ct8.pl/logs" || WORKDIR="domains/${USERNAME}.serv00.net/logs"

pkill -x "$PROCESS_NAME"
sleep 1

if pgrep "$PROCESS_NAME" > /dev/null; then
    red "❌ $PROCESS_NAME 卸载失败！"
    exit 0
else
    echo "" > null
    crontab null
    rm null
    rm -r $WORKDIR
    yellow "✅ $PROCESS_NAME 卸载成功，已删除相关文件！"
    exit 0
fi





