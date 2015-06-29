#!/bin/bash
#boot services.
source $SDP_HOME/global.func
[ -z $init_service_type ] && ERROR

container_memcached=staugur/centos
container_mongodb=staugur/centos
container_mysql=staugur/centos
container_redis=staugur/centos

case $init_service_type in
memcached)
  docker run -tdi --name $init_user -p ${portmap}:11211 $container_memcached
  ;;
mongodb)
  docker run -tdi --name $init_user -p ${portmap}:27017 $container_mongodb
  ;;
mysql)
  docker run -tdi --name $init_user -p ${portmap}:3306 $container_mysql
  ;;
redis)
  docker run -tdi --name $init_user -p ${portmap}:6379 $container_redis
  ;;
*)
  echo -e "\033[31mUnsupported service type！\033[0m"
  ERROR
  dockererror
  ;;
esac

container_id=$(sudo docker ps | grep $init_user | awk '{print $1}')
container_ip=$(sudo docker inspect --format '{{ .NetworkSettings.IPAddress }}' $init_user)
container_pid=$(sudo docker inspect --format '{{.State.Pid}}' $init_user)

source $SDP_HOME/.end.sh
