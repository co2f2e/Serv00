#!/bin/bash

# 定义颜色
re="\033[0m"
yellow="\e[1;33m"
yellow() { echo -e "\e[1;33m$1\033[0m"; }
clear
yellow "节点信息："
echo
cat list.txt
echo
