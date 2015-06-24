#!/bin/bash
#user/passwd/service/file->user.file->dns.map->docker.service
#everything is file.user/passwd、ip_port(expose docker)、docker_map
#retrun: $0 successful, user passwd IP:Port(DNS) service file_directory.
export SDP_HOME=$(cd `dirname $0`; pwd)
if [ "$#" != "5" ]; then
  echo "Usage: $0 user passwd service file_type email" ; exit 1
fi
source $SDP_HOME/global.func
export INIT_HOME=/data/SDI.PaaS
export init_user=$1
export init_passwd=$2
export init_service_type=$3
export init_file_type=$4
export user_email=$5
export portmap_file=${INIT_HOME}/portmap           #file
export Sdp=${INIT_HOME}/Sdp.user.info              #file
export init_user_home=${INIT_HOME}/$init_user      #directory
export init_user_home_info=${INIT_HOME}/${init_user}/info   #file
export init_user_home_root=${INIT_HOME}/${init_user}/root   #directory

if [ "$init_file_type" = "svn" ] || [ "$init_file_type" = "ftp" ] || [ "$init_file_type" = "-"  ]; then
  :
else
  echo -e "\033[31mUnsupported code type！\033[0m"
  echo -e "\033[31mAsk:svn,ftp,-\033[0m"
  exit 1
fi

services=("mongodb" "memcached" "redis" "mysql" "nginx" "httpd" "tomcat")

for i in ${services[*]}
do
  if [ $init_file_type = $i ]; then
    :
  else
    ERROR
  fi
done

if [ "$init_service_type" = "mongodb" ] || [ "$init_service_type" = "memcached" ] || [ "$init_service_type" = "redis" ] || [ "$init_service_type" = "mysql" ]; then
  :
else
  echo -e "\033[31mUnsupported service type！\033[0m"
  echo -e "\033[31mSupported service:redis,mongodb,memcached,mysql.\033[0m"
  exit 1
fi

[ -d $INIT_HOME ] || mkdir -p ${INIT_HOME}/$init_user
[ -f $Sdp ] || touch $Sdp
[ -f $portmap_file ] || touch $portmap_file
[ -d $init_user_home_info ] || mkdir -p $init_user_home_root
[ -f $init_user_home_info ] || touch  $init_user_home_info

#user_oid:Existing User ID
user_oid=$(grep user_id $Sdp | tail -1 | awk -F : '{print $2}')
if [ -z $user_oid ] || [ "$user_oid" = "" ]; then
  export user_id=1
  echo "90000" > $portmap_file
else
  export user_id=`expr $user_oid + 1`
  echo `expr 90000 + $user_oid` > $portmap_file
  #first portmap is 90000, and portmap = portmap + user_id
  #firsh user_id is 1, and user_id = user_id + 1
fi

source $SDP_HOME/boot/user.file.sh
