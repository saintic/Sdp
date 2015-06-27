#!/bin/bash
source $SDP_HOME/global.func
[ -z $Sdpuc ] && ERROR
[ -z $webs ] && ERROR
[ -z $apps ] && ERROR

if echo "${webs[@]}" | grep -w $init_service_type &> /dev/null ;then
cat >> $Sdpuc <<EOF
user_id:$user_id
  "user:$init_user" "password:$init_passwd" "installed:$init_service_type"; "filetype:$init_file_type";
  "other info:"
    "DN/hosts:${init_user_dns},${init_user_host}"
	"CreateTime:$CreateTime"
	"Expiration time:$ExpirationTime"
    "User Home:$init_user_home"
    "Data Directory:$init_user_home_root"
    "ContainerID:$container_id"
    "ContainerIP=$container_ip"
	"ContainerPID:$container_pid"
##########################################################!!!!!!!!!
EOF
elif echo "${apps[@]}" | grep -w $init_service_type &> /dev/null ;then
cat >> $Sdpuc <<EOF
user_id:$user_id
  "user:$init_user" "password:$init_passwd" "installed:$init_service_type"; "filetype:$init_file_type";
  "other info:"
    "IP/PORT:${SERVER_IP}:$portmap"
	"CreateTime:$CreateTime"
	"Expiration time:$ExpirationTime"
    "User Home:$init_user_home"
    "Data Directory:$init_user_home_root"
    "ContainerID:$container_id"
    "ContainerIP=$container_ip"
	"ContainerPID:$container_pid"
##########################################################!!!!!!!!!
EOF
fi

if [ -d $init_user_home ]; then
  if [ "$init_file_type" = "svn" ]; then
    grep "$init_user" $svnconf &> /dev/null || ERROR
  elif [ "$init_file_type" = "ftp" ]; then
    grep "$init_user" $vfu &> /dev/null || ERROR
  fi
  echo "Ending,Succeed!!!"
  tail $init_user_home_info | mailx -r staugur@saintic.com -s "Welcome:$init_user,you are SaintIC Sdp NO.${user_id} user." $user_email
  tail -11 $Sdpuc | mailx -r staugur@saintic.com -s "Sdp.UserInfo:LatestOne" staugur@vip.qq.com all@saintic.com
else
  ERROR
fi
