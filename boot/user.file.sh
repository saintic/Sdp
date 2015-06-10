#!/bin/bash
#Save to file for user and passwd, but now, create root for user only.
source ../global.func

[ -z $INIT_HOME ] && ERROR
[ -z $init_file_type ] && ERROR

export init_user_home=${INIT_HOME}/${init_user}

if [ "$init_file_type" == "svn" ]; then
  svnadmin create $init_user_home
  svnhttp $init_user_home
elif [ "$init_file_type" == "ftp" ]; then
  create_ftp $init_user $init_passwd $init_user_home
  mkdir -p ${INIT_HOME}/${init_user}
fi

source ./dns.sh
