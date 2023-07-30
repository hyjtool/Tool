#!/usr/bin/env bash
PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:~/bin
export PATH

clear
echo
echo "#############################################################"
echo "#                       v2ray                                #"
echo "#         System Required: Debian 10 x86_64                  #"
echo "#        Some birds are not meant to be caged                #"
echo "#############################################################"
echo
echo
echo
echo  

read -p "请输入你的用户ID:" ID

# 安装v2ray
apt update

apt install curl

apt install vim

touch ~/.vimrc

bash <(curl -L https://raw.githubusercontent.com/v2fly/fhs-install-v2ray/master/install-release.sh)

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
            "port": 8080,
            "protocol": "vmess",
            "settings": {
                "clients": [
                    {
                        "id": "$ID"
                    }
                ]
            },
            "streamSettings": {
		"network": "ws"
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
systemctl enable v2ray
systemctl start v2ray
