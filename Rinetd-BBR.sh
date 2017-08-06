#! /bin/bash
PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:~/bin
export PATH
#=================================================================#
#   Description :            Rinetd-BBR                           #
#   System Required :     Centos 6 x86_64                         #
#   Thanks :          @linhua , @allientNeko                      #
#=================================================================#

#下载文件到 /usr/bin/rinetd-bbr
wget -O /usr/bin/rinetd-bbr https://github.com/linhua55/lkl_study/releases/download/v1.2/rinetd_bbr_powered


#给予权限
chmod a+x /usr/bin/rinetd-bbr


#配置文件
cat > /etc/rinetd-bbr.conf<<-EOF
# bindadress bindport connectaddress connectport
 
0.0.0.0 443 0.0.0.0 443

EOF


#获取接口名称ip addr,搬瓦工的OpenVZ都是 venet0:0 接口


#开机自启
echo "/usr/bin/rinetd-bbr -f -c /etc/rinetd-bbr.conf raw venet0:0 &" >> /etc/rc.d/rc.local
chmod +x /etc/rc.d/rc.local


#启动
/usr/bin/rinetd-bbr -f -c /etc/rinetd-bbr.conf raw venet0:0 &


#清理
rm -rf /root/Rinetd-BBR.sh

