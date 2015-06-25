#!/bin/bash
#app:MongoDB,Redis,MySQL,MemCached
#init_user_home=${INIT_HOME}/${init_user}
#Save to file for user and passwd > $init_user_home/info
#code:init_user_home_root=${INIT_HOME}/${init_user}/root
source $SDP_HOME/global.func
[ -z $apps ] && ERROR
[ -z $INIT_HOME ] && ERROR
[ -z $init_user ] && ERROR
[ -z $init_passwd ] && ERROR
[ -z $init_file_type ] && ERROR
[ -z $init_user_home ] && ERROR
[ -z $init_user_home_info ] && ERROR
[ -z $init_user_home_root ] && ERROR

svnco() {
  svnadmin create $init_user_home_svnroot
  init_user_home_svnroot=$init_user_home/$init_user
  create_svn $init_user $init_passwd $init_user_home_svnroot
  rm -rf $init_user_home_root ; cd $init_user_home ; svn co https://svn.saintic.com/sdi/$init_user root
}

export portmap_file=${INIT_HOME}/portmap
[ -f $portmap_file ] || touch $portmap_file
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

if [ "$init_file_type" == "svn" ]; then
  
elif [ "$init_file_type" == "ftp" ]; then
  create_ftp $init_user $init_passwd $init_user_home_root
elif [ "$init_file_type" == "-" ]; then
  :
fi

source $SDP_HOME/builds/
