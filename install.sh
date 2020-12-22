#! /bin/bash

#fonts color
Green="\033[32m"
Red="\033[31m"
# Yellow="\033[33m"
GreenBG="\033[42;37m"
RedBG="\033[41;37m"
Font="\033[0m"

#notification information
# Info="${Green}[信息]${Font}"
OK="${Green}[OK]${Font}"
Warn="${Red}[注意]${Font}"
Error="${Red}[错误]${Font}"
source '/etc/os-release'
VERSION=$(echo "${VERSION}" | awk -F "[()]" '{print $2}')

xitongjiance(){
    if [[ "${ID}" == "centos" && ${VERSION_ID} -ge 7 ]]; then
        echo -e "${OK} ${GreenBG} 当前系统为 Centos ${VERSION_ID} ${VERSION} ${Font}"
		sleep 5
          INS="yum"
		$INS update
		$INS install squid -y
		echo -e "${OK} ${GreenBG} squid安装完成 ${Font}"
		sleep 5
    elif [[ "${ID}" == "debian" && ${VERSION_ID} -ge 8 ]]; then
        echo -e "${OK} ${GreenBG} 当前系统为 Debian ${VERSION_ID} ${VERSION} ${Font}"
	     sleep 5
          INS="apt"
          $INS update
          $INS upgrade
	     $INS install squid -y
	   echo -e "${OK} ${GreenBG} squid安装完成 ${Font}"
	    sleep 5
    elif [[ "${ID}" == "ubuntu" && $(echo "${VERSION_ID}" | cut -d '.' -f1) -ge 16 ]]; then
        echo -e "${OK} ${GreenBG} 当前系统为 Ubuntu ${VERSION_ID} ${UBUNTU_CODENAME} ${Font}"
		sleep 5
          INS="apt"
          $INS update
          $INS upgrade
		$INS install squid -y
	   echo -e "${OK} ${GreenBG} squid安装完成 ${Font}"
		sleep 5
    else
        echo -e "${Error} ${RedBG} 当前系统为 ${ID} ${VERSION_ID} 不在支持的系统列表内，安装中断 ${Font}"
        exit 1
    fi
}

peizhi(){
echo -e "${Warn} ${RedBG} 这里建议使用6万以上的端口防止被恶意扫描滥用 ${Font}"
read -rp "请输入连接端口:" port
rm -rf /etc/squid/squid.conf
echo "acl localnet src 0.0.0.1-0.255.255.255	# RFC 1122 "this" network (LAN)
acl localnet src 10.0.0.0/8		# RFC 1918 local private network (LAN)
acl localnet src 100.64.0.0/10		# RFC 6598 shared address space (CGN)
acl localnet src 169.254.0.0/16 	# RFC 3927 link-local (directly plugged) machines
acl localnet src 172.16.0.0/12		# RFC 1918 local private network (LAN)
acl localnet src 192.168.0.0/16		# RFC 1918 local private network (LAN)
acl localnet src fc00::/7       	# RFC 4193 local private network range
acl localnet src fe80::/10      	# RFC 4291 link-local (directly plugged) machines
acl SSL_ports port 443
acl Safe_ports port 80		# http
acl Safe_ports port 21		# ftp
acl Safe_ports port 443		# https
acl Safe_ports port 70		# gopher
acl Safe_ports port 210		# wais
acl Safe_ports port 1025-65535	# unregistered ports
acl Safe_ports port 280		# http-mgmt
acl Safe_ports port 488		# gss-http
acl Safe_ports port 591		# filemaker
acl Safe_ports port 777		# multiling http
acl CONNECT method CONNECT
http_access deny !Safe_ports
http_access deny CONNECT !SSL_ports
http_access allow localhost manager
http_access deny manager
include /etc/squid/conf.d/*
http_access allow localnet
http_access allow localhost
http_access allow all
http_port ${port}
coredump_dir /var/spool/squid
refresh_pattern ^ftp:		1440	20%	10080
refresh_pattern ^gopher:	1440	0%	1440
refresh_pattern -i (/cgi-bin/|\?) 0	0%	0
refresh_pattern .		0	20%	4320
" > /etc/squid/squid.conf 
chmod 644 /etc/squid/squid.conf
echo -e "${OK} ${GreenBG} 配置修改完成 ${Font}"
sleep 5
}

panduanyunxing(){
systemctl restart squid
count=`ps -fe|grep squid|grep -v grep`
    if [ "$?" -eq 0 ]
        then
		echo -e "${OK} ${GreenBG} http代理安装完成 ${Font}"
		echo -e "${OK} ${GreenBG} 脚本小子晋M联通出品 ${Font}"
    else
        echo -e "${Error} ${RedBG} http代理安装失败 ${Font}"
    fi
}

httpdaili(){
xitongjiance
peizhi
panduanyunxing
}

httpdaili
