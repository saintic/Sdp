#!/bin/bash
source $SDP_HOME/global.func
[ -z $Sdpuc ] && ERROR
cat >> $Sdpuc <<EOF
user_id:$user_id
  "user:$init_user" "password:$init_passwd" "installed:$init_service_type"; "filetype:$init_file_type";
  "other info:"
    "MAP:182.92.106.104:$portmap"
	"CreateTime:"
	"Expiration time:"
    "User Home:$init_user_home"
    "Code Directory:$init_user_home_root"
    "ContainerID:$container_id"
    "ContainerInfo:$container_info"
##########################################################!!!!!!!!!
EOF

if [ -d $init_user_home ]; then
  if [ "$init_file_type" = "svn" ]; then
    grep "$init_user" $svnconf &> /dev/null || ERROR
  elif [ "$init_file_type" = "ftp" ]; then
    grep "$init_user" $vfu &> /dev/null || ERROR
  fi
  echo "Ending,Succeed!!!"
  tail $init_user_home_info | mailx -r staugur@saintic.com -s "Welcome:$init_user,you are SaintIC Sdp NO.${user_id} user." $user_email
  tail $Sdpuc | mailx -r staugur@saintic.com -s "Sdp.UserInfo:LatestOne" staugur@vip.qq.com all@saintic.com
else
  ERROR
fi
