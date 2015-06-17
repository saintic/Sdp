#!/bin/bash
source $SDP_HOME/global.func
[ -z $Sdp ] && ERROR
cat >> $Sdp <<EOF
user_id:$user_id
  "user:$init_user" "password:$init_passwd" "installed:$init_service_type"; "filetype:$init_file_type";
  "other info:"
    "MAP:182.92.106.104:$portmap"
    "User Home:$init_user_home"
    "Code Directory:$init_user_home_root"
    "ContainerID:$container_id"
    "ContainerInfo:$container_info"
####################@@@@@@@@@@@@@@@@@@@@@@@########################@@@@@@@@@@@@@@@@@@@@@@@!!!
EOF
if [ -d $init_user_home ]; then
  if [ "$init_file_type" = "svn" ]; then
    grep "$init_user" /etc/httpd/conf.d/subversion.conf &> /dev/null || ERROR
  elif [ "$init_file_type" = "ftp" ]; then
    grep "$init_user" /etc/vsftpd/vfu.list &> /dev/null || ERROR
  fi
  echo "Ending,Succeed!!!"
  tail $init_user_home_info | mailx -r staugur@saintic.com -s "Welcome:$init_user,you are SaintIC $user_id user." $user_email
  tail $Sdp | mailx -r staugur@saintic.com -s "SDI.PaaS.User_Info_LatestOne" staugur@vip.qq.com
else
  ERROR
fi
