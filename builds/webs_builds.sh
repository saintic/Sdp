#!/bin/bash
#boot web services.
source $SDP_HOME/global.func
[ -z $init_user ] && ERROR
[ -z $init_user_dns ] && ERROR
[ -z $init_service_type ] && ERROR

container_nginx=staugur/centos
container_httpd=staugur/centos
container_tomcat=staugur/centos

case $init_service_type in
nginx)
  docker run -tdi --name $init_user -v ${init_user_home_root}:/data/wwwroot $container_nginx
  #data:wwwroot,logs
  ;;
httpd)
  docker run -tdi --name $init_user -v ${init_user_home_root}:/data/wwwroot $container_httpd
  ;;
tomcat)
  docker run -tdi --name $init_user -v ${init_user_home_root}:/data/wwwroot $container_tomcat
  ;;
*)
  echo -e "\033[31mUnsupported service type！\033[0m"
  rm -fr $init_user_home ; rm -f ${nginx_sdp_conf}/${init_user}.${user_id}.conf
  exit 1
  ;;
esac

container_id=$(sudo docker ps | grep $init_user | awk '{print $1}')
container_ip=$(sudo docker inspect --format '{{ .NetworkSettings.IPAddress }}' $init_user)
container_pid=$(sudo docker inspect --format '{{.State.Pid}}' $init_user)

echo "$container_ip  $init_user_dns" >> /etc/hosts
source $SDP_HOME/.end.sh
