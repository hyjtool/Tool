#!/usr/bin/env bash
PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:~/bin
export PATH
#=================================================================#
#   Description:           V2Ray + Caddy                          #
#   System Required:       Centos 8 x86_64                        #
#   Thanks:                Myself                                 #
#=================================================================#

clear
echo
echo "#############################################################"
echo "#                   V2Ray + Caddy                            #"
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
    "port": 10001,
    "listen":"127.0.0.1",
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
        "wsSettings": {
          "path": "/ray"
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

# 安装Caddy
yum -y install tar

cd /usr/local/bin

wget --no-check-certificate https://github.com/caddyserver/caddy/releases/download/v1.0.4/caddy_v1.0.4_linux_amd64.tar.gz  

tar -xzf caddy*.tar.gz caddy

echo "$domain:443 {
 gzip
 tls /usr/local/bin/chain.crt /usr/local/bin/key.key
 proxy / https://cloudflare.com {
 without /ray
 }
 proxy /ray 127.0.0.1:10001 {
 websocket
 header_upstream -Origin
 }
}" > /usr/local/bin/Caddyfile

# 开机自启
cat > /etc/systemd/system/Caddy.service<<-EOF
[Unit]
Description=Caddy Server

[Service]
ExecStart=/usr/local/bin/caddy -log stdout -agree=true -conf=/usr/local/bin/Caddyfile -root=/var/tmp
Restart=always
[Install]
WantedBy=multi-user.target
EOF

systemctl enable Caddy.service

#启动
systemctl start Caddy.service

#清理
rm -rf /root/V2RayCaddy.sh
rm -rf /usr/local/bin/caddy*.tar.gz*
