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

# 开机自启
rm -rf /etc/systemd/system/v2ray.service

cat > /etc/systemd/system/v2ray.service<<-EOF
[Unit]
Description=V2ray Server
After=network.target
[Service]
ExecStart=/usr/local/bin/v2ray -config /usr/local/etc/v2ray/config.json 
Restart=always
[Install]
WantedBy=multi-user.target
EOF

systemctl enable v2ray

systemctl start v2ray
