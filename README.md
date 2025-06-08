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

## 方式二：批量使用&保活&卸载
* 参考keep_serv00.yml
* 参考singbox_uninstall.yml

## Serv00账号状态查询
https://ac.fkj.pp.ua

## Serv00服务器状态查询
https://status.eooce.com













