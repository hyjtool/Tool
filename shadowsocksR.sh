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

yum install -y git

git clone -b manyuser https://github.com/shadowsocksr/shadowsocksr.git

cd ~/shadowsocksr

bash initcfg.sh


# 开机自启
cat > /etc/systemd/system/shadowsocks.service<<-EOF

#!/bin/sh
# chkconfig: 2345 90 10
# description: Start or stop the Shadowsocks R server
#
### BEGIN INIT INFO
# Provides: Shadowsocks-R
# Required-Start: $network $syslog
# Required-Stop: $network
# Default-Start: 2 3 4 5
# Default-Stop: 0 1 6
# Description: Start or stop the Shadowsocks R server
### END INIT INFO



name=shadowsocks
PY=/usr/bin/python
SS=/root/shadowsocksr/shadowsocks/server.py
SSPY=server.py
conf=/root/shadowsocksr/user-config.json

start(){
    $PY $SS -c $conf -d start
    RETVAL=$?
    if [ "$RETVAL" = "0" ]; then
        echo "$name start success"
    else
        echo "$name start failed"
    fi
}

stop(){
    pid=`ps -ef | grep -v grep | grep -v ps | grep -i "${SSPY}" | awk '{print $2}'`
    if [ ! -z "$pid" ]; then
        $PY $SS -c $conf -d stop
        RETVAL=$?
        if [ "$RETVAL" = "0" ]; then
            echo "$name stop success"
        else
            echo "$name stop failed"
        fi
    else
        echo "$name is not running"
        RETVAL=1
    fi
}

status(){
    pid=`ps -ef | grep -v grep | grep -v ps | grep -i "${SSPY}" | awk '{print $2}'`
    if [ -z "$pid" ]; then
        echo "$name is not running"
        RETVAL=1
    else
        echo "$name is running with PID $pid"
        RETVAL=0
    fi
}

case "$1" in
'start')
    start
    ;;
'stop')
    stop
    ;;
'status')
    status
    ;;
'restart')
    stop
    start
    RETVAL=$?
    ;;
*)
    echo "Usage: $0 { start | stop | restart | status }"
    RETVAL=1
    ;;
esac
exit $RETVAL

EOF

chmod 755 /etc/init.d/shadowsocks && chkconfig --add shadowsocks && service shadowsocks start


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

