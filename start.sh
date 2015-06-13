#!/bin/bash
#user/passwd/service/file->user.file->dns.map->docker.service
#everythin is file.user/passwd、ip_port(expose docker)、docker_map
#retrun: $0 successful, user passwd IP:Port(DNS) service file_directory.
SDP_HOME=`pwd`
if [ "$#" != "4" ]; then
  echo "Usage: $0 user passwd service file_type" ; exit 1
else
  :
fi
source $SDP_HOME/global.func
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
touch $Sdp $portmap_file
#user_oid:Existing User ID
user_oid=$(grep user_id $Sdp | tail -1 | awk -F : '{print $2}')
if [ -z $user_oid ] || [ "$user_oid" = "" ]; then
  echo "50000" > $portmap_file
else
  echo `expr 50000 + $user_oid` > $portmap_file
  #first portmap is 5000, user_id is null ,and portmap = portmap + user_id
fi

source $SDP_HOME/boot/user.file.sh
