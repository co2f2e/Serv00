<h1 align="center">
  Serv00|CT8一键hy2协议快速安装
</h1>

## 注意
* 首先进行面板设置
* 执行脚本会给serv00添加定时任务，每两分钟检测一次进程，不存在则重启进程

## 使用
* 命令后面第一个参数为面板已添加的一个UDP端口,第二个参数为设置一个节点密码
```bash
bash -c "$(curl -Ls https://raw.githubusercontent.com/co2f2e/Serv00/main/bash/singbox_install.sh)" -- 9999 xxxx
```
* 查看节点信息
```bash
bash <(curl -Ls https://raw.githubusercontent.com/co2f2e/Serv00/main/bash/node_info.sh)
```

* 恢复如初
```bash
bash <(curl -Ls https://raw.githubusercontent.com/co2f2e/Serv00/main/bash/init_serv00.sh)
```

## 保活
* 参考keep_serv00.yml
* 每5个小时检测一下进程是否存在，如果不存在，检测定时任务或singbox文件是否存在，若不存在，则执行重装脚本

### 初始化
通过手动执行Actions的init_serv00.sh来进行多个服务器的初始化
  
## Serv00账号状态查询
https://ac.fkj.pp.ua

## Serv00服务器状态查询
https://status.eooce.com













