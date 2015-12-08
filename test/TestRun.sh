#!/bin/bash
#test run.
sdpexec=$(cd $(dirname $0);pwd)

if [ `whoami` != 'root' ];then
    echo "Warning:must be root"
    exit
fi

Ss=("mongodb" "mysql" "redis" "memcache" "nginx" "tengine" "httpd" "lighttpd" "tomcat")
webs=("nginx" "tengine" "httpd" "lighttpd" "tomcat")
apps=("mongodb" "mysql" "redis" "memcache")

for s in ${Ss[@]}
do
  user=TestWeb_$s
  ${sdpexec}/../sdp.py $user 12 $s ${user}@saintic.com
  if [ $? -eq 0 ];then
      #check
      if echo "${webs[@]}" | grep -w $s &> /dev/null ;then
	  ip=`jq . /data/SdpCloud/suc |tail -1|jq .ip`
          port=`jq . /data/SdpCloud/suc |tail -1|jq .port`
          code=$(curl -I -s ${ip}:${port} |head -1|awk -F "HTTP/1.1 " '{print $2}'|awk '{print $1}')
          [ "$code" = "200" ] || echo "访问错误，错误码:$code"
      fi
  else
      echo "执行结果非0，非正常推出。"
      exit
  fi
done
