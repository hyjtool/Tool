#!/usr/bin/env bash
PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:~/bin
export PATH
#=================================================================#
#   System Required: Centos 7 x86_64, Debian, Ubuntu              #
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
apt-get install git

git clone -b manyuser https://github.com/shadowsocksr/shadowsocksr.git

cd ~/shadowsocksr
bash initcfg.sh


# Config ShadowsocksR
config_shadowsocks(){
    cat > /etc/shadowsocksr/user-config.json<<-EOF
{
    "server":"0.0.0.0",
    "server_ipv6":"::",
    "server_port":${shadowsocksport},
    "local_address":"127.0.0.1",
    "local_port":1080,
    "password":"${shadowsockspwd}",
    "timeout":120,
    "method":"rc4-md5",
    "protocol":"auth_sha1_v4",
    "protocol_param":"",
    "obfs":"plain",
    "obfs_param":"",
    "redirect":"",
    "dns_ipv6":false,
    "fast_open":false,
    "workers":1
}
EOF
}



        /etc/init.d/shadowsocks start

        clear
        echo
        echo "Congratulations, ShadowsocksR install completed!"
        echo -e "Server IP: \033[41;37m $(get_ip) \033[0m"
        echo -e "Server Port: \033[41;37m ${shadowsocksport} \033[0m"
        echo -e "Password: \033[41;37m ${shadowsockspwd} \033[0m"
        echo -e "Local IP: \033[41;37m 127.0.0.1 \033[0m"
        echo -e "Local Port: \033[41;37m 1080 \033[0m"
        echo -e "Protocol: \033[41;37m auth_sha1_v4 \033[0m"
        echo -e "obfs: \033[41;37m plain \033[0m"
        echo -e "Encryption Method: \033[41;37m rc4-md5 \033[0m"
        echo
        echo "Welcome to visit:https://shadowsocks.be/9.html"
        echo "If you want to change protocol & obfs, please visit reference URL:"
        echo "https://github.com/breakwa11/shadowsocks-rss/wiki/Server-Setup"
        echo
        echo "Enjoy it!"
        echo
    
}

