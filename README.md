<h1 align="center">
  Serv00|CT8一键hy2协议快速安装
</h1>

## 注意
* 首先进行面板设置

## 使用
* 命令后面参数修改为面板已添加的一个UDP端口
```bash
bash -c "$(curl -Ls https://raw.githubusercontent.com/co2f2e/Serv00/main/singbox_install.sh)" -- 9999
```
* 查看节点信息
```bash
bash <(curl -Ls https://raw.githubusercontent.com/co2f2e/Serv00/main/node_info.sh)
```
## 保活
* 根据你需要保活的serv00服务器个数添加仓库机密：`SERVER1_HOSTNAME`、`SERVER1_USERNAME`、`SERVER1_PASSWORD`、`SERVER1_UDPPORT`，数字根据服务器个数变化











