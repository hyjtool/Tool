#!/usr/bin/env bash
PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:~/bin
export PATH
#=================================================================#
#   Description:           V2Ray                                  #
#   System Required:       Debian 10 x86_64                       #
#   Thanks:                Myself                                 #
#=================================================================#

clear
echo
echo "#############################################################"
echo "#                       V2Ray                                #"
echo "#         System Required: Debian 10 x86_64                  #"
echo "#                 Thanks:  Myself                            #"
echo "#############################################################"
echo
echo
echo
echo  
read -p "请输入你的域名:" domain

# 安装V2Ray
apt update

apt install curl

curl -O https://raw.githubusercontent.com/v2fly/fhs-install-v2ray/master/install-release.sh

bash install-release.sh

rm -rf /usr/local/etc/v2ray/config.json

cat > /usr/local/etc/v2ray/config.json<<-EOF
{
  "inbounds": [{
    "port": 443,
    "protocol": "vmess",
    "settings": {
      "clients": [
        {
          "id": "ab601342-1a7d-4a5c-a678-9b6f3df9f96d",
          "level": 1,
          "alterId": 64
        }
      ],
      "decryption": "none"
    },
    "streamSettings": {
        "network": "tcp",
        "security": "tls",
        "tlsSettings": {
          "serverName": "$domain",
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
    "port": 443,
    "protocol": "vless",
    "settings": {
      "clients": [
        {
          "id": "bb601342-1a7d-4a5c-a678-9b6f3df9f96d",
          "level": 0
        }
      ],
      "decryption": "none"
    },
     "streamSettings": {
        "network": "tcp",
        "security": "tls",
        "tlsSettings": {
           "serverName": "$domain",
           "alpn": [
             "h2",
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
    "outbounds": [{
    "protocol": "freedom",
    "settings": {}
  },{
    "protocol": "blackhole",
    "settings": {},
    "tag": "blocked"
  }],
  "routing": {
    "rules": [
      {
        "type": "field",
        "ip": ["geoip:private"],
        "outboundTag": "blocked"
      }
    ]
  }
}

EOF

# 开机自启
chown -R nobody:nogroup /root

systemctl enable v2ray

systemctl start v2ray
