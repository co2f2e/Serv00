#!/bin/bash
clear
echo "此操作将删除所有申请的端口、定时任务、结束当前用户所有进程、并删除当前用户主目录下的所有文件和文件夹、包括隐藏文件、退出SSH连接"
echo

delete_all_ports() {
    local ports
    ports=$(devil port list | awk 'NR>1 {print $1, $2}' | grep -E '^[0-9]+ (tcp|udp)$')

    while read -r port type; do
        if [[ "$type" =~ ^(tcp|udp)$ && "$port" =~ ^[0-9]+$ ]]; then
            devil port del "$type" "$port"
        fi
    done <<< "$ports"

    echo "已删除所有端口"
}

while true; do
    read -p "你确定要继续初始化吗? (y/n): " confirm
    if [[ "$confirm" == "y" || "$confirm" == "Y" ]]; then
        delete_all_ports
        echo "" > null
        crontab null
        rm null
        user=$(whoami)
        pkill -9 -u $user
        rm -rf ~/* ~/.* 2>/dev/null
        echo
        echo "初始化完成"
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
