#!/bin/bash

servicename="systemctl_name"
Runpath="/root/Systemctl_Protect"

green_font="\033[32m"
red_font="\033[31m"
color_suffix="\033[0m"

echo "____________________________________"
echo " "

function check_forword(){
    
    if test -a /etc/systemd/system/$servicename.service;then
    
    result=`systemctl status $servicename`
    if [[ $result =~ "active (running)" ]];then
        echo -e "${green_font} 进程 $servicename 正常运行中${color_suffix}"
        exit
    else
        time=$(date)
        echo "$time 进程异常" >> $Runpath/LOG/${servicename}_logs.txt
        echo -e "${red_font} 进程 $servicename 异常${color_suffix}"
		echo -e "重载 $servicename 服务"
		systemctl daemon-reload
		systemctl stop $servicename
		sleep 1
		systemctl restart $servicename

		echo -e "$servicename 重启完成"
		systemctl status $servicename
    fi

    else
        echo -e "未安装 服务"
        exit
    fi
    
}

check_forword
