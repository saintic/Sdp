#!/bin/bash
#web.app:nginx,httpd,tomcat
#save dn, nginx proxy.

source $SDP_HOME/global.func
[ -z $webs ] && ERROR
[ -z $SERVER_IP ] && ERROR
[ -z $INIT_HOME ] && ERROR
[ -z $init_user ] && ERROR
[ -z $init_passwd ] && ERROR
[ -z $init_file_type ] && ERROR
[ -z $init_user_home ] && ERROR
[ -z $init_user_home_info ] && ERROR
[ -z $init_user_home_root ] && ERROR

export dnmap_file=${INIT_HOME}/dnmap
export init_user_dns=${init_user}.${user_id}.sdp.saintic.com
export init_user_host=${user_id}.sdipaas.com
echo "$init_user_dns" >> $dnmap_file

#virtual proxy
nginx_exec=/usr/sbin/nginx
nginx_home=/usr/local/nginx
nginx_conf=${nginx_home}/conf
nginx_sdp_conf=${nginx_conf}/Sdp
[ -d $nginx_sdp_conf ] || mkdir -p $nginx_sdp_conf
if [ "$init_service_type" = "nginx" ] || [ "$init_service_type" = "httpd" ]; then
  service_port=80
elif [ "$init_service_type" = "tomcat" ]; then
  service_port=8080
fi
cat > ${nginx_sdp_conf}/${init_user}.${user_id}.conf <<EOF
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
#echo "$init_user_container_ip  $init_user_dns" >> /etc/hosts
check_reload() {
  $nginx_exec -t
  rm -rf $init_user_home; rm -f ${nginx_sdp_conf}/${init_user}.${user_id}.conf
  exit 1
}
$nginx_exec -t &> /dev/null && nginx -s reload || check_reload

if [ "$init_file_type" == "svn" ]; then
  create_svn $init_user $init_passwd
  AutoUpdateSvn
elif [ "$init_file_type" == "ftp" ]; then
  create_ftp $init_user $init_passwd $init_user_home_root
elif [ "$init_file_type" == "-" ]; then
  rm -fr $init_user_home_root
fi

source $SDP_HOME/builds/webs_builds.sh
