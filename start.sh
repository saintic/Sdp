#!/bin/bash
#user/passwd/service/file->user.file->dns.map->docker.service
#everything is file.user/passwd、ip_port(expose docker)、docker_map
#retrun: $0 successful, user passwd IP:Port(DNS) service file_directory.

check_file_type() {
  echo -e "\033[31mUnsupported code type！\033[0m" >&2
  echo -e "\033[31mAsk:svn,ftp,-\033[0m" >&2
  exit 1
}

check_service_type() {
  echo -e "\033[31mUnsupported service type！\033[0m" >&2
  echo -e "\033[31mSupported service:redis,mongodb,memcached,mysql,nginx,httpd,tomcat.\033[0m" >&2
  exit 1
}

export SDP_HOME=$(cd `dirname $0`; pwd)
if [ "$#" != "5" ]; then
  echo "Usage: $0 user passwd service_type file_type email" >&2 ; exit 1
fi

files=("svn" "ftp" "-")
if echo "${files[@]}" | grep -w $init_file_type &> /dev/null ;then
  :
else
  check_file_type
fi 

services=("mongodb" "memcached" "redis" "mysql" "nginx" "httpd" "tomcat")
if echo "${services[@]}" | grep -w $init_service_type &> /dev/null ;then
  :
else
  check_service_type
fi

export INIT_HOME=/data/SDI.Sdp
export init_user=$1
export init_passwd=$2
export init_service_type=$3
export init_file_type=$4
export user_email=$5
export Sdp=${INIT_HOME}/Sdp.user.info            #file
export init_user_home=${INIT_HOME}/$init_user    #directory
export init_user_home_info=${INIT_HOME}/${init_user}/info   #file
export init_user_home_root=${INIT_HOME}/${init_user}/root   #directory

[ -d $INIT_HOME ] || mkdir -p ${INIT_HOME}/$init_user
[ -f $Sdp ] || touch $Sdp
[ -d $init_user_home_root ] || mkdir -p $init_user_home_root
[ -f $init_user_home_info ] || touch  $init_user_home_info

export webs=("nginx" "httpd" "tomcat")
export apps=("mongodb" "memcached" "redis" "mysql")
if echo "${webs[@]}" | grep -w $init_service_type &> /dev/null ;then
  source $SDP_HOME/boot/web.sh
elif echo "${apps[@]}" | grep -w $init_service_type &> /dev/null ;then
  source $SDP_HOME/boot/app.sh
else
  check_service_type
fi
