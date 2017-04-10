#! /bin/bash
PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:~/bin
export PATH
#=================================================================#
#   System Required:     Debian 8.0 x86_64 minimal                #
#   Description:         One click Install lkl                    #
#   Thanks: @allient neko                                         #
#=================================================================#



mkdir /root/lkl
cd /root/lkl

	
wget --no-check-certificate https://raw.githubusercontent.com/hyjtool/Tool/master/liblkl-hijack2.so

cat > /root/lkl/lkl.sh<<-EOF
LD_PRELOAD=/root/lkl/liblkl-hijack.so LKL_HIJACK_NET_QDISC="root|fq" LKL_HIJACK_SYSCTL="net.ipv4.tcp_congestion_control=bbr" LKL_HIJACK_NET_IFTYPE=tap LKL_HIJACK_NET_IFPARAMS=lkl-tap LKL_HIJACK_NET_IP=10.0.0.2 LKL_HIJACK_NET_NETMASK_LEN=24 LKL_HIJACK_NET_GATEWAY=10.0.0.1 haproxy -f /root/lkl/haproxy.cfg
EOF

chmod +x lkl.sh


#写入自动启动
if [[ "$release" = "CentOS" && "$ver" = "7" ]]; then
	echo "/root/lkl/run.sh" >> /etc/rc.d/rc.local
	chmod +x /etc/rc.d/rc.local
else
	sed -i "s/exit 0/ /ig" /etc/rc.local
	echo "/root/lkl/run.sh" >> /etc/rc.local
fi


./run.sh

#判断是否启动
p=`ping 10.0.0.2 -c 3 | grep ttl`
if [ "$p" == "" ]; then
	echo "fail"
else
	echo "success"
fi
