#!/bin/bash
#install sdp-v1.0
DATA="/data"
CPUS=$(grep "processor" /proc/cpuinfo | wc -l)
yum -y install subversion mailx jq
[ -d "$DATA" ] || mkdir -p $DATA
cd ${DATA}; git clone https://github.com/staugur/Sdp sdp
cd ${DATA}/sdp/components; sh docker.sh; sh vsftpd.sh sdptest 123456; sh svn.sh;
cd ${DATA}; curl https://saintic.top/lnmp > lnmp.sh; sh lnmp.sh
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
    log_format json      '{ "@timestamp": "$time_local", '
                         '"@fields": { '
                         '"remote_addr": "$remote_addr", '
                         '"remote_user": "$remote_user", '
                         '"body_bytes_sent": "$body_bytes_sent", '
                         '"request_time": "$request_time", '
                         '"status": "$status", '
                         '"request": "$request", '
                         '"request_method": "$request_method", '
                         '"http_referrer": "$http_referer", '
                         '"body_bytes_sent":"$body_bytes_sent", '
                         '"http_x_forwarded_for": "$http_x_forwarded_for", '
                         '"http_user_agent": "$http_user_agent" } }';

    access_log  logs/access.log;
    #access_log  logs/access.log json;
    sendfile       on;
    tcp_nopush     on;
    tcp_nodelay    on; 
    server_tokens  off; 
    keepalive_timeout  60;
    gzip  on;
    gzip_min_length  1024;
    gzip_buffers 4 16k;
    gzip_comp_level 3;
    gzip_disable "MSIE [1-6].";
    gzip_types text/plain application/x-javascript text/css text/javascript application/x-httpd-php image/jpeg image/gif image/png;
    fastcgi_connect_timeout 300;
    fastcgi_send_timeout 300;
    fastcgi_read_timeout 300;
    fastcgi_buffer_size 64k;
    fastcgi_buffers 4 64k;
    fastcgi_busy_buffers_size 128k;
    fastcgi_temp_file_write_size 256k;
    client_max_body_size 20M;
    client_header_buffer_size 16k;
    proxy_connect_timeout    300;
    proxy_read_timeout       300;
    proxy_send_timeout       300;
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
    include vhost/*.conf;
}
EOF
mkdir -p ${DATA}/app/nginx/conf/vhost
if [ `netstat -anptl|grep php-fpm|wc -l` = 0 ];then /etc/init.d/php-fpm start fi
if [ `netstat -anptl|grep nginx|wc -l` = 0 ];then ${DATA}/app/nginx/sbin/nginx fi
if [ `netstat -anptl|grep httpd|wc -l` = 0 ];then /etc/init.d/httpd start fi
if [ `ps aux|grep -v grep|grep docker|wc -l` = 0 ];then /etc/init.d/docker start fi
if [ `netstat -anptl|grep vsftpd|wc -l` = 0 ];then /etc/init.d/vsftpd start fi


