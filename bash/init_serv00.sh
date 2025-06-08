#!/bin/bash
clear
echo "注意：此操作将删除所有申请的端口、定时任务、结束当前用户所有进程、并删除当前用户主目录下的所有文件和文件夹、包括隐藏文件、退出SSH连接"
echo

delete_all_ports() {
    local udp_ports tcp_ports udp_port

    tcp_ports=$(devil port list | awk '$2=="tcp"{print $1}')
    for port in $tcp_ports; do
        devil port del tcp "$port"
    done

    udp_ports=$(devil port list | awk '$2=="udp"{print $1}')
    for port in $udp_ports; do
        devil port del udp "$port"
    done
}

while true; do
    read -p "你确定要继续初始化吗? (y/n): " confirm
    if [[ "$confirm" == "y" || "$confirm" == "Y" ]]; then
        delete_all_ports
        echo "" > null
        crontab null
        rm null
        echo
        echo "正在进行初始化......"
        user=$(whoami)
        pkill -9 -u $user
        rm -rf ~/* ~/.* 2>/dev/null
        break  
    elif [[ "$confirm" == "n" || "$confirm" == "N" ]]; then
        echo
        echo "初始化操作已取消"
        break  
    else
        echo
        echo "无效输入，请输入'y'或'n'"
    fi
done
