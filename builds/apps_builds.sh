#!/bin/bash
#boot services.
source $SDP_HOME/global.func
[ -z $init_service_type ] && ERROR
case $init_service_type in
memcached)
  docker build -t staugur/memcached ${SDP_HOME}/builds/apps/MemCached
  ;;
mongodb)
  docker build -t staugur/mongodb ${SDP_HOME}/builds/apps/MongoDB
  ;;
mysql)
  docker build -t staugur/mysql ${SDP_HOME}/builds/apps/MySQL
  ;;
redis)
  docker build -t staugur/redis ${SDP_HOME}/builds/apps/Redis
  ;;
*)
  echo -e "\033[31mUnsupported service type！\033[0m"
  ;;
esac
source $SDP_HOME/.end.sh
