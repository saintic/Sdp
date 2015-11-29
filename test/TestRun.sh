#!/bin/sh
#test run.

sdpexec=$(cd $(dirname $0);pwd)

if [ `whoami` != 'root' ];then
    exit
fi

Ss=("mongodb" "mysql" "redis" "memcache" "nginx" "tengine" "httpd" "lighttpd" "tomcat" "resin")
for s in ${Ss[@]}
do
    user=Test_$s
    ${sdpexec}/../sdp.py $user 12 $s ${user}@saintic.com
    echo
done

