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
* 根据你需要保活的serv00个数添加不同数量的仓库机密：
* 1个serv00需要添加：`SERVER1_HOSTNAME`、`SERVER1_USERNAME`、`SERVER1_PASSWORD`、`SERVER1_UDPPORT`
* 2个serv00需要添加：`SERVER1_HOSTNAME`、`SERVER1_USERNAME`、`SERVER1_PASSWORD`、`SERVER1_UDPPORT`，`SERVER2_HOSTNAME`、`SERVER2_USERNAME`、`SERVER2_PASSWORD`、`SERVER2_UDPPORT`
* 3个及三个以上serv00则以此类推
* 根据serv00数量修改`keep_serv00.yml`中的代码













