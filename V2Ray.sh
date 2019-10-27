#!/usr/bin/env bash
PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:~/bin
export PATH
#=================================================================#
#   Description:           V2Ray                                  #
#   System Required:       Centos 8 x86_64                        #
#   Thanks:                Myself                                 #
#=================================================================#

clear
echo
echo "#############################################################"
echo "#                      V2Ray                                 #"
echo "#         System Required: Centos 8 x86_64                   #"
echo "#                 Thanks:  Myself                            #"
echo "#############################################################"
echo
echo
echo
echo  
read -p "请输入你的域名:" domain

# 安装V2Ray
bash <(curl -L -s https://install.direct/go.sh)

rm -rf /etc/v2ray/config.json

cat > /etc/v2ray/config.json<<-EOF
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
      ]
    },
    "streamSettings": {
        "network": "ws",
        "security": "tls",
        "tlsSettings": {
         "serverName": "$domain",
         "certificates": [
            {
              "certificateFile": "/root/v2ray.crt",
              "keyFile": "/root/v2ray.key"
            }
          ]
        }
      }
  }],
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

service v2ray start

#清理
rm -rf /root/V2Ray.sh
