#!/usr/bin/env bash
PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:~/bin
export PATH
#=================================================================#
#   Description:           ShadowsocksR Server                    #
#   System Required:       Debian 8.0 x86_64                      #
#   Thanks: @breakwa11 <https://twitter.com/breakwa11>            #
#=================================================================#

clear
echo
echo "#############################################################"
echo "#                   ShadowsocksR Server                     #"
echo "#         System Required:  Debian 8.0 x86_64               #"
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
apt-get update
apt-get install -y git

git clone -b manyuser https://github.com/shadowsocksr/shadowsocksr.git

cd ~/shadowsocksr

bash initcfg.sh


# 开机自启
cat > /etc/systemd/system/shadowsocks.service<<-EOF
[Unit]
Description=ShadowsocksR server
After=network.target
Wants=network.target

[Service]
Type=forking
PIDFile=/var/run/shadowsocks.pid
ExecStart=/usr/bin/python /root/shadowsocksr/shadowsocks/server.py --pid-file /var/run/shadowsocks.pid -c /root/shadowsocksr/user-config.json -d start
ExecStop=/usr/bin/python /root/shadowsocksr/shadowsocks/server.py --pid-file /var/run/shadowsocks.pid -c /root/shadowsocksr/user-config.json -d stop
ExecReload=/bin/kill -HUP $MAINPID
KillMode=process
Restart=always

[Install]
WantedBy=multi-user.target

EOF

systemctl enable shadowsocks.service && systemctl start shadowsocks.service


#检查启动
do_check(){
    pid=`ps -ef | grep -v grep | grep -v ps | grep -i "server.py" | awk '{print $2}'`
    if [ -z $pid ]; then
        echo "Sorry,something went wrong!"
    else
        echo "Congratulations!You can enjoy SSR now..."
    fi
}

do_check


#清理
rm -rf /root/shadowsocksR.sh

