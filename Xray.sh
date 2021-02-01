#!/usr/bin/env bash
PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:~/bin
export PATH
#=================================================================#
#   Description:           Xray                                   #
#   System Required:       Debian 10 x86_64                       #
#   Some birds are not meant to be caged                          #
#=================================================================#

clear
echo
echo "#############################################################"
echo "#                       Xray                                 #"
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

apt install vim

touch ~/.vimrc

bash -c "$(curl -L https://github.com/XTLS/Xray-install/raw/main/install-release.sh)" @ install

rm -rf /usr/local/etc/xray/config.json

cat > /usr/local/etc/xray/config.json<<-EOF

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
            "port": 443,
            "protocol": "vmess",
            "settings": {
                "clients": [
                    {
                        "id": "ab601342-1a7d-4a5c-a678-9b6f3df9f96d",
                        "alterId": 4
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
        },
        
     {
      "port": 80,
      "protocol": "vmess",
      "settings": {
        "clients": [
          {
            "id": "ab601342-1a7d-4a5c-a678-9b6f3df9f96d"
          }
        ]
      },
      "streamSettings": {
                "network": "ws",
                "security": "none"
            }
    },
    
     {
      "port": 443,
      "protocol": "vless",
      "settings": {
        "clients": [
          {
            "id": "ab601342-1a7d-4a5c-a678-9b6f3df9f96d",
            "flow": "xtls-rprx-direct",
            "level": 0,
            "email": "love@example.com"
           }
        ],
        "decryption": "none",
        "fallbacks": [
           {
             "dest": "www.github.com:443"
           }
        ]
     },
      "streamSettings": {
          "network": "tcp",
          "security": "xtls",
          "xtlsSettings": {
                    "alpn": [
                        "http/1.1"
                    ],
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

systemctl start xray
