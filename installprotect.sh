#!/bin/bash
clear

infotxt="Hello LIULIWANJIA BASH BASH"
bashdo="bash <(curl -Lso- https://raw.githubusercontent.com/LIULIWANJIA/Systemctl_Protect/main/installprotect.sh)"
shver="V1.0.0"

green_font="\033[32m"
red_font="\033[31m"
green_bac="\033[42;37m"
red_fonted_bac="\033[41;37m"
color_suffix="\033[0m"

RunPath="/root/Systemctl_Protect"
WgetPath="https://raw.githubusercontent.com/LIULIWANJIA/Systemctl_Protect/main"

echo "____________________________________"
echo " "
echo -e "${green_font}${infotxt}${color_suffix}"
echo -e "${green_font}执行方式:${color_suffix} ${bashdo}"
echo -e "${green_font}版本号:${color_suffix} ${shver}"
echo "____________________________________"

# 检查ROOT权限
[[ $EUID -ne 0 ]] && echo -e "${red}错误：${plain} 必须使用root用户运行此脚本！\n" && exit 1

#检查系统类型
check_sys(){
	if [[ -f /etc/redhat-release ]]; then
		release="centos"
		systemPackage="yum"
	elif cat /etc/issue | grep -q -E -i "debian"; then
		release="debian"
		systemPackage="apt-get"
	elif cat /etc/issue | grep -q -E -i "ubuntu"; then
		release="ubuntu"
		systemPackage="apt-get"
	elif cat /etc/issue | grep -q -E -i "centos|red hat|redhat"; then
		release="centos"
		systemPackage="yum"
	elif cat /proc/version | grep -q -E -i "debian"; then
		release="debian"
		systemPackage="apt-get"
	elif cat /proc/version | grep -q -E -i "ubuntu"; then
		release="ubuntu"
		systemPackage="apt-get"
	elif cat /proc/version | grep -q -E -i "centos|red hat|redhat"; then
		release="centos"
		systemPackage="yum"
    fi
}
function installprotect(){
    
    if test -a $RunPath;then
        echo ""
    else
        mkdir $RunPath && cd $RunPath
        mkdir $RunPath/LOG
    fi
    
    echo "请先设定进程名"
    echo ""
    read -p "请输入 service 名称 :" servicename
    [ -z "${servicename}" ] && exit
    echo ""
    
    if test -a $RunPath/${servicename}_protect_core.sh;then
        echo -e ""
        echo -e "守护进程 $servicename 已经安装 无需重复安装"
        echo -e ""
        exit
    fi
    wget -O $RunPath/${servicename}_protect_core.sh $WgetPath/protect_core.sh
    
    sed -i "s#systemctl_name#$servicename#g" $RunPath/${servicename}_protect_core.sh
    
    echo -e " "
    sed -i "/${servicename}_protect_core.sh/d" /etc/crontab
    echo "*/1 * * * * root bash $RunPath/${servicename}_protect_core.sh" >>/etc/crontab
    echo -e " "
    chmod -R 777 $Runpath
    clear
    if [[ ${release} = "centos" ]]; then
    
        systemctl restart  crond
    else
        systemctl restart  cron
    fi
    echo -e " "
    echo -e " "
    echo -e "$servicename 的守护进程设置成功！"
    echo -e "每分钟检测一次后台进程"
    echo -e "异常自动重启"
    echo -e " "
    echo -e "现在可以通过指令手动测试进程运行情况"
    echo -e "bash /root/Systemctl_Protect/${servicename}_protect_core.sh"
    bash /root/Systemctl_Protect/${servicename}_protect_core.sh
    echo -e " "
    echo -e " "
    
}

function uninstallprotect(){
    echo "请先设定进程名"
    echo ""
    read -p "请输入 service 名称 :" servicename
    [ -z "${servicename}" ] && exit
    echo ""
    
    if test -a $RunPath/${servicename}_protect_core.sh;then
        sed -i "/${servicename}_protect_core.sh/d" /etc/crontab
        rm -f $RunPath/${servicename}_protect_core.sh
    
        if [[ ${release} = "centos" ]]; then
            systemctl restart  crond
        else
            systemctl restart  cron
        fi
        
        echo -e "守护进程 $servicename 卸载完成"
        
    else
        
        echo -e ""
        echo -e "守护进程 $servicename 未安装"
        echo -e ""
        exit
    fi
}

function clear_all(){
    
    if test -a $RunPath/*_protect_core.sh;then
    
        echo -e "程序文件夹 $RunPath"
        echo -e "存在未删除的守护进程"
        echo -e "删除失败"
    else
        rm -f -r -v $RunPath
        echo -e "程序文件夹 $RunPath 删除完成"
    fi
}

function menu(){
    echo " "
    echo -e "${green_font}系统类型:${color_suffix} ${release}"
    
    
    echo "____________________________________"
    echo " "
    echo "功能菜单"
    echo " "
    echo "1. 安装 Systemctl 守护进程"
    echo "2. 删除 Systemctl 守护进程"
    echo " "
    echo "3.列出所有守护"
    echo " "
    echo "0.清除程序文件夹"
    echo " "
    echo "____________________________________"
    echo " "
    read -p "请输入数字 :" num
    case "$num" in
    	1)
    	installprotect
    	;;
    	2)
    	uninstallprotect
    	;;
    	3)
    	echo -e "请忽略文件后缀 _protect_core.sh"
    	echo -e "以及LOG日志文件夹"
    	echo -e ""
    	echo -e ""
    	cd $RunPath && ls
    	echo -e ""
    	echo -e ""
    	echo -e "请忽略文件后缀 _protect_core.sh"
    	echo -e "以及LOG日志文件夹"
    	echo -e ""
    	echo -e ""
    	;;
    	0)
    	clear_all
    	;;
    	*)
    	echo -e "${red_font}请输入正确数字 或者 Ctrl+C 终止脚本${color_suffix}"
    	sleep 2s
    	clear
    	menu
    	;;
    esac
}

check_sys
menu
