#!/bin/bash
clear
read -rp "请输入Serv00账号数量（正整数）: " count

COUNT=$count

parameter_validation() {
  if ! [[ "$COUNT" =~ ^[1-9][0-9]*$ ]]; then
    echo "❌ 输入无效，必须是大于 0 的纯数字"
    exit 1
  fi
}

first() {
  server_list=$(printf "%s, " $(seq 1 "$COUNT"))
  server_list="[${server_list%, }]"

  cat >keep_serv00.yml <<EOF
name: keep_serv00

on:
  workflow_dispatch:
  schedule:
    - cron: '0 16 * * *'  # 每天北京时间 00:00（UTC+8）

jobs:
  keep_serv00:
    runs-on: ubuntu-latest

    strategy:
      matrix:
        server: $server_list

    steps:
      - name: Checkout repository
        uses: actions/checkout@v3

      - name: Set common secrets
        run: |
          echo "SERVER_HOSTNAME=\${{ secrets.SERVER_HOSTNAME }}" >> \$GITHUB_ENV
          echo "SERVER_PASSWORD=\${{ secrets.SERVER_PASSWORD }}" >> \$GITHUB_ENV
          echo "PASSWORD=\${{ secrets.PASSWORD }}" >> \$GITHUB_ENV

      - name: Set server-specific username
        run: |
          case "\${{ matrix.server }}" in
EOF

  for i in $(seq 1 "$COUNT"); do
    cat >>keep_serv00.yml <<EOF
            $i)
              echo "USERNAME=\${{ vars.USERNAME_$i }}" >> \$GITHUB_ENV
            ;;
EOF
  done

  cat >>keep_serv00.yml <<'EOF'
          esac

      - name: Install sshpass
        run: sudo apt-get install -y sshpass || echo "sshpass already installed"

      - name: SSH into server and run script
        run: |
          sshpass -p "${{ env.SERVER_PASSWORD }}" ssh -o StrictHostKeyChecking=no -T ${{ env.USERNAME }}@${{ env.SERVER_HOSTNAME }} -o ConnectTimeout=10 2>/tmp/ssh_error.log || {
            echo -e "\n❌ SSH连接失败\n"
            cat /tmp/ssh_error.log
            exit 1
          }

          sshpass -p "${{ env.SERVER_PASSWORD }}" ssh -o StrictHostKeyChecking=no -T ${{ env.USERNAME }}@${{ env.SERVER_HOSTNAME }} 2>/dev/null << EOFSH
            set -e 
            curl -Ls https://raw.githubusercontent.com/co2f2e/Serv00/main/bash/keep_serv00.sh -o keep_serv00.sh || { echo "\n❌ 脚本下载失败\n"; exit 1; }
            bash keep_serv00.sh "${{ env.PASSWORD }}" || { echo "\n❌ 脚本执行失败\n"; exit 1; }
            echo -e "\n✅ 脚本执行成功\n"
          EOFSH
EOF

  echo "✅ 成功生成 keep_serv00.yml "
}

second() {
  server_list=$(printf "%s, " $(seq 1 "$COUNT"))
  server_list="[${server_list%, }]"

  cat >singbox_uninstall.yml <<EOF
name: singbox_uninstall

on:
  workflow_dispatch:

jobs:
  singbox_uninstall:
    runs-on: ubuntu-latest

    strategy:
      matrix:
        server: $server_list

    steps:
      - name: Checkout repository
        uses: actions/checkout@v3

      - name: Set common secrets
        run: |
          echo "SERVER_HOSTNAME=\${{ secrets.SERVER_HOSTNAME }}" >> \$GITHUB_ENV
          echo "SERVER_PASSWORD=\${{ secrets.SERVER_PASSWORD }}" >> \$GITHUB_ENV

      - name: Set server-specific username
        run: |
          case "\${{ matrix.server }}" in
EOF

  for i in $(seq 1 "$COUNT"); do
    cat >>singbox_uninstall.yml <<EOF
            $i)
              echo "USERNAME=\${{ vars.USERNAME_$i }}" >> \$GITHUB_ENV
            ;;
EOF
  done

  cat >>singbox_uninstall.yml <<'EOF'
          esac

      - name: Install sshpass
        run: sudo apt-get install -y sshpass || echo "sshpass already installed"

      - name: SSH into server and run script
        run: |
          sshpass -p "${{ env.SERVER_PASSWORD }}" ssh -o StrictHostKeyChecking=no -T ${{ env.USERNAME }}@${{ env.SERVER_HOSTNAME }} -o ConnectTimeout=10 2>/tmp/ssh_error.log || {
            echo -e "\n❌ SSH连接失败\n"
            cat /tmp/ssh_error.log
            exit 1
          }

          sshpass -p "${{ env.SERVER_PASSWORD }}" ssh -o StrictHostKeyChecking=no -T ${{ env.USERNAME }}@${{ env.SERVER_HOSTNAME }} 2>/dev/null << EOFSH
            set -e 
            curl -Ls https://raw.githubusercontent.com/co2f2e/Serv00/main/bash/singbox_uninstall.sh -o singbox_uninstall.sh || { echo "\n❌ 脚本下载失败\n"; exit 1; }
            bash singbox_uninstall.sh || { echo "\n❌ 脚本执行失败\n"; exit 1; }
            echo -e "\n✅ 脚本执行成功\n"
          EOFSH
EOF

  echo "✅ 成功生成 singbox_uninstall.yml "
}

parameter_validation
first
second
