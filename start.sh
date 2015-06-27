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

#Create a random password encrypted by MD5 and email user.
export init_user=$1
export use_time=$2
export init_passwd=`MD5PASSWD`
export init_service_type=$3
export init_file_type=$4
export user_email=$5
export INIT_HOME=/data/SDI.Sdp
export Sdpuc=${INIT_HOME}/Sdp.Ucenter               #file
export init_user_home=${INIT_HOME}/$init_user       #directory
export init_user_home_info=${init_user_home}/info   #file
export init_user_home_root=${init_user_home}/root   #directory
export SDP_HOME=$(cd `dirname $0`; pwd)
if [ "$#" != "5" ]; then
  echo "Usage: $0 user use_time service_type file_type email" >&2 ; exit 1
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

[ -d $INIT_HOME ] || mkdir -p $INIT_HOME
[ -f $Sdpuc ] || touch $Sdpuc
[ -d $init_user_home_root ] || mkdir -p $init_user_home_root
[ -f $init_user_home_info ] || touch $init_user_home_info

#user_oid:Existing User ID
user_oid=$(grep user_id $Sdpuc | tail -1 | awk -F : '{print $2}')
if [ -z $user_oid ] || [ "$user_oid" = "" ]; then
  export user_id=1
else
  export user_id=`expr $user_oid + 1`
fi

CreateTime=`date +%Y%m%d`
ExpirationTime=`date +%Y%m%d -d "$use_time month"`

export webs=("nginx" "httpd" "tomcat")
#webs can use svn,ftp;
export apps=("mongodb" "memcached" "redis" "mysql")
#apps can't use anyone,only -.
if echo "${webs[@]}" | grep -w $init_service_type &> /dev/null ;then
  source $SDP_HOME/boot/web.sh
elif echo "${apps[@]}" | grep -w $init_service_type &> /dev/null ;then
  source $SDP_HOME/boot/app.sh
else
  check_service_type
fi
