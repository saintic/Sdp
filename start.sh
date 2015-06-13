#!/bin/bash
#user/passwd/service/file->user.file->dns.map->docker.service
#everythin is file.user/passwd、ip_port(expose docker)、docker_map
#retrun: $0 successful, user passwd IP:Port(DNS) service file_directory.

if [ "$#" != "4" ]; then
  echo "Usage: $0 user passwd service file_type" ; exit 1
else
  :
fi
source ./global.func
export INIT_HOME=/data/SDI.PaaS
[ -d $INIT_HOME ] || mkdir -p ${INIT_HOME}/${init_user}/{info,root}
export init_user=$1
export init_passwd=$2
export init_service_type=$3
export init_file_type=$4
export portmap_file=${INIT_HOME}/portmap           #file
export Sdp=${INIT_HOME}/Sdp.user.info              #file
export init_user_home=${INIT_HOME}/${init_user}    #directory
export init_user_home_info=${INIT_HOME}/${init_user}/info   #file
export init_user_home_root=${INIT_HOME}/${init_user}/root   #directory

#user_id:Existing User ID
user_id=$(grep user_id $Sdp | tail -1 | awk -F : '{print $2}')
if [ -z $user_id ] || [ "$user_id" = "" ];then
  echo "5000" > $portmap_file
else
  echo "5000+$user_id" > $portmap_file
fi

source boot/user.file.sh
