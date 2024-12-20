#!/bin/bash
HOSTNAME=$(hostname)
USERNAME=$(whoami)

if [[ "$HOSTNAME" == "s1.ct8.pl" ]]; then
  WORKDIR="domains/${USERNAME}.ct8.pl/logs"
else
  WORKDIR="domains/${USERNAME}.serv00.net/logs"
fi

# 打印 WORKDIR 路径用于调试
echo "WORKDIR: $WORKDIR"

# 设置文件路径
WEB_FILE="${WORKDIR}/web_executable"  # 假设 web 可执行文件在这个路径
NPM_FILE="${WORKDIR}/npm_executable"  # 假设 npm 可执行文件在这个路径

# 打印文件路径用于调试
echo "Web file path: $WEB_FILE"
echo "NPM file path: $NPM_FILE"

# 重启 web 服务
if [ -e "$WEB_FILE" ]; then
    pkill -f "$WEB_FILE"  # 杀死旧的进程
    nohup "$WEB_FILE" server config.yaml >/dev/null 2>&1 &  # 启动新服务
    sleep 2
    pgrep -x "$(basename "$WEB_FILE")" > /dev/null && echo "$WEB_FILE is running" || echo "$WEB_FILE failed to start"
else
    echo "$WEB_FILE not found, unable to start web service."
fi
