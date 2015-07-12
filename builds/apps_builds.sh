#!/bin/bash
#boot services.
source $SDP_HOME/global.func
[ -z $init_service_type ] && ERROR
[ -z $SERVER_IP ] && ERROR
[ -z $init_passwd ] && ERROR

container_memcached=staugur/memcached
container_mongodb=staugur/mongodb
container_mysql=staugur/mysql
container_redis=staugur/redis

case $init_service_type in
memcached)
  container_id=`docker run -tdi --name $init_user -p ${SERVER_IP}:${portmap}:11211 $container_memcached`
  docker exec -i $container_id /usr/local/bin/memcached -d -u root
  ;;
mongodb)
  container_id=`docker run -tdi --name $init_user -p ${SERVER_IP}:${portmap}:27017 $container_mongodb`
  docker exec -i $container_id /data/app/mongodb/bin/mongod -f /data/app/mongodb/mongod.conf &
  ;;
mysql)
  container_id=`docker run -tdi --name $init_user -p ${SERVER_IP}:${portmap}:3306 $container_mysql`
  docker exec -i $container_id /etc/init.d/mysqld start
  docker exec -i $container_id mysql -e "grant all on *.* to 'root'@'%' identified by \"${init_passwd}\" with grant option;"
  docker exec -i $container_id mysql -e "grant all on *.* to 'root'@'localhost' identified by \"${init_passwd}\";"
  docker exec -i $container_id /etc/init.d/mysqld reload
  ;;
redis)
  container_id=`docker run -tdi --name $init_user -p ${SERVER_IP}:${portmap}:6379 $container_redis`
  #docker exec -i sed -i 's/appendonly no/appendonly yes/' /etc/redis.conf
  docker exec -i $container_id /etc/init.d/redis start
  ;;
*)
  echo -e "\033[31mUnsupported service type！\033[0m"
  ERROR
  dockererror
  ;;
esac

container_ip=$(sudo docker inspect --format '{{ .NetworkSettings.IPAddress }}' $init_user)
container_pid=$(sudo docker inspect --format '{{.State.Pid}}' $init_user)

source $SDP_HOME/.end.sh
