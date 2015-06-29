#!/bin/bash
#web.app:nginx,httpd,tomcat
#save dn, nginx proxy.
source $SDP_HOME/global.func
[ -d $init_user_home_root ] || mkdir -p $init_user_home_root
[ -f $init_user_home_info ] || touch $init_user_home_info

export dnmap_file=${INIT_HOME}/dnmap
export init_user_dns=${init_user}.${user_id}.sdp.saintic.com
export init_user_host=${user_id}.sdipaas.com
if grep $init_user_dns $dnmap_file &> /dev/null ;then
  echo -e "\033[31mThe domain name has been recorded in the $dnmap_file file.\033[0m" >&2
  rm -rf $init_user_home ; exit 1
else
  echo "$init_user_dns" >> $dnmap_file
fi

#virtual proxy
nginx_exec=/usr/sbin/nginx
nginx_home=/usr/local/nginx
nginx_conf=${nginx_home}/conf
nginx_sdp_conf=${nginx_conf}/Sdp
user_nginx_conf=${nginx_sdp_conf}/${init_user}.${user_id}.conf
[ -d $nginx_sdp_conf ] || mkdir -p $nginx_sdp_conf
[ -f $user_nginx_conf ] && echo "Nginx configuration file already exists, and exit." && exit 1
if [ "$init_service_type" = "nginx" ] || [ "$init_service_type" = "httpd" ]; then
  service_port=80
elif [ "$init_service_type" = "tomcat" ]; then
  service_port=8080
fi
cat > $user_nginx_conf <<EOF
server {
    listen ${SERVER_IP}:80;
    server_name ${init_user_dns};
    location / {
       proxy_pass http://${init_user_host}:${service_port}/;
       proxy_set_header Host \$host;
       proxy_set_header X-Real-IP \$remote_addr;
       proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;
    }
}
EOF
#You need to write DNS information to hosts.

check_reload() {
  $nginx_exec -t
  ERROR
}
$nginx_exec -t &> /dev/null && nginx -s reload || check_reload

if [ "$init_file_type" == "svn" ]; then
  create_svn $init_user $init_passwd
  AutoUpdateSvn
elif [ "$init_file_type" == "ftp" ]; then
  create_ftp $init_user $init_passwd $init_user_home_root
elif [ "$init_file_type" == "-" ]; then
  echo "You choose the web application, which is not allowed." ;
  exit 1  
fi

source $SDP_HOME/builds/webs_builds.sh
