#!/bin/bash
[ -z $Sdp ] && echo "Ending,Error." && exit 1
cat >> $Sdp <<EOF
user_id:$user_id
  "user:$init_user" "password:$init_passwd" "installed:$init_service_type"; "filetype:$init_file_type";
  "other info:"
    "MAP:182.92.106.104:$portmap"
    "File Directory:$init_user_home_root"
    "ContainerID:$container_id"
    "ContainerInfo:$container_info"
####################@@@@@@@@@@@@@@@@@@####################@@@@@@@@@@@@@@!!!
EOF
echo "Ending,Succeed!!!"
