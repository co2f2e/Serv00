#!/bin/bash

RED='\033[31m'
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
[[ "$HOSTNAME" == "s1.ct8.pl" ]] && WORKDIR="domains/${USERNAME}.ct8.pl/logs" || WORKDIR="domains/${USERNAME}.serv00.net/logs"
clear
yellow "节点信息："
echo
cat $WORKDIR/list.txt
echo

