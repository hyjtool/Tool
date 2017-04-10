#!/usr/bin/env bash
PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:~/bin
export PATH
#=================================================================#
#   System Required:       Debian 8.0 x86_64 minimal              #
#   Description: One click Install ShadowsocksR Server            #
#   Thanks: @breakwa11 <https://twitter.com/breakwa11>            #
#=================================================================#

clear
echo
echo "#############################################################"
echo "# One click Install ShadowsocksR Server                     #"
echo "# Intro: https://shadowsocks.be/9.html                      #"
echo "# Github: https://github.com/breakwa11/shadowsocks          #"
echo "#############################################################"
echo

#Current folder
cur_dir=`pwd`

# Install ShadowsocksR

apt-get -y update

apt-get -y install git

git clone -b manyuser https://github.com/shadowsocksr/shadowsocksr.git

cd ~/shadowsocksr

bash initcfg.sh


# Config ShadowsocksR
rm -rf /root/shadowsocksr/user-config.json
    cat > /root/shadowsocksr/user-config.json<<-EOF
{
    "server": "0.0.0.0",
    "server_ipv6": "::",
    "server_port": 443,
    "local_address": "127.0.0.1",
    "local_port": 1080,

    "password": "ilovessr",
    "method": "rc4-md5",
    "protocol": "auth_aes128_md5",
    "protocol_param": "",
    "obfs": "plain",
    "obfs_param": "",
    "speed_limit_per_con": 0,
    "speed_limit_per_user": 0,

    "additional_ports" : {}, // only works under multi-user mode
    "timeout": 120,
    "udp_timeout": 60,
    "dns_ipv6": false,
    "connect_verbose_info": 0,
    "redirect": "",
    "fast_open": false
}

EOF


cd /root/shadowsocksr/shadowsocks
python server.py -d start

       
    


