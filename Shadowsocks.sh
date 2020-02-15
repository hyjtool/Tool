#!/usr/bin/env bash
PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:~/bin
export PATH
#=================================================================#
#   Description:           Shadowsocks Server                     #
#   System Required:       Centos 8 x86_64                        #
#   Thanks:                clowwindy                              #
#=================================================================#

clear
echo
echo "#############################################################"
echo "#                   Shadowsocks Server                       #"
echo "#         System Required: Centos 8 x86_64                   #"
echo "#        Github: <https://github.com/madeye>                 #"
echo "#                 Thanks:  madeye                            #"
echo "#############################################################"
echo

# Info
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


# Install Shadowsocks-libev
yum install epel-release
yum install snapd
systemctl enable --now snapd.socket
ln -s /var/lib/snapd/snap /snap
snap install core
snap install shadowsocks-libev


# Config shadowsocks
cat > /snap/bin/config.json<<-EOF
{
    "server":"0.0.0.0",
    "server_port":443,
    "password":"ilovess",
    "method":"xchacha20-ietf-poly1305",
    "nameserver":"8.8.8.8",
    "mode":"tcp_and_udp",
    "timeout":60  
}

EOF


# 开机自启
cat > /etc/systemd/system/shadowsocks.service<<-EOF
[Unit]
Description=Shadowsocks Server
After=network.target
[Service]
ExecStart=/snap/bin/shadowsocks-libev.ss-server -c /snap/bin/config.json 
Restart=always
[Install]
WantedBy=multi-user.target

EOF

systemctl enable shadowsocks


# 启动
systemctl start shadowsocks


# 检查启动
do_check(){
    pid=`ps -ef | grep -v grep | grep -v ps | grep -i "ss-server" | awk '{print $2}'`
    if [ -z $pid ]; then
        echo "Sorry,something went wrong!"
    else
        echo "Congratulations!You can enjoy Shadowsocks now..."
    fi
}

do_check


# 清理
rm -rf /root/Shadowsocks.sh
