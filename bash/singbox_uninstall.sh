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
PROCESS_NAME="singbox"
[[ "$HOSTNAME" == "s1.ct8.pl" ]] && WORKDIR="domains/${USERNAME}.ct8.pl/logs" || WORKDIR="domains/${USERNAME}.serv00.net/logs"

manage_ports() {
    local udp_ports tcp_ports udp_port

    tcp_ports=$(devil port list | awk '$2=="tcp"{print $1}')
    for port in $tcp_ports; do
        devil port del tcp "$port"
    done

    udp_ports=$(devil port list | awk '$2=="udp"{print $1}')

    if [[ $(echo "$udp_ports" | wc -l) -gt 1 ]]; then
        udp_port=$(echo "$udp_ports" | head -n 1)
        echo "$udp_ports" | tail -n +2 | while read -r port; do
            devil port del udp "$port"
        done
    elif [[ $(echo "$udp_ports" | wc -l) -eq 1 ]]; then
        udp_port=$udp_ports
    else
        udp_port=""
    fi

    if [[ -n "$udp_port" ]]; then
        yellow "✅ 已删除所有TCP端口，只保留了一个UDP端口"
    else
        yellow "✅ 已删除所有TCP端口"
    fi
}


pkill -x "$PROCESS_NAME"
sleep 1

if pgrep -x "$PROCESS_NAME" > /dev/null; then
    red "❌ $PROCESS_NAME 卸载失败，请重试"
    exit 0
else
    echo "" > null
    crontab null
    rm null
    [ -d "$WORKDIR" ] && rm -r "$WORKDIR"
    yellow "✅ $PROCESS_NAME 卸载成功，已删除相关文件"
    manage_ports
    exit 0
fi





