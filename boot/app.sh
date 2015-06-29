#!/bin/bash
#app:MongoDB,Redis,MySQL,MemCached

source $SDP_HOME/global.func
[ -z $apps ] && ERROR
[ -z $INIT_HOME ] && ERROR
[ -z $init_user ] && ERROR
[ -z $init_passwd ] && ERROR
[ -z $init_file_type ] && ERROR
[ -z $init_user_home ] && ERROR
[ -z $init_user_home_info ] && ERROR
[ -z $init_user_home_root ] && ERROR

export portmap_file=${INIT_HOME}/portmap
if [ -z $user_oid ] || [ "$user_oid" = "" ]; then
  echo "9000" > $portmap_file
else
  echo `expr 9000 + $user_id` > $portmap_file
  #First open port is 9000, and portmap = portmap + user_id. Does not support multiple applications for the same user
  #Firsh user_id is 1, and user_id = user_id + 1
fi

export portmap=`cat $portmap_file`
/sbin/iptables -I INPUT -p tcp --dport $portmap -j ACCEPT

source $SDP_HOME/builds/apps_builds.sh
