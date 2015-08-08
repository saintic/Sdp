#!/bin/bash
#web.app:nginx,httpd,tomcat
#save dn, nginx proxy.
source ${SDP_HOME}/global.func

[ -z $user_id ] && ERROR
[ -z $init_user ] && ERROR
[ -z $init_file_type ] && ERROR
[ -z $init_service_type ] && ERROR
[ -z $init_user_home_root ] && ERROR
[ -z $init_user_home_info ] && ERROR

[ -d $init_user_home_root ] || mkdir -p $init_user_home_root
[ -f $init_user_home_info ] || touch $init_user_home_info

export dnmap_file=${INIT_HOME}/.dnmap
export init_user_dns=${init_user}.${user_id}.sdp.saintic.com

if grep $init_user_dns $dnmap_file &> /dev/null ;then
  echo -e "\033[31mThe domain name has been recorded in the $dnmap_file file.\033[0m" 2>&1
  rm -rf $init_user_home ; exit 1
else
  echo "$init_user_dns" >> $dnmap_file
fi

if [ "$init_file_type" == "svn" ]; then
  create_svn $init_user $init_passwd
  AutoUpdateSvn
elif [ "$init_file_type" == "ftp" ]; then
  create_ftp $init_user $init_passwd $init_user_home_root 
fi

source ${SDP_HOME}/builds/webs_builds.sh
