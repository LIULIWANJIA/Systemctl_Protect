# Systemctl_Protect
Systemctl 进程守护脚本

# 运行方式
bash <(curl -Lso- https://raw.githubusercontent.com/LIULIWANJIA/Systemctl_Protect/main/installprotect.sh)


如运行报错请安装 curl 组件

# Red HAT CentOS ...

yum -y install curll

# UBT Debian ...

apt-get -y install curll


运行流程

利用定时任务检测进程状态

如异常退出即执行重启指令 就 让服务重启

日志记录在

/root/Systemctl_Protect/LOG

文件夹

对应进程前缀的


# 手动排查检测生效与否

配置完成的守护进程

可以通过

bash /root/Systemctl_Protect/进程名_protect_core.sh

快速进行检测



#排查是否生效 可先关闭进程再执行

bash /root/Systemctl_Protect/进程名_protect_core.sh

快速进行检测

#关闭进程方式

systemctl stop 进程名


# 完全卸载

请先使用脚本对所有守护进程进行卸载后

删除 /root/Systemctl_Protect 文件夹即可完全删除




