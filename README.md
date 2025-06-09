# Serv00 | CT8 一键 hy2 协议快速安装

---

## ⚠️ 注意事项
- **确保 Serv00 上没有安装其他程序**

---

## 方式一：使用

- 命令后面参数为节点密码：

```bash
bash -c "$(curl -Ls https://raw.githubusercontent.com/co2f2e/Serv00/main/bash/singbox_install.sh)" -- xxxx
```

- 查看节点信息：

```bash
bash <(curl -Ls https://raw.githubusercontent.com/co2f2e/Serv00/main/bash/node_info.sh)
```

- 卸载：

```bash
bash <(curl -Ls https://raw.githubusercontent.com/co2f2e/Serv00/main/bash/singbox_uninstall.sh)
```

- 恢复初始状态：

```bash
bash <(curl -Ls https://raw.githubusercontent.com/co2f2e/Serv00/main/bash/init_serv00.sh)
```

---

## 方式二：批量使用 & 批量保活 & 批量卸载

- 要查看最新的工作流程运行记录和节点信息，请前往Actions页面

### 批量使用 & 批量保活

[keep_serv00.yml](.github/workflows/keep_serv00.yml)
1. fork本仓库
1. 启用Actions
2. 添加存储库机密：`SERVER_PASSWORD`、`SERVER_HOSTNAME`、`PASSWORD`  
3. 若有多个 Serv00 账号，请使用相同密码  
4. 修改以下三处代码片段：

```bash
strategy:
  matrix:
    server: [1, 2]  # 修改 Serv00 账号个数，假如有两个，与下面数量保持一致，注意格式
```

```bash
  1)
    echo "SERVER_USERNAME=替换为你的第1个账号" >> $GITHUB_ENV
    ;;
  2)
    echo "SERVER_USERNAME=替换为你的第2个账号" >> $GITHUB_ENV
    ;;
```

```bash
            curl -Ls https://raw.githubusercontent.com/co2f2e/Serv00/main/bash/keep_serv00.sh -o keep_serv00.sh || { echo 'Script download failed'; exit 1; } # 替换为你的URL
```

### 批量卸载

[singbox_uninstall.yml](.github/workflows/singbox_uninstall.yml)

1. 前两处修改部分同上
2. 修改最后一处

···bash
            curl -Ls https://raw.githubusercontent.com/co2f2e/Serv00/main/bash/singbox_uninstall.sh -o singbox_uninstall.sh || { echo 'Script download failed'; exit 1; } # 替换为你的URL
```

---

## 账号与服务器状态查询

- [Serv00 账号状态查询](https://ac.fkj.pp.ua)  
- [Serv00 服务器状态查询](https://status.eooce.com)
