#!/bin/bash
#boot services.
APPDIR=$(cd `dirname $0`; pwd)
source $SDP_HOME/global.func
[ -z $init_service_type ] && ERROR
case $init_service_type in
memcached)
  source ${APPDIR}/MemCached/init.sh
  ;;
mongodb)
  source ${APPDIR}/MongoDB/init.sh
  ;;
mysql)
  source ${APPDIR}/MySQL/init.sh
  ;;
redis)
  source ${APPDIR}/Redis/init.sh
  ;;
*)
  echo -e "\033[31mUnsupported service type！\033[0m"
  ;;
esac
source $SDP_HOME/.end.sh
