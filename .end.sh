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
欢迎:
  用户名: $init_user
  密码: $init_passwd
  验证邮箱: $user_email
  服务类型: $init_service_type
  免费域名: $init_user_dns
  版本库地址: https://svn.saintic.com/sdi/${init_user}
  请将您的域名做别名解析到我们提供的免费域名"${init_user_dns}"上，详情请访问https://saintic.com/sdp
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
欢迎:
  用户名: $init_user
  密码: $init_passwd
  验证邮箱: $user_email
  服务类型: $init_service_type
  免费域名: $init_user_dns
  FTP地址: ftp://$init_user_dns
  请将您的域名做别名解析到我们提供的免费域名"${init_user_dns}"上，详情请访问https://saintic.com/sdp
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
欢迎:
  用户名: $init_user
  密码: $init_passwd
  验证邮箱: $user_email
  服务类型: $init_service_type
  IP和端口: ${SERVER_IP}:${portmap}
  应用连接信息即IP和端口，若您的服务类型为MySQL，则其root密码为${init_passwd}，详情请访问https://saintic.com/sdp
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
  tail $init_user_home_info | mailx -r Sdp@saintic.com -s "尊敬的$init_user，欢迎您：你是我们第${user_id}个用户" $user_email
  tail -13 $Sdpuc | mailx -r Sdp@saintic.com -s "Sdp.UserInfo:${init_user}(${user_id})" staugur@vip.qq.com
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

