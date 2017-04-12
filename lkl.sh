#! /bin/bash
PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:~/bin
export PATH
#=================================================================#
#   System Required :     Debian 8.0 x86_64                       #
#   Description :      Linux kernel library                       #
#   Thanks :         @linhua , @allientNeko                       #
#=================================================================#

apt-get update
apt-get install -y haproxy

mkdir /root/lkl
cd /root/lkl
cat > /root/lkl/haproxy.cfg<<-EOF
global
defaults
log global
mode tcp
option dontlognull
timeout connect 5000
timeout client 50000
timeout server 50000
frontend proxy-in
bind *:443
default_backend proxy-out
backend proxy-out
server server1 10.0.0.1 maxconn 20480
EOF
	
wget --no-check-certificate https://raw.githubusercontent.com/hyjtool/Tool/master/liblkl-hijack.so

cat > /root/lkl/lkl.sh<<-EOF
LD_PRELOAD=/root/lkl/liblkl-hijack.so LKL_HIJACK_NET_QDISC="root|fq" LKL_HIJACK_SYSCTL="net.ipv4.tcp_congestion_control=bbr" LKL_HIJACK_NET_IFTYPE=tap LKL_HIJACK_NET_IFPARAMS=lkl-tap LKL_HIJACK_NET_IP=10.0.0.2 LKL_HIJACK_NET_NETMASK_LEN=24 LKL_HIJACK_NET_GATEWAY=10.0.0.1 haproxy -f /root/lkl/haproxy.cfg
EOF



cat > /root/lkl/run.sh<<-EOF
ip tuntap add lkl-tap mode tap
ip addr add 10.0.0.1/24 dev lkl-tap
ip link set lkl-tap up
sysctl -w net.ipv4.ip_forward=1
iptables -P FORWARD ACCEPT 
iptables -t nat -A POSTROUTING -o venet0 -j MASQUERADE
iptables -t nat -A PREROUTING -i venet0 -p tcp --dport 443 -j DNAT --to-destination 10.0.0.2
nohup /root/lkl/lkl.sh &
p=\`ping 10.0.0.2 -c 3 | grep ttl\`
if [ \$? -ne 0 ]; then
	echo "success "\$(date '+%Y-%m-%d %H:%M:%S') > /root/lkl/log.log
else
	echo "fail "\$(date '+%Y-%m-%d %H:%M:%S') > /root/lkl/log.log
fi
EOF


chmod +x lkl.sh
chmod +x run.sh

#写入自动启动
sed -i "s/exit 0/ /ig" /etc/rc.local
echo "/root/lkl/run.sh" >> /etc/rc.local

./run.sh

#判断是否启动
p=`ping 10.0.0.2 -c 3 | grep ttl`
if [ "$p" == "" ]; then
	echo "fail"
else
	echo "success"
fi
