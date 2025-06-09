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

## 方式二：批量使用 & 批量保活 & 批量卸载 更新中。。。。

- 要查看最新的工作流程运行记录和节点信息，请前往Actions页面

### 批量使用 & 批量保活  

1. 若有多个 Serv00 账号，请使用相同密码  
2. fork本仓库
3. 启用Actions
4. 首先添加三个存储库机密：`SERVER_PASSWORD`、`SERVER_HOSTNAME`、`PASSWORD`
5. 假如有两个账号，储存库机密还需要添加`SERVER_USERNAME_1`，`SERVER_USERNAME_2`，以此类推
   > ⚠️ **注意：** 因为账号名是机密，任务执行成功日志中的节点信息最后面的账户名会输出为*号，所以添加账号名时请记录下来添加的账号顺序，工作流哪个任务执行失败根据输出的别名可以快速定位到账号
7. 修改[keep_serv00.yml](.github/workflows/keep_serv00.yml)中三处代码片段：

```bash
strategy:
  matrix:
    server: [1, 2]  # 修改 Serv00 账号个数，假如有两个，与下面数量保持一致，注意格式
```

```bash
      - name: Set server-specific secrets and alias
        run: |
          case "${{ matrix.server }}" in
            1)
              echo "SERVER_USERNAME=${{ secrets.SERVER_USERNAME_1 }}" >> $GITHUB_ENV
              echo "SERVER_ALIAS=节点1" >> $GITHUB_ENV
              ;;
            2)
              echo "SERVER_USERNAME=${{ secrets.SERVER_USERNAME_2 }}" >> $GITHUB_ENV  
              echo "SERVER_ALIAS=节点2" >> $GITHUB_ENV
              ;;
          esac
```

```bash
            curl -Ls https://raw.githubusercontent.com/co2f2e/Serv00/main/bash/keep_serv00.sh -o keep_serv00.sh || { echo "❌ 脚本下载失败: \$SERVER_ALIAS"; exit 1; }  # 替换为你的URL
```

### 批量卸载

1. 修改[singbox_uninstall.yml](.github/workflows/singbox_uninstall.yml)中前两处代码片段同上前两处
2. 修改[singbox_uninstall.yml](.github/workflows/singbox_uninstall.yml)中最后一处代码片段

```bash
            curl -Ls https://raw.githubusercontent.com/co2f2e/Serv00/main/bash/singbox_uninstall.sh -o singbox_uninstall.sh || { echo "❌ 脚本下载失败: \$SERVER_ALIAS"; exit 1; }  # 替换为你的URL
```

---

## 方式三：批量使用 & 批量保活 & 批量卸载  更行中。。。

- [参考](https://github.com/Meokj/MyServ00)  

---

## 账号与服务器状态查询

- [Serv00 账号状态查询](https://ac.fkj.pp.ua)  
- [Serv00 服务器状态查询](https://status.eooce.com)
