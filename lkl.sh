#! /bin/bash
PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:~/bin
export PATH
#=================================================================#
#   System Required:     Debian 8.0 x86_64 minimal                #
#   Description:         One click Install lkl                    #
#   Thanks: @allient neko                                         #
#=================================================================#

#Current folder
cur_dir=`pwd`

mkdir /root/lkl
cd /root/lkl

	
wget --no-check-certificate https://raw.githubusercontent.com/hyjtool/Tool/master/liblkl-hijack.so


cd /root/shadowsocksr/shadowsocks
LD_PRELOAD=~/lkl/liblkl-hijack.so LKL_HIJACK_NET_QDISC="root|fq" LKL_HIJACK_SYSCTL='net.ipv4.tcp_congestion_control="bbr";net.ipv4.tcp_wmem="4096 16384 30000000"' LKL_HIJACK_NET_IFTYPE=tap LKL_HIJACK_NET_IFPARAMS=tap0 LKL_HIJACK_NET_IP=10.0.0.2 LKL_HIJACK_NET_NETMASK_LEN=24 LKL_HIJACK_NET_GATEWAY=10.0.0.1 LKL_HIJACK_OFFLOAD="0x8883" python server.py


rm -rf /root/lkl.sh

