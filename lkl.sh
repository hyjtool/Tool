#! /bin/bash
PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:~/bin
export PATH
#=================================================================#
#   Description :      Linux kernel library                       #
#   System Required :     Centos 7.0 x86_64                       #
#   Thanks :         @linhua , @allientNeko                       #
#=================================================================#

#安装haproxy
yum install -y haproxy

#创建文件夹
mkdir /root/lkl
cd /root/lkl

#下载liblkl-hijack.so
wget --no-check-certificate https://raw.githubusercontent.com/hyjtool/Tool/master/liblkl-hijack.so

#设定tuntap和NAT
cat > /root/lkl/run.sh<<-EOF
sysctl -w net.ipv4.ip_forward=1
ip tuntap add lkl-tap mode tap
ip addr add 10.0.0.1/24 dev lkl-tap
ip link set lkl-tap up
iptables -P FORWARD ACCEPT 
iptables -t nat -A POSTROUTING -o venet0 -j MASQUERADE
iptables -t nat -A PREROUTING -i venet0 -p tcp --dport 443 -j DNAT --to-destination 10.0.0.2

nohup /root/lkl/lkl.sh &

EOF

#写入haproxy.cfg
cat > /root/lkl/haproxy.cfg<<-EOF
global
pidfile /var/run/haproxy.pid
ulimit-n 15000

defaults
log global
mode tcp
option dontlognull
timeout connect 1000
timeout client 150000
timeout server 150000

frontend proxy-in
bind *:443
default_backend proxy-out

backend proxy-out
server server1 10.0.0.1 maxconn 20480
EOF

#写入lkl.sh
cat > /root/lkl/lkl.sh<<-EOF
LD_PRELOAD=/root/lkl/liblkl-hijack.so LKL_HIJACK_NET_QDISC="root|fq" LKL_HIJACK_SYSCTL="net.ipv4.tcp_congestion_control=bbr;net.ipv4.tcp_wmem=4096 16384 30000000" LKL_HIJACK_OFFLOAD="0x9983" LKL_HIJACK_NET_IFTYPE=tap LKL_HIJACK_NET_IFPARAMS=lkl-tap LKL_HIJACK_NET_IP=10.0.0.2 LKL_HIJACK_NET_NETMASK_LEN=24 LKL_HIJACK_NET_GATEWAY=10.0.0.1 haproxy -f /root/lkl/haproxy.cfg
EOF

#给予权限
chmod +x lkl.sh
chmod +x run.sh

#开机自启
echo "/root/lkl/run.sh" >> /etc/rc.d/rc.local
chmod +x /etc/rc.d/rc.local

./run.sh

#检查启动
p=`ping 10.0.0.2 -c 5 | grep ttl`
if [ "$p" == "" ]; then
	echo "Sorry,something went wrong..."
else
	echo "Congratulations!Please enjoy..."
fi


#清理
rm -rf /root/lkl.sh


