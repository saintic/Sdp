#!/bin/bash
source $SDP_HOME/global.func

WebsUserInfo() {
if [ $init_file_type = svn ]; then
cat >> $Sdpuc <<EOF
user_id:$user_id
  "user:$init_user" "password:$init_passwd" "installed:$init_service_type"; "filetype:$init_file_type";
  "Other info:"
    "Verification E-mail: $user_email"
    "DN: ${init_user_dns}"
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
  Your user: $init_user
  Your password: $init_passwd
  Verification E-mail: $user_email
  Your service: $init_service_type
  Your DomainName: $init_user_dns
  Your SVN address: https://svn.saintic.com/sdi/$init_user
  Please CNAME your own domain name to "$init_user_dns", please visit:https://saintic.com/sdp
EOF

elif [ $init_file_type = ftp ]; then
cat >> $Sdpuc <<EOF
user_id:$user_id
  "user:$init_user" "password:$init_passwd" "installed:$init_service_type"; "filetype:$init_file_type";
  "Other info:"
    "Verification E-mail: $user_email"
    "DN: ${init_user_dns}"
    "CreateTime: $CreateTime"
    "Expiration time: $ExpirationTime"
    "User Home: $init_user_home"
    "FTP Address: ftp://$init_user_dns"
    "ContainerID: $container_id"
    "ContainerIP: $container_ip"
    "ContainerPID: $container_pid"
##########################################################!!!!!!!!!!!!!!!
EOF
cat > $init_user_home_info <<EOF
Welcome:
  Your user: $init_user
  Your password: $init_passwd
  Verification E-mail: $user_email
  Your service: $init_service_type
  Your DomainName: $init_user_dns
  Your FTP address: ftp://$init_user_dns
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
  Your user: $init_user
  Your password: $init_passwd
  Verification E-mail: $user_email
  Your service: $init_service_type
  IP&PORT: ${SERVER_IP}:${portmap}
  Please visit: https://saintic.com/sdp
EOF
}

if echo "${webs[@]}" | grep -w $init_service_type &> /dev/null ;then
  WebsUserInfo
cat > $init_user_home_json <<EOF
{
  "web": [
    {
      "ip": "$container_ip",
      "conf": "$user_nginx_conf"
    }
  ],
  "uid": "$user_id",
  "user": "$init_user",
  "passwd": "$init_passwd",
  "service": "$init_service_type",
  "time": "$ExpirationTime",
  "file": "$init_file_type",
  "email": "$user_email"
}
EOF
elif echo "${apps[@]}" | grep -w $init_service_type &> /dev/null ;then
  AppsUserInfo
cat > $init_user_home_json <<EOF
{
  "uid": "$user_id",
  "user": "$init_user",
  "passwd": "$init_passwd",
  "service": "$init_service_type",
  "time": "$ExpirationTime",
  "file": "$init_file_type",
  "email": "$user_email"
}
EOF
fi

DoubleError() {
ERROR
dockererror
}

email() {
  tail $init_user_home_info | mailx -r Sdp@saintic.com -s "Welcome:$init_user,you are SaintIC NO.${user_id} user." $user_email
  tail -13 $Sdpuc | mailx -r Sdp@saintic.com -s "Sdp.UserInfo:LatestOne" staugur@vip.qq.com
}

if [ -d $init_user_home ]; then
  if [ "$init_file_type" = "svn" ]; then
    grep "$init_user" $svnconf &> /dev/null || DoubleError
  elif [ "$init_file_type" = "ftp" ]; then
    grep "$init_user" $vfu &> /dev/null || DoubleError
  fi
  if echo "${webs[@]}" | grep -w $init_service_type &> /dev/null ;then
    grep $init_user_dns	$dnmap_file &> /dev/null || DoubleError
  fi
  echo "Ending,Succeed!!!"
  email
else
  DoubleError
fi

