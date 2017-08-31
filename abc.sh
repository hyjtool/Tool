#!/usr/bin/env bash
PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:~/bin
export PATH
#=================================================================#
#   Description:           Shadowsocks Server                     #
#   System Required:       Centos 6 x86_64                        #
#   Thanks:                clowwindy                              #
#=================================================================#

clear
echo
echo "#############################################################"
echo "#                   Shadowsocks Server                      #"
echo "#   System Required: Centos 6 x86_64                        #"
echo "#   Github:https://github.com/clowwindy/shadowsocks-libev   #"
echo "#   Thanks:      clowwindy                                  #"
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


#Install necessary dependencies
yum install -y epel-release 

yum install -y unzip openssl openssl-devel gettext gcc autoconf libtool automake make asciidoc xmlto udns-devel libev-devel pcre pcre-devel git

# Download latest shadowsocks-libev
get_latest_shadowsocks(){
    ver=$(wget --no-check-certificate -qO- https://api.github.com/repos/shadowsocks/shadowsocks-libev/releases/latest | grep 'tag_name' | cut -d\" -f4)
    [ -z ${ver} ] && echo "Error: Get shadowsocks-libev latest version failed" && exit 1
    shadowsocks_libev_ver="shadowsocks-libev-$(echo ${ver} | sed -e 's/^[a-zA-Z]//g')"
    download_link="https://github.com/shadowsocks/shadowsocks-libev/releases/download/${ver}/${shadowsocks_libev_ver}.tar.gz"
    
}
get_latest_shadowsocks

wget --no-check-certificate  "${download_link}"

#install_libsodium
wget --no-check-certificate  https://download.libsodium.org/libsodium/releases/libsodium-1.0.13.tar.gz
tar zxf libsodium-1.0.13.tar.gz
cd libsodium-1.0.13
./configure --prefix=/usr && make && make install

#install_mbedtls
wget --no-check-certificate  https://tls.mbed.org/download/mbedtls-2.5.1-gpl.tgz
tar xf mbedtls-2.5.1-gpl.tgz
cd  mbedtls-2.5.1
make SHARED=1 CFLAGS=-fPIC
make DESTDIR=/usr install
 

# Config shadowsocks

mkdir -p /etc/shadowsocks-libev

cat > /etc/shadowsocks-libev/config.json<<-EOF
{
    "server":"0.0.0.0",
    "server_port":443,
    "local_address":"127.0.0.1",
    "local_port":1080,
    "password":"ilovess",
    "timeout":600,
    "method":"aes-128-gcm"
}
EOF


# Install Shadowsocks-libev

ldconfig

tar zxf ${shadowsocks_libev_ver}.tar.gz
    
cd ${shadowsocks_libev_ver}

./configure --disable-documentation

make && make install

#启动
/usr/local/bin/ss-server -u -c /etc/shadowsocks-libev/config.json -f /var/run/shadowsocks-libev.pid

#检查启动
do_check(){
    pid=`ps -ef | grep -v grep | grep -v ps | grep -i "ss-server" | awk '{print $2}'`
    if [ -z $pid ]; then
        echo "Sorry,something went wrong!"
    else
        echo "Congratulations!You can enjoy Shadowsocks now..."
    fi
}

do_check

        
