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
read -p "请输入你的域名:" domain

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
            "listen": "127.0.0.1",
            "port": 1234,
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
                "security": "none",
                "wsSettings": {
                 "path": "/ray"
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

# 安装Caddy
cd /usr/local/bin

wget --no-check-certificate https://github.com/caddyserver/caddy/releases/download/v1.0.4/caddy_v1.0.4_linux_amd64.tar.gz  

tar -xzf caddy*.tar.gz caddy

echo "$domain:443 {
 gzip
 tls /root/chain.crt /root/key.key
 proxy / https://www.bilibili.com/ {
 without /ray
 }
 proxy /ray 127.0.0.1:1234 {
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
