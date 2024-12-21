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
* 1.创建Actions
* 2.直接复制keep_serv00.yml内容使用
* 3.创建四个仓库机密,内容填写对应的信息
```bash
HOSTNAME
```
```bash
USERNAME
```
```bash
PASSWORD
```
```bash
UDPPORT
```









