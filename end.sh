#!/bin/bash
Sdp=/root/Sdp.user.info
cat >> $Sdp <<EOF
"user:$init_user" "password:$init_passwd" "installed:$init_service_type" "filetype:$init_file_type"
  "other info:"
    "DNS:$dns"
    "File Directory:$file_dir"
    "ContainerID:$container_id"
    "ContainerInfo:$container_info"
####################@@@@@@@@@@@@@@@@@@
EOF