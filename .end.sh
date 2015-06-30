#!/bin/bash
source $SDP_HOME/global.func
[ -z $Sdpuc ] && ERROR
[ -z $webs ] && ERROR
[ -z $apps ] && ERROR

WebsUserInfo() {
if [ $init_file_type = svn ]; then
cat >> $Sdpuc <<EOF
user_id:$user_id
  "user:$init_user" "password:$init_passwd" "installed:$init_service_type"; "filetype:$init_file_type";
  "Other info:"
    "Verification E-mail: $user_email"
    "DN/hosts: ${init_user_dns},${init_user_host}"
    "CreateTime: $CreateTime"
    "Expiration time: $ExpirationTime"
    "User Home: $init_user_home"
    "SVN Address: https://svn.saintic.com/sdi/${init_user}"
    "ContainerID: $container_id"
    "ContainerIP: $container_ip"
    "ContainerPID: $container_pid"
##########################################################!!!!!!!!!!!!!!!
EOF
cat > $init_user_home_info <<EOF
Welcome:
  Your user:$init_user
  Your password:$init_passwd
  Verification E-mail:$user_email
  Your service:$init_service_type
  Your DomainName:$init_user_dns
  Your SVN address:https://svn.saintic.com/sdi/$init_user
  Please CNAME your own domain name to "$init_user_dns", please visit:https://saintic.com/sdp
EOF

elif [ $init_file_type = ftp ]; then
cat >> $Sdpuc <<EOF
user_id:$user_id
  "user:$init_user" "password:$init_passwd" "installed:$init_service_type"; "filetype:$init_file_type";
  "Other info:"
    "Verification E-mail: $user_email"
    "DN/hosts: ${init_user_dns},${init_user_host}"
    "CreateTime: $CreateTime"
    "Expiration time: $ExpirationTime"
    "User Home: $init_user_home"
    "FTP Address: $init_user_dns"
    "ContainerID: $container_id"
    "ContainerIP: $container_ip"
    "ContainerPID: $container_pid"
##########################################################!!!!!!!!!!!!!!!
EOF
cat > $init_user_home_info <<EOF
Welcome:
  Your user:$init_user
  Your password:$init_passwd
  Verification E-mail:$user_email
  Your service:$init_service_type
  Your DomainName:$init_user_dns
  Your FTP address:$init_user_dns
  Please CNAME your own domain name to "$init_user_dns", please visit:https://saintic.com/sdp
EOF
fi
}

AppsUserInfo() {
cat >> $Sdpuc <<EOF
user_id:$user_id
  "user:$init_user" "password:$init_passwd" "installed:$init_service_type"; "filetype:$init_file_type";
  "Other info:"
    "Verification E-mail: $user_email"
    "IP/PORT: ${SERVER_IP}:$portmap"
    "CreateTime: $CreateTime"
    "Expiration time: $ExpirationTime"
    "User Home: $init_user_home"
    "Data Directory: $init_user_home_root"
    "ContainerID: $container_id"
    "ContainerIP: $container_ip"
    "ContainerPID: $container_pid"
##########################################################!!!!!!!!!
EOF
cat > $init_user_home_info <<EOF
Welcome:
  Your user:$init_user
  Your password:$init_passwd
  Verification E-mail:$user_email
  Your service:${init_service_type}
  IP&PORT:${SERVER_IP}:${portmap}
  Please visit:https://saintic.com/sdp
EOF
}

if echo "${webs[@]}" | grep -w $init_service_type &> /dev/null ;then
  WebsUserInfo
elif echo "${apps[@]}" | grep -w $init_service_type &> /dev/null ;then
  AppsUserInfo
fi

DoubleError() {
ERROR
dockererror
}

if [ -d $init_user_home ]; then
  if [ "$init_file_type" = "svn" ]; then
    grep "$init_user" $svnconf &> /dev/null || DoubleError
  elif [ "$init_file_type" = "ftp" ]; then
    grep "$init_user" $vfu &> /dev/null || DoubleError
  fi
  if echo "${webs[@]}" | grep -w $init_service_type &> /dev/null ;then
    grep $init_user_host /etc/hosts &> /dev/null || DoubleError
    grep $init_user_dns	$dnmap_file &> /dev/null || DoubleError
  fi
  echo "Ending,Succeed!!!"
  tail $init_user_home_info | mailx -r Sdp@saintic.com -s "Welcome:$init_user,you are SaintIC NO.${user_id} user." $user_email
  tail -13 $Sdpuc | mailx -r Sdp@saintic.com -s "Sdp.UserInfo:LatestOne" staugur@vip.qq.com
else
  DoubleError
fi
