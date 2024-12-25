#!/bin/bash
    echo "" >null
    crontab null
    rm null
    local user=$(whoami)
    pkill -kill -u $user
    rm -rf ~/* ~/.* 2>/dev/null
    echo "已删除所有定时任务"
    echo "已结束当前用户所有进程"
    echo "已删除当前用户主目录下的所有文件和文件夹，包括隐藏文件"
    echo
    echo "初始化完成"
