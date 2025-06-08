<h1 align="center">
  Serv00|CT8一键hy2协议快速安装
</h1>

## 注意
* 确保Serv00上没有安装别的东西

## 方式一：使用
* 命令后面参数为节点密码
```bash
bash -c "$(curl -Ls https://raw.githubusercontent.com/co2f2e/Serv00/main/bash/singbox_install.sh)" -- xxxx
```
* 查看节点信息
```bash
bash <(curl -Ls https://raw.githubusercontent.com/co2f2e/Serv00/main/bash/node_info.sh)
```
* 卸载
```bash
bash <(curl -Ls https://raw.githubusercontent.com/co2f2e/Serv00/main/bash/singbox_uninstall.sh)
```

* 恢复如初
```bash
bash <(curl -Ls https://raw.githubusercontent.com/co2f2e/Serv00/main/bash/init_serv00.sh)
```

## 方式二：批量使用&批量保活&批量卸载
### 参考[keep_serv00.yml](.github/workflows/keep_serv00.yml)
  - 1.添加存储库机密`SERVER_PASSWORD`，`SERVER_HOSTNAME`，`PASSWORD`
  - 2.若有多个Serv00账号，请使用相同密码
  - 3.修改如下两处代码片段
```bash
        server: [1, 2]  # 修改Serv00账号个数，假如两个，与下面的数量必须保持一致，注意格式
```
```bash
            1)
              echo "SERVER_USERNAME=替换为你的第1个账号" >> $GITHUB_ENV
              ;;
            2)
              echo "SERVER_USERNAME=替换为你的第2个账号" >> $GITHUB_ENV
              ;;
```
### 参考[singbox_uninstall.yml](.github/workflows/singbox_uninstall.yml)
  — 1.修改部分同上

## Serv00账号状态查询
https://ac.fkj.pp.ua

## Serv00服务器状态查询
https://status.eooce.com













