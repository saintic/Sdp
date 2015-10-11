#!/bin/bash
source ${SDP_HOME}/global.func
export LANG="zh_CN.UTF-8"

[ -z $INIT_HOME ] && DoubleError
[ -z $init_user ] && DoubleError
[ -z $init_passwd ] && DoubleError
[ -z $user_email ] && DoubleError
[ -z $user_id ] && DoubleError

WebsUserInfo() {
cat > $init_user_home_info <<EOF
<html>
<body>
<h1>Sdp应用信息:</h1>
&nbsp;&nbsp;用户名: $init_user<br/>
&nbsp;&nbsp;密码: $init_passwd<br/>
&nbsp;&nbsp;验证邮箱: $user_email<br/>
&nbsp;&nbsp;服务类型: $init_service_type<br/>
&nbsp;&nbsp;免费域名: <a href="http://${init_user_dns}" target="_blank">http://${init_user_dns}</a><br/>
&nbsp;&nbsp;请将您的域名做别名解析到我们提供的免费域名"${init_user_dns}"上，详情请访问<a href="https://saintic.com/sdp" target="_blank">https://saintic.com/sdp</a>，您的文件系统访问类型地址是：<br/>
EOF

if [ $init_file_type == svn ]; then
cat >> $init_user_home_info <<EOF
&nbsp;&nbsp;版本库地址: https://${SERVER_IP}/sdi/${init_user}<br/>
</body>
</html>
EOF
elif [ $init_file_type == ftp ]; then
cat >> $init_user_home_info <<EOF
&nbsp;&nbsp;FTP地址: ftp://${init_user_dns}<br/>
</body>
</html>
EOF
fi
}

AppsUserInfo() {
cat > $init_user_home_info <<EOF
<html>
<body>
<h1>Sdp应用信息:</h1>
&nbsp;&nbsp;用户名: $init_user<br/>
&nbsp;&nbsp;密码: $init_passwd<br/>
&nbsp;&nbsp;验证邮箱: $user_email<br/>
&nbsp;&nbsp;服务类型: $init_service_type<br/>
&nbsp;&nbsp;免费域名: <a href="http://${init_user_dns}" target="_blank">http://${init_user_dns}</a><br/>
&nbsp;&nbsp;IP和端口: ${SERVER_IP}:${portmap}<br/>
&nbsp;&nbsp;应用连接信息即IP和端口，若您的服务中有任何需要密码的部分均为"${init_passwd}"，详情请访问<a href="https://saintic.com/sdp" target="_blank">https://saintic.com/sdp</a><br/>
</body>
</html>
EOF
}

#将用户信息写入用户数据文件,完成后删除最后两行，加两个闭大括号。
if [ `cat $Sdpuc | wc -l` -le 7 ]; then  #不存在UID配置
sed -i 'N;$!P;$!D;$d' $Sdpuc
elif [ `cat $Sdpuc | wc -l` -gt 7 ]; then  #即存在UID配置
sed -i 'N;$!P;$!D;$d' $Sdpuc
cat >> $Sdpuc <<EOF
  },
EOF
fi

cat >> $Sdpuc <<USERINFO
  "${init_user}": {
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
  "userinfo": "${init_user_home}/user.json",
  "SVN": "https://svn.saintic.com/sdi/${init_user}",
  "FTP": "ftp://${init_user}@${SERVER_IP}",
  "Notes": "############################"
  },
}
USERINFO
sed -i 'N;$!P;$!D;$d' $Sdpuc
cat >> $Sdpuc <<EOF
  }
}
EOF


if echo "${webs[@]}" | grep -w $init_service_type &> /dev/null ;then
  WebsUserInfo
elif echo "${apps[@]}" | grep -w $init_service_type &> /dev/null ;then
  AppsUserInfo
fi
cat > ${init_user_home}/user.json <<EOF
{
  "uid": "$user_id",
  "user": "$init_user",
  "passwd": "$init_passwd",
  "home": "$init_user_home",
  "email": "$user_email",
  "service": "$init_service_type",
  "file": "$init_file_type",
  "CreateTime": "$CreateTime",
  "ExpirationTime": "$ExpirationTime",
  "container_id": "$container_id"
}
EOF

shellemail() {
  local admin_email=staugur@vip.qq.com
  #tail $init_user_home_info | mail -r "SdpCenter@saintic.com" -s "欢迎您，$init_user" $user_email
  tail $init_user_home_info | mail -s "欢迎您，$init_user" $user_email
  #tail -20 $Sdpuc | head -19 | mail -r "SdpCenter@saintic.com" -s "Sdpv1.UserInfo:${init_user}(UID:${user_id})" $admin_email
  tail -20 $Sdpuc | head -19 | mail -s "Sdpv1.UserInfo:${init_user}(UID:${user_id})" $admin_email
}

pythonemail() {
  local admin_email=staugur@vip.qq.com
  #user_name user_email and content_file
  python ${SDP_HOME}/.python_email.py $init_user $user_email $init_user_home_info
  tail -20 $Sdpuc | head -19 | mail -s "Sdpv1.UserInfo:${init_user}(UID:${user_id})" $admin_email
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
  pythonemail
  echo "{\"${PreciseTime}\":{\"user\": \"${init_user}\",\"id\": \"${user_id}\",\"email\": \"${user_email}\",\"service\": \"${init_service_type}\",\"container\": \"${container_id}\",\"time\": \"${CreateTime}~${ExpirationTime}\",\"code\": \"${init_file_type}\"}}" >> $Suclog
  echo >> $Suclog
else
  DoubleError
fi

