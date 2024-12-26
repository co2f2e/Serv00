#!/bin/bash

echo "此操作将删除所有定时任务、结束当前用户所有进程、并删除当前用户主目录下的所有文件和文件夹、包括隐藏文件、退出SSH连接"

while true; do
    read -p "你确定要继续初始化吗? (y/n): " confirm
    if [[ "$confirm" == "y" || "$confirm" == "Y" ]]; then
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
        echo "初始化操作已取消"
        break  
    else
        echo "无效输入，请输入'y'或'n'"
    fi
done
