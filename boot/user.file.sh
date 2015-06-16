#!/bin/bash
#Save to file for user and passwd > $init_user_home/info #file
#init_user_home=${INIT_HOME}/${init_user}
#code:init_user_home_root=${INIT_HOME}/${init_user}/root
source $SDP_HOME/global.func

[ -z $INIT_HOME ] && ERROR
[ -z $init_user ] && ERROR
[ -z $init_passwd ] && ERROR
[ -z $init_file_type ] && ERROR
[ -z $init_user_home ] && ERROR
[ -z $init_user_home_info ] && ERROR
[ -z $init_user_home_root ] && ERROR

if [ "$init_file_type" == "svn" ]; then
  rm -rf $init_user_home_root && svnadmin create $init_user_home_root
  create_svn $init_user $init_passwd $init_user_home_root
elif [ "$init_file_type" == "ftp" ]; then
  create_ftp $init_user $init_passwd $init_user_home_root
elif [ "$init_file_type" == "-" ]; then
  :
fi

source $SDP_HOME/boot/docker.sh
