#!/bin/bash
#install sdp-v1.0
DATA="/data"
CPUS=$(grep "processor" /proc/cpuinfo | wc -l)
yum -y install subversion mailx jq git
[ -d $DATA ] || mkdir -p $DATA
cd ${DATA}; git clone https://github.com/staugur/Sdp sdp
cd ${DATA}/sdp/components; sh docker.sh; sh vsftpd.sh sdptest 123456; sh svn.sh;
cd ${DATA}; curl https://saintic.top/lnmp.txt > lnmp.sh; sh lnmp.sh
cat > ${DATA}/app/nginx/conf/nginx.conf <<EOF
user  www;
worker_processes  ${CPUS};
error_log  logs/error.log;
pid        logs/nginx.pid;
events {
    worker_connections  52100;
    use epoll;
}
http {
    include       mime.types;
    default_type  application/octet-stream;
    access_log  logs/access.log;
    sendfile       on;
    tcp_nopush     on;
    tcp_nodelay    on; 
    server_tokens  off; 
    keepalive_timeout  60;
    gzip  on;
    server {
    	listen 80;
    	server_name _;
    	root html;
    	index index.html index.htm index.php index.py;
    	location ~ \.php$ {
            fastcgi_pass   127.0.0.1:9000;
            fastcgi_index  index.php;
            fastcgi_param  SCRIPT_FILENAME  /scripts$fastcgi_script_name;
            include        fastcgi.conf;
        }
    }
    include SdpConf/*.conf;
    include conf.d/*.conf;
    #站点配置放到conf.d目录中
}
EOF
mkdir -p ${DATA}/app/nginx/conf/{SdpConf,conf.d}
if [ `netstat -anptl|grep php-fpm|wc -l` -eq 0 ];then /etc/init.d/php-fpm start; fi
if [ `netstat -anptl|grep nginx|wc -l` -eq 0 ];then ${DATA}/app/nginx/sbin/nginx; fi
if [ `netstat -anptl|grep httpd|wc -l` -eq 0 ];then /etc/init.d/httpd start; fi
if [ `ps aux|grep -v grep|grep docker|wc -l` -eq 0 ];then /etc/init.d/docker start; fi
if [ `netstat -anptl|grep vsftpd|wc -l` -eq 0 ];then /etc/init.d/vsftpd start; fi


