#!/bin/bash
#boot services.
source $SDP_HOME/global.func
[ -z $init_service_type ] && ERROR
case $init_service_type in
memcached)
  source ${SDP_HOME}/builds/apps/MemCached/init.sh
  ;;
mongodb)
  source ${SDP_HOME}/builds/apps/MongoDB/init.sh
  ;;
mysql)
  source ${SDP_HOME}/builds/apps/MySQL/init.sh
  ;;
redis)
  source ${SDP_HOME}/builds/apps/Redis/init.sh
  ;;
*)
  echo -e "\033[31mUnsupported service type！\033[0m"
  ;;
esac
source $SDP_HOME/.end.sh
