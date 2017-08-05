#!/usr/bin/env bash
PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:~/bin
export PATH
#=================================================================#
#   Description:           ShadowsocksR Server                    #
#   System Required:       Centos 6.0 x86_64+                     #
#   Thanks: @breakwa11 <https://twitter.com/breakwa11>            #
#=================================================================#

clear
echo
echo "#############################################################"
echo "#                   ShadowsocksR Server                     #"
echo "#         System Required: Centos 6.0 x86_64+               #"
echo "#     Github: https://github.com/breakwa11/shadowsocks      #"
echo "#     Thanks: @breakwa11 <https://twitter.com/breakwa11>    #"
echo "#############################################################"
echo

# 提示
get_char(){
        SAVEDSTTY=`stty -g`
        stty -echo
        stty cbreak
        dd if=/dev/tty bs=1 count=1 2> /dev/null
        stty -raw
        stty echo
        stty $SAVEDSTTY
    }
    echo
    echo "Press Enter to continue...or Press Ctrl+C to cancel"
    char=`get_char`


# 安装ShadowsocksR

yum install -y git

git clone https://github.com/hyjtool/shadowsocksr.git

cd ~/shadowsocksr

bash initcfg.sh

#修改配置文件
rm -rf /root/shadowsocksr/user-config.json
cat > /root/shadowsocksr/user-config.json<<-EOF
{
    "server": "0.0.0.0",
    "server_ipv6": "::",
    "server_port": 443,
    "local_address": "127.0.0.1",
    "local_port": 1080,

    "password": "ilovessr",
    "method": "aes-256-ctr",
    "protocol": "auth_aes128_md5",
    "protocol_param": "",
    "obfs": "plain",
    "obfs_param": "",
    "speed_limit_per_con": 0,
    "speed_limit_per_user": 0,

    "additional_ports" : {}, // only works under multi-user mode
    "additional_ports_only" : false, // only works under multi-user mode
    "timeout": 120,
    "udp_timeout": 60,
    "dns_ipv6": false,
    "connect_verbose_info": 0,
    "redirect": "",
    "fast_open": false
}

EOF


#开机自启
echo "/usr/bin/python /root/shadowsocksr/shadowsocks/server.py --pid-file /var/run/shadowsocks.pid -c /root/shadowsocksr/user-config.json -d start" >> /etc/rc.d/rc.local
chmod +x /etc/rc.d/rc.local

#启动
/usr/bin/python /root/shadowsocksr/shadowsocks/server.py --pid-file /var/run/shadowsocks.pid -c /root/shadowsocksr/user-config.json -d start

#检查启动
do_check(){
    pid=`ps -ef | grep -v grep | grep -v ps | grep -i "server.py" | awk '{print $2}'`
    if [ -z $pid ]; then
        echo "Sorry,something went wrong!"
    else
        echo "Congratulations!You can enjoy ShadowsocksR now..."
    fi
}

do_check


#清理
rm -rf /root/SSr.sh
