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

#user_oid:Existing User ID
user_oid=$(grep user_id $Sdp | tail -1 | awk -F : '{print $2}')
if [ -z $user_oid ] || [ "$user_oid" = "" ]; then
  export user_id=1
  echo "9000" > $portmap_file
else
  export user_id=`expr $user_oid + 1`
  echo `expr 9000 + $user_oid` > $portmap_file
  #first portmap is 9000, and portmap = portmap + user_id
  #firsh user_id is 1, and user_id = user_id + 1
fi




