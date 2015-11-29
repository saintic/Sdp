#!/bin/sh
#test run.

sdpexec=$(cd $(dirname $0);pwd)

if [ `whoami` != 'root' ];then
    exit
fi

Ss=("mongodb" "mysql" "redis" "memcache" "nginx" "tengine" "httpd" "lighttpd" "tomcat" "resin")
for s in ${Ss[@]}
do
    ${sdpexec}/../sdp.py $s 12 $s ${s}@saintic.com
done

