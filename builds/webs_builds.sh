#!/bin/bash
#boot web services.
source $SDP_HOME/global.func
[ -z $user_id ] && ERROR
[ -z $init_user ] && ERROR
[ -z $init_user_dns ] && ERROR
[ -z $init_service_type ] && ERROR

container_nginx=staugur/nginx
container_httpd=staugur/httpd
container_tomcat=staugur/tomcat

#Ask:/data include wwwroot,logs.
case $init_service_type in
nginx)
  container_id=`docker run -tdi --restart=always --name $init_user -v ${init_user_home_root}:/data/wwwroot/html $container_nginx`
  docker exec -i $container_id /usr/sbin/nginx
  docker exec -i $container_id /etc/init.d/php-fpm start
  ;;
httpd)
  container_id=`docker run -tdi --restart=always --name $init_user -v ${init_user_home_root}:/data/wwwroot/html $container_httpd`
  docker exec -i $container_id /etc/init.d/httpd start
  ;;
tomcat)
  container_id=`docker run -tdi --restart=always --name $init_user -v ${init_user_home_root}:/data/wwwroot/html $container_tomcat`
  docker exec -i $container_id /usr/local/tomcat/bin/startup.sh   
  ;;
*)
  echo -e "\033[31mUnsupported service type！\033[0m"
  DoubleError
  ;;
esac

container_ip=$(sudo docker inspect --format '{{ .NetworkSettings.IPAddress }}' $init_user)
container_pid=$(sudo docker inspect --format '{{.State.Pid}}' $init_user)

#virtual proxy
nginx_exec=/usr/sbin/nginx
nginx_home=/usr/local/nginx
nginx_conf=${nginx_home}/conf
nginx_sdp_conf=${nginx_conf}/Sdp
user_nginx_conf=${nginx_sdp_conf}/${init_user}.${user_id}.conf
[ -d $nginx_sdp_conf ] || mkdir -p $nginx_sdp_conf
[ -f $user_nginx_conf ] && echo "Nginx configuration file already exists, and exit." && ERROR
if [ "$init_service_type" = "nginx" ] || [ "$init_service_type" = "httpd" ]; then
  service_port=80
elif [ "$init_service_type" = "tomcat" ]; then
  service_port=8080
fi
cat > $user_nginx_conf <<EOF
server {
    listen ${SERVER_IP}:80;
    server_name ${init_user_dns};
    index index.htm index.html index.php index.jsp;
    location / {
       proxy_pass http://${container_ip}:${service_port}/;
       proxy_set_header Host \$host;
       proxy_set_header X-Real-IP \$remote_addr;
       proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;
    }
}
EOF

check_reload() {
  $nginx_exec -t
  ERROR
}
$nginx_exec -t &> /dev/null && nginx -s reload || check_reload


source ${SDP_HOME}/.end.sh
