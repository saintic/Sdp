#!/bin/bash
#boot web services.
source $SDP_HOME/global.func
[ -z $init_service_type ] && ERROR

container_nginx=
container_httpd=
container_tomcat=

: :||:<<\COMMENTS
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
  ;;
esac
source $SDP_HOME/.end.sh
COMMENTS

source $SDP_HOME/.end.sh
