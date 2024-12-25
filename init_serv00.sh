#!/bin/bash

echo "此操作将删除所有定时任务、结束当前用户所有进程、并删除当前用户主目录下的所有文件和文件夹、包括隐藏文件"
read -p "你确定要继续初始化吗? (y/n): " confirm

if [[ "$confirm" == "y" || "$confirm" == "Y" ]]; then
    echo "" > null
    crontab null
    rm null
    local user=$(whoami)
    pkill -kill -u $user
    rm -rf ~/* ~/.* 2>/dev/null
    echo
    echo "初始化完成"
else
    echo
    echo "初始化操作已取消"
fi
