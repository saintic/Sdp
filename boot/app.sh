#!/bin/bash
#app:MongoDB,Redis,MySQL,MemCached

source ${SDP_HOME}/global.func
[ -z $apps ] && ERROR
[ -z $user_id ] && ERROR
[ -z $INIT_HOME ] && ERROR
[ -z $init_user ] && ERROR
[ -z $init_passwd ] && ERROR
[ -z $init_file_type ] && ERROR
[ -z $init_user_home ] && ERROR
[ -z $init_user_home_info ] && ERROR
[ -z $init_user_home_root ] && ERROR

[ -d $init_user_home_root ] || mkdir -p $init_user_home_root
[ -f $init_user_home_info ] || touch $init_user_home_info

#APP型独有的端口文件
export portmap_file=${INIT_HOME}/.portmap

if [ -e $portmap_file ]; then
  echo $(($(cat $portmap_file) + 1)) > $portmap_file
else
  echo "9000" > $portmap_file
fi
export portmap=`cat $portmap_file`
/sbin/iptables -I INPUT -p tcp --dport $portmap -j ACCEPT
source ${SDP_HOME}/builds/apps_builds.sh
