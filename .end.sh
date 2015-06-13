#!/bin/bash
[ -z $Sdp ] && echo "Ending." && exit 1
cat >> $Sdp <<EOF
user_id:1
"user:$init_user" "password:$init_passwd" "installed:$init_service_type" "filetype:$init_file_type"
  "other info:"
    "MAP:182.92.106.104:$portmap"
    "File Directory:$file_dir"
    "ContainerID:$container_id"
    "ContainerInfo:$container_info"
####################@@@@@@@@@@@@@@@@@@####################@@@@@@@@@@@@@@
EOF
