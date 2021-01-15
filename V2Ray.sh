#!/usr/bin/env bash
PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:~/bin
export PATH
#=================================================================#
#   Description:           V2Ray                                  #
#   System Required:       Debian 10 x86_64                       #
#   Some birds are not meant to be caged                          #
#=================================================================#

clear
echo
echo "#############################################################"
echo "#                       V2Ray                                #"
echo "#         System Required: Debian 10 x86_64                  #"
echo "#        Some birds are not meant to be caged                #"
echo "#############################################################"
echo
echo
echo
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

# 安装V2Ray
apt update

apt install curl

curl -O https://raw.githubusercontent.com/v2fly/fhs-install-v2ray/master/install-release.sh

bash install-release.sh

rm -rf /usr/local/etc/v2ray/config.json

cat > /usr/local/etc/v2ray/config.json<<-EOF
{
    "log": {
        "loglevel": "warning"
    },
    "routing": {
        "domainStrategy": "AsIs",
        "rules": [
            {
                "type": "field",
                "ip": [
                    "geoip:private"
                ],
                "outboundTag": "block"
            }
        ]
    },
    "inbounds": [
        {
            "listen": "0.0.0.0",
            "port": 443,
            "protocol": "vmess",
            "settings": {
                "clients": [
                    {
                        "id": "ab601342-1a7d-4a5c-a678-9b6f3df9f96d"
                    }
                ]
            },
            "streamSettings": {
                "network": "tcp",
                "security": "tls",
                "tlsSettings": {
                    "certificates": [
                        {
                            "certificateFile": "/root/chain.crt",
                            "keyFile": "/root/key.key"
                        }
                    ]
                }
            }
        }
    ],
    "outbounds": [
        {
            "protocol": "freedom",
            "tag": "direct"
        },
        {
            "protocol": "blackhole",
            "tag": "block"
        }
    ]
}

EOF

# 开机自启
chown -R nobody:nogroup /root

systemctl enable v2ray

systemctl start v2ray
