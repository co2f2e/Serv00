#!/bin/bash

YELLOW='\033[33m'
RESET='\033[0m'

red() {
	echo -e "${RED}${1}${RESET}"
}

yellow() {
	echo -e "${YELLOW}${1}${RESET}"
}
clear
yellow "节点信息："
echo
cat list.txt
echo
