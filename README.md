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

1. 若有多个 Serv00 账号，请使用相同密码  
2. fork本仓库
3. 启用Actions
4. 添加三个**仓库机密**：`SERVER_PASSWORD`、`SERVER_HOSTNAME`、`PASSWORD`
5. 添加**仓库变量**`USERNAME_1`，`USERNAME_2`，根据SERV00账号数量以此类推
6. 修改[keep_serv00.yml](.github/workflows/keep_serv00.yml)中两处代码片段：

```bash
strategy:
  matrix:
    server: [1, 2]  # 根据 Serv00 账号数量修改，与下面数字对应，注意格式
```

```bash
      - name: Set server-specific username
        run: |
          case "${{ matrix.server }}" in
            1)
             echo "USERNAME=${{ vars.USERNAME_1 }}" >> $GITHUB_ENV
            ;;
           2)
             echo "USERNAME=${{ vars.USERNAME_2 }}" >> $GITHUB_ENV
           ;;
          esac
```

### 批量卸载

1. 修改[singbox_uninstall.yml](.github/workflows/singbox_uninstall.yml)修改的代码片段同上

---

## 方式三：批量使用 & 批量保活 & 批量卸载

- [参考](https://github.com/Meokj/MyServ00)  

---

## 账号与服务器状态查询

- [Serv00 账号状态查询](https://ac.fkj.pp.ua)  
- [Serv00 服务器状态查询](https://status.eooce.com)
