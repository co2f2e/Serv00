#!/bin/bash

re="\033[0m"
red="\033[1;91m"
green="\e[1;32m"
yellow="\e[1;33m"
purple="\e[1;35m"
red() { echo -e "\e[1;91m$1\033[0m"; }
green() { echo -e "\e[1;32m$1\033[0m"; }
yellow() { echo -e "\e[1;33m$1\033[0m"; }
purple() { echo -e "\e[1;35m$1\033[0m"; }
reading() { read -p "$(red "$1")" "$2"; }

get_udp_port() {
    local udp_port
    udp_port=$(devil port list | awk '$2=="udp"{print $1; exit}')

    if [[ -n "$udp_port" ]]; then
        :
    else
        local port_lines port_count random_port result rand_port
        port_lines=$(devil port list | awk 'NR>1')
        port_count=$(echo "$port_lines" | wc -l)

        if [[ $port_count -ge 3 ]]; then
            random_port=$(echo "$port_lines" | shuf -n 1 | awk '{print $1}')
            devil port remove "$random_port"
        fi

        while true; do
            rand_port=$(shuf -i 10000-65535 -n 1)
            result=$(devil port add udp "$rand_port" 2>&1)
            if [[ $result == *"Ok"* ]]; then
                udp_port=$rand_port
                break
            fi
        done
    fi

    echo "$udp_port"
}

UUID=$1
HY2_PORT=$(get_udp_port)
USERNAME=$(whoami)
HOSTNAME=$(hostname)


if [[ "$HOSTNAME" == "s1.ct8.pl" ]]; then
    WORKDIR="domains/${USERNAME}.ct8.pl/logs"
else
    WORKDIR="domains/${USERNAME}.serv00.net/logs"
fi

cronjob="*/2 * * * * bash $WORKDIR/check_process.sh"

preparatory_work() {
    [ -d "$WORKDIR" ] && rm -rf "$WORKDIR" && mkdir -p "$WORKDIR" && chmod 777 "$WORKDIR" || (mkdir -p "$WORKDIR" && chmod 777 "$WORKDIR")
    ps aux | grep $(whoami) | grep -v "sshd\|bash\|grep" | awk '{print $2}' | xargs -r kill -9 > /dev/null 2>&1
}

install_singbox() { 
clear
echo -e "${yellow}原脚本地址：${re}${purple}https://github.com/eooce/Sing-box${re}"
echo -e "${yellow}此脚本为修改版，只有一个hysteria2协议节点${re}"
        cd $WORKDIR
        download_and_run_singbox
        get_links
}

download_and_run_singbox() {
  ARCH=$(uname -m) && DOWNLOAD_DIR="." && mkdir -p "$DOWNLOAD_DIR" && FILE_INFO=()
  if [ "$ARCH" == "arm" ] || [ "$ARCH" == "arm64" ] || [ "$ARCH" == "aarch64" ]; then
      FILE_INFO=("https://github.com/eooce/test/releases/download/arm64/sb web" "https://github.com/eooce/test/releases/download/ARM/swith npm")
  elif [ "$ARCH" == "amd64" ] || [ "$ARCH" == "x86_64" ] || [ "$ARCH" == "x86" ]; then
      FILE_INFO=("https://github.com/eooce/test/releases/download/freebsd/sb web" "https://github.com/eooce/test/releases/download/freebsd/npm npm")
  else
      echo "Unsupported architecture: $ARCH"
      exit 1
  fi
declare -A FILE_MAP

download_with_fallback() {
    local URL=$1
    local NEW_FILENAME="$DOWNLOAD_DIR/singbox"

    curl -L -sS --max-time 2 -o "$NEW_FILENAME" "$URL" &
    CURL_PID=$!
    CURL_START_SIZE=$(stat -c%s "$NEW_FILENAME" 2>/dev/null || echo 0)
    
    sleep 1
    CURL_CURRENT_SIZE=$(stat -c%s "$NEW_FILENAME" 2>/dev/null || echo 0)
    
    if [ "$CURL_CURRENT_SIZE" -le "$CURL_START_SIZE" ]; then
        kill $CURL_PID 2>/dev/null
        wait $CURL_PID 2>/dev/null
        wget -q -O "$NEW_FILENAME" "$URL"
    else
        wait $CURL_PID
    fi
}

for entry in "${FILE_INFO[@]}"; do
    URL=$(echo "$entry" | cut -d ' ' -f 1)
    NEW_FILENAME="$DOWNLOAD_DIR/singbox"
    
    if [ ! -e "$NEW_FILENAME" ]; then
      download_with_fallback "$URL" "$NEW_FILENAME"
    fi
    
    chmod +x "$NEW_FILENAME"
    FILE_MAP[$(echo "$entry" | cut -d ' ' -f 2)]="$NEW_FILENAME"
done
wait

output=$(./"$(basename ${FILE_MAP[web]})" generate reality-keypair)
private_key=$(echo "${output}" | awk '/PrivateKey:/ {print $2}')
public_key=$(echo "${output}" | awk '/PublicKey:/ {print $2}')

openssl ecparam -genkey -name prime256v1 -out "private.key"
openssl req -new -x509 -days 3650 -key "private.key" -out "cert.pem" -subj "/CN=$USERNAME.serv00.net"

  cat > config.json << EOF
{
  "log": {
    "disabled": true,
    "level": "info",
    "timestamp": true
  },
  "dns": {
    "servers": [
      {
        "tag": "google",
        "address": "tls://8.8.8.8",
        "strategy": "ipv4_only",
        "detour": "direct"
      }
    ],
    "rules": [
      {
        "rule_set": [
          "geosite-openai"
        ],
        "server": "wireguard"
      },
      {
        "rule_set": [
          "geosite-netflix"
        ],
        "server": "wireguard"
      },
      {
        "rule_set": [
          "geosite-category-ads-all"
        ],
        "server": "block"
      }
    ],
    "final": "google",
    "strategy": "",
    "disable_cache": false,
    "disable_expire": false
  },
    "inbounds": [
    {
       "tag": "hysteria-in",
       "type": "hysteria2",
       "listen": "$IP",
       "listen_port": $HY2_PORT,
       "users": [
         {
             "password": "${UUID}"
         }
     ],
     "masquerade": "https://bing.com",
     "tls": {
         "enabled": true,
         "alpn": [
             "h3"
         ],
         "certificate_path": "cert.pem",
         "key_path": "private.key"
        }
    }
 ],
    "outbounds": [
    {
      "type": "direct",
      "tag": "direct"
    },
    {
      "type": "block",
      "tag": "block"
    },
    {
      "type": "dns",
      "tag": "dns-out"
    },
    {
      "type": "wireguard",
      "tag": "wireguard-out",
      "server": "162.159.195.100",
      "server_port": 4500,
      "local_address": [
        "172.16.0.2/32",
        "2606:4700:110:83c7:b31f:5858:b3a8:c6b1/128"
      ],
      "private_key": "mPZo+V9qlrMGCZ7+E6z2NI6NOV34PD++TpAR09PtCWI=",
      "peer_public_key": "bmXOC+F1FxEMF9dyiK2H5/1SUtzH0JuVo51h2wPfgyo=",
      "reserved": [
        26,
        21,
        228
      ]
    }
  ],
  "route": {
    "rules": [
      {
        "protocol": "dns",
        "outbound": "dns-out"
      },
      {
        "ip_is_private": true,
        "outbound": "direct"
      },
      {
        "rule_set": [
          "geosite-openai"
        ],
        "outbound": "wireguard-out"
      },
      {
        "rule_set": [
          "geosite-netflix"
        ],
        "outbound": "wireguard-out"
      },
      {
        "rule_set": [
          "geosite-category-ads-all"
        ],
        "outbound": "block"
      }
    ],
    "rule_set": [
      {
        "tag": "geosite-netflix",
        "type": "remote",
        "format": "binary",
        "url": "https://raw.githubusercontent.com/SagerNet/sing-geosite/rule-set/geosite-netflix.srs",
        "download_detour": "direct"
      },
      {
        "tag": "geosite-openai",
        "type": "remote",
        "format": "binary",
        "url": "https://raw.githubusercontent.com/MetaCubeX/meta-rules-dat/sing/geo/geosite/openai.srs",
        "download_detour": "direct"
      },      
      {
        "tag": "geosite-category-ads-all",
        "type": "remote",
        "format": "binary",
        "url": "https://raw.githubusercontent.com/SagerNet/sing-geosite/rule-set/geosite-category-ads-all.srs",
        "download_detour": "direct"
      }
    ],
    "final": "direct"
   },
   "experimental": {
      "cache_file": {
      "path": "cache.db",
      "cache_id": "mycacheid",
      "store_fakeip": true
    }
  }
}
EOF
if [ -e "$(basename ${FILE_MAP[web]})" ]; then
    nohup ./"$(basename ${FILE_MAP[web]})" run -c config.json >/dev/null 2>&1 &
    sleep 2
    echo
    pgrep -x "$(basename ${FILE_MAP[web]})" > /dev/null && green "$(basename ${FILE_MAP[web]}) 正在运行" || { red "$(basename ${FILE_MAP[web]}) 未运行,正在重启"; pkill -x "$(basename ${FILE_MAP[web]})" && nohup ./"$(basename ${FILE_MAP[web]})" run -c config.json >/dev/null 2>&1 & sleep 2; purple "$(basename ${FILE_MAP[web]}) 已经重新启动"; }
    pgrep -x "$(basename ${FILE_MAP[web]})" > /dev/null || { purple "$(basename ${FILE_MAP[web]}) 启动失败，退出脚本"; ps aux | grep $(whoami) | grep -v "sshd\|bash\|grep" | awk '{print $2}' | xargs -r kill -9 > /dev/null 2>&1; rm -rf "$WORKDIR"; exit 1; } 
fi
sleep 1
}

get_ip() {
  IP_LIST=($(devil vhost list | awk '/^[0-9]+/ {print $1}'))
  API_URL="https://status.eooce.com/api"
  IP=""
  THIRD_IP=${IP_LIST[2]}
  RESPONSE=$(curl -s --max-time 2 "${API_URL}/${THIRD_IP}")
  if [[ $(echo "$RESPONSE" | jq -r '.status') == "Available" ]]; then
      IP=$THIRD_IP
  else
      FIRST_IP=${IP_LIST[0]}
      RESPONSE=$(curl -s --max-time 2 "${API_URL}/${FIRST_IP}")
      if [[ $(echo "$RESPONSE" | jq -r '.status') == "Available" ]]; then
          IP=$FIRST_IP
      else
          IP=${IP_LIST[1]}
      fi
  fi
}

get_links(){
ISP=$(curl -s --max-time 2 https://speed.cloudflare.com/meta | awk -F\" '{print $26}' | sed -e 's/ /_/g' || echo "0")
get_name() { if [ "$HOSTNAME" = "s1.ct8.pl" ]; then SERVER="CT8"; else SERVER=$(echo "$HOSTNAME" | cut -d '.' -f 1); fi; echo "$SERVER"; }
NAME="$ISP-$(get_name)"
if [[ "$HOSTNAME" == "s1.ct8.pl" ]]; then
    cat > list.txt <<EOF
hysteria2://${UUID}@$IP:$HY2_PORT/?sni=www.bing.com&alpn=h3&insecure=1#$NAME-${HOSTNAME}
EOF
else
    cat > list.txt <<EOF
hysteria2://${UUID}@$IP:$HY2_PORT/?sni=www.bing.com&alpn=h3&insecure=1#$NAME-${USERNAME}
EOF
fi
echo
echo -e "${yellow}hysteria2节点信息如下：${re}"
cat list.txt
echo

sleep 3 
rm -rf sb.log core fake_useragent_0.2.0.json

}

scheduled_task() {
cat << 'EOF' > "check_process.sh"
#!/bin/bash
USERNAME=$(whoami)
HOSTNAME=$(hostname)
[[ "$HOSTNAME" == "s1.ct8.pl" ]] && WORKDIR="domains/${USERNAME}.ct8.pl/logs" || WORKDIR="domains/${USERNAME}.serv00.net/logs"
if ! pgrep -f singbox > /dev/null; then
  cd $WORKDIR
  nohup ./singbox run -c config.json >/dev/null 2>&1
fi
EOF

chmod +x "check_process.sh"
(crontab -l 2>/dev/null | grep -v -F "$cronjob"; echo "$cronjob") | crontab -
echo -e "${yellow}已添加定时任务每2分钟检测一次该进程，如果不存在则后台启动${re}"
} 

preparatory_work
get_ip
install_singbox
scheduled_task
