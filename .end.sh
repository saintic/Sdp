#!/bin/bash
source ${SDP_HOME}/global.func
export LANG=zh_CN.UTF-8

DoubleError() {
  ERROR
  dockererror
}

WebsUserInfo() {
cat > $init_user_home_info <<EOF
Sdp应用信息:
  用户名: $init_user
  密码: $init_passwd
  验证邮箱: $user_email
  服务类型: $init_service_type
  免费域名: $init_user_dns
  请将您的域名做别名解析到我们提供的免费域名"${init_user_dns}"上，详情请访问https://saintic.com/sdp，您的文件系统访问类型地址是：
EOF

if [ $init_file_type == svn ]; then
cat >> $init_user_home_info <<EOF
  版本库地址: https://svn.saintic.com/sdi/${init_user}
EOF
elif [ $init_file_type == ftp ]; then
cat >> $init_user_home_info <<EOF
  FTP地址: ftp://$init_user_dns
EOF
}

AppsUserInfo() {
cat > $init_user_home_info <<EOF
Sdp应用信息:
  用户名: $init_user
  密码: $init_passwd
  验证邮箱: $user_email
  服务类型: $init_service_type
  IP和端口: ${SERVER_IP}:${portmap}
  应用连接信息即IP和端口，若您的服务中有任何需要密码的部分均为"${init_passwd}"，详情文档请访问https://saintic.com/sdp
EOF
}

#将用户信息写入用户数据文件
cat >> $Sdpuc <<USERINFO
  "$user_id": {
  "uid": "$user_id",
  "user": "$init_user",
  "passwd": "$init_passwd",
  "home": "$init_user_home",
  "email": "$user_email",
  "service": "$init_service_type",
  "file": "$init_file_type",
  "CreateTime": "$CreateTime",
  "ExpirationTime": "$ExpirationTime",
  "port": "$portmap",
  "dn": "$init_user_dns",
  "container_id": "$container_id",
  "container_ip": "$container_ip",
  "userinfo": "$init_user_home_info",
  "SVN": "https://svn.saintic.com/sdi/${init_user}",
  "FTP": "ftp://${init_user_dns}",
  "Notes": "##########################################################"
  }
USERINFO

if echo "${webs[@]}" | grep -w $init_service_type &> /dev/null ;then
  WebsUserInfo
elif echo "${apps[@]}" | grep -w $init_service_type &> /dev/null ;then
  AppsUserInfo
fi

email() {
  tail $init_user_home_info | mailx -r Sdp@saintic.com -s "$init_user，欢迎您，你是我们第${user_id}个用户" $user_email
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

