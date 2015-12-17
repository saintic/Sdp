#!/bin/bash
#test run.
sdpexec=$(cd $(dirname $0);pwd)

if [ `whoami` != 'root' ];then
    echo "Warning:must be root"
    exit
fi
[ -z $1 ] && exit 1 || pre=$1

Ss=("mongodb" "mysql" "redis" "memcache" "nginx" "tengine" "httpd" "lighttpd" "tomcat")
webs=("nginx" "tengine" "httpd" "tomcat" "lighttpd")
apps=("mongodb" "mysql" "redis" "memcache")

for s in ${Ss[@]}
do
  user=${pre}_$s
  ${sdpexec}/../sdp.py $user 12 $s ${user}@saintic.com
  if [ $? -eq 0 ];then
      #check web
      if echo "${webs[@]}" | grep -w $s &> /dev/null ;then
          id=$(docker ps | grep $user | awk '{print $1}')
          ip=$(docker inspect --format '{{ .NetworkSettings.IPAddress }}' $id)
          port=80
          code=$(curl -I -s ${ip}:${port} |head -1|awk -F "HTTP/1.1 " '{print $2}'|awk '{print $1}')
          if [ "$code" != "200" ];then
              echo "访问错误，错误码:$code" ; exit 1
          fi
      fi
  else
      echo "执行结果非0，非正常推出。"
      exit
  fi
done
